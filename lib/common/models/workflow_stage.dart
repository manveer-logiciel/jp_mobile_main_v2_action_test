import 'package:jobprogress/core/utils/helpers.dart';
import 'workflow/workflow_stage_group.dart';

class WorkFlowStageModel {
  late String name;
  String? initial;
  late String color;
  late String code;
  int? position;
  int? resourceId;
  WorkFlowStageOptions? workStageOptions;
  int? jobsCount;
  String? startDate;
  String? endDate;
  String? completedDate;
  bool? isCurrentStage;
  bool? createTasks;
  bool? sendCustomerEmail;
  bool? doShowMarkAsCompleted;
  bool? doShowReinstate;
  bool? isOrAfterAwardedStage;
  int? emailCount;
  int? taskCount;
  String? colorType;

  // Group-related properties
  WorkFlowStageGroupModel? group;
  int? groupId;
  String? groupName;

  WorkFlowStageModel({
    required this.name,
    required this.color,
    required this.code,
    this.position,
    this.resourceId,
    this.jobsCount,
    this.isOrAfterAwardedStage = false,
    this.initial,
    this.createTasks,
    this.sendCustomerEmail,
    this.doShowMarkAsCompleted = false,
    this.doShowReinstate = false,
    this.taskCount,
    this.emailCount,
    this.group,
    this.groupId,
    this.groupName,
  });

  WorkFlowStageModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    color = json['color'];
    code = json['code'] ?? '';
    position = json['position'];
    resourceId = json['resource_id'];
    jobsCount = json['jobs_count'];
    workStageOptions = json['options'] is Map ? WorkFlowStageOptions.fromJson(json["options"]) : null;
    createTasks = json['create_tasks'] == 1;
    sendCustomerEmail = json['send_customer_email'] == 1;
    colorType = json['color_type'];
    initial = name[0];
    if (json['meta'] != null) {
      emailCount = json['meta']['email_count'];
      taskCount = json['meta']['task_count'];
    }

    // Handle group data from API response
    if (json['group'] != null && json['group'] is Map) {
      group = WorkFlowStageGroupModel.fromJson(json['group']);
      groupId = group?.id;
      groupName = group?.name;
    } else {
      // Handle group data from local DB (separate fields)
      groupId = json['group_id'];
      groupName = json['group_name'];
      if (groupId != null && groupName != null) {
        group = WorkFlowStageGroupModel(
          id: groupId!,
          name: groupName!,
          color: json['group_color'],
        );
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['color'] = color;
    data['code'] = code;
    data['resource_id'] = resourceId;
    data['create_tasks'] = Helper.isTrueReverse(createTasks);
    data['send_customer_email'] = Helper.isTrueReverse(sendCustomerEmail);
    if (data['meta'] != null) {
      data['meta']['email_count'] = emailCount;
      data['meta']['task_count'] = taskCount;
    }

    // Include group data for local DB storage
    if (groupId != null) data['group_id'] = groupId;
    if (groupName != null) data['group_name'] = groupName;
    if (group?.color != null) data['group_color'] = group!.color;
    if (colorType != null) data['color_type'] = colorType;

    return data;
  }
}

class WorkFlowStageOptions {
  String? description;

  WorkFlowStageOptions({this.description});

  WorkFlowStageOptions.fromJson(Map<String, dynamic> json) {
    description = json["description"];
  }
}
