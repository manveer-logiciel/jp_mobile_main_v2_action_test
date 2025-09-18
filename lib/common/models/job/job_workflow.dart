import 'package:jobprogress/common/models/workflow_stage.dart';

import '../../../core/constants/date_formats.dart';
import '../../../core/utils/date_time_helpers.dart';

class JobWorkFlow {

  int? id;
  String? currentStageCode;
  int? modifiedBy;
  String? stageLastModified;
  String? createdAt;
  String? updatedAt;
  WorkFlowStageModel? currentStage;
  String? lastStageCompletedDate;

  JobWorkFlow({
    this.id,
    this.currentStageCode,
    this.modifiedBy,
    this.stageLastModified,
    this.createdAt,
    this.updatedAt,
    this.currentStage,
    this.lastStageCompletedDate,
  });

  JobWorkFlow.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    currentStageCode = json['current_stage_code']?.toString();
    modifiedBy = int.tryParse(json['modified_by']?.toString() ?? '');
    stageLastModified = json['stage_last_modified'] != null ? DateTimeHelper.formatDate((json['stage_last_modified']?.toString() ?? ""), DateFormatConstants.dateTimeFormatWithoutSeconds) : null;
    createdAt = json['created_at'] != null ? DateTimeHelper.formatDate((json['created_at']?.toString() ?? ""), DateFormatConstants.dateTimeFormatWithoutSeconds) : null;
    updatedAt = json['updated_at'] != null ? DateTimeHelper.formatDate((json['updated_at']?.toString() ?? ""), DateFormatConstants.dateTimeFormatWithoutSeconds) : null;
    currentStage = (json['current_stage'] != null && (json['current_stage'] is Map)) ? WorkFlowStageModel.fromJson(json['current_stage']) : null;
    lastStageCompletedDate = json['last_stage_completed_date']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['current_stage_code'] = currentStageCode;
    data['modified_by'] = modifiedBy;
    data['stage_last_modified'] = stageLastModified;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (currentStage != null) {
      data['current_stage'] = currentStage!.toJson();
    }
    data['last_stage_completed_date'] = lastStageCompletedDate;
    return data;
  }
}

