import '../../job_financial/tax_model.dart';

class StateModel {
  late int id;
  late String name;
  late String code;
  late int countryId;
  TaxModel? tax;

  StateModel({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
    this.tax
  });
  // converting from local db data -> modal
  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    countryId = json['country_id'];
    tax = (json["tax"] != null && (json["tax"] is Map)) ? TaxModel.fromJson(json["tax"]) : null;
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['country_id'] = countryId;
    return data;
  }
}