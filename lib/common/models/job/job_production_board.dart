class JobProductionBoardModel {
  int? id;
  String? name;
  String? archived;
  String? createdAt;
  String? updatedAt;

  JobProductionBoardModel({
    this.id,
    this.name,
    this.archived,
    this.createdAt,
    this.updatedAt,
  });

  JobProductionBoardModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '0') ?? 0;
    name = json['name']?.toString();
    archived = json['archived']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['archived'] = archived;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}