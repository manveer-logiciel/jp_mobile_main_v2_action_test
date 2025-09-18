import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/tasks.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../enums/task_form_type.dart';

/// CreateTaskFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
/// - Helps in comparing form data
class CreateTaskFormData {


  CreateTaskFormData({
    required this.update,
    required this.task,
    this.jobModel,
    this.pageType});

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  TaskListModel? task; // used to set up form data
  final TaskFormType? pageType;

  // form field controllers
  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController usersController = JPInputBoxController();
  JPInputBoxController jobController = JPInputBoxController();
  JPInputBoxController dueOnController = JPInputBoxController();
  JPInputBoxController notesController = JPInputBoxController();
  JPInputBoxController notifyUsersController = JPInputBoxController();
  JPInputBoxController reminderFrequencyController = JPInputBoxController(text: '1');
  JPInputBoxController reminderTypeController = JPInputBoxController();
  JPInputBoxController stageSelectionController = JPInputBoxController();

  // form toggles
  bool isHighPriorityTask = false;
  bool emailNotification = false;
  bool messageNotification = false;
  bool isDueDateReminder = false;
  bool isAdditionalDetailsExpanded = false;
  bool isReminderNotificationSelected = false;
  bool isLockStageSelected = false;
  bool isStageLocked = false;
  bool isJobNotFound = false;
  
  bool get isLockStageVisible =>  
    (((jobModel != null && jobModel?.parentId == null) 
      || ((jobModel?.stages?.length ?? 0) >= 1) 
      || (jobModel != null && jobModel!.isMultiJob)
      ) && PermissionService.hasUserPermissions([PermissionConstants.markTaskUnlock])
        && jobModel?.currentStage?.name != jobModel?.stages?.last.name
    );

  JobModel? jobModel; // used to store selected job data
  DateTime dueOnDate = DateTime.now(); // used to select task due date

  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user
  List<AttachmentResourceModel> uploadedAttachments = []; // contains attachments coming from server
  List<JPMultiSelectModel> tags = []; // used to store tags
  List<JPMultiSelectModel> users = []; // used to store users
  List<JPMultiSelectModel> notifyUsers = []; // used to store notify users
  List<JPSingleSelectModel> stageList = []; // used to store notify users

  List<JPSingleSelectModel> reminderTypes = [
    JPSingleSelectModel(id: 'hour', label: 'hours'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'day', label: 'days'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'week', label: 'weeks'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'month', label: 'months'.tr.capitalizeFirst!),
  ]; // for recurring notification

  List<JPSingleSelectModel> reminderBeforeDueDateTypes = [
    JPSingleSelectModel(id: 'day', label: 'days_before'.tr.capitalize!),
    JPSingleSelectModel(id: 'week', label: 'weeks_before'.tr.capitalize!),
    JPSingleSelectModel(id: 'month', label: 'months_before'.tr.capitalize!),
  ]; // for before due date notification

  String reminderTypeId = 'day';
  JPSingleSelectModel? selectedStage;
  dynamic groupVal = ReminderNotificationType.recurring;

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // proves selection list as per reminder notification type
  List<JPSingleSelectModel> get selectedReminderList =>
      isDueDateReminder ? reminderBeforeDueDateTypes : reminderTypes;

  // setFormData(): set-up form data to be pre-filled in form
  void setFormData({bool isTaskTemplate = false}) {
    if (task != null) {

      // setting task details title
      titleController.text = task!.title;

      if(task!.dueDate != null) {
        dueOnDate = DateTime.parse(task!.dueDate.toString());
        dueOnController.text = DateTimeHelper.convertHyphenIntoSlash(task!.dueDate ?? '');
      }

      isHighPriorityTask = task?.isHighPriorityTask ?? false;
      notesController.text = task!.notes ?? '';

      // setting additional options sections
      emailNotification = task!.sendAsEmail;
      messageNotification = task!.sendAsMessage;
      isDueDateReminder = task?.isDueDateReminder ?? false;

      isReminderNotificationSelected =
          (task?.reminderType?.isNotEmpty ?? false) && (task?.reminderFrequency?.isNotEmpty ?? false);

      isAdditionalDetailsExpanded = isReminderNotificationSelected;

      if (isReminderNotificationSelected) {
        groupVal = isDueDateReminder
            ? ReminderNotificationType.beforeDueDate
            : ReminderNotificationType.recurring;

        reminderTypeId = task!.reminderType!;
        reminderFrequencyController.text = task!.reminderFrequency!;
      }

      // setting up attachment section
      uploadedAttachments.addAll(task?.attachments ?? []);
      attachments.addAll(uploadedAttachments);

      //  Setting up stage lock
      isStageLocked = task?.locked ?? false;
      isLockStageSelected = isStageLocked;
    }

    reminderTypeController.text = SingleSelectHelper.getSelectedSingleSelectValue(
      selectedReminderList,
      reminderTypeId,
    );

    jobModel = task?.job ?? jobModel;
    if(jobModel != null) {
      FormValueSelectorService.setJobName(jobModel: jobModel!, controller: jobController);
    }

    if(!isTaskTemplate) {
      initialJson = taskFormJson();
    }
    update();
  }

