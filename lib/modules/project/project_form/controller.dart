import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/navigation_parms_constants.dart';

class ProjectFormController extends GetxController {
  ProjectFormController(
    this.fields,
    this.divisionCode,
    this.showCompanyCam,
    this.showHover,
    this.parentFormType, {
      this.customer,
  });

  final form = GlobalKey<FormState>();
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper;
  late ProjectFormService service; // helps in handling form
  List<InputFieldParams> fields;

  bool isSavingForm = false; // used to disable user interaction with ui
  bool isSectionExpanded = false;
  bool validateFormOnDataChange = false;
  bool? showHover;
  bool? showCompanyCam;// helps in continuous validation after user submits form
  CustomerModel? customer;

  String divisionCode;
  
  ParentFormType parentFormType;

  StreamSubscription<String>? fieldsSubscription;

  JobFormType type = Get.arguments?[NavigationParams.type] ?? JobFormType.add;

  JobModel? job = Get.arguments?[NavigationParams.jobModel]; // used to load job data

  String get saveButtonText => type== JobFormType.add ?
  'save'.tr.toUpperCase() :
  'update'.tr.toUpperCase();
  
  @override
  void onInit() {
    init();
    super.onInit();
  }


  String get pageTitle {
    if (type == JobFormType.add) {
      return 'add_project'.tr.toUpperCase();
    } else {
      return 'edit_project'.tr.toUpperCase();
    }
  }

  void didUpdateDivisionCode(String newDivisionCode){
    service.selectedJobDivisionCode = newDivisionCode;
    update();
  }


  Future<void> init() async {
    service = ProjectFormService(
        fields: fields,
        update: update,
        formType: type,
        validateForm: validateForm,
        onDataChange: onDataChanged,
        job: job,
        showCompanyCam: showCompanyCam,
        showHover: showHover,
        divisionCode: divisionCode,
        parenrFormType: parentFormType,
        customer: customer
    );
    service.initForm().then((_) {
      if (parentFormType == ParentFormType.individual) {
        addFieldsListener();
      }
    });
  }

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

  // onSectionExpansionChanged(): manages expansion state of section
  void onSectionExpansionChanged(bool val) {
    isSectionExpanded = val;
  }

  bool validateProjectForm() {
    return form.currentState?.validate() ?? false;
  }

  bool validateForm({bool scrollOnValidate = true}) {
    validateProjectForm();
    validateFormOnDataChange = true;
    bool isValid = service.validateProjectAllFields();
    return !isValid;
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
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

    return true;
  }

  // createJob() : will save form data on validations completed otherwise scroll to error field
  Future<void> createJob() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    // validateAllFields() will validate as well as manage scroll to error field
    bool isValid = validateForm();

    if (isValid) {
      saveForm();
    }
  }

  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if (!isNewDataAdded) {
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

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdateOnDataChange = true}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateProjectForm();
    }

    if (doUpdateOnDataChange) update();
  }

  Future<void> expandSection() async {
    // if section is already is expanded, no need to expand it again
    if (isSectionExpanded) return;

    isSectionExpanded = true;
    update();
    // additional delay for section to get expanded before focusing error field
    await Future<void>.delayed(const Duration(milliseconds: 300));

    validateForm(scrollOnValidate: true);
  }

  Map<String, dynamic> projectData() {
    return service.projectFormJson();
  }
}
