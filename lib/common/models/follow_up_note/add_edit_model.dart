import 'package:flutter/foundation.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';

class AddEditFollowUpModel {

  String? mark;
  String? note;
  bool? followUpReminder;
  String? taskDueDate;
  List<int?>? taskAssignTo;
  int? jobId;
  int? customerId;
  String? stageCode;
  List<UserLimitedModel>? mentions;

  AddEditFollowUpModel({
    this.taskAssignTo,
    this.mark,
    this.note,
    this.jobId,
    this.customerId,
    this.stageCode,
    this.taskDueDate,
    this.followUpReminder = false,
    this.mentions
  });

  @override
  bool operator ==(Object other) {
    return (other is AddEditFollowUpModel)
        && other.mark == mark
        && other.note == note
        && other.jobId == jobId
        && other.customerId == customerId
        && other.stageCode == stageCode
        && other.taskDueDate == taskDueDate
        && other.followUpReminder == followUpReminder
        && listEquals(mentions, mentions)
        && listEquals(other.taskAssignTo, taskAssignTo);
  }

  @override
  int get hashCode => 0;

  factory AddEditFollowUpModel.copy(AddEditFollowUpModel params) => AddEditFollowUpModel(
    mark: params.mark,
    note: params.note,
    jobId: params.jobId,
    customerId: params.customerId,
    stageCode: params.stageCode,
    taskDueDate: params.taskDueDate,
    followUpReminder: params.followUpReminder,
    taskAssignTo: params.taskAssignTo,
    mentions: params.mentions
  );

  AddEditFollowUpModel.fromJson(Map<String, dynamic> json) {
    if (json['task_assign_to'] != null && (json['task_assign_to'] is List)) {
      taskAssignTo = [];
      json['task_assign_to'].forEach((dynamic v) {
        taskAssignTo!.add(int.tryParse(v?.toString() ?? ''));
      });
    }
    mark = json['mark']?.toString();
    note = json['note']?.toString();
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    customerId = int.tryParse(json['customer_id']?.toString() ?? '');
    stageCode = json['stage_code']?.toString();
    taskDueDate = json['task_due_date']?.toString();
    if (json['mentions'] != null && json['mentions']['data'] != null) {
      mentions = <UserLimitedModel>[];
      json['mentions']['data'].forEach((dynamic v) {
        mentions!.add(UserLimitedModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (taskAssignTo != null) {
      data['task_assign_to'] = <dynamic>[];
      for (var v in taskAssignTo!) {
        data['task_assign_to'].add(v);
      }
    }
    data['mark'] = mark;
    data['note'] = note;
    data['job_id'] = jobId;
    data['customer_id'] = customerId;
    data['stage_code'] = stageCode;
    data['task_due_date'] = taskDueDate;
    return data;
  }
}