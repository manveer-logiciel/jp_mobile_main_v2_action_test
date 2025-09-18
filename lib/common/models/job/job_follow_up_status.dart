class JobFollowUpStatus {
  String? createdAt;
  String? dateTime;
  int? id;
  int? jobId;
  String? mark;
  String? note;
  int? order;
  String? stageCode;
  String? taskId;

  JobFollowUpStatus({
    this.createdAt,
    this.dateTime,
    this.id,
    this.jobId,
    this.mark,
    this.note,
    this.order,
    this.stageCode,
    this.taskId,
  });

  JobFollowUpStatus.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at']?.toString();
    dateTime = json['date_time']?.toString();
    id = int.tryParse(json['id']?.toString() ?? '');
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    mark = json['mark']?.toString();
    note = json['note']?.toString();
    order = int.tryParse(json['order']?.toString() ?? '');
    stageCode = json['stage_code']?.toString();
    taskId = json['task_id']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['date_time'] = dateTime;
    data['id'] = id;
    data['job_id'] = jobId;
    data['mark'] = mark;
    data['note'] = note;
    data['order'] = order;
    data['stage_code'] = stageCode;
    data['task_id'] = taskId;
    return data;
  }
}