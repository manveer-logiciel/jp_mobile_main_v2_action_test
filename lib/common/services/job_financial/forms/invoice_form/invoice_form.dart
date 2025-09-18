import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/worksheet/supplier_form_params.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/global_widgets/select_supplier_branch/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/constants/date_formats.dart';
import '../../../../../core/constants/financial_constants.dart';
import '../../../../../core/constants/mix_panel/event/add_events.dart';
import '../../../../../core/constants/mix_panel/event/edit_events.dart';
import '../../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../../core/utils/date_time_helpers.dart';
import '../../../../../core/utils/form/db_helper.dart';
import '../../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/job_financial_helper.dart';
import '../../../../../global_widgets/add_signature_dialog/index.dart';
import '../../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../../modules/job_financial/form/invoice_form/controller.dart';
import '../../../../enums/form_field_visibility.dart';
import '../../../../enums/invoice_form_type.dart';
import '../../../../models/suppliers/beacon/default_branch_model.dart';
import '../../../../models/forms/invoice_form/index.dart';
import '../../../../models/job_financial/tax_model.dart';
import '../../../../repositories/job.dart';
import '../../../auth.dart';
import '../../../forms/value_selector.dart';
import '../../../mixpanel/index.dart';

class InvoiceFormService extends InvoiceFormData {
  InvoiceFormService({
    required super.update,
    required this.validateForm,
    super.jobId,
    super.orderId,
    super.invoiceId,
    super.dbUnsavedResourceId,
    super.pageType
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  InvoiceFormController? _controller; // helps in managing controller without passing object

  InvoiceFormController get controller => _controller ?? InvoiceFormController();

  set controller(InvoiceFormController value) => _controller = value;

  bool get isTotalPriceFieldVisible => isTaxable && invoiceItems.isNotEmpty && totalTaxableAmount != 0;

  num get getTotalTaxableAmount => totalTaxableItems == invoiceItems.length ? 0 : totalTaxableAmount;

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!RunModeService.isUnitTestMode) showJPLoader();
    try {
      await setUpAPIData(); // loading form data from server
      if(unsavedResourceJson != null) {
        setFormDataFromDB();
      } else {
        setFormData();// filling form data
      }
    } catch (e) {
      rethrow;
    } finally {
      calculateTotalPrice();
      initialJson = getFormJson(canAddDefaultItem: false);
      isLoading = false;
      Get.back();
      update();
      setUnsavedResourceDB();
    }
  }

  // setUpAPIData(): loads users from local DB & also fill fields with selected users
  Future<void> setUpAPIData() async {
    setUnsavedResourceType();
    await fetchJobDetail();
    switch(pageType) {
      case InvoiceFormType.changeOrderFromInvoiceForm:
        await fetchChangeOrderDetailFromInvoice();
        break;
      case InvoiceFormType.changeOrderCreateForm:
      case InvoiceFormType.changeOrderEditForm:
        if(orderId == null && pageType == InvoiceFormType.changeOrderEditForm) {
          await fetchChangeOrderIdByInvoiceId();
        }
        await fetchChangeOrderDetail();
        break;
      case InvoiceFormType.invoiceCreateForm:
      case InvoiceFormType.invoiceEditForm:
        await fetchInvoiceDetail();
        break;
      default:
        break;
    }
    await fetchTaxDetailList();
    await fetchAllDivisions();
    await fetchUnsavedResourcesData();
  }

