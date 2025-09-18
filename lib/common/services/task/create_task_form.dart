import 'dart:ui';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/tasks.dart';
import 'package:jobprogress/common/models/forms/create_task/index.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/repositories/firebase/firestore/groups.dart';
import 'package:jobprogress/common/repositories/task_listing.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/profile_image_widget/index.dart';
import '../../enums/form_field_type.dart';
import '../../enums/form_field_visibility.dart';
import '../../enums/task_form_type.dart';
import '../../models/job/job.dart';
import '../../models/workflow_stage.dart';

/// CreateTaskFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class CreateTaskFormService extends CreateTaskFormData {
  CreateTaskFormService(
      {required super.update,
      required this.validateForm,
      super.task,
      super.jobModel,
      super.pageType});

  final VoidCallback
      validateForm; // helps in validating form when form data updates
  CreateTaskFormController?
      _controller; // helps in managing controller without passing object

  CreateTaskFormController get controller =>
      _controller ?? CreateTaskFormController();

  set controller(CreateTaskFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  Future<void> initForm({bool isTaskTemplate = false}) async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
      await setAllUsers(isTaskTemplate: isTaskTemplate); // loading users from local DB
      setFormData(isTaskTemplate: isTaskTemplate); // filling form data

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

 void setUserTypeList(List<JPMultiSelectModel> users, {List<String>? selectedUsers , bool isTaskTemplate = false}) {
  if (jobModel != null) {
    if (jobModel?.isMultiJob ?? false) {
      JPMultiSelectModel firstUser = UserTypeConstants.userTypeList.firstWhere((element) => element.id == '-1');
        users.insert(0, JPMultiSelectModel.clone(firstUser)); 
     
    } else {
      users.insertAll(0, UserTypeConstants.userTypeList.map((user) => JPMultiSelectModel.clone(user)).toList());
    }
    if (!Helper.isValueNullOrEmpty(selectedUsers) && isTaskTemplate) {
      for (var selectedUser in selectedUsers!) {
        users.firstWhereOrNull((user) => user.id == Helper.getUserTypeId(selectedUser))?.isSelect = true;
      }
    } 
  }
}

  // setAllUsers(): loads users from local DB & also fill fields with selected users
  Future<void> setAllUsers({bool isTaskTemplate = false}) async {
    final loggedInUserId = AuthService.userDetails!.id.toString();

    List<String> userIds =
        task?.participants?.map((user) => user.id.toString()).toList() ?? [];


    List<String> notifyUserIds =
        task?.notifyUsers?.map((user) => user.id.toString()).toList() ??
            [loggedInUserId];

    // loading from DB

    users = await FormsDBHelper.getAllUsers(
      userIds, 
      divisionIds: [jobModel?.division?.id]
      );
    tags = await FormsDBHelper.getAllTags();
    notifyUsers = await FormsDBHelper.getAllUsers(
        notifyUserIds,
        divisionIds: [jobModel?.division?.id]
    );
    if(pageType != TaskFormType.salesAutomation){
      setUserTypeList(users, selectedUsers: task?.assignToSetting, isTaskTemplate: isTaskTemplate);
      setUserTypeList(notifyUsers, selectedUsers: task?.notifyUserSetting, isTaskTemplate: isTaskTemplate); 
    }
    
    // Set stages for the job
    setStages();

    // filling fields
    FormValueSelectorService.parseMultiSelectData(
        notifyUsers, notifyUsersController);
  }
  String getStageCode(TaskListModel? task, JobModel? jobModel) {
  // Create a list of possible stage code values to return
  List<String?> stageCodes = [
    task?.stage?.code,
    jobModel?.currentStage?.code,
    task?.stageCode
  ];

  // Iterate through the list and return the first non-null, non-empty stage code
  for (String? code in stageCodes) {
    if (!Helper.isValueNullOrEmpty(code)) {
      return code!;
    }
  }
  return "";
}
  
  void setStages() {
    stageList = [];
    int? position = jobModel?.stages?.firstWhereOrNull((element) => element.code == jobModel?.currentStage?.code)?.position;
    
    jobModel?.stages?.forEach((element) {
      if(position != null &&  (element.position ?? 0) >= position) {
        stageList.add(JPSingleSelectModel(
          id: element.code,
          label: element.name,
          child: JPProfileImage(
            size: JPAvatarSize.small,
            color: element.color,
            initial: element.initial,
          )
        ));
      }
    });

    if(task?.stage?.code != null) {
      stageList.addIf(
        stageList.every((element) => element.id != task?.stage?.code), JPSingleSelectModel(
          id: task?.stage?.code ?? "",
          label: task?.stage?.name ?? "",
          child: JPProfileImage(
            size: JPAvatarSize.small,
            color:  task?.stage?.color ?? "",
            initial: task?.stage?.initial ?? "",
          )
        )
      );
    }
    
    selectedStage = stageList.firstWhereOrNull((element) => element.id == (getStageCode(task, jobModel)));
    if(task?.stageCode?.isNotEmpty ?? false) {
      task?.stage = WorkFlowStageModel(
        code: selectedStage?.id ?? "",
        color: selectedStage?.child != null ? (selectedStage?.child as JPProfileImage).color ?? "" : "",
        name: selectedStage?.label ?? "",
        initial: selectedStage?.child != null ? (selectedStage?.child as JPProfileImage).initial ?? "" : "",
      );
    }
  }

  Future<void> updateUsersOnJobChange() async {

    final selectedNotifyUserIds = selectedNotifyUsers.map((e) => e.id).toList();

    notifyUsers = await FormsDBHelper.getAllUsers(
      selectedNotifyUserIds,
      divisionIds: [jobModel?.division?.id],
    );

    if(!(pageType != TaskFormType.createForm || pageType != TaskFormType.progressBoardCreate)) return;

    final selectedUserIds = selectedUser.map((e) => e.id).toList();

    users = await FormsDBHelper.getAllUsers(
      selectedUserIds,
      divisionIds: [jobModel?.division?.id],
    );
    setUserTypeList(users);
    setUserTypeList(notifyUsers);

    setStages();
  }

  /// getters

  List<JPMultiSelectModel> get selectedUser =>
      FormValueSelectorService.getSelectedMultiSelectValues(users);

  List<JPMultiSelectModel> get selectedNotifyUsers =>
      FormValueSelectorService.getSelectedMultiSelectValues(notifyUsers);

  /// selectors to select form data (users, jobs etc) --------------------------

  void selectAssignTo() {
    FormValueSelectorService.openMultiSelect(
      list: users,
      tags: tags,
      title: 'assign_to'.tr,
      controller: usersController,
      onSelectionDone: () {
        validateForm();
        update();
      },
    );
  }

  void selectNotifyUsers() {
    FormValueSelectorService.openMultiSelect(
      list: notifyUsers,
      tags: tags,
      title: 'notify_users_on_completion'.tr,
      controller: notifyUsersController,
      onSelectionDone: () {
        validateForm();
        update();
      },
    );
  }

  void selectReminderType() {
    FormValueSelectorService.openSingleSelect(
        list: selectedReminderList,
        controller: reminderTypeController,
        selectedItemId: reminderTypeId,
        onValueSelected: (val) {
          reminderTypeId = val;
          validateAndUpdateReminderTime();
          update();
        });
  }

  void validateAndUpdateReminderTime() {
    if (reminderFrequencyController.text.isEmpty) {
      reminderFrequencyController.text = '1';
    } else {
      reminderFrequencyController.text =
          FormValidator.setMaxAvailableFrequencyValue(
              reminderTypeId, reminderFrequencyController.text);
    }
  }

  void selectJob() {
    FormValueSelectorService.selectJob(
        jobModel: jobModel,
        controller: jobController,
        onSelectionDone: (job) async {
          jobModel = controller.jobModel = job;
          await controller.fetchJob();
          await updateUsersOnJobChange();
          update();
        });
  }

  void selectDueOnDate() {
    FormValueSelectorService.selectDate(
        date: dueOnDate,
        controller: dueOnController,
        initialDate: dueOnDate.toString(),
        onDateSelected: (date) {
          dueOnDate = date;
          validateForm();
        });
  }

  void selectStage(String val) {
    selectedStage = stageList.firstWhereOrNull((element) => element.id == val);
    task?.stage = WorkFlowStageModel(
      code: selectedStage?.id ?? "",
      color: (selectedStage?.child as JPProfileImage).color ?? "",
      name: selectedStage?.label ?? "",
      initial: (selectedStage?.child as JPProfileImage).initial ?? "",
    );
    update();
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void toggleReminderNotificationType(dynamic val) {
    groupVal = val;
    isDueDateReminder = groupVal == ReminderNotificationType.beforeDueDate;
    final selectedReminderType = selectedReminderList[0].id;
    reminderTypeId = selectedReminderType;
    reminderTypeController.text =
        SingleSelectHelper.getSelectedSingleSelectValue(
            selectedReminderList, selectedReminderType);
    validateAndUpdateReminderTime();
    update();
  }

  void toggleIsHighPriorityTask(bool val) {
    isHighPriorityTask = !val;
    update();
  }

  void toggleEmailNotification(bool val) {
    emailNotification = !val;
    update();
  }

  void toggleMessageNotification(bool val) {
    messageNotification = !val;
    update();
  }

  void toggleIsDueDateReminder(bool val) {
    messageNotification = !val;
    update();
  }

  void onAdditionalOptionsExpansionChanged(bool val) {
    isAdditionalDetailsExpanded = val;
  }

  void toggleIsReminderNotificationSelected(bool val) {
    isReminderNotificationSelected = val;
  }

  void toggleIsLockStageSelected(bool val) {
    isLockStageSelected = val;
  }

  // onJobLockedChanged(): toggles jobs locked state
  void onJobLockedChanged(bool val) {
    isStageLocked = val;
    update();
  }

  void removeSelectedUser(JPMultiSelectModel user,
      {bool doPopOnLastItemRemove = false}) {
    user.isSelect = false;
    update();
    if (doPopOnLastItemRemove) {
      if (selectedUser.length <= 5) {
        Get.back();
      }
    }
  }

  void removeSelectedNotifyUser(int index) {
    notifyUsers[index].isSelect = false;
    update();
  }

  Future<void> removeJob() async {
    jobModel = null;
    jobController.text = '';
    await updateUsersOnJobChange();
    isStageLocked = false;
    update();
  }

  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
        attachments: attachments,
        maxSize: CommonConstants.totalAttachmentMaxSize,
        jobId: jobModel?.id,
        onSelectionDone: () {
          update();
        });
  }

  /// form field validators ----------------------------------------------------

  String? validateTitle(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'title_cant_be_left_blank'.tr);
  }

  String? validateAssignTo(String val) {
    if (selectedUser.isEmpty) {
      return 'task_must_be_assigned_to_some_one'.tr;
    }
    return null;
  }

  String? validateDueOn(String val) {
    if (isDueDateReminder && isReminderNotificationSelected) {
      return FormValidator.requiredFieldValidator(val,
          errorMsg: 'due_date_is_required_for_before_due_date_reminder'.tr);
    } else {
      return null;
    }
  }

  String? validateReminderFrequency(String val) {
    if (isReminderNotificationSelected) {
      return FormValidator.requiredFieldValidator(val,
          errorMsg: 'enter_valid_value'.tr);
    } else {
      return null;
    }
  }

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable(dynamic formFieldType) {
    switch (pageType) {
      case TaskFormType.createForm:
        return true;
      case TaskFormType.editForm:
        switch (formFieldType) {
          case FormFieldType.assignedTo:
          case FormFieldType.sendCopy:
          case FormFieldType.linkJob:
          case FormFieldVisibility.linkJob:
          case FormFieldVisibility.sendCopy:
            if ((formFieldType == FormFieldVisibility.linkJob && jobModel != null) || isJobNotFound ) return true;
            return false;
          default:
            return true;
        }
      case TaskFormType.salesAutomation:
        switch (formFieldType) {
          case FormFieldType.title:
          case FormFieldType.linkJob:
          case FormFieldType.note:
          case FormFieldType.attachments:
          case FormFieldVisibility.linkJob:
            return false;
          default:
            return true;
        }
      case TaskFormType.progressBoardCreate:
        switch (formFieldType) {
          case FormFieldType.linkJob:
            return false;
          default:
            return true;
        }
      case TaskFormType.progressBoardEdit:
        switch (formFieldType) {
          case FormFieldType.assignedTo:
          case FormFieldType.linkJob:
          case FormFieldType.sendCopy:
          case FormFieldVisibility.sendCopy:
            return false;
          default:
            return true;
        }
      default:
        return true;
    }
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    bool isTitleError = validateTitle(titleController.text) != null;
    bool isAssignToError = validateAssignTo(usersController.text) != null;
    bool isDueOnError = validateDueOn(dueOnController.text) != null;
    bool isReminderFrequencyError =
        validateReminderFrequency(reminderFrequencyController.text) != null;

    if (isTitleError) {
      titleController.scrollAndFocus();
    } else if (isAssignToError) {
      usersController.scrollAndFocus();
    } else if (isDueOnError) {
      dueOnController.scrollAndFocus();
    } else if (isReminderFrequencyError) {
      if (!controller.isAdditionalDetailsExpanded) {
        controller.onAdditionalOptionsExpansionChanged(true);
        update();
        // ignore: inference_failure_on_instance_creation
        await Future.delayed(const Duration(milliseconds: 200));
      }
      reminderFrequencyController.scrollAndFocus();
    }
  }

  // saveForm():  makes a network call to save/update form
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    try {
      final params = taskFormJson();
      switch(pageType) {
        case TaskFormType.createForm:
        case TaskFormType.progressBoardCreate:
          await createTaskAPICall(params);
          break;
        case TaskFormType.editForm:
        case TaskFormType.progressBoardEdit:
          await updateTaskAPICall(params);
          break;
        case TaskFormType.salesAutomation:
          await onUpdate!(jsonToTaskListingModel(taskFormJson(), selectedUser, selectedNotifyUsers));
          break;
        default:
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createTaskAPICall(Map<String, dynamic> params) async {
    final result = await TaskListingRepository().createTask(params);
    if(messageNotification) {
      final taskDetails = result['data'] as TaskListModel;
      await sendMessage(taskDetails);
    }
    if (result["status"]) {
      MixPanelService.trackEvent(event: MixPanelAddEvent.form);
      Helper.showToastMessage('task_created'.tr);
      Get.back(result: result);
    }
  }

  Future<void> updateTaskAPICall(Map<String, dynamic> params) async {
    final result = await TaskListingRepository().updateTask(params);
    if (result["status"]) {
      MixPanelService.trackEvent(event: MixPanelEditEvent.form);
      Helper.showToastMessage('task_updated'.tr);
      Get.back(result: result);
    }
  }

  Future<void> sendMessage(TaskListModel task) async {
    List<String> participantIds = users
        .where((participant) => participant.isSelect)
        .map((selectedParticipant) => selectedParticipant.id)
        .toList();

    if (FirestoreHelpers.instance.isMessagingEnabled) {
      await GroupsRepo.createNewGroup(
          content: GroupsRepo.getMessageContentForTask(task),
          jobId: jobModel?.id.toString(),
          sendAsEmail: false,
          participantIds: participantIds,
          taskId: task.id.toString());
    }
  }
}
