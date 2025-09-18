import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/constants/financial_constants.dart';
import '../../../../core/constants/sql/auto_save_duration.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../core/utils/form/db_helper.dart';
import '../../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../../../core/utils/job_financial_helper.dart';
import '../../../../global_widgets/select_supplier_branch/controller.dart';
import '../../../../routes/pages.dart';
import '../../../enums/invoice_form_type.dart';
import '../../../enums/unsaved_resource_type.dart';
import '../../../services/quick_book.dart';
import '../../job/job.dart';
import '../../job_financial/financial_listing.dart';
import '../../sheet_line_item/sheet_line_item_model.dart';

class InvoiceFormData {
  InvoiceFormData({
    required this.update,
    this.jobId,
    this.orderId,
    this.invoiceId,
    this.dbUnsavedResourceId,
    this.pageType
  });

  InvoiceFormType? pageType;
  late UnsavedResourceType unsavedResourcesType;
  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  JobModel? jobModel; // used to store selected job data
  FinancialListingModel? financialListingModel;

  JPInputBoxController changeOrderFromController = JPInputBoxController();
  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController dueDateController = JPInputBoxController();
  JPInputBoxController billDateController = JPInputBoxController();
  JPInputBoxController unitController = JPInputBoxController();
  JPInputBoxController divisionController = JPInputBoxController();

  LeapPayPreferencesController leapPayPreferencesController = LeapPayPreferencesController();

  List<JPSingleSelectModel> divisionsList = []; // used to store divisions for dropdown
  List<SheetLineItemModel> invoiceItems = [];
  List<SheetLineItemModel> noChargeItemsList = [];
  List<JPSingleSelectModel> singleSelectTaxList = [];

  JPSingleSelectModel? selectedDivision;
  JPSingleSelectModel? selectedTaxRate;

  bool isLoading = true;
  bool isWithSignature = false;
  bool isTaxable = true;
  bool isWithInvoice = true;
  bool getIsRevisedTaxable = false;
  bool isRevisedTaxable = false;
  bool isSRSEnable = false;
  bool isBeaconEnable = false;
  bool defaultTradeWorkTypeInvoiceEnabled = false;

  SrsShipToAddressModel? selectedSrsShipToAddress;

  SupplierBranchModel? selectedSrsBranch;

  BeaconAccountModel? selectedBeaconAccount;
  SupplierBranchModel? selectedBeaconBranch;

  SrsShipToAddressModel? selectedAbcAccount;
  SupplierBranchModel? selectedAbcBranch;

  String noteString = '';
  String? signatureString;

  int? jobId;
  int? orderId;
  int? invoiceId;
  int? dbUnsavedResourceId;

  num totalInvoicePrice = 0;
  num itemsTotalPrice = 0;
  num defaultTaxRate = 0;
  num taxRate = 0;
  num revisedTaxRate = 0;
  num totalTaxAmount = 0;
  num totalTaxableAmount = 0;
  num totalTaxableItems = 0;
  num noChargeItemsTotal = 0;

  int? srsSupplierId;

  /// [getSupplierDetails] gives supplier details based on active supplier
  String get getSupplierDetails {
    if (isSRSEnable) {
      // SRS branch details
      String label = '${'srs'.tr.toUpperCase()} ${'branch'.tr}';
      String branchName = selectedSrsBranch?.name ?? '';
      String branchCode = selectedSrsBranch?.branchCode ?? '';
      return '$label: $branchName ($branchCode)';
    } else if (isBeaconEnable) {
      // Beacon branch details
      String label = '${'qxo'.tr} ${'branch'.tr}';
      String branchName = selectedBeaconBranch?.name ?? '';
      String branchCode = selectedBeaconBranch?.branchCode ?? '';
      return '$label: $branchName ${branchCode.isNotEmpty ? '($branchCode)' : ''}';
    } else if (isAbcEnable) {
      // ABC branch details
      String label = '${'abc'.tr} ${'branch'.tr}';
      String branchName = selectedAbcBranch?.name ?? '';
      String branchCode = selectedAbcBranch?.branchCode ?? '';
      return '$label: $branchName ${branchCode.isNotEmpty ? '($branchCode)' : ''}';
    } else {
      // Default case
      return '';
    }
  }

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison
  Map<String, dynamic>? unsavedResourceJson; // helps in storing unsaved resource data

