import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/providers/firebase/realtime_db.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormController extends GetxController {
  final formKey = GlobalKey<FormState>(); // used to validate form

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  late JobFormService service; // helps in handling form

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  JobModel? job = Get.arguments?[NavigationParams.jobModel]; // used to load job data
  JobFormType type = Get.arguments?[NavigationParams.type] ?? JobFormType.add;
  bool forEditInsurance =  Get.arguments?[NavigationParams.forEditInsurance] ?? false;
  int? customerId =  Get.arguments?[NavigationParams.customerId];
  ParentFormType parentFormType = Get.arguments?[NavigationParams.parentFormType] ?? ParentFormType.inherited;

  String get pageTitle {
    if (type == JobFormType.add) {
      return 'add_job'.tr.toUpperCase();
    } else {
      return 'update_job'.tr.toUpperCase();
    }
  }

  String get saveButtonText => type== JobFormType.add ? 
    'save'.tr.toUpperCase() :
    'update'.tr.toUpperCase() ;

  StreamSubscription<String>? fieldsSubscription;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    service = JobFormService(
        job: job,
        customerId: customerId,
        forEditInsurance: forEditInsurance,
        formType: type,
        update: update,
        validateForm: validateForm,
        onDataChange: onDataChanged,
    );
    service.initForm().then((value) => addFieldsListener());
  }

  // createJob() : will save form data on validations completed otherwise scroll to error field
  Future<void> createJob() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    // validateAllFields() will validate as well as manage scroll to error field
    bool isValid = !(await service.validateAllFields());
    isValid = isValid && service.validateUserDivision();
    if (isValid) {
      saveForm();
    }
  }

  // onSectionExpansionChanged(): helps in manging expansion state of section
  void onSectionExpansionChanged(FormSectionModel section, bool val) {
    section.isExpanded = val;
    if (!val) Helper.hideKeyboard();
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdateOnDataChange = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }

    if (doUpdateOnDataChange) update();
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
    if (!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      if (!await service.confirmAndSetUpdatedStage()) return;
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

    if (isNewDataAdded) {
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
}
