
class CompanyStateModel {

  late int stateId;
  int? companyId;

  CompanyStateModel({
    required this.companyId,
    required this.stateId,
  });

  // converting from local db data -> modal
  CompanyStateModel.fromJson(Map<dynamic, dynamic> json) {
    companyId = json['company_id'];
    stateId = json['state_id'] ?? json['id'];
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['state_id'] = stateId;
    return data;
  }

}