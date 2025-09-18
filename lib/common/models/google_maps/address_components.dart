class AddressComponentsModel {
  String? id;
  String? longName;
  String? shortName;
  List<String?>? types;

  AddressComponentsModel({
    this.id,
    this.longName,
    this.shortName,
    this.types,
  });

  AddressComponentsModel.fromJson(Map<String, dynamic> json) {
    longName = json['id']?.toString();
    longName = json['long_name']?.toString();
    shortName = json['short_name']?.toString();
    if (json['types'] != null && (json['types'] is List)) {
      types = <String>[];
      json['types'].forEach((dynamic type) {
        types!.add(type.toString());
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['long_name'] = longName;
    data['short_name'] = shortName;
    if (types != null) {
      data['types'] = <dynamic>[];
      for (var type in types!) {
        data['types'].add(type);
      }
    }
    return data;
  }
}