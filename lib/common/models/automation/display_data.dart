import 'package:jobprogress/common/models/workflow_stage.dart';

class DisplayData {
  List<int>? jobIds;
  int? proposalId;
  int? companyId;
  int? taskId;
  WorkFlowStageModel? fromStage;
  WorkFlowStageModel? toStage;

  DisplayData({
    this.jobIds,
    this.proposalId,
    this.companyId,
    this.taskId,
    this.fromStage,
    this.toStage,
  });

  DisplayData.fromJson(Map<String, dynamic> json){
    jobIds = List<int>.from(json['job_ids']);
    proposalId = json['proposal_id'];
    companyId = json['company_id'];
    taskId = json['task_id'];
    fromStage = WorkFlowStageModel.fromJson(json['from_stage']);
    toStage = WorkFlowStageModel.fromJson(json['to_stage']);
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_ids'] = jobIds;
    data['proposal_id'] = proposalId;
    data['company_id'] = companyId;
    data['task_id'] = taskId;
    data['from_stage'] = fromStage?.toJson();
    data['to_stage'] = toStage?.toJson();
    return data;
  }
}