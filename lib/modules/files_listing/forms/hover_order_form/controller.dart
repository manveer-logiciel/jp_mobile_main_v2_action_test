import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HoverOrderFormController extends GetxController {

  HoverOrderFormController(this.params);

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late HoverOrderFormService service;
  HoverOrderFormParams? params;

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  final formKey = GlobalKey<FormState>();

  get pageTitle => 'hover_order'.tr.toUpperCase();

  @override
  void onInit() {

    params ??= Get.arguments?[NavigationParams.params];

    // setting up service
    service = HoverOrderFormService(
      update: update,
      params: params,
      validateForm: () => onDataChanged(''),
    );
    service.controller = this;
    service.initForm();

    super.onInit();
  }

  // synchHover() : will save form data on validations completed otherwise scroll to error field
  Future<void> synchHover() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    bool isValid = validateForm(); // validating form

    if (isValid) {
      saveForm();
    } else {
      service.scrollToErrorField();
    }
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  Future<void> onDataChanged(dynamic val) async {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
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
    try {
      toggleIsSavingForm();
      await service.saveForm();
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSavingForm();
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;

  }
}