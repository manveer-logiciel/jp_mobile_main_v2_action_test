class TableUpdateStatusModel {
  late int id;
  late int companyId;
  late String tableName;
  late String updatedAt;

  TableUpdateStatusModel({
    required this.id,
    required this.tableName,
    required this.companyId,
    required this.updatedAt,
  });
  // converting from local db data -> modal
  TableUpdateStatusModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    updatedAt = json['updated_at'];
    tableName = json['table_name'];
  }
  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['updated_at'] = updatedAt;
    data['table_name'] = tableName;
    return data;
  }
}
