import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_message.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class TaskListModel {
  late int id;
  late String title;
  late bool sendAsMessage;
  late bool sendAsEmail;
  late bool locked;
  late bool isHighPriorityTask;
  late bool isDueDateReminder;
  late bool isWfTask;
  bool isDueOnEmpty = false;
  bool isAssigneEmpty = false;
  bool isChecked = true;
  bool send = false;
  bool? isApiRequestFailed ;
  String? notes;
  String? dueDate;
  int? jobId;
  String? stageCode;
  String? completed;
  String? createdAt;
  String? updatedAt;
  String? reminderType;
  List<TaskListModel>? tasks;
  List<String>? assignToSetting;
  List<String>? notifyUserSetting;
  String? reminderFrequency;
  JobModel? job;
  List<UserLimitedModel>? initialParticipants;
  List<UserLimitedModel>? participants;
  List<UserLimitedModel>? notifyUsers;
  List<AttachmentResourceModel>? attachments;
  UserLimitedModel? createdBy;
  UserLimitedModel? completedBy;
  WorkFlowStageModel? stage;
  TaskMessageModel? message;
  CustomerModel? customer;

  TaskListModel(
      {required this.id,
      required this.title,
      this.notes,
      this.dueDate,
      this.jobId,
      this.stageCode,
      this.completed,
      this.isHighPriorityTask = false,
      this.createdAt,
      this.assignToSetting,
      this.notifyUserSetting,
      this.updatedAt,
      this.initialParticipants = const [],
      this.locked = false,
      this.reminderType,
      this.send = false,
      this.reminderFrequency,
      this.isDueDateReminder = false,
      this.isWfTask = false,
      this.sendAsMessage = false,
      this.tasks,
      this.isChecked = true,
      this.sendAsEmail = false,
      this.job,
      this.isApiRequestFailed,
      this.participants,
      this.createdBy,
      this.completedBy,
      this.stage,
      this.attachments,
      this.isAssigneEmpty = false,
      this.isDueOnEmpty = false,
      this.notifyUsers});

  TaskListModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    notes = json['notes'];
    dueDate = json['due_date'];
    jobId = json['job_id'];
    stageCode = json['stage_code'] ?? "";
    completed = json['completed'];
    isHighPriorityTask = json['is_high_priority_task'] == 1 ? true : false;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if(json['assign_to_setting'] != null){
      assignToSetting = json['assign_to_setting'].cast<String>();
    }
    if(json['notify_user_setting'] != null){
      notifyUserSetting = json['notify_user_setting'].cast<String>();
    }
    locked = json['locked'] == 1 ? true : false;
    reminderType = json['reminder_type'];
    reminderFrequency = json['reminder_frequency'];
    isDueDateReminder = json['is_due_date_reminder'] == 1 ? true : false;
    isWfTask = json['is_wf_task'] == 1 ? true : false;
    if(json['send_as_message'] != null){
      sendAsMessage = json['send_as_message'] == 1 ? true : false;
    } else {
      sendAsMessage = json['message_notification'] == 1 ? true : false;
    }
    if(json['send_as_email'] != null) {
      sendAsEmail = json['send_as_email'] == 1 ? true : false;
    } else {
      sendAsEmail = json['email_notification'] == 1 ? true : false;
    }
   
    if(json['tasks'] != null){
      tasks = <TaskListModel>[];
      json['tasks']['data'].forEach((dynamic v) {
        tasks!.add(TaskListModel.fromJson(v));
      });
    }
    createdBy = (json['created_by'] != null && json['created_by'] is Map<String, dynamic>)
        ? UserLimitedModel.fromJson(json['created_by'])
        : null;
    completedBy = (json['completed_by'] != null && json['completed_by'] is Map<String, dynamic>)  
        ? UserLimitedModel.fromJson(json['completed_by'])
        : null;
    completed = json['completed'];
    job = json['job'] != null ? JobModel.fromJson(json['job']) : null;
    stage = json['stage'] != null
        ? WorkFlowStageModel.fromJson(json['stage'])
        : null;
    if (json['participants'] != null) {
      participants = <UserLimitedModel>[];
      json['participants']['data'].forEach((dynamic v) {
        participants!.add(UserLimitedModel.fromJson(v));
      });
    }
    if(!Helper.isValueNullOrEmpty(tasks)) {
      participants = <UserLimitedModel>[];
      isChecked = false;
      send = true;
      for (TaskListModel task in tasks!) {
       participants!.addAll(task.participants!);
      }
    }
    if (json['notify_users'] != null) {
      notifyUsers = <UserLimitedModel>[];
      json['notify_users']['data'].forEach((dynamic v) {
        notifyUsers!.add(UserLimitedModel.fromJson(v));
      });
    }
    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }
    if(json['message'] != null) {
      message = TaskMessageModel.fromJson(json['message']);
    }
    if(json['customer'] != null) {
      customer = CustomerModel.fromJson(json['customer']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['notes'] = notes;
    data['due_date'] = dueDate;
    data['job_id'] = jobId;
    data['stage_code'] = stageCode;
    data['completed'] = completed;
    data['is_high_priority_task'] = isHighPriorityTask;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['locked'] = locked ? 1 : 0;
    data['notify_user_setting'] = notifyUserSetting;
    data['assign_to_setting'] = assignToSetting;
    data['reminder_type'] = reminderType;
    data['reminder_frequency'] = reminderFrequency;
    data['is_due_date_reminder'] = isDueDateReminder ? 1 : 0;
    data['is_wf_task'] = isWfTask;
    data['send_as_message'] = sendAsMessage;
    if (job != null) {
      data['job'] = job!.toJson();
    }
    if (participants != null) {
      data['participants'] = participants!.map((v) => v.toJson()).toList();
    }
    if (notifyUsers != null) {
      data['notify_users'] = notifyUsers!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    if (completedBy != null) {
      data['completed_by'] = completedBy!.toJson();
    }
    return data;
  }

   Map<String, dynamic> toTemplateJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['notes'] = notes;
    data['is_high_priority_task'] = isHighPriorityTask ? 1 : 0;
    data['locked'] = locked ? 1 : 0;
    data['reminder_type'] = reminderType;
    data['email_notification'] = sendAsEmail ? 1 : 0;
    data['message_notification'] = sendAsMessage ? 1 : 0;
    data['reminder_frequency'] = reminderFrequency;
    if(locked) {
      data['stage_code']= stage?.code;
    }
    data['is_due_date_reminder'] = isDueDateReminder ? 1 : 0;
    data['wf_task_id'] = id;
  

    if (participants != null) {
      data['users'] = participants!.map((v) => v.id).toList();
    }
    if (notifyUsers != null) {
      data['notify_users'] = notifyUsers!.map((v) => v.id).toList();
    }

    if(dueDate != null) {
      data['due_date'] = dueDate;
    }
    return data;
  }

}