  Future<void> fetchJobDetail() async {
    if (jobId == null) return;
    try {
      final jobSummaryParams = <String, dynamic> {
        "id": jobId,
        "includes[0]":"address.state_tax",
        "includes[1]":"parent.address.state_tax",
        "includes[2]":"custom_tax",
        "includes[3]":"financial_details",
        "includes[4]":"job_invoices",
        "includes[5]":"flags.color",
        "includes[6]":"division",
      };

      jobModel = (await JobRepository.fetchJob(jobId!, params: jobSummaryParams))["job"];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchChangeOrderDetail() async {
    try {
      if(orderId != null) {
        final changeOrderParams = <String, dynamic> {
          "id": orderId,
          "includes[0]":"custom_tax",
          "includes[1]":"invoice",
          "includes[2]":"srs_ship_to_address",
          "includes[3]":"branch",
          "includes[4]":"division",
          'includes[5]': "beacon_account",
          'includes[6]': "beacon_job",
          'includes[7]': "suppliers",
          if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
           'includes[8]': "supplier_account",
          "job_id": jobModel?.id,
        };

        financialListingModel = (await JobFinancialRepository.fetchChangeOrderDetail(orderId, changeOrderParams))["data"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchChangeOrderDetailFromInvoice() async {
    try {
      if(invoiceId != null) {
        financialListingModel = (await JobFinancialRepository.fetchChangeOrderDetailFromInvoice(invoiceId!))["data"];
        orderId = financialListingModel?.id;
        await fetchChangeOrderDetail();
        controller.pageType = pageType = InvoiceFormType.changeOrderEditForm;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchInvoiceDetail() async {
    try {
      if(orderId != null) {
        final invoiceParams = <String, dynamic> {
          "includes[0]":"custom_tax",
          "includes[1]":"lines",
          "includes[2]":"srs_ship_to_address",
          "includes[3]":"branch",
          "includes[4]":"division",
          'includes[5]': "beacon_account",
          'includes[6]': "beacon_job",
          'includes[7]': "suppliers",
          if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
           'includes[8]': "supplier_account"
        };

        financialListingModel = (await JobFinancialRepository.fetchInvoiceDetail(orderId, invoiceParams))["data"];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchTaxDetailList() async {
    try {
      List<TaxModel> taxList = await JobRepository.fetchCustomTax({"limit":0});
      for (var element in taxList) {
        singleSelectTaxList.add(JPSingleSelectModel(
          id: element.id.toString(),
          label: "${element.title} - (${element.taxRate} %)",
          additionalData: element.taxRate,
        ));
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAllDivisions() async {
    try {
      divisionsList = await FormsDBHelper.getAllDivisions();
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  Future<void> fetchUnsavedResourcesData() async {
   try { 
    unsavedResourceJson = await FormsDBHelper.getUnsavedResources(dbUnsavedResourceId);
      await FormsDBHelper.getAllUnsavedResources(type: unsavedResourcesType, jobId: jobId!);
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  void deleteItem(int index) {
    invoiceItems.removeAt(index);
    calculateTotalPrice();
    update();
  }

  //////////////////////////////////////////////////////////////////////////////

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() => initialJson.toString() != getFormJson().toString();

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable(dynamic formFieldType)  {
    if(controller.isSavingForm) {
      return !controller.isSavingForm;
    }

    switch(pageType) {
      case InvoiceFormType.invoiceCreateForm:
      case InvoiceFormType.invoiceEditForm:
        return !(formFieldType == FormFieldVisibility.signature);
      default:
        return true;
    }
  }

  /////////////////////////////     DATE FIELD     /////////////////////////////

  void onClickBillDateField() async {
    DateTime? selectedDate = await DateTimeHelper.openDatePicker(
        initialDate: billDateController.text,
        helpText: 'bill_date'.tr, isPreviousDateSelectionAllowed: true);
    if(selectedDate != null) {
      billDateController.text = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateOnlyFormat);
      validateForm();
    }
  }

  void onClickDueDateField() async {
    DateTime? selectedDate = await DateTimeHelper.openDatePicker(
        initialDate: (dueDateController.text.isNotEmpty && !validateDates())
            ? dueDateController.text : billDateController.text,
        firstDate: billDateController.text,
        helpText: 'due_date'.tr, isPreviousDateSelectionAllowed: false);
    if(selectedDate != null) {
      dueDateController.text = DateTimeHelper.format(selectedDate.toString(), DateFormatConstants.dateOnlyFormat);
    }
    validateForm();
  }

  ///////////////////////////     SELECT DIVISION     //////////////////////

  void selectDivision() => FormValueSelectorService.openSingleSelect(
    title: 'select_division'.tr,
    list: divisionsList,
    controller: divisionController,
    selectedItemId: selectedDivision?.id ?? "",
    onValueSelected: (val) {
      selectedDivision = divisionsList.firstWhereOrNull((element) => element.id == val);
      update();
      validateForm();
    });

///////////////////////////     SELECT TAX     //////////////////////////

  void selectTaxRate() {
    Helper.hideKeyboard(); 
    FormValueSelectorService.openSingleSelect(
      title: 'select_tax'.tr,
      list: singleSelectTaxList,
      selectedItemId: selectedTaxRate?.id ?? "",
      onValueSelected: (val) {
        selectedTaxRate = singleSelectTaxList.firstWhereOrNull((element) => element.id == val);
        taxRate = num.tryParse(selectedTaxRate?.additionalData?.toString() ?? taxRate.toString()) ?? taxRate;
        isRevisedTaxable = false;
        calculateTotalPrice();
        validateForm();
      }
    );
  }
  ///////////////////     OPEN CHANGE ORDER NOTE DIALOG     ////////////////////

  void onNoteChange(String? val) {
    noteString = val ?? "";
    update();
    validateForm();
    Future.delayed(AutoSaveDuration.delay, () => setUnsavedResourceDB());
  }

  //////////////////////////     SIGNATURE DIALOGUE     ////////////////////////

  void toggleIsWithSignature(bool val) {
    Helper.hideKeyboard();
    if(isWithSignature) {
      isWithSignature = !val;
      signatureString = "";
      update();
    } else {
      showAddViewSignatureDialog(val);
    }
    validateForm();
  }

  Future<void> showAddViewSignatureDialog(bool val) async {
    showJPGeneralDialog(
      child: (_) => AddViewSignatureDialog(
        viewOnly: false,
        onAddSignature: (signature) {
          signatureString = signature;
          isWithSignature = !val;
          update();
          validateForm();
        },
      ),
    );
  }

  //////////////////////////     APPLY REVISED TAX      ////////////////////////

  void toggleIsRevisedTaxable(bool val) {
    if(isRevisedTaxable) {
      taxRate = num.tryParse(financialListingModel?.taxRate ?? "0") ?? 0;
      isRevisedTaxable = !val;
      calculateTotalPrice();
    } else {
      showRevisedTaxConformationDialog(val);
    }
    validateForm();
  }

  void showRevisedTaxConformationDialog(bool val) {
    showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
        title: 'apply_revised_tax'.tr.toUpperCase(),
        subTitle: "${'apply_revised_tax_conformation'.tr} (${JobFinancialHelper.getRoundOff(revisedTaxRate)}%)?",
        icon: Icons.info_outline,
        suffixBtnText: 'yes'.tr.toUpperCase(),
        prefixBtnText: 'no'.tr.toUpperCase(),
        onTapSuffix: () {
          taxRate = revisedTaxRate;
          isRevisedTaxable = !val;
          selectedTaxRate = null;
          calculateTotalPrice();
          Get.back();
          validateForm();
        },
      ),
    );
  }

  void setInvoiceItemsList(SheetLineItemModel sheetLineItemModel, {bool isEdit = false}) {
    if(isEdit) {
      if(sheetLineItemModel.currentIndex != null) {
        invoiceItems[sheetLineItemModel.currentIndex!] = sheetLineItemModel;
      }
    } else {
      invoiceItems.add(sheetLineItemModel);
    }
    billDateController.text = billDateController.text.isEmpty ? getInitialBillDate() : billDateController.text;
    setNoChargeItemList();
    calculateTotalPrice();
    validateForm();
    Future.delayed(AutoSaveDuration.delay, () => setUnsavedResourceDB());
  }

  void scrollToErrorField() {
    if(invoiceItems.isEmpty) {
      Helper.showToastMessage("please_add_some_item".tr);
    }
    changeOrderFromController.scrollAndFocus();
  }

///////////////////////////     APPLY TAX     //////////////////////////

  void onTapMoreActionIcon(PopoverActionModel moreIconActions) {
    switch(moreIconActions.value) {
      case "apply_tax":
        isTaxable = true;
        taxRate = defaultTaxRate;
        Helper.hideKeyboard();
        break;
      case "remove_tax":
        isTaxable = false;
        selectedTaxRate = null;
        Helper.hideKeyboard();
        break;
      case "srs":
        toggleSupplier(!isSRSEnable, MaterialSupplierType.srs, isAction: true);
        break;
      case "beacon":
        toggleBeaconSupplier(!isBeaconEnable);
        break;
      case "abc":
        toggleSupplier(!isAbcEnable, MaterialSupplierType.abc, isAction: true);
        break;
    }
    for (var element in invoiceItems) {
      if(element.productCategorySlug == FinancialConstant.noCharge) {
        element.isTaxable = false;
      } else {
        element.isTaxable = isTaxable;
      }
    }
    update();
    calculateTotalPrice();
  }

  /// [toggleSupplier] activates/deactivates the supplier based on the given value.
  ///
  /// If [val] is true, it activates the [supplier], otherwise it deactivates it.
  /// If [isAction] is [False], it navigates back.
  void toggleSupplier(bool val, MaterialSupplierType supplier, {
    bool isAction = false,
  }) {
    // closing the more actions pop-up if it's open
    if (!isAction) Get.back();
    if (val) {
      // activating supplier if it's not been activated before
      activateSupplier(supplier);
    } else {
      // deactivating supplier if it's been activated before
      deactivateSupplier(supplier);
    }
  }

  void toggleBeaconSupplier(bool isOn) {
    if(isOn && !AuthService.isUserBeaconConnected()) {
      WorksheetHelpers.showBeaconLoginConfirmationDialog((isBeaconConnecting) {
        if(isBeaconConnecting) {
          toggleSupplier(isOn, MaterialSupplierType.beacon, isAction: true);
        }
      });
    } else {
      toggleSupplier(isOn, MaterialSupplierType.beacon, isAction: true);
    }
  }

  /// [activateSupplier] Activates a supplier by conditionally showing a confirmation
  /// message and then opens the supplier selector bottom sheet.
  ///
  /// [supplier] The material supplier type to activate.
  void activateSupplier(MaterialSupplierType supplier) {
    // Check if a confirmation message needs to be displayed
    String? message = getRemoveSupplierConfirmation(makeProductCheck: true);

    // If a confirmation message is available, show confirmation dialog and
    // then remove supplier and open bottom sheet
    if (message != null) {
      WorksheetHelpers.showConfirmation(
          subTitle: message,
          onConfirmed: () async {
            // Removing previously activated supplier
            // As only one material supplier can be active at a time
            removeSupplier();
            // Open the bottom sheet to select the supplier details
            openSupplierSelector(supplier);
          }
      );
    }
    else {
      // If no confirmation message is available, directly open
      // the supplier selector bottom sheet
      openSupplierSelector(supplier);
    }
  }

  /// [deactivateSupplier] Deactivates the supplier of the specified type.
  ///
  /// If a confirmation message is available, it is shown to the user.
  /// If the user confirms, the supplier is removed.
  void deactivateSupplier(MaterialSupplierType supplier) {
    String? message = getRemoveSupplierConfirmation();
    if (message == null) return;
    WorksheetHelpers.showConfirmation(
        subTitle: message,
        onConfirmed: removeSupplier
    );
  }

  /// [getRemoveSupplierConfirmation] gives a confirmation message for removing a supplier.
  ///
  /// If [makeProductCheck] is true, checks for the presence of products from the specified supplier.
  /// If [isSRSEnable] is true, checks for SRS products;
  /// if [isBeaconEnable] is true, checks for Beacon products.
  /// Returns the appropriate deactivation message based on the presence of products.
  /// Returns null if neither SRS nor Beacon are enabled.
  String? getRemoveSupplierConfirmation({bool makeProductCheck = false}) {
    bool isChangeOrderForm = pageType == InvoiceFormType.changeOrderCreateForm || pageType == InvoiceFormType.changeOrderEditForm;
    if (isSRSEnable) {
      bool hasSRSProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.srsId, invoiceItems);
      String withProductsMessage = isChangeOrderForm ? 'deactivate_srs_dialog_with_products_message_change_order'.tr : 'deactivate_srs_dialog_with_products_message_invoice'.tr;
      String withOutProductsMessage = isChangeOrderForm ? 'deactivate_srs_dialog_message_change_order'.tr : 'deactivate_srs_dialog_message_invoice'.tr;
      return hasSRSProducts ? withProductsMessage : withOutProductsMessage;
    } else if (isBeaconEnable) {
      bool hasBeaconProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.beaconId, invoiceItems);
      String withProductsMessage = isChangeOrderForm ? 'deactivate_beacon_dialog_with_products_message_change_order'.tr : 'deactivate_beacon_dialog_with_products_message_invoice'.tr;
      String withOutProductsMessage = isChangeOrderForm ? 'deactivate_beacon_dialog_message_change_order'.tr : 'deactivate_beacon_dialog_message_invoice'.tr;
      return hasBeaconProducts ? withProductsMessage : withOutProductsMessage;
    }
    else if (isAbcEnable) {
      bool hasAbcProducts = makeProductCheck && WorksheetHelpers.hasSuppliersProduct(CommonConstants.abcSupplierId, invoiceItems);
      return hasAbcProducts
          ? 'deactivate_abc_dialog_with_products_message'.tr
          : 'deactivate_abc_dialog_message'.tr;
    }
    return null;
  }

  /// [openSupplierSelector] helps in selecting supplier account and branch
  Future<void> openSupplierSelector([MaterialSupplierType? type, bool isDefaultBranch = true]) async {
    type ??= getSelectedSupplier();
    if (type == null) return;
    bool isDefaultBranchSaved =  this.isDefaultBranchSaved(type);
    DefaultBranchModel? defaultBranchModel = WorksheetHelpers.getDefaultBranch(type);
    final result = await showJPBottomSheet(
      ignoreSafeArea: false,
      isScrollControlled: true,
      child: (_) => MaterialSupplierForm(
        params: MaterialSupplierFormParams(
          abcAccount: isDefaultBranchSaved ? defaultBranchModel?.abcAccount : selectedAbcAccount,
          abcBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedAbcBranch,
          srsShipToAddress: isDefaultBranchSaved ? defaultBranchModel?.srsShipToAddress : selectedSrsShipToAddress,
          srsBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedSrsBranch,
          beaconAccount: isDefaultBranchSaved ? defaultBranchModel?.beaconAccount : selectedBeaconAccount,
          beaconBranch: isDefaultBranchSaved ? defaultBranchModel?.branch : selectedBeaconBranch,
          type: type,
          excludeJob: true,
          isDefaultBranchSaved: isDefaultBranch && isDefaultBranchSaved,
          onChooseDifferentBranch: () {
            openSupplierSelector(type, false);
          },
          srsSupplierId: srsSupplierId
        ),
      ),
    );

    // In case supplier has been selected or updated in the supplier form
    if (result != null && result is Map<String, dynamic>) {
      // resetting the supplier details to avoid any conflicts
      resetSupplier();
      // Parsing and updating the supplier details
      final supplierDetails = result[NavigationParams.supplierDetails];
      setUpSupplier(type, supplierDetails);
    }
    update();
  }

  /// [setUpSupplier] Sets up the supplier based on the given [type] and [details].
  ///
  /// If [type] [is MaterialSupplierType.srs], sets the selected
  /// SRS ship to address and branch and checks if SRS is enabled.
  /// If [type] is [MaterialSupplierType.beacon], sets the selected
  /// Beacon account and branch, and checks if Beacon is enabled.
  void setUpSupplier(MaterialSupplierType type, MaterialSupplierFormParams details) {
    switch (type) {
      case MaterialSupplierType.srs:
        selectedSrsShipToAddress = details.srsShipToAddress;
        selectedSrsBranch = details.srsBranch;
        isSRSEnable = selectedSrsShipToAddress != null && selectedSrsBranch != null;
        // removing the beacon supplier products
        removeSupplierProducts();
        break;
      case MaterialSupplierType.beacon:
        selectedBeaconAccount = details.beaconAccount;
        selectedBeaconBranch = details.beaconBranch;
        isBeaconEnable = selectedBeaconAccount != null && selectedBeaconBranch != null;
        // removing the SRS supplier products
        removeSupplierProducts();
        break;
      case MaterialSupplierType.abc:
        selectedAbcAccount = details.abcAccount;
        selectedAbcBranch = details.abcBranch;
        isAbcEnable = selectedAbcAccount != null && selectedAbcBranch != null;
        // removing the beacon supplier products
        removeSupplierProducts();
        break;
    }

    if(details.isBranchMakeDefault) {
      WorksheetHelpers.saveDefaultBranchSettings(
          DefaultBranchModel(
              srsShipToAddress: type == MaterialSupplierType.srs ? selectedSrsShipToAddress : null,
              beaconAccount: type == MaterialSupplierType.beacon ? selectedBeaconAccount : null,
              abcAccount: type == MaterialSupplierType.abc ? selectedAbcAccount : null,
              branch: WorksheetHelpers.getSupplierBranch(
                type,
                selectedSrsBranch: selectedSrsBranch,
                selectedBeaconBranch: selectedBeaconBranch,
                selectedAbcBranch: selectedAbcBranch,
              )
          ),
          type
      );
    }
  }

  /// [removeSupplierProducts] Removes products associated with a supplier.
  ///
  /// [id] The id of the supplier.
  void removeSupplierProducts({bool isDeactivating = false}) {
    int? supplierId1;
    int? supplierId2;
    int? supplierId3;
    if(getActiveSupplierId() == CommonConstants.srsId) {
      supplierId1 = Helper.getSupplierId(key: CommonConstants.beaconId);
      supplierId2 = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    } else if(getActiveSupplierId() == CommonConstants.beaconId) {
      supplierId1 = Helper.getSRSV1Supplier();
      supplierId2 = Helper.getSRSV2Supplier();
      supplierId3 = Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    } else if(getActiveSupplierId() == CommonConstants.abcSupplierId) {
      supplierId1 = Helper.getSRSV1Supplier();
      supplierId2 = Helper.getSRSV2Supplier();
      supplierId3 = Helper.getSupplierId(key: CommonConstants.beaconId);
    }

    // Remove supplier products from line items
    if(isDeactivating) {
      if(isSRSEnable) {
        int? srsV1Id = Helper.getSRSV1Supplier();
        int? srsV12d = Helper.getSRSV2Supplier();
        invoiceItems.removeWhere((element) =>
         (element.supplier?.id == srsV1Id
            || element.supplierId == srsV1Id.toString())
            || (element.supplier?.id == srsV12d
            || element.supplierId == srsV12d.toString())
        );
      } else {
        int? activatedSupplierId = Helper.getSupplierId(key: getActiveSupplierId());
        invoiceItems.removeWhere((element) =>
         element.supplier?.id == activatedSupplierId || element.supplierId == activatedSupplierId.toString());
      }
    } else {
      if (isSRSEnable) {
        invoiceItems.removeWhere((element) =>
        (element.supplier?.id == supplierId1 ||
            element.supplierId == supplierId1.toString())
            || (element.supplier?.id == supplierId2 ||
            element.supplierId == supplierId2.toString())
        );
      } else {
        invoiceItems.removeWhere((element) =>
        (element.supplier?.id == supplierId1 ||
            element.supplierId == supplierId1.toString())
            || (element.supplier?.id == supplierId2 ||
            element.supplierId == supplierId2.toString())
            || (element.supplier?.id == supplierId3 ||
            element.supplierId == supplierId3.toString())
        );
      }
    }
  }

  /// [getSelectedSupplier] gives the selected material supplier type based on the enabled supplier.
  ///
  /// If [isSRSEnable] is true, returns [MaterialSupplierType.srs].
  /// If [isBeaconEnable] is true, returns [MaterialSupplierType.beacon].
  /// Otherwise, returns null.
  MaterialSupplierType? getSelectedSupplier() {
    if (isSRSEnable) {
      return MaterialSupplierType.srs;
    } else if (isBeaconEnable) {
      return MaterialSupplierType.beacon;
    } else if (isAbcEnable) {
      return MaterialSupplierType.abc;
    }
    return null;
  }

  /// [removeSupplier] Removes the supplier and resets related variables and line items.
  void removeSupplier() {
    final selectedSupplierId = getActiveSupplierId();
    if (selectedSupplierId != null) removeSupplierProducts(isDeactivating: true);

    selectedSrsShipToAddress = null;
    selectedSrsBranch = null;
    isSRSEnable = false;
    selectedBeaconAccount = null;
    selectedBeaconBranch = null;
    isBeaconEnable = false;
    isAbcEnable = false;
    selectedAbcAccount = null;
    selectedAbcBranch = null;

    for (SheetLineItemModel lineItem in invoiceItems) {
      lineItem.product?.notAvailable = false;
      lineItem.product?.notAvailableInPriceList = false;
    }
    update();
  }

  Future<void> saveForm() async {
    try {
      final params = getFormJson();
      switch(pageType) {
        case InvoiceFormType.changeOrderCreateForm:
        case InvoiceFormType.changeOrderEditForm:
          await changeOrderAPICall(params);
          break;
        case InvoiceFormType.invoiceCreateForm:
        case InvoiceFormType.invoiceEditForm:
          await invoiceAPICall(params);
          break;
        default:
          break;
      }
    } catch (e) {
      toggleIsSavingForm();
      rethrow;
    }

  }

  Future<void> changeOrderAPICall(Map<String, dynamic> params) async {
    try {
      Map<String, dynamic>? result = pageType == InvoiceFormType.changeOrderCreateForm
          ? await JobFinancialRepository.createChangeOrder(params)
          : await JobFinancialRepository.updateChangeOrder(orderId, params);

      if (result["status"] ?? false) {
        Helper.showToastMessage(pageType == InvoiceFormType.changeOrderCreateForm
            ? 'order_created'.tr : 'order_updated'.tr);
        MixPanelService.trackEvent(event: pageType == InvoiceFormType.changeOrderCreateForm
            ? MixPanelAddEvent.form : MixPanelEditEvent.form);
        deleteUnsavedResource();
        Get.back(result: result["data"]);
      }
    } catch (e) {
      toggleIsSavingForm();
      rethrow;
    }
  }

  Future<void> invoiceAPICall(Map<String, dynamic> params) async {
    try {

      Map<String, dynamic>? result = pageType == InvoiceFormType.invoiceCreateForm
          ? await JobFinancialRepository.createInvoice(params)
          : await JobFinancialRepository.updateInvoice(orderId, params);

      if (result["status"] ?? false) {
        Helper.showToastMessage(pageType == InvoiceFormType.invoiceCreateForm
            ? 'invoice_created'.tr : 'invoice_updated'.tr);
        MixPanelService.trackEvent(event: pageType == InvoiceFormType.invoiceCreateForm
            ? MixPanelAddEvent.form : MixPanelEditEvent.form);
        deleteUnsavedResource();
        Get.back(result: result["data"]);
      }
    } catch (e) {
      toggleIsSavingForm();
      rethrow;
    }}

  Future<void> fetchChangeOrderIdByInvoiceId() async {
    orderId = await JobFinancialRepository.fetchChangeOrderIdByInvoiceId(invoiceId);
  }

  ///////////////////////     CALCULATE TOTAL PRICE     ////////////////////////

  void calculateTotalPrice() {

    totalInvoicePrice = 0;
    itemsTotalPrice = 0;
    totalTaxAmount = 0;
    totalTaxableAmount = 0;
    totalTaxableItems = 0;

    for (var item in invoiceItems) {
      num price = num.parse(item.totalPrice ?? "");
      itemsTotalPrice += price;
      if (item.productCategorySlug != FinancialConstant.noCharge) {
        if ((item.isTaxable ?? false)) {
          totalTaxableItems++;
          totalTaxableAmount += price;
          totalTaxAmount += ((price * taxRate) / 100);
          totalInvoicePrice += price + ((price * taxRate) / 100);
        } else {
          totalInvoicePrice += price;
        }
      }
    }

    if(noChargeItemsList.isNotEmpty) {
      noChargeItemsTotal = 0;
      for (var item in noChargeItemsList) {
        noChargeItemsTotal += num.parse(item.totalPrice ?? "");
      }
    }

    update();
  }

  void toggleIsSavingForm() => controller.toggleIsSavingForm();

  ////////////////////////////     VALIDATIONS     /////////////////////////////

  bool validateFormData() => (invoiceItems.isNotEmpty) && !validateDates();

  bool validateDates() {
    DateTime? due;
    DateTime? bill;
    if(dueDateController.text.trim().isNotEmpty) {
      due = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(dueDateController.text));
    }
    if(billDateController.text.trim().isNotEmpty) {
      bill = DateTime.parse(DateTimeHelper.convertSlashIntoHyphen(billDateController.text));
    }
    return due?.isBefore(bill ?? DateTime.now()) ?? false;
  }

  //////////////////////     DELETE UNSAVED RESOURCE     ///////////////////////

  void deleteUnsavedResource() {
    if(dbUnsavedResourceId != null) UnsavedResourcesHelper.deleteUnsavedResource(id: dbUnsavedResourceId!);
  }

  /// [isDefaultBranchSaved] - In case of Default branch is saved in company settings - Dialog will be shown
  bool isDefaultBranchSaved(MaterialSupplierType type) {
    final DefaultBranchModel selectedDefaultAccount = DefaultBranchModel(
        srsShipToAddress: selectedSrsShipToAddress,
        beaconAccount: selectedBeaconAccount,
        abcAccount: selectedAbcAccount,
        branch: WorksheetHelpers.getSupplierBranch(
          type,
          selectedSrsBranch: selectedSrsBranch,
          selectedBeaconBranch: selectedBeaconBranch,
          selectedAbcBranch: selectedAbcBranch,
        )
    );
    return WorksheetHelpers.isDefaultBranchSaved(selectedDefaultAccount, type, isInvoiceFormType: true);
  }

  bool isAbcConnected() => ConnectedThirdPartyService.isAbcConnected();
}