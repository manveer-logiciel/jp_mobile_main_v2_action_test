class MeasurementUnit {
  int? id;
  String? name;
  String? displayName;

  MeasurementUnit({this.id, this.name, this.displayName});

  MeasurementUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{} ;
    data['id'] = id;
    data['name'] = name;
    data['display_name'] = displayName;
    return data;
  }
}