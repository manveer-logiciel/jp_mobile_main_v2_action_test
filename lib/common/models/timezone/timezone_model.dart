class TimezoneModel {
  int? id;
  String? label;
  String? name;
  int? countryId;

  TimezoneModel({
    this.id,
    this.label,
    this.name,
    this.countryId,
  });

  TimezoneModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    label = json['label']?.toString();
    name = json['name']?.toString();
    countryId = int.tryParse(json['country_id']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['name'] = name;
    data['country_id'] = countryId;
    return data;
  }
}