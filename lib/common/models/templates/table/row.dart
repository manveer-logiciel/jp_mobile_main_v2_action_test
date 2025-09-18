import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/templates/table/rules.dart';
import 'cell.dart';
import 'options.dart';

class TemplateTableRowModel {
  String? id;
  late TableCellType type;
  TemplateFormTableRowOptions? options;
  List<TemplateTableCellModel>? tds;
  TemplateTableDependentCol? dependentCols;

  TemplateTableRowModel({
    this.id,
    this.tds,
    this.options,
    this.type = TableCellType.body,
    this.dependentCols
  });

  TemplateTableRowModel.fromJson(Map<String, dynamic> json, {
    required this.type,
    this.dependentCols
  }) {
    id = json['id'];
    options = TemplateFormTableRowOptions.fromJson(json['options']);
    if (json['tds'] != null) {
      tds = <TemplateTableCellModel>[];
      json['tds'].forEach((dynamic cellData) {
        tds!.add(TemplateTableCellModel.fromJson(cellData, type: type));
      });

      // setting up table cell data from row options
      for (int i = 0; i < tds!.length; i++) {
        // setting dependent cell's value
        if (options?.depPrice != null && dependentCols?.depCol == i) {
          tds![i].controller.text = options?.depPrice ?? "";
        }
        // blocking listener of dependent cell if main cell's toggle is not true
        if (dependentCols?.mainCol != null && dependentCols?.depCol == i) {
          tds![i].avoidListeners = tds![dependentCols!.mainCol!].text?.toLowerCase() != 'yes';
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (tds != null) {
      data['tds'] = tds!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}
