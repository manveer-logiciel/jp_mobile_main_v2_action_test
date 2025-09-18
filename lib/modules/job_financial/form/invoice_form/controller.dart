import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../../../../common/enums/sheet_line_item_type.dart';
import '../../../../common/enums/invoice_form_type.dart';
import '../../../../common/models/forms/invoice_form/invoice_form_param.dart';
import '../../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../../common/services/job_financial/forms/invoice_form/invoice_form.dart';
import '../../../../core/constants/dropdown_list_constants.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/single_select_helper.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../global_widgets/financial_form/add_item_bottom_sheet/index.dart';

class InvoiceFormController extends GetxController {

  InvoiceFormController({this.invoiceFormParam});

  final InvoiceFormParam? invoiceFormParam;
  late InvoiceFormService service;

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isPaymentSectionExpanded = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey();

  InvoiceFormType? pageType; // helps in manage form privileges

  int? jobId;
  int? customerId;
  int? orderId;
  int? invoiceId;
  int? dbUnsavedResourceId;

  Function(dynamic val)? onUpdate;

  String get formTitle {
    switch (pageType) {
      case InvoiceFormType.changeOrderCreateForm:
      case InvoiceFormType.changeOrderEditForm:
        return 'change_order_details'.tr.toUpperCase();
      case InvoiceFormType.invoiceCreateForm:
      case InvoiceFormType.invoiceEditForm:
        return 'invoice_details'.tr.toUpperCase();
      default:
        return 'invoice_details'.tr.toUpperCase();
    }
  }

  String get saveButtonText{
    switch (pageType) {
      case InvoiceFormType.changeOrderEditForm:
      case InvoiceFormType.invoiceEditForm:
        return 'update'.tr.toUpperCase();

      default:
        return 'save'.tr.toUpperCase();
    }
  }

  bool get isWithSignature => pageType == InvoiceFormType.changeOrderCreateForm
      || pageType == InvoiceFormType.changeOrderEditForm;

  @override
  Future<void> onInit() async {
    await init();
    super.onInit();
  }

  /////   init(): will set up form service and form data    /////

  Future<void> init() async {
    jobId ??= invoiceFormParam?.jobModel?.id ?? Get.arguments?[NavigationParams.jobId];
    orderId ??= invoiceFormParam?.financialListingModel?.id ?? Get.arguments?[NavigationParams.id];
    invoiceId ??= Get.arguments?[NavigationParams.invoiceId];
    pageType ??= invoiceFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType];
    dbUnsavedResourceId ??= Get.arguments?[NavigationParams.dbUnsavedResourceId];
    onUpdate = invoiceFormParam?.onUpdate;
    customerId ??= invoiceFormParam?.jobModel?.customerId;

