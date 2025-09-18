class WorkFlowStageGroupModel {
  late int id;
  late String name;
  int? companyId;
  String? color;
  String? createdAt;
  String? updatedAt;

  WorkFlowStageGroupModel({
    required this.id,
    required this.name,
    this.companyId,
    this.color,
    this.createdAt,
    this.updatedAt,
  });

  WorkFlowStageGroupModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    name = json['name'].toString();
    companyId = json['company_id'];
    color = json['color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (companyId != null) data['company_id'] = companyId;
    if (color != null) data['color'] = color;
    if (createdAt != null) data['created_at'] = createdAt;
    if (updatedAt != null) data['updated_at'] = updatedAt;
    return data;
  }

  /// For local database storage (without timestamps)
  Map<String, dynamic> toLocalDbJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (companyId != null) data['company_id'] = companyId;
    if (color != null) data['color'] = color;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkFlowStageGroupModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'WorkFlowStageGroupModel{id: $id, name: $name, companyId: $companyId, color: $color}';
  }
}
