import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:permission_handler/permission_handler.dart';

class CustomerFormController extends GetxController {

  final formKey = GlobalKey<FormState>(); // used to validate form

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late CustomerFormService service; // helps in handling form

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  int? customerId = Get.arguments?[NavigationParams.customerId]; // used to load customer data

  String get pageTitle {
    if (customerId == null) {
      return 'add_lead_prospect_customer'.tr.toUpperCase();
    } else {
      return 'update_lead_prospect_customer'.tr.toUpperCase();
    }
  }

  String get saveButtonText => customerId == null ? 'save'.tr.toUpperCase() : 'update'.tr.toUpperCase();

  StreamSubscription<String>? fieldsSubscription;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    service = CustomerFormService(
      customerId: customerId,
      update: update,
      validateForm: validateForm,
      onDataChange: onDataChanged
    );
    service.initForm().then((value) => addFieldsListener());
  }

  // createCustomer() : will save form data on validations completed otherwise scroll to error field
  Future<void> createCustomer() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

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

  /// [addFieldsListener] is responsible for creating realtime listener for listening
  /// fields change / company settings change
  void addFieldsListener() {
    fieldsSubscription = RealtimeDBProvider.listenToLocalStream(
        RealTimeKeyType.companySettingUpdated,
        onData: service.showUpdateFieldConfirmation
    );
  }

  void removeFieldsListener() {
    fieldsSubscription?.cancel();
    fieldsSubscription = null;
  }

  // fetchContactFromPhone(): fetch contact from phone directory
  Future<void> fetchContactFromPhone() async { 
    try {
      PermissionStatus status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
        final contactsFromPhoneDirectory = await FlutterContacts.openExternalPick();
        if(contactsFromPhoneDirectory != null) {
          service.updateLoading();
          await Future<void>.delayed(const Duration(milliseconds: 500));
          service.getContactFromPhoneData(contactsFromPhoneDirectory);
        } else{
          service.updateLoading();
        }
      } else if(status == PermissionStatus.permanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      rethrow;
    } finally {
      service.updateLoading();    
    }
  }

}
