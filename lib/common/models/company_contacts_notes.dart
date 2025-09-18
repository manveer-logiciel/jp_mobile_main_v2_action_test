class CompanyContactNoteModel {
  int? id;
  String? note;
  String? createdAt;
  String? updatedAt;

  CompanyContactNoteModel({this.id, this.note, this.createdAt, this.updatedAt});

  CompanyContactNoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}