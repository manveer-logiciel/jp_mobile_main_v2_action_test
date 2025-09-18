import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/form/dialog_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/controller.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ReceivePaymentFormController extends GetxController {
  final formKey = GlobalKey<FormState>(); // used to validate form

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  bool isSavingForm = false;
  bool isLoading = true;
  bool validateFormOnDataChange = false;
  bool recordPayment = false;

  int? jobId;
  int? invoiceId;

  FinancialListingModel? financialDetails = Get.arguments?[NavigationParams.financialDetails];
  String? actionFrom = Get.arguments?[NavigationParams.receivePaymentActionFrom];

  late PaymentFormService service;

  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    jobId = Get.arguments?[NavigationParams.jobId];
    invoiceId = Get.arguments?[NavigationParams.invoiceId];
    // displaying only record payment form in case LeapPay is not enabled
    // other deciding the form type to display on the basis of navigation params
    // [null] - both Record Payment and Process Payment
    // [ReceivePaymentFormType.recordPayment] - Record Payment form only
    // [ReceivePaymentFormType.processPayment] - Process Payment form only
    ReceivePaymentFormType? receivePaymentFormType = ConnectedThirdPartyService.isLeapPayEnabled()
        ? (Get.arguments?[NavigationParams.receivePaymentFormType])
        : ReceivePaymentFormType.recordPayment;

    service = PaymentFormService(
        update: update,
        validateForm: () => onDataChanged(''),
        jobId: jobId,
        invoiceId: invoiceId,
        type: PaymentFormType.receivePayment,
        receivePaymentFormType: receivePaymentFormType,
        financialDetails: financialDetails,
        actionFrom: actionFrom
      );

    service.receivePaymentFormController = this;

    await service.initReceivePaymentForm();
    isLoading = false;
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  bool validateForm() {
   bool isValid = formKey.currentState?.validate() ?? false;
   service.validateJustifiForm(isValid);
    return isValid;
  }

  void onDataChanged(dynamic val, {bool isAmountChanged = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (isAmountChanged) {
      service.calculatePendingInvoiceAmount();
    }
    validateFormOnDataChange = true;
    update();
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    if (service.showLeapPreferenceStatus) {
      Get.back();
      return true;
    }

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      FormDialogHelper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;

  }

  Future<void> saveForm() async {
    try {
      service.hideKeyboard();
      toggleIsSavingForm();
      bool isValid = validateForm();
      validateFormOnDataChange = true;
      if (!isValid) {
        service.scrollToErrorField();
      } else if (service.isRecordPaymentForm) {
        service.proceedToPay();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  void navigateToLeapPayPrefs() async {
    if(service.isLeapPayEnabled) {
      final result = await Get.to(
        LeapPayPreferencesPage(
          controller: service.leapPayPreferencesController,
          amount: service.invoicesAmount,
        ),
        transition: Transition.rightToLeft,
      );

      if (result is LeapPayPreferencesController) {
        service.onUpdatePreferences(result);
      }
    }
  }

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }
}
