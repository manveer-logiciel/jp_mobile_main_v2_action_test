class JustifiCardDetails {
  String? id;
  String? name;
  String? acctLastFour;
  String? brand;
  String? token;
  String? metadata;
  String? month;
  String? year;
  String? addressLine1Check;
  String? addressPostalCodeCheck;

  JustifiCardDetails({
    this.id,
    this.name,
    this.acctLastFour,
    this.brand,
    this.token,
    this.metadata,
    this.month,
    this.year,
    this.addressLine1Check,
    this.addressPostalCodeCheck,
  });

  JustifiCardDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    acctLastFour = json['acct_last_four'];
    brand = json['brand'];
    token = json['token'];
    metadata = json['metadata'];
    month = json['month'];
    year = json['year'];
    addressLine1Check = json['address_line1_check'];
    addressPostalCodeCheck = json['address_postal_code_check'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['acct_last_four'] = acctLastFour;
    data['brand'] = brand;
    data['token'] = token;
    data['metadata'] = metadata;
    data['month'] = month;
    data['year'] = year;
    data['address_line1_check'] = addressLine1Check;
    data['address_postal_code_check'] = addressPostalCodeCheck;
    return data;
  }
}
