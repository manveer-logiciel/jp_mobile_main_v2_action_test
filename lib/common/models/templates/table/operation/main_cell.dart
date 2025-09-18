
class TemplateOperationCellModel {

  int? row;
  int? cell;

  TemplateOperationCellModel({this.row, this.cell});

  TemplateOperationCellModel.fromJson(Map<String, dynamic>? json) {

    if(json == null) return;

    row = json['row'];
    cell = json['cell'] ?? json['col'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['row'] = row;
    data['cell'] = cell;
    return data;
  }
}