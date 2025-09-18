class ProjectStageModel {
  int? id;
  int? companyId;
  String? name;
  String? createdAt;
  String? updatedAt;
  bool? isCompleted;
  bool? isCurrentStage;

  ProjectStageModel({
    this.id,
    this.companyId,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.isCompleted = false,
    this.isCurrentStage = false
  });

  ProjectStageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['company_id'] = companyId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
