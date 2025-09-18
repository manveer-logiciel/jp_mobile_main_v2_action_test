import 'package:jobprogress/common/models/automation/display_data.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class AutomationModel {
  late int id;
  String? event;
  int? companyId;
  int? automationTaskId;
  int? incompleteTaskLockCount;
  DisplayData? displayData;
  String? failedReason;
  String? automationStatus;
  String? createdAt;
  String? updatedAt;
  JobModel? job;
  bool? enableUndo;
  bool? showReverted;
  bool? isExpanded;
  List<TaskListModel>? taskList;
  List<String>? transitionStages;
  bool taskEmailSkipped = false;
  String? emailAutomationStatus;
  String? taskAutomationStatus;

  AutomationModel({
    required this.id,
    this.event,
    this.companyId,
    this.automationTaskId,
    this.displayData,
    this.failedReason,
    this.automationStatus,
    this.createdAt,
    this.updatedAt,
    this.job,
    this.enableUndo,
    this.showReverted,
    this.incompleteTaskLockCount,
    this.isExpanded,
    this.taskList,
    this.taskEmailSkipped = false,
    this.emailAutomationStatus,
    this.taskAutomationStatus,
    this.transitionStages,
  });

  AutomationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    event = json['event'];
    companyId = json['company_id'];
    automationTaskId = json['automation_task_id'];
    if(json['display_data'] is Map) {
      displayData = DisplayData.fromJson(json['display_data']);
    }
    if (json['transition_stages'] != null) {
      transitionStages = [];
      json['transition_stages'].forEach((dynamic transitionStage) {
        transitionStages?.add(transitionStage.toString());
      });
    }
    incompleteTaskLockCount = json['incomplete_task_lock_count'];
    failedReason = json['failed_reason'];
    automationStatus = json['automation_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    enableUndo = json['enable_undo'];
    emailAutomationStatus = json['email_automation_status'];
    taskAutomationStatus = json['task_automation_status'];
    taskEmailSkipped = !(Helper.isValueNullOrEmpty(emailAutomationStatus) && Helper.isValueNullOrEmpty(taskAutomationStatus));
    if (json['job'] is Map) {
      job = JobModel.fromJson(json['job']);
      if (json['customer'] is Map) {
        job?.customer = CustomerModel.fromJson(json['customer']);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['event'] = event;
    data['company_id'] = companyId;
    data['automation_task_id'] = automationTaskId;
    data['display_data'] = displayData?.toJson();
    data['failed_reason'] = failedReason;
    data['automation_status'] = automationStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['enable_undo'] = enableUndo;
    data['incomplete_task_lock_count'] = incompleteTaskLockCount;
    data['email_automation_status'] = emailAutomationStatus;
    data['task_automation_status'] = taskAutomationStatus;
    if (job != null) {
      data['job'] = job!.toJson();
      if (job!.customer != null) {
        data['customer'] = job!.customer!.toJson();
      }
    }
    if (transitionStages != null) {
      data['transition_stages'] = <dynamic>[];
      for (var transitionStage in transitionStages!) {
        data['transition_stages'].add(transitionStage);
      }
    }

    return data;
  }
}