  bool get isLeapPayEnabled => ConnectedThirdPartyService.isLeapPayEnabled();
  bool get doShowPaymentPreferences => isLeapPayEnabled && invoiceItems.isNotEmpty
      && (pageType == InvoiceFormType.invoiceCreateForm || pageType == InvoiceFormType.invoiceEditForm || financialListingModel?.invoiceId != null);

  bool isAbcEnable = false;

  // setFormData(): set-up form data to be pre-filled in form
  void setFormData() {
    if (jobModel != null) {
      selectedDivision = divisionsList.firstWhereOrNull((element) =>
      element.id == jobModel?.division?.id?.toString());

      ///   Get is job taxable
      isTaxable = getIsTaxable();

      if(pageType == InvoiceFormType.invoiceCreateForm) {
        setInitialInvoiceItem(jobModel!);
      }
    }
    ///   Get initial tax rate
    defaultTaxRate = JobFinancialHelper.getTaxRateForFinancialForm(
        jobModel: jobModel, jobInvoices: financialListingModel);
    revisedTaxRate = defaultTaxRate;
    taxRate = revisedTaxRate;

    if(financialListingModel != null) {
      titleController.text = financialListingModel?.name ?? "";
      unitController.text = financialListingModel?.unitNumber ?? "";
      selectedDivision = JPSingleSelectModel(
        id: financialListingModel?.division?.id.toString() ?? "",
        label: financialListingModel?.division?.name.toString() ?? "",
      );
      divisionController.text = selectedDivision?.label ?? "";
      invoiceItems = financialListingModel?.lines ?? [];
      setNoChargeItemList();
      ///   Get tax rate in case of edit
      isTaxable = getIsTaxable();
      selectedTaxRate = singleSelectTaxList.firstWhereOrNull((element) => element.id == financialListingModel?.customTax?.id.toString());
      taxRate = num.tryParse(financialListingModel?.taxRate ?? "0") ?? 0;
      billDateController.text = DateTimeHelper.convertHyphenIntoSlash(financialListingModel?.invoices?.date ??  financialListingModel?.date ?? "");
      dueDateController.text = DateTimeHelper.convertHyphenIntoSlash(financialListingModel?.invoices?.dueDate ?? financialListingModel?.dueDate ?? "");
      noteString = financialListingModel?.invoiceNote ?? "";
      isWithInvoice = financialListingModel?.invoiceId != null;

      setSupplierDetails();
      leapPayPreferencesController.setLeapPayPreferences(
        defaultPaymentMethod: financialListingModel?.defaultPaymentMethod,
        isAcceptingLeapPay: financialListingModel?.isAcceptingLeapPay,
        isFeePassoverEnabledForInvoice: financialListingModel?.isFeePassoverEnabled,
      );
    }
    getIsRevisedTaxable = pageType == InvoiceFormType.changeOrderEditForm && isTaxable && (revisedTaxRate != taxRate);
    if(selectedDivision != null) {
      divisionController.text = selectedDivision!.label;
    }

    srsBranchList = [];
    shipToAddressList = [];

    setSRSSupplierId();
  }

  void setFormDataFromDB() {
    Map<String, dynamic> data = FormsDBHelper.getUnsavedResourcesJsonData(unsavedResourceJson);
    if(data["order_id"] != 0) {
      orderId = data["order_id"];
    }
    if(pageType == InvoiceFormType.invoiceCreateForm && orderId != null) {
      pageType = InvoiceFormType.invoiceEditForm;
    } else if(pageType == InvoiceFormType.changeOrderCreateForm && orderId != null)  {
      pageType = InvoiceFormType.changeOrderEditForm;
    }
    titleController.text = data["name"] ?? "";
    billDateController.text = DateTimeHelper.convertHyphenIntoSlash(data["date"] ?? "");
    dueDateController.text = DateTimeHelper.convertHyphenIntoSlash(data["due_date"] ?? "");
    unitController.text = data["unit_number"] ?? "";
    selectedDivision = divisionsList.firstWhereOrNull((element) => element.id == data["division_id"]);
    divisionController.text = selectedDivision?.label ?? "";
    defaultTaxRate = JobFinancialHelper.getTaxRateForFinancialForm(jobModel: jobModel, jobInvoices: financialListingModel);
    revisedTaxRate = defaultTaxRate;
    taxRate = num.tryParse(data["tax_rate"]?.toString() ?? "") ?? revisedTaxRate;
    isTaxable = Helper.isTrue(data["taxable"]);
    selectedTaxRate = singleSelectTaxList.firstWhereOrNull((element) => element.id == data["custom_tax_id"]);

    if(pageType == InvoiceFormType.changeOrderCreateForm || pageType == InvoiceFormType.changeOrderEditForm) {
      isWithInvoice = Helper.isTrue(data["create_without_invoice"]);
      if (data['entities'] != null) {
        invoiceItems = <SheetLineItemModel>[];
        data['entities'].forEach((dynamic value) {
          invoiceItems.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm);
        });
      }
      noteString = data["invoice_note"] ?? data["note"] ?? "";
    } else {
      if(unsavedResourceJson!["created_through"] == "v1") {
        if (data['action_for'] == 'invoice') {
          invoiceId = orderId = data['id'];
          pageType = data['action'] == 'edit' ? InvoiceFormType.invoiceEditForm : InvoiceFormType.invoiceCreateForm;
        } else {
          orderId = data['id'];
          pageType = data['action'] == 'edit' ? InvoiceFormType.changeOrderEditForm : InvoiceFormType.changeOrderCreateForm;
        }
        if (data['lines']?["data"] != null) {
          invoiceItems = <SheetLineItemModel>[];
          data['lines']?["data"].forEach((dynamic value) {
            invoiceItems.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm);
          });
        }
      } else {
        if (data['lines'] != null) {
          invoiceItems = <SheetLineItemModel>[];
          data['lines'].forEach((dynamic value) {
            invoiceItems.add(SheetLineItemModel.fromChangeOrderJson(value)..pageType = AddLineItemFormType.changeOrderForm);
          });
        }
      }
      noteString = data["note"] ?? "";
    }
    if(data["srs_branch"] != null) {
      selectedSrsBranch = SupplierBranchModel.fromJson(data["srs_branch"]);
      selectedSrsShipToAddress = SrsShipToAddressModel.fromJson(data["srs_ship_to_address"]);
      isSRSEnable = selectedSrsShipToAddress != null && selectedSrsBranch != null;
    }

    if(data["beacon_account"] != null) {
      selectedBeaconAccount = BeaconAccountModel.fromJson(data["beacon_account"]);
      selectedBeaconBranch = SupplierBranchModel.fromJson(data["beacon_branch"]);
      isBeaconEnable = selectedBeaconAccount != null && selectedBeaconBranch != null;
    }

  }

  void setInitialInvoiceItem(JobModel jobModel) {
    int jobTradesCount = jobModel.trades?.length ?? 0;
    int jobWorkCount = jobModel.workTypes?.length ?? 0;
    List<CompanyTradesModel>? jobTradeType = jobModel.trades;
    List<JobTypeModel?>? jobWorkType = jobModel.workTypes;
    bool defaultWorkTradeTypeEnabled = isDefaultToJobWorkTradeTypeEnabled(pageType!);
    bool showTradeType = jobTradesCount == 1 && defaultWorkTradeTypeEnabled;
    bool showWorkType = jobWorkCount == 1  && defaultWorkTradeTypeEnabled;
    invoiceItems.add(SheetLineItemModel(
      pageType: pageType == InvoiceFormType.changeOrderCreateForm
          || pageType == InvoiceFormType.changeOrderEditForm
          ? AddLineItemFormType.changeOrderForm
          : AddLineItemFormType.invoiceForm,
      productId: "0",
      title: getInitialItemTitle(jobModel),
      price: getInitialItemPrice(jobModel).toString(),
      qty: "1",
      totalPrice: (getInitialItemPrice(jobModel) * 1).toString(),
      isTaxable: isTaxable,
      tradeType: showTradeType ? JPSingleSelectModel(
        label: jobTradeType!.first.name.toString(), 
        id: jobTradeType.first.id.toString()) : null,
      workType: showWorkType  ? JPSingleSelectModel(
        label: jobWorkType!.first!.name.toString(), 
        id: jobWorkType.first!.id.toString()) : null
    ));
    billDateController.text = getInitialBillDate();
  }

  bool isDefaultToJobWorkTradeTypeEnabled(InvoiceFormType pageType) {
    dynamic changeOrderSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultJobTradeWorkTypeOnChangeOrder);
    dynamic invoiceSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.defaultJobTradeWorkTypeOnInvoices);
    switch(pageType){
      case InvoiceFormType.changeOrderCreateForm:
      case InvoiceFormType.changeOrderEditForm:
        if(changeOrderSetting == null) {
          return false;
        }
        return Helper.isTrue(changeOrderSetting);
      case InvoiceFormType.invoiceCreateForm:
      case InvoiceFormType.invoiceEditForm:
        if(invoiceSetting == null) {
          return false;
        }
        return Helper.isTrue(invoiceSetting);
      default:
        return false;  
    }
  }

  bool get getDefaultTaxable => !QuickBookService.isQuickBookConnected()
      && !QuickBookService.isQBDConnected()
      && Helper.isTrue(jobModel?.taxable)
      && !Helper.isTrue(jobModel?.financialDetails?.isDerivedTax);

  bool getIsTaxable() {
    switch(pageType) {
      case InvoiceFormType.changeOrderEditForm:
        return financialListingModel?.taxable ?? getDefaultTaxable;
      case InvoiceFormType.invoiceEditForm:
        return financialListingModel?.taxRate?.isNotEmpty ?? getDefaultTaxable;
      default:
        return getDefaultTaxable;
    }
  }

  void setNoChargeItemList() {
    noChargeItemsList = [];
    for (var invoiceItem in invoiceItems) {
      if(invoiceItem.productCategorySlug == FinancialConstant.noCharge) noChargeItemsList.add(invoiceItem);
    }
    update();
  }

  String getInitialItemTitle(JobModel jobModel) {
    String title;
    ///   customer name
    title = jobModel.customer?.fullName ?? "";
    title += Helper.isValueNullOrEmpty(title) ? "" : " / ";
    ///   job number
    title += jobModel.number ?? "";
    title += Helper.isValueNullOrEmpty(title) ? "" : " / ";
    ///   trade type
    title += jobModel.tradesString;
    ///   work type
    title += jobModel.workTypesString?.isNotEmpty ?? false ? "(${jobModel.workTypesString ?? ""})" : "";

    return title;
  }

  String getInitialBillDate() => DateTimeHelper.convertHyphenIntoSlash(DateTimeHelper.formatDate(DateTime.now().toString(), DateFormatConstants.dateOnlyFormat));

  num getInitialItemPrice(JobModel jobModel) =>
      (num.tryParse(jobModel.amount ?? "0") ?? 0) - (jobModel.financialDetails?.jobInvoiceAmount ?? 0);

  void setUnsavedResourceType () {
    unsavedResourcesType = (pageType == InvoiceFormType.changeOrderCreateForm || pageType == InvoiceFormType.changeOrderEditForm)
        ? UnsavedResourceType.changeOrder : UnsavedResourceType.invoice;
  }


  /////////////////////////////      API PARAMS     ////////////////////////////
  
  ///[canAddDefaultItem] controls whether to add default item in [initialJson] or not for create invoice.
  Map<String, dynamic> getFormJson({bool isForUnsavedDB = false, bool canAddDefaultItem = true}) {
    switch(pageType){
      case InvoiceFormType.changeOrderCreateForm:
      case InvoiceFormType.changeOrderEditForm:
        return changeOrderFormJson(isForUnsavedDB: isForUnsavedDB);
      case InvoiceFormType.invoiceCreateForm:
        return invoiceFormJson(isForUnsavedDB: isForUnsavedDB, isUpdateJobPrice:isUpdateJobPrice(), isUpdateTaxRate:isUpdateTaxRate(), isDefaultInvoiceItemRequired: canAddDefaultItem);
      case InvoiceFormType.invoiceEditForm:
        return invoiceFormJson(isForUnsavedDB: isForUnsavedDB, isUpdateJobPrice:isUpdateJobPrice(), isUpdateTaxRate:isUpdateTaxRate());
      default:
        return {};
    }
  }

  int isUpdateTaxRate() {
    if(isTaxable && taxRate != num.tryParse(jobModel?.taxRate ?? '0')){
      return 1;
    } 
    return 0;
  }

  int isUpdateJobPrice() {
    num jobAmount = num.parse(jobModel?.amount ?? '0');
    num financialInvoiceAmount = jobModel?.financialDetails?.jobInvoiceAmount ?? 0;
    
    if (totalInvoicePrice > jobAmount - financialInvoiceAmount) {
        return 1;
    }
    return 0;
  }

  Map<String, dynamic> changeOrderFormJson({bool isForUnsavedDB = false}) {
    final data = <String, dynamic>{};

    if(pageType == InvoiceFormType.invoiceEditForm) {
      data["id"] = orderId.toString();
    } else {
      data["job_id"] = jobModel?.id;
    }

    if(financialListingModel?.invoiceId == null) {
      data["create_without_invoice"] = isWithInvoice ? 0 : 1;
    }

    ///   Common json elements
    data.addEntries(commonFormJson(isForUnsavedDB: isForUnsavedDB).entries);
    data["signature"] = signatureString;
    ///   Change item list section
    data.addEntries({"entities" : invoiceItems.map((item) => item.toJson()).toList()}.entries);
    ///   Note section
    data["invoice_note"] = noteString;
    ///
    data["force"] = "1";
    data["show_no_charge"] = false;
    data["taxable_amount"] = totalTaxableAmount;

    if (isWithInvoice && isLeapPayEnabled) {
      data["leap_pay_enabled"] = Helper.isTrueReverse(leapPayPreferencesController.acceptingLeapPay);
      data["payment_method"] = leapPayPreferencesController.getEnabledPaymentMethod();
      data["fee_passover_enabled"] = Helper.isTrueReverse(leapPayPreferencesController.isFeePassoverEnabled);
    }

    return data;
  }

  Map<String, dynamic> invoiceFormJson({bool isForUnsavedDB = false, int isUpdateJobPrice = 0, int isUpdateTaxRate = 0, bool isDefaultInvoiceItemRequired = true }) {
    final data = <String, dynamic>{};

    data["job_id"] = jobModel?.id;
    ///   Common json elements
    data.addEntries(commonFormJson(isForUnsavedDB: isForUnsavedDB).entries);
    ///   item list section
    if(isDefaultInvoiceItemRequired){
      data.addEntries({"lines" : invoiceItems.map((item) => item.toJson()).toList()}.entries);
    }
    ///   Note section
    data["note"] = noteString;
    ///
    data["update_job_tax_rate"] = isUpdateTaxRate;
    data["update_job_price"] = isUpdateJobPrice;
    if (isLeapPayEnabled) {
      data["leap_pay_enabled"] = Helper.isTrueReverse(leapPayPreferencesController.acceptingLeapPay);
      data["payment_method"] = leapPayPreferencesController.getEnabledPaymentMethod();
      data["fee_passover_enabled"] = Helper.isTrueReverse(leapPayPreferencesController.isFeePassoverEnabled);
    }

    return data;
  }

  Map<String, dynamic> commonFormJson({bool isForUnsavedDB = false}) {
    final data = <String, dynamic>{};
    ///   Invoice Detail Section
    data["name"] = titleController.text.trim().isEmpty ? "Invoice" : titleController.text;
    data["date"] = DateTimeHelper.convertSlashIntoHyphen(billDateController.text.toString());
    data["due_date"] = DateTimeHelper.convertSlashIntoHyphen(dueDateController.text.toString());
    data["unit_number"] = unitController.text;
    data["division_id"] = selectedDivision?.id ?? "";
    ///   Tax calculation section
    data["tax_rate"] = taxRate;
    data["taxable"] = isTaxable ? 1 : 0;
    data["custom_tax_id"] = selectedTaxRate?.id;
    data["total_price"] = totalInvoicePrice;

    final selectedBranch = getSelectedBranch();
    data["branch_code"] = selectedBranch?.branchCode;
    data["branch_id"] = selectedBranch?.branchId ?? "";

    if(selectedAbcAccount != null) {
      data["supplier_account_id"] = selectedAbcAccount?.shipToId ?? "";
      data["ship_to_sequence_number"] = "";
    } else {
      data["ship_to_sequence_number"] = selectedSrsShipToAddress?.shipToSequenceId ?? "";
    }
    data["beacon_account_id"] = selectedBeaconAccount?.accountId ?? "";

    if(isForUnsavedDB) {
      data["order_id"] = orderId;
      data["srs_branch"] = selectedSrsBranch?.toJson();
      data["srs_ship_to_address"] = selectedSrsShipToAddress?.toJson();
      data['beacon_branch'] = selectedBeaconBranch?.toJson();
      data['beacon_account'] = selectedBeaconAccount?.toJson();
      data['supplier_account'] = selectedAbcAccount?.toJson();
    }

    return data;
  }

  Future<void> setUnsavedResourceDB() async {
    if(Get.routing.current != Routes.invoiceForm) return;

    Map<String, dynamic> resource = {
      "type": UnsavedResourcesHelper.getUnsavedResourcesString(unsavedResourcesType),
      "job_id": jobId,
      "data": json.encode(getFormJson(isForUnsavedDB: true)),
    };

    dbUnsavedResourceId = await UnsavedResourcesHelper().insertOrUpdate(dbUnsavedResourceId, resource);
    update();
    Future.delayed(AutoSaveDuration.delay, () => setUnsavedResourceDB());
  }

  bool isNoChargeItemAvailable() =>
      invoiceItems.any((element) =>
      element.productCategorySlug == FinancialConstant.noCharge);

  /// [resetSupplier] resets the supplier details
  void resetSupplier() {
    selectedSrsShipToAddress = null;
    selectedSrsBranch = null;
    selectedBeaconAccount = null;
    selectedBeaconBranch = null;
    isSRSEnable = false;
    isBeaconEnable = false;
    isAbcEnable = false;
    selectedAbcAccount = null;
    selectedAbcBranch = null;
  }

  /// [getActiveSupplierId] gives the active supplier ID based on the enabled supplier.
  String? getActiveSupplierId() {
    if (isSRSEnable) {
      // Return the SRS supplier ID if SRS is enabled
      return CommonConstants.srsId;
    } else if (isBeaconEnable) {
      // Return the beacon supplier ID if beacon is enabled
      return CommonConstants.beaconId;
    } else if(isAbcEnable) {
      // Return the ABC supplier ID if ABC is enabled
      return CommonConstants.abcSupplierId;
    }
    // Return null if no supplier is enabled
    return null;
  }

  /// [getSelectedBranch] gives the selected branch based on the enabled supplier (SRS or Beacon).
  /// If SRS is enabled, it returns the selected SRS branch.
  /// If Beacon is enabled, it returns the selected Beacon branch.
  /// If neither SRS nor Beacon is enabled, it returns null.
  SupplierBranchModel? getSelectedBranch() {
    if (isSRSEnable) {
      return selectedSrsBranch;
    } else if (isBeaconEnable) {
      return selectedBeaconBranch;
    } else if(isAbcEnable) {
      return selectedAbcBranch;
    }
    return null;
  }

  /// [setSupplierDetails] Sets the supplier details based on the type of supplier.
  void setSupplierDetails() {
    switch (financialListingModel?.supplierType) {
      case MaterialSupplierType.srs:
      // Set SRS details
        isSRSEnable = true;
        selectedSrsShipToAddress = financialListingModel?.srsShipToAddressModel ?? selectedSrsShipToAddress;
        selectedSrsBranch = financialListingModel?.supplierBranch ?? selectedSrsBranch;
        break;
      case MaterialSupplierType.beacon:
      // Set Beacon details
        selectedBeaconAccount = financialListingModel?.beaconAccountModel ?? selectedBeaconAccount;
        selectedBeaconBranch = financialListingModel?.supplierBranch ?? selectedBeaconBranch;
        isBeaconEnable = true;
        break;
      case MaterialSupplierType.abc:
      // Set Beacon details
        selectedAbcAccount = financialListingModel?.abcAccountModel ?? selectedAbcAccount;
        selectedAbcBranch = financialListingModel?.supplierBranch ?? selectedAbcBranch;
        isAbcEnable = true;
        break;
      default:
        resetSupplier();
        break;
    }
  }

  void setSRSSupplierId() {
    if(!Helper.isValueNullOrEmpty(financialListingModel?.suppliers)) {
      int? supplierId = financialListingModel?.suppliers?.first.id;
      if(Helper.isSRSv1Id(supplierId) || Helper.isSRSv2Id(supplierId)) {
        srsSupplierId = supplierId;
      }
    }
    srsSupplierId ??= Helper.getSupplierId();
  }
}