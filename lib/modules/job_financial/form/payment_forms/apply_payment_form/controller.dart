import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/form/dialog_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyPaymentFormController extends GetxController {

  final formKey = GlobalKey<FormState>(); // used to validate form
  
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  
  
  DateTime date = DateTime.now();

  bool isSavingForm = false;
  bool isLoading = true;
  bool validateFormOnDataChange = false;
  
  int? jobId;

  late PaymentFormService service;

  @override
  void onInit() {
    initForm();
    super.onInit();
  }

  Future<void> initForm() async {
    
    jobId = Get.arguments?[NavigationParams.jobId];
   
    service = PaymentFormService(
      update: update, 
      validateForm:() => onDataChanged(''),
      jobId: jobId,
      type: PaymentFormType.applyPayment
    ); 
    service.applyPaymentFormcontroller  = this;
    await service.initApplyPaymentForm();
    isLoading = false; 
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  void onDataChanged(dynamic val) {
    service.calculateUnappliedAmount();
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
    update();
  }

  Future<void> saveForm() async{
    if(service.showValidationToastMessage() != null){
      return service.showValidationToastMessage();
    }
    service.setParamInvoiceList();
    toggleIsSavingForm();
  
    try {
      await service.saveForm();
    } catch(e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  void onSave() async {
    bool isValid = validateForm();
    validateFormOnDataChange = true;
    if(isValid){
      await saveForm();
    } else {
      service.scrollToErrorField();
    }
  }  

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      FormDialogHelper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;

  }
}

  

