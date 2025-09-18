import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/services/job/insurance_form/add_insurance.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetailsFormController extends GetxController {
  final formKey = GlobalKey<FormState>(); // used to validate form

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late InsuranceDetailsFormService service; // helps in handling form

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  InsuranceModel? insuranceDetails;

  String get pageTitle {
    return insuranceDetails?.id != null
        ? 'edit_insurance_details'.tr.toUpperCase()
        : 'add_insurance_details'.tr.toUpperCase();
  }

  String get saveButtonText => 'save'.tr.toUpperCase();

  @override
  void onInit() {
    insuranceDetails = Get.arguments?[NavigationParams.insuranceDetails];
    service = InsuranceDetailsFormService(validateForm: () => onDataChanged(''), insuranceModel: insuranceDetails);
    service.initForm();
    super.onInit();
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }

    if (doUpdate) update();
  }

  // createInsurance() : will save form data on validations completed otherwise scroll to error field
  Future<void> createInsurance() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    bool isValid = validateForm(); // validating form
    bool isValidPhoneExt = service.validatePhoneFormWithExt();

    if (isValid && isValidPhoneExt) {
      saveForm();
    } else {
      service.scrollToErrorField();
    }
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    return isValid;
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm() async {
    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if (!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      try {
        toggleIsSavingForm();
        service.saveForm();
      } catch (e) {
        rethrow;
      } finally {
        toggleIsSavingForm();
      }
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {
    bool isNewDataAdded = service.checkIfNewDataAdded();

    if (isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;
  }

}