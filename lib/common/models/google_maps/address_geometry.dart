class AddressGeometryModel {

  double? lat;
  double? lng;

  AddressGeometryModel({
    this.lat,
    this.lng,
  });

  AddressGeometryModel.fromJson(Map<String, dynamic> json) {
    lat = double.tryParse(json['lat']?.toString() ?? '');
    lng = double.tryParse(json['lng']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}