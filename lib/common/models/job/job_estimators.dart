class JobEstimatorsModel {
  String? companyName;
  String? firstName;
  String? fullName;
  String? fullNameMobile;
  int? id;
  String? lastName;
  String? color;

  JobEstimatorsModel({
    this.companyName,
    this.firstName,
    this.fullName,
    this.fullNameMobile,
    this.id,
    this.lastName,
    this.color
  });

  JobEstimatorsModel.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name']?.toString();
    firstName = json['first_name']?.toString();
    fullName = json['full_name']?.toString();
    fullNameMobile = json['full_name_mobile']?.toString();
    id = int.tryParse(json['id']?.toString() ?? '');
    lastName = json['last_name']?.toString();
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['first_name'] = firstName;
    data['full_name'] = fullName;
    data['full_name_mobile'] = fullNameMobile;
    data['id'] = id;
    data['last_name'] = lastName;
    data['color'] = color;
    return data;
  }
}