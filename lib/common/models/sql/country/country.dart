class CountryModel {
  late int id;
  late String name;
  late String code;
  late String currencyName;
  late String currencySymbol;
  int? companyId;
  String? phoneCode;
  String? phoneFormat;

  CountryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.currencyName,
    required this.currencySymbol,
    this.phoneCode,
    this.phoneFormat,
  });
  // converting from local db data -> modal
  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    phoneCode = json['phone_code'];
    phoneFormat = json['phone_format'];
  }

  // this function is used while inserting data in to local db
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['local_id'] = "${companyId}_$id";
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['currency_name'] = currencyName;
    data['currency_symbol'] = currencySymbol;
    data['phone_code'] = phoneCode;
    data['phone_format'] = phoneFormat;
    data['company_id'] = companyId;
    return data;
  }
}