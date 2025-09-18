
class LinkedMaterialModel {
  int? id;
  int? worksheetId;
  dynamic forSupplierId;
  String? filePath;
  String? fileMimeType;

  LinkedMaterialModel(
      {this.id,
        this.worksheetId,
        this.forSupplierId,
        this.filePath,
        this.fileMimeType});

  LinkedMaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    worksheetId = json['worksheet_id'];
    forSupplierId = json['for_supplier_id'];
    filePath = json['file_path'];
    fileMimeType = json['file_mime_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['worksheet_id'] = worksheetId;
    data['for_supplier_id'] = forSupplierId;
    data['file_path'] = filePath;
    data['file_mime_type'] = fileMimeType;
    return data;
  }
}