  // taskFormJson(): provides json to stores on server while submitting form
  Map<String, dynamic> taskFormJson() {
    final Map<String, dynamic> data = {};
    final selectedNotifyUser = FormValueParser.multiSelectToSelectedIds(notifyUsers);
    data['includes[0]'] = "stage";
    data['includes[1]'] = "attachments";

    // Task details section
    if(task != null) {
      data['id'] = task!.id.toString();
    }

    data['title'] = titleController.text;
    data['users[]'] = FormValueParser.multiSelectToSelectedIds(users);
    data['assign_to_setting[]'] = FormValueParser.multiSelectToUserTypeIds(users);
    data['notify_user_setting[]'] = FormValueParser.multiSelectToUserTypeIds(notifyUsers);

    if(Helper.isValueNullOrEmpty(selectedNotifyUser)){
       data['notify_users'] = null;
    } else {
      data['notify_users[]'] = selectedNotifyUser;
    }
   
    if(jobModel != null) {
      data['job_id'] = jobModel!.id;
    }

    if(isReminderNotificationSelected) {
      data['is_due_date_reminder'] = isDueDateReminder ? 1 : 0;
    }

    if(dueOnController.text.isNotEmpty) {
      data['due_date'] =
          DateTimeHelper.convertSlashIntoHyphen(dueOnController.text);
    }

    data['is_high_priority_task'] = isHighPriorityTask ? 1 : 0;
    data['notes'] = notesController.text;

    // Additional details section
    data['email_notification'] = emailNotification ? 1 : 0;
    data['message_notification'] = messageNotification ? 1 : 0;

    data['reminder_type'] = isReminderNotificationSelected ? reminderTypeId : "";
    data['reminder_frequency'] = isReminderNotificationSelected ? reminderFrequencyController.text : "";

    // Attachments section
    if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

      List<AttachmentResourceModel> attachmentsToUpload = [];
      List<AttachmentResourceModel> attachmentsToDelete = [];

      attachmentsToUpload = attachments.where((attachment) => !uploadedAttachments.contains(attachment)).toList();
      attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

      // Map attachments for API payload
      // Using attachment.type with fallback to "resource" for backward compatibility
      // Some attachments may have null type due to legacy data or when created without explicit type
      // The "resource" type is the default expected by the backend API
      data['attachments'] = attachmentsToUpload.map((attachment) => {
        'type': attachment.type ?? "resource",
        'value': attachment.id,
      }).toList();

      data['delete_attachments[]'] = attachmentsToDelete.map((attachment) => attachment.id).toList();
    }

    if (isLockStageVisible) {
      switch(pageType) {
        case TaskFormType.salesAutomation:
          data['locked'] = isStageLocked ? 1 : 0;
          break;
        case TaskFormType.progressBoardEdit:
        case TaskFormType.editForm:
        case TaskFormType.createForm:
          data['locked'] = isStageLocked ? 1 : 0;
          data['stage_code'] = selectedStage?.id ?? "";
          break;
        default:
          break;
      }
    }

    return data;
  }

  TaskListModel jsonToTaskListingModel(Map<dynamic, dynamic> json,
    List<JPMultiSelectModel> users, List<JPMultiSelectModel> notifyUsers) {
    task?.id = int.parse(json['id']);
    task?.title = json['title'];
    task?.jobId = json['job_id'];
    task?.isDueDateReminder = json['is_due_date_reminder'] == 1;
    task?.dueDate = json['due_date'];
    task?.isHighPriorityTask = json['is_high_priority_task'] == 1;
    task?.notes = json['notes'];
    task?.sendAsEmail = json['email_notification'] == 1;
    task?.sendAsMessage = json['message_notification'] == 1;
    task?.reminderType = json['reminder_type'];
    task?.reminderFrequency = json['reminder_frequency'];
    task?.locked = json['locked'] == 1;
    task?.stage = jobModel?.currentStage;
    task?.stageCode = jobModel?.currentStage?.code;
    task?.job = jobModel;
    task?.participants = FormValueParser.jpMultiSelectToUserModel(users);
    task?.notifyUsers = FormValueParser.jpMultiSelectToUserModel(notifyUsers);
    return task!;
  }


  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = taskFormJson();
    return initialJson.toString() != currentJson.toString();
  }

}