import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/form_field_type.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/global_widgets/forms/user_notification/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/enums/event_form_type.dart';
import '../../../common/models/forms/event/event_form_param.dart';
import '../../../common/models/job/job.dart';
import '../../../common/models/schedules/schedules.dart';
import '../../../common/services/calendars/event_form.dart';
import '../../../core/constants/dropdown_list_constants.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/single_select_helper.dart';
import '../../../global_widgets/bottom_sheet/index.dart';

class EventFormController extends GetxController {

  EventFormController({
    this.eventFormParam,
  });

  late EventFormService service;

  final formKey = GlobalKey<FormState>(); // used to validate form
  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isAllDayReminderEnabled = false; // used to manage/control expansion state of reminder notification section
  bool isUserNotificationEnabled = false;  // used to hide/show reminder notification info
  bool isRecurringEnabled = false;  // used to hide/show recurring info
  final EventFormParams? eventFormParam;
  SchedulesModel? schedulesModel; // helps in retrieving event from previous page
  JobModel? jobModel; // helps in retrieving job from previous page
  EventFormType? pageType; // helps in manage form privileges
  String? workOrderId; // helps in storing work order ids

  FilesListingModel? selectedFile;
  final userNotificationFormKey = GlobalKey<UserNotificationFormState>();

  List<Map<String, dynamic>> data = [];

  bool get isScheduleForm => pageType == EventFormType.createScheduleForm
      || pageType == EventFormType.editScheduleForm;

  String get pageTitle {
    switch (pageType) {
      case EventFormType.createForm:
        return 'create_event'.tr.toUpperCase();
      case EventFormType.editForm:
        return 'update_event'.tr.toUpperCase();
      case EventFormType.createScheduleForm:
        return 'create_schedule'.tr.toUpperCase();
      case EventFormType.editScheduleForm:
        return 'update_schedule'.tr.toUpperCase();
      default:
        return 'create_event'.tr.toUpperCase();
    }
  }

  String get saveButtonText {
    switch (pageType) {
      case EventFormType.createForm:
      case EventFormType.createScheduleForm:
        return 'create'.tr.toUpperCase();
      case EventFormType.editForm:
      case EventFormType.editScheduleForm:
        return 'update'.tr.toUpperCase();
      default:
        return 'create'.tr.toUpperCase();
    }
  }

  Function(dynamic val)? onUpdate;

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    schedulesModel ??= eventFormParam?.schedulesModel ?? Get.arguments?[NavigationParams.schedulesModel] ?? SchedulesModel();
    selectedFile = Get.arguments?[NavigationParams.selectedFile];
    jobModel ??= eventFormParam?.jobModel ?? eventFormParam?.schedulesModel?.job ?? Get.arguments?[NavigationParams.jobModel];
    pageType ??= eventFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType];
    workOrderId ??= Get.arguments?[NavigationParams.resourceId];
    if(pageType == EventFormType.createScheduleForm){
      if(selectedFile != null){
        schedulesModel?.workOrder ??= [];
        schedulesModel?.workOrder?.add(AttachmentResourceModel.fromFileModel(selectedFile!,null));
      }      
    }
    
    onUpdate = eventFormParam?.onUpdate;
    // setting up service
    service = EventFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      schedulesModel: schedulesModel,
      jobModel: jobModel,
      pageType: pageType,
      workOrderId: workOrderId
    );
    service.controller = this;
    await service.initForm(); // setting up form data
    onUserNotificationChanged(service.isUserNotificationSelected);
  }

  // createTask() : will save form data on validations completed otherwise scroll to error field
  Future<void> createEvent() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    bool isRecurringOverlappedValid = service.validateOverLappedSchedules(); // validating form

    bool isScheduleTimeValid = service.validateScheduleEventTime();

    bool isDivisionsValid = service.validateDivisions();

    bool isValid = validateForm() && isRecurringOverlappedValid && isScheduleTimeValid && isDivisionsValid;

    if (isValid) {
      saveForm(onUpdate: onUpdate);
    } else {
      service.scrollToErrorField();
    }
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false, FormFieldType? formFieldType }) {
    // realtime changes will take place only once after user tried to submit form
    if(formFieldType == FormFieldType.title) {
      service.isTitleEditedOnce = true;
      service.setScheduleTitle();
    }
    if (validateFormOnDataChange) {
      validateForm();
    }

    if(doUpdate) update();
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    bool isValid = formKey.currentState?.validate() ?? false;
    bool isUserNotificationFormValid = true;

    if(isUserNotificationEnabled) {
      isUserNotificationFormValid = userNotificationFormKey.currentState?.validate(scrollOnValidate: false) ?? false;
    }

    return isValid && isUserNotificationFormValid;
  }

  // onReminderChanged(): toggles reminder notification expansion state
  void onReminderChanged(bool val) {
    isAllDayReminderEnabled = val;
    service.toggleIsAllDayReminderSelected(val);
    service.validateScheduleEventTime();
    update();
  }

  // onUserNotificationChanged(): toggles reminder notification expansion state
  void onUserNotificationChanged(bool val) {
    isUserNotificationEnabled = val;
    service.toggleIsUserNotificationSelected(val);
    update();
  }

  // onRecurringChanged(): toggles recurring notification expansion state
  void onRecurringChanged(bool val) {
    isRecurringEnabled = val;
    service.toggleIsRecurringSelected(val);
    update();
  }

  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }


  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm({Function(dynamic val)? onUpdate , bool saveSpecificField = false}) async {

    bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    
    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      if(service.showChangesConfirmation(saveSpecificField)) {
        return scheduleChangesConfirmationDialog();
      }
      
      bool isEditForm = (pageType == EventFormType.editScheduleForm || pageType == EventFormType.editForm);
      if (service.isOnlyThis && isEditForm) {
        openUpdateScheduleBottomSheet();
      } else {
        updateSchedule("this");
      }
    }
  }

  void scheduleChangesConfirmationDialog() {
    showJPBottomSheet(child: (_) {
      return JPConfirmationDialog(
        title: 'confirmation'.tr,
        subTitle:'schedule_changes_confirmation'.tr,
        suffixBtnText: 'confirm'.tr,
        icon: Icons.report_problem_outlined,
        
        onTapSuffix: () {
          Get.back();
          saveForm(onUpdate: onUpdate, saveSpecificField: true); 
        },
      );
    });
  }

  void openUpdateScheduleBottomSheet() {
    SingleSelectHelper.openSingleSelect(
        isScheduleForm
            ? DropdownListConstants.updateScheduleTypeList
            : DropdownListConstants.updateEventTypeList,
        "",
        'update_for'.tr,
        (String value) {
          Get.back();
          updateSchedule(value);
        },
        isFilterSheet: false
    );
  }

  void updateSchedule(String value) async {

    switch(value) {
      case "this":
        service.isOnlyThis = false;
        break;
      case "all":
        service.isOnlyThis = true;
        break;
    }

    try {
      toggleIsSavingForm();
      await service.saveForm(onUpdate: onUpdate);
    } catch (e) {
      toggleIsSavingForm();
      rethrow;
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }

    return false;

  }

  // showUnsavedChangesConfirmation(): displays confirmation dialog
  void showUnsavedChangesConfirmation() {
    showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
        title: 'unsaved_changes'.tr,
        subTitle: 'unsaved_changes_desc'.tr,
        icon: Icons.warning_amber_outlined,
        suffixBtnText: 'dont_save'.tr.toUpperCase(),
        prefixBtnText: 'cancel'.tr.toUpperCase(),
        onTapSuffix: () {
          Get.back();
          Get.back();
        },
      ),
    );
  }
}