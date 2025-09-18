class LinkedWorkOrder {
  int? id;
  int? worksheetId;
  String? filePath;

  LinkedWorkOrder({this.id, this.worksheetId, this.filePath});

  LinkedWorkOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    worksheetId = json['worksheet_id'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['worksheet_id'] = worksheetId;
    data['file_path'] = filePath;
    return data;
  }
}
