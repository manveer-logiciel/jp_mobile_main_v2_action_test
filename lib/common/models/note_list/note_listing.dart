import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';

class NoteListModel {
  int? id;
  int? jobId;
  int? objectId;
  String? note;
  String? createdAt;
  String? updatedAt;
  String? stageCode;
  String? mark;
  UserModel? createdBy;
  List<UserLimitedModel>? reps;
  List<UserLimitedModel>? mentions;
  List<UserLimitedModel>? subContractors;
  List<UserLimitedModel>? workCrew;
  WorkFlowStageModel? stage;
  List<AttachmentResourceModel>? attachments;
  TaskListModel? task;
  int? taskId;
  bool isSelected = false;

  NoteListModel({
    this.id,
    this.jobId,
    this.objectId,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.stageCode,
    this.mark,
    this.createdBy,
    this.mentions,
    this.reps,
    this.subContractors,
    this.workCrew,
    this.stage,
    this.attachments,
    this.task,
    this.taskId,
    this.isSelected = false,
  });

  NoteListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['job_id'] is String) {
      jobId = int.parse(json['job_id']);
    } else {
      jobId = json['job_id'];
    }
    objectId = json['object_id'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    stageCode = json['stage_code'];
    mark = json['mark'];
    taskId = json['task_id'];

    if (json['reps'] != null && json['reps']['data'] != null) {
      reps = <UserLimitedModel>[];
      json['reps']['data'].forEach((dynamic v) {
        reps!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (json['mentions'] != null && json['mentions']['data'] != null) {
      mentions = <UserLimitedModel>[];
      json['mentions']['data'].forEach((dynamic v) {
        mentions!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (json['sub_contractors'] != null) {
      subContractors = <UserLimitedModel>[];
      json['sub_contractors']['data'].forEach((dynamic v) {
        subContractors!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (reps != null || subContractors != null) {
      if (subContractors!.isNotEmpty) {
        for (UserLimitedModel user in subContractors!) {
          user.roleName = AuthConstant.subContractorPrime;
        }
      }
      workCrew = List.from(reps!)..addAll(subContractors!);
    }

    createdBy = (json['created_by'] != null &&
            json['created_by'] is Map<String, dynamic>)
        ? UserModel.fromJson(json['created_by'])
        : null;

    stage = (json['stage'] != null && json['stage'] is Map<String, dynamic>)
        ? WorkFlowStageModel.fromJson(json['stage'])
        : null;

    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }

    task = (json['task'] != null && json['task'] is Map<String, dynamic>)
        ? TaskListModel.fromJson(json['task'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_id'] = jobId;
    data['object_id'] = objectId;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['stage_code'] = stageCode;
    data['mark'] = mark;
    data['task_id'] = taskId;

    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }

    if (stage != null) {
      data['stage'] = stage!.toJson();
    }

    if (task != null) {
      data['task'] = task!.toJson();
    }
    return data;
  }
}
