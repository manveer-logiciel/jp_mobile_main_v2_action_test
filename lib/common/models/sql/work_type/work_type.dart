
class WorkTypeModel {
  late int id;
  late int tradeId;
  late String name;
  int? companyId;
  bool? active;
  String? color;

  WorkTypeModel({
    required this.id,
    required this.name,
    required this.tradeId,
    this.companyId,
    this.color,
    this.active,
  });

  // convert from api json -> modal
  WorkTypeModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    tradeId = json['trade_id'] ?? -1;
    name = json['name'] ?? "";
    color = json['color'];
    active = (json['active'] != null) ? json['active'] : true;
  }
  // converting from local db data -> modal
  WorkTypeModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString()) ?? 0;
    companyId = json['company_id'];
    tradeId = json['trade_id'] ?? -1;
    name = json['name'];
    color = json['color'];
    active = json['active'] == 1;
  }
  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['local_id'] = '${id}_$companyId';
    data['trade_id'] = tradeId;
    data['name'] = name;
    data['color'] = color;
    data['active'] = active == true ? 1 : 0;
    return data;
  }
}
