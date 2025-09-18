
class JobTypeModel {
  String? color;
  String? deletedAt;
  int? id;
  bool? isInsuranceClaim;
  String? name;
  int? order;
  String? qbAccountId;
  String? qbId;
  int? tradeId;
  int? type;
  JobTypeModel? pivot;
  ///  pivot
  int? jobId;
  int? jobTypeId;

  JobTypeModel({
    this.color,
    this.deletedAt,
    this.id,
    this.isInsuranceClaim,
    this.name,
    this.order,
    this.pivot,
    this.qbAccountId,
    this.qbId,
    this.tradeId,
    this.type,
    this.jobId,
    this.jobTypeId,
  });

  JobTypeModel.fromJson(Map<String, dynamic> json) {
    color = json['color']?.toString();
    deletedAt = json['deleted_at']?.toString();
    id = int.tryParse(json['id']?.toString() ?? '');
    isInsuranceClaim = json['insurance_claim'];
    name = json['name']?.toString();
    order = int.tryParse(json['order']?.toString() ?? '');
    pivot = (json['pivot'] != null && (json['pivot'] is Map)) ? JobTypeModel.fromJson(json['pivot']) : null;
    qbAccountId = json['qb_account_id']?.toString();
    qbId = json['qb_id']?.toString();
    tradeId = int.tryParse(json['trade_id']?.toString() ?? '');
    type = int.tryParse(json['type']?.toString() ?? '');
    jobId = int.tryParse(json['job_id']?.toString() ?? '');
    jobTypeId = int.tryParse(json['job_type_id']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['color'] = color;
    data['deleted_at'] = deletedAt;
    data['id'] = id;
    data['insurance_claim'] = isInsuranceClaim;
    data['name'] = name;
    data['order'] = order;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    data['qb_account_id'] = qbAccountId;
    data['qb_id'] = qbId;
    data['trade_id'] = tradeId;
    data['type'] = type;
    data['job_id'] = jobId;
    data['job_type_id'] = jobTypeId;
    return data;
  }
}
