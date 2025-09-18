import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/division_unmatch.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/division_unmatch/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/constants/dropdown_list_constants.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../core/utils/form/db_helper.dart';
import '../../../core/utils/form/validators.dart';
import '../../../core/utils/single_select_helper.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../modules/calendar/event/controller.dart';
import '../../../modules/work_crew_notes/add_edit_note_dialog_box/index.dart';
import '../../../routes/pages.dart';
import '../../enums/date_picker_type.dart';
import '../../enums/event_form_type.dart';
import '../../enums/file_listing.dart';
import '../../enums/form_field_type.dart';
import '../../models/forms/event/index.dart';
import '../../models/note_list/note_listing.dart';
import '../../repositories/events.dart';
import '../file_attachment/quick_actions.dart';
import '../forms/value_selector.dart';

class EventFormService extends EventFormData {
  EventFormService({
    required super.update,
    required this.validateForm,
    super.schedulesModel,
    super.jobModel,
    super.pageType,
    super.workOrderId,
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  EventFormController? _controller; // helps in managing controller without passing object

  EventFormController get controller => _controller ?? EventFormController();

  set controller(EventFormController value) => _controller = value;


  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
      await setAllUsers(); // loading users from local DB

      setFormData(); // filling form data

      // In Duplicate case data will fill and should be saved without showing error 'no changes made'
      if(pageType == EventFormType.createScheduleForm) {
        initialJson = {};
      }

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  // setAllUsers(): loads users from local DB & also fill fields with selected users
  Future<void> setAllUsers() async {

    List<String> crewUsersIds = schedulesModel?.reps?.map((user) => user.id.toString()).toList() ?? [];
    List<String> contractorsUsersIds = schedulesModel?.subContractors?.map((user) => user.id.toString()).toList() ?? [];
    List<String> tradeIds = schedulesModel?.trades?.map((trade) => trade.id.toString()).toList() ?? [];

    // loading from DB
    crewUsers = await FormsDBHelper.getAllUsers(crewUsersIds, withSubContractorPrime: false);
    tagList = await FormsDBHelper.getAllTags();
    contractorsUsers = await FormsDBHelper.getAllUsers(
        contractorsUsersIds,
        onlySub: true,
        useCompanyName: true,
        isSubTextVisible: false
    );

    if(jobModel != null) {
      trades = [];
      jobModel?.trades?.forEach((element) {
        trades.add(JPMultiSelectModel(
          id: element.id.toString(),
          label: element.name ?? "",
          isSelect: tradeIds.any((id) => id == element.id.toString(),
          ),
        ));
      });

      if (pageType == EventFormType.createScheduleForm) {
        if (tradeIds.isEmpty) {
          tradeIds = jobModel?.trades?.map((trade) => trade.id.toString()).toList() ?? [];
          for (var trade in trades) {
            for (var element in tradeIds) {
              if(element == trade.id){
                trade.isSelect = true;
              }
            }
          }
        }

        for (var element in crewUsers) {
          jobModel?.reps?.forEach((reps) {
            if (reps.id.toString() == element.id) {
              element.isSelect = true;
            }
          });
        }

        for (var element in contractorsUsers) {
          jobModel?.workCrew?.forEach((workCrew) {
            if (workCrew.id.toString() == element.id) {
              element.isSelect = true;
            }
          });
        }
      }
    }

    // filling fields
    FormValueSelectorService.parseMultiSelectData(crewUsers, companyCrewController);
    FormValueSelectorService.parseMultiSelectData(contractorsUsers, labourContractorsController);
    FormValueSelectorService.parseMultiSelectData(trades, tradesController);
  }

  /// getters

  List<JPMultiSelectModel> get selectedCompanyCrew => FormValueSelectorService.getSelectedMultiSelectValues(crewUsers);

  List<JPMultiSelectModel> get selectedLaborContractors => FormValueSelectorService.getSelectedMultiSelectValues(contractorsUsers);

  bool get isScheduleForm => pageType == EventFormType.createScheduleForm || pageType == EventFormType.editScheduleForm;

  /// selectors to select form data (users, jobs etc) --------------------------

  void selectTrade() {

    FormValueSelectorService.openMultiSelect(
      list: trades,
      title: 'select_trades'.tr,
      controller: tradesController,
      onSelectionDone: () {
        validateForm();
        update();
        setScheduleTitle();
      },
    );
  }

  // here is the list of company crew that can be selected
  void selectCompanyCrew() {
    FormValueSelectorService.openMultiSelect(
      list: crewUsers,
      tags: tagList,
      title: 'company_crew'.tr,
      controller: companyCrewController,
      onSelectionDone: () {
        setScheduleTitle();
        validateForm();
        update();
      },
    );
  }
  

  void removeSelectedWorkCrew() {
    setScheduleTitle();
    validateForm();
    update();
  }

  void selectLabourContractors() {
    FormValueSelectorService.openMultiSelect(
      list: contractorsUsers,
      title: 'labor_sub_contractors'.tr,
      controller: labourContractorsController,
      onSelectionDone: () {
        setScheduleTitle();
        validateForm();
        update();
      },
    );
  }

  void selectRecurringType() {
    SingleSelectHelper.openSingleSelect(
        DropdownListConstants.recurringDurationList,
        selectedRecurringType,
        'select'.tr, (value) {
      setRecurring(value);
    });
  }

  void setRecurring(String val) {
    selectedRecurringType = val;
    recurringFrequencyController.text = SingleSelectHelper.getSelectedSingleSelectValue(DropdownListConstants.recurringDurationList, selectedRecurringType);
    Get.back();
  }

  void openDatePicker({String? initialDate, required DatePickerType datePickerType, String? firstDate}) {
    DateTimeHelper.openDatePicker(
        initialDate: initialDate,
        firstDate: datePickerType == DatePickerType.end ? firstDate : null,
        helpText: datePickerType == DatePickerType.start ? "start_date".tr : "end_date".tr).then((dateTime) {
      if(dateTime != null) {
        DateTime currentDateTime = DateTime.now();
        dateTime = dateTime.add(Duration(hours: currentDateTime.hour, minutes: currentDateTime.minute, seconds: currentDateTime.second));
        switch (datePickerType) {
          case DatePickerType.start:
            startDateTime = DateTimeHelper.dateTimePickerTimeFormatting(dateTime.toString(), startDateTime ?? "");
            break;
          case DatePickerType.end:
            endDateTime = DateTimeHelper.dateTimePickerTimeFormatting(dateTime.toString(), endDateTime ?? "");
            break;
        }
        endDateTime = modifyEndDateTime(endDateTime!, startDateTime!, datePickerType)?? endDateTime;
        if(controller.validateFormOnDataChange) validateScheduleEventTime();
        update();
      }
    });
  }

  void openTimePicker({required DatePickerType datePickerType, String? initialTime}) {

    DateTimeHelper.openTimePicker(
        initialTime: initialTime,
        helpText: datePickerType == DatePickerType.start ? "start_time".tr : "end_time".tr).then((pickedTime) {
      if(pickedTime != null) {
        switch (datePickerType) {
          case DatePickerType.start:
            startDateTime = DateTimeHelper.dateTimePickerTimeFormatting(startDateTime ?? "", pickedTime.toDateTime().toString());
            break;
          case DatePickerType.end:
            endDateTime = DateTimeHelper.dateTimePickerTimeFormatting(endDateTime ?? "", pickedTime.toDateTime().toString());
            break;
        }
        endDateTime = modifyEndDateTime(endDateTime!, startDateTime!, datePickerType)?? endDateTime;
        if(controller.validateFormOnDataChange) validateScheduleEventTime();
        update();
      }
    });
  }

  List<JPMultiSelectModel> addDataInJobUserList(List<UserLimitedModel>? jobUserList, List<JPMultiSelectModel> userList) {
    List<JPMultiSelectModel> modifiedJobUserList = [];
    
    jobUserList ??= [];
    for (UserLimitedModel jobUser in jobUserList) {
      List<JPMultiSelectModel> tempUsers = userList.where((user) => jobUser.id.toString() == user.id).toList();
      modifiedJobUserList.addAll(tempUsers);
    }
    return modifiedJobUserList;
  }

  void createWorkNote() {
    // Clone the crew users list to avoid modifying the original list
    List<JPMultiSelectModel> clonedCrewList = crewUsers.map((user) => JPMultiSelectModel.clone(user)).toList();
    
    // Clone the contractors users list to avoid modifying the original list
    List<JPMultiSelectModel> clonedContractorsUsers = contractorsUsers.map((user) => JPMultiSelectModel.clone(user)).toList();
    
    List<Map<String, dynamic>> suggestionList = NoteService.getSuggestionsList(jobModel);
    List<JPMultiSelectModel> jobCrewUserList = addDataInJobUserList(jobModel?.reps, clonedCrewList);
    List<JPMultiSelectModel> jobContractorUserList = addDataInJobUserList(jobModel?.workCrew, clonedContractorsUsers);
      
    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: AddEditWorkCrewNoteDialogBox(
            jobId: jobModel?.id ?? jobModel?.id ?? schedulesModel?.jobId ?? 0,
            suggestionList: suggestionList,
            companyCrewList: jobCrewUserList,
            subcontractorList: jobContractorUserList,
            note: (schedulesModel?.workCrewNote?.isNotEmpty ?? false) ? schedulesModel?.workCrewNote![0] : null,
            dialogController: dialogController,
            isEdit: false,
            onFinish: (noteListModel) {
              if(schedulesModel?.workCrewNote?.isEmpty ?? true) {
                schedulesModel?.workCrewNote = [];
              }
              schedulesModel?.workCrewNote?.add(noteListModel);
              update();
            },
          )
        );
      }
    );
  }

  void selectWorkNote() {
    Get.toNamed(Routes.workCrewNotesListing, arguments: {
      'jobId': jobModel?.id,
      'customerId': jobModel?.customerId,
      NavigationParams.isInSelectMode: true,
      NavigationParams.list: schedulesModel?.workCrewNote,
    })?.then((value)  {
      if(value != null && value is List<NoteListModel>) {
        schedulesModel?.workCrewNote = value;
        update();
      }
    });
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void toggleIsAllDayReminderSelected(bool val) => isAllDayReminderSelected = val;

  void toggleIsUserNotificationSelected(bool val) => isUserNotificationSelected = val;

  void toggleIsRecurringSelected(bool val) => isRecurringSelected = val;

  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
        attachments: attachments,
        jobId: jobModel?.id,
        maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.totalAttachmentMaxSize),
        onSelectionDone: () {
          update();
        });
  }

  // addWorkOrderAttachment() : displays quick actions sheet to select files from
  void addWorkOrderAttachment() async {
    FileAttachService.showAttachDialog(
        FLModule.workOrder,
        jobId: jobModel?.id,
        allowMultiple: true,
        onFilesSelected: (files) async {
          if(schedulesModel?.workOrder?.isEmpty ?? true) {
            schedulesModel?.workOrder = [];
          }

          await Future<void>.delayed(const Duration(milliseconds: 500));

          schedulesModel?.workOrder?.addAll(files);
          update();
        }
    );
  }

  // removeWorkOrderAttachment() : displays quick actions sheet to select files from
  void removeWorkOrderAttachment(int index) async {
    schedulesModel?.workOrder?.removeAt(index);
    update();
  }

  // addMaterialAttachment() : displays quick actions sheet to select files from
  void addMaterialAttachment() async {
    FileAttachService.showAttachDialog(
        FLModule.materialLists,
        jobId: jobModel?.id,
        allowMultiple: true,
        onFilesSelected: (files) async {
          if(schedulesModel?.materialList?.isEmpty ?? true) {
            schedulesModel?.materialList = [];
          }
          await Future<void>.delayed(const Duration(milliseconds: 500));
          schedulesModel?.materialList?.addAll(files);
          update();
        }
    );
  }

  // removeMaterialAttachment() : displays quick actions sheet to select files from
  void removeMaterialAttachment(int index) async {
    schedulesModel?.materialList?.removeAt(index);
    update();
  }

  /// form field validators ----------------------------------------------------

  String? validateTitle(String val) => FormValidator.requiredFieldValidator(val, errorMsg: 'title_cant_be_left_blank'.tr);

  bool validateScheduleEventTime() {
    if(!isAllDayReminderSelected) {
      if(startDateTime?.isEmpty ?? true) {
        errorText = "please_provide_start_date_and_time".tr;
      } else if(endDateTime?.isEmpty ?? true) {
        errorText = "please_provide_end_date_and_time".tr;
      } else if(DateTime.parse(endDateTime ?? "" ).isBefore(DateTime.parse(startDateTime ?? ""))) {
        errorText = "end_time_must_be_greater_then_start_time".tr;
      } else if(endDateTime == startDateTime) {
        errorText = "end_time_must_be_greater_then_start_time".tr;
      } else if(!validateOverLappedSchedules()) {
        errorText = 'overlapped_schedules_are_not_allowed'.tr;
      } else {
        errorText = null;
      }
    } else {
      if(startDateTime?.isEmpty ?? true) {
        errorText = "please_provide_start_date_and_time".tr;
      } else if(!validateOverLappedSchedules()) {
        errorText = 'overlapped_schedules_are_not_allowed'.tr;
      } else {
        errorText = null;
      }
    }
    update();
    return errorText?.isEmpty ?? true;
  }

  bool validateOverLappedSchedules() {
    if(isAllDayReminderSelected || !isRecurringSelected) {
      return true;
    } else {

      final isValid = FormValidator.validateOverLappedRecurring(
        startDateTime: DateTime.parse(startDateTime!),
        endDateTime: DateTime.parse(endDateTime!),
        repeat: selectedRecurringType,
      );

      return isValid;
    }
  }

  bool validateDivisions() {

    if(jobModel?.division?.id == null) return true;

    List<JPMultiSelectModel> usersFromAnotherDivision = FormValidator.validateAllUsersBelongToSameDivision(
      currentDivisionId: jobModel!.division!.id!,
      selectedUsers: selectedCompanyCrew,
    );

    if(usersFromAnotherDivision.isEmpty) {
      return true;
    } else {
      showDivisionFailedDialog(usersFromAnotherDivision);
      return false;
    }
  }

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable(dynamic formFieldType) {

    if(controller.isSavingForm) {
      return false;
    }

    switch (pageType) {
      case EventFormType.createForm:
        return true;
      case EventFormType.editScheduleForm:
        if(controller.isUserNotificationEnabled) {
          switch (formFieldType) {
            case FormFieldType.emailNotification:
            case FormFieldType.notificationDuration:
            case FormFieldType.gapInNotifications:
              return false;
            default:
              return true;
          }
        } else {
          return true;
        }
      default:
        return true;
    }
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {

    if(isUserNotificationSelected) {
      controller.userNotificationFormKey.currentState?.validate(scrollOnValidate: true) ?? false;
    }
    if (validateTitle(titleController.text) != null) {
      titleController.scrollAndFocus();
    } else if(FormValidator.validateOccurrence(recurringOccurrencesController.text) != null) {
      recurringOccurrencesController.scrollAndFocus();
    } else if(!validateScheduleEventTime()) {
      dateTimeController.scrollAndFocus();
    }
  }

  // saveForm():  makes a network call to save/update form
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    try {
      final params = eventFormJson();
      switch(pageType) {
        case EventFormType.createForm:
        case EventFormType.createScheduleForm:
          await createEventAPICall(params);
          break;
        case EventFormType.editForm:
        case EventFormType.editScheduleForm:
          await updateEventAPICall(params);
          break;
        default:
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createEventAPICall(Map<String, dynamic> params) async {
    try {
      final result = await EventsRepository().createEvent(params);
      if (result["status"]) {
        switch(pageType) {
          case EventFormType.createForm:
            Helper.showToastMessage('event_created'.tr);
            break;
          default:
            Helper.showToastMessage('schedule_created'.tr);
            break;
        }
        MixPanelService.trackEvent(event: MixPanelAddEvent.form);
        Get.back(result: result);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEventAPICall(Map<String, dynamic> params) async {
    try {
      final result = await EventsRepository().updateEvent(schedulesModel?.id?.toString() ?? "", params);
      if (result["status"]) {
        switch(pageType) {
          case EventFormType.editForm:
            Helper.showToastMessage('event_updated'.tr);
            break;
          default:
            Helper.showToastMessage('schedule_updated'.tr);
            break;
        }
        MixPanelService.trackEvent(event: MixPanelEditEvent.form);
        Get.back(result: result);
      }
    } catch (e) {
      rethrow;
    }
  }

  void showDivisionFailedDialog(List<JPMultiSelectModel> userFromAnotherDivision) {
    showJPGeneralDialog(child: (_) => DivisionUnMatchAlert(
      jobs: [jobModel!],
      type: DivisionUnMatchType.schedule,
      usersFromAnotherDivision: userFromAnotherDivision,
    ),
    );
  }

  String? modifyEndDateTime(String endDateTime, String startDateTime, DatePickerType datePickerType) {
    // bool value to check if end date is before start date
    bool isEndDateAfterStartDate = DateTime.parse(endDateTime).isBefore(DateTime.parse(startDateTime));
    String  formattedEndTime = DateTimeHelper.formatDate(endDateTime,DateFormatConstants.dateTimeFormatWithoutSeconds);
    String  formattedStartDate = DateTimeHelper.formatDate(endDateTime,DateFormatConstants.dateTimeFormatWithoutSeconds);

    // Write if condition to check if end time is less than start time then add 1 hour in end time
    if(datePickerType == DatePickerType.start && (isEndDateAfterStartDate || formattedEndTime ==  formattedStartDate)) {
      return DateTimeHelper.dateTimePickerTimeFormatting(startDateTime, DateTime.parse(startDateTime).add(const Duration(hours: 1)).toString());
    }
    return null;
  }

  bool showChangesConfirmation( bool saveSpecificField) {
    bool showScheduleEditConfirmation = Helper.isTrue(
      CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.showScheduleEditConfirmation)
    );
    bool isSpecificFieldModified = checkIfSpecificFieldChanged() ;
    bool isEditSchedulePage = pageType == EventFormType.editScheduleForm;

    return isSpecificFieldModified && 
      !saveSpecificField && 
      showScheduleEditConfirmation && 
      isEditSchedulePage;
  }
}