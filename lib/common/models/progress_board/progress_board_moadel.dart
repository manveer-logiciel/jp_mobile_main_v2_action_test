class ProgressBoardModel {

  int? id;
  String? name;
  String? archived;
  String? createdAt;
  String? updatedAt;

  ProgressBoardModel({
    this.id,
    this.name,
    this.archived,
    this.createdAt,
    this.updatedAt,
  });

  ProgressBoardModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
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
