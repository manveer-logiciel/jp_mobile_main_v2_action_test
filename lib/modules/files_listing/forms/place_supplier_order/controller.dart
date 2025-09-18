import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../global_widgets/forms/phone/index.dart';

class PlaceSupplierOrderFormController extends GetxController {

  final formKey = GlobalKey<FormState>(); // used to validate form
  final personalDetailsFormKey = GlobalKey<FormState>(); // used to validate form
  final phoneFormKey = GlobalKey<PhoneFormState>(); // used to validate Phone field

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late PlaceSupplierOrderFormService service; // helps in handling form

  bool isSavingForm = false; // used to disable user interaction with ui

  JobModel? job = Get.arguments?[NavigationParams.jobModel]; // used to load job data
  int? worksheetId = Get.arguments?[NavigationParams.id]; // used to load file listing model data
  MaterialSupplierType type = Get.arguments?[NavigationParams.supplierType] ?? MaterialSupplierType.srs;
  int? forSupplierId = Get.arguments?[NavigationParams.forSupplierId];

  String? deliveryDate = Get.arguments?[NavigationParams.deliveryDate];

  String get pageTitle {
    switch (type) {
      case MaterialSupplierType.srs:
        return 'place_srs_order'.tr.toUpperCase();
      case MaterialSupplierType.beacon:
        return 'place_beacon_order'.tr.toUpperCase();
      case MaterialSupplierType.abc:
        return 'place_abc_order'.tr.toUpperCase();

    }
  }

  String get saveButtonText => 'place_order'.tr.toUpperCase();

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    service = PlaceSupplierOrderFormService(
      job: job,
      type: type,
      worksheetId: worksheetId.toString(),
      forSupplierId: forSupplierId,
      deliveryDate: deliveryDate,
      update: update,
      validateForm: validateForm,
      onDataChange: onDataChanged
    );
    service.controller = this;
    service.initForm();
  }

  // createJob() : will save form data on validations completed otherwise scroll to error field
  Future<void> createPlaceSupplierOrder() async {
    service.validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    // validateAllFields() will validate as well as manage scroll to error field
    bool isValid = !(await service.validateAllFields());

    if (isValid) {
      saveForm();
    }
  }

  // onSectionExpansionChanged(): helps in manging expansion state of section
  void onSectionExpansionChanged(FormSectionModel section, bool val) {
    section.isExpanded = val;
    if(!val) Helper.hideKeyboard();
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val) {
    // realtime changes will take place only once after user tried to submit form
    if (service.validateFormOnDataChange) {
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
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      try {
        toggleIsSavingForm();
        await service.saveForm();
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

    if(isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return true;
  }

  Future<bool> onWillPopPersonalDetails() async {
    bool isNewDataAdded = service.checkIfNewPersonalDetailsDataAdded();
    if(isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }
    return true;
  }

  void onSavePersonalDetails() {
    bool isValid = personalDetailsFormKey.currentState?.validate() ?? false;
    bool isValidAddress = service.type == MaterialSupplierType.abc ? true : service.personalAddressFormKey.currentState?.validate(scrollOnValidation: true) ?? false;
    bool isValidPhone = type == MaterialSupplierType.abc ? phoneFormKey.currentState?.validate(scrollOnValidate: false) ?? false : true;
    if (isValid && isValidAddress && isValidPhone) {
      if (type == MaterialSupplierType.abc) {
        service.phoneField = phoneFormKey.currentState?.controller.phoneFields.first.toPhoneModel();
      }
      service.name = service.nameController.text;
      if(type == MaterialSupplierType.abc) {
        service.phone = service.phoneField?.number ?? '';
      } else {
        service.phone = service.phoneController.text;
      }
      service.email = service.emailController.text;
      service.companyAddress = service.personaladdress;
      bool isNewDataAdded = service.checkIfNewPersonalDetailsDataAdded(); // checking for changes
      if (!isNewDataAdded) {
        Helper.showToastMessage('no_changes_made'.tr);
      } else {
        Helper.hideKeyboard();
        Get.back();
      }
    }
  }
}