    /////   setting up service    /////
    service = InvoiceFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      jobId: jobId,
      orderId: orderId,
      invoiceId: invoiceId,
      dbUnsavedResourceId: dbUnsavedResourceId,
      pageType: pageType,
    );

    service.controller = this;
    await service.initForm(); // setting up form data
  }

  /// return AddLineItemFormType from InvoiceFormType page type
  AddLineItemFormType getAddLineItemFormType() {
    if (pageType == InvoiceFormType.changeOrderCreateForm || pageType == InvoiceFormType.changeOrderEditForm) {
      return AddLineItemFormType.changeOrderForm; 
    }
    if (pageType == InvoiceFormType.invoiceCreateForm || pageType == InvoiceFormType.invoiceEditForm) {
      return AddLineItemFormType.invoiceForm; 
    }
    return AddLineItemFormType.insuranceForm;
  }

  /////   onDataChanged() : will validate form as soon as data in input field changes   /////

  void onDataChanged(dynamic val, {bool doUpdate = false,}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
    if(doUpdate) update();
    service.setUnsavedResourceDB();
  }

  /////   openAddItemBottomSheet(): open Add Item Bottom Sheet   /////

  Future<void> openAddItemBottomSheet() async {
    Helper.hideKeyboard();
    bool defaultWorkTradeTypeEnabled = service.isDefaultToJobWorkTradeTypeEnabled(pageType!);
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (_) => AddItemBottomSheetForm(
        pageType: AddLineItemFormType.changeOrderForm,
        sheetLineItemModel: SheetLineItemModel.getInitialInvoiceItem(service.jobModel!, defaultWorkTradeTypeEnabled),
        onSave : service.setInvoiceItemsList,
        isTaxable: service.isTaxable,
        srsBranchCode: service.selectedSrsBranch?.branchCode,
        shipToSequenceId: service.selectedSrsShipToAddress?.shipToSequenceId,
        beaconAccount: service.selectedBeaconAccount,
        beaconBranchCode: service.selectedBeaconBranch?.branchCode,
        abcBranchCode: service.selectedAbcBranch?.branchCode,
        supplierAccountId: service.selectedAbcAccount?.shipToId,
      ),
    );
  }

  void onListItemReorder(int oldIndex, int newIndex) {
    if (oldIndex <= newIndex) {
      newIndex -= 1;
    }
    var temp = service.invoiceItems[oldIndex];
    service.invoiceItems.removeAt(oldIndex);
    service.invoiceItems.insert(newIndex, temp);
    update();
    if(oldIndex == newIndex) return;
  }

  void editInvoiceOrderItem(SheetLineItemModel item) {
    Helper.hideKeyboard();
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (controller) => AddItemBottomSheetForm(
        pageType: AddLineItemFormType.changeOrderForm,
        sheetLineItemModel: item,
        isTaxable: service.isTaxable,
        onSave : (SheetLineItemModel sheetLineItemModel) =>
            service.setInvoiceItemsList(sheetLineItemModel, isEdit: true),
      ),
    );
  }

  // validateForm(): validates form and returns result
  bool validateForm() => (formKey.currentState?.validate() ?? false) && service.validateFormData();

  // saveOrderForm() : will save form data on validations completed otherwise scroll to error field
  Future<void> saveOrderForm() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    if (validateForm()) {
      saveForm(onUpdate: onUpdate);
    } else {
      service.scrollToErrorField();
    }
  }

  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {

    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes

    if(!isNewDataAdded && dbUnsavedResourceId == null) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else if (service.totalInvoicePrice < 0) {
      Helper.showToastMessage('total_amount_should_be_greater_than_0'.tr);
      return;
    } else {
      switch(pageType) {
        case InvoiceFormType.changeOrderCreateForm:
          openSaveTypeBottomSheet(false);
          break;
        case InvoiceFormType.changeOrderEditForm:
          if(service.financialListingModel?.invoiceId == null) {
            openSaveTypeBottomSheet(true);
          } else {
            updateInvoice("");
          }

          break;
        case InvoiceFormType.invoiceCreateForm:
        case InvoiceFormType.invoiceEditForm:
          updateInvoice("");
          break;
        default:
          break;
      }
    }
  }

  void openSaveTypeBottomSheet(bool isEdit) {
    SingleSelectHelper.openSingleSelect(
        isEdit ? DropdownListConstants.updateWithOrWithoutInvoice
            : DropdownListConstants.saveWithOrWithoutInvoice,
        "",
        'quick_actions'.tr,
            (String value) {
          Get.back();
          updateInvoice(value);
        },
        isFilterSheet: false
    );
  }

  void updateInvoice(String value) async {

    switch(value) {
      case "with_invoice":
        if(service.isLeapPayEnabled) {
          final doSaveOrder = await navigateToPaymentPreferences();
          if(!doSaveOrder) return;
        } else {
          service.isWithInvoice = true;
        }
        break;
      case "without_invoice":
        service.isWithInvoice = false;
        break;
      default:
        break;
    }

    try {
      toggleIsSavingForm();
      await service.saveForm();
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  Future<bool> navigateToPaymentPreferences() async {
    final result = await Get.toNamed(Routes.leapPayPreferences, arguments: {
      NavigationParams.changeOrderAmount: service.totalInvoicePrice.toDouble()
    });
    if (result is LeapPayPreferencesController) {
      service.leapPayPreferencesController = result;
      service.isWithInvoice = true;
      return true;
    }
    return false;
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  /* onWillPop(): will check if any new data is added to form and takes decisions
   accordingly whether to show confirmation or navigate back directly */

  Future<bool> onWillPop() async {
    if(service.checkIfNewDataAdded() || dbUnsavedResourceId != null) {
      Helper.showUnsavedChangesConfirmation(unsavedResourceId: service.dbUnsavedResourceId);
    } else {
      Helper.hideKeyboard();
      if(dbUnsavedResourceId == null) service.deleteUnsavedResource();
      Get.back();
    }
    return false;
  }

  String? validateDate(value) {
    if(service.validateDates()){
      return "due_date_should_be_greater_then_bill_date".tr;
    } else {
      return null;
    }
  }

  void onExpansionChanged(bool isExpanded) {
    isPaymentSectionExpanded = isExpanded;
  }
}
