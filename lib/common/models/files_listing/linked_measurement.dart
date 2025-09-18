class LinkedMeasurement {
  int? id;
  String? filePath;

  LinkedMeasurement({this.id, this.filePath});

  LinkedMeasurement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['file_path'] = filePath;
    return data;
  }
}
