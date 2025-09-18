import 'dart:convert';

import '../task_listing/task_listing.dart';
import 'production_board_column.dart';

class ProgressBoardEntriesModel {
  int? id;
  int? columnId;
  Map<String, dynamic>? data;
  String? createdAt;
  String? updatedAt;
  String? color;
  ProductionBoardColumn? productionBoardColumn;
  TaskListModel? task;

  ProgressBoardEntriesModel({
    this.id,
    this.columnId,
    this.data,
    this.createdAt,
    this.updatedAt,
    this.color,
    this.productionBoardColumn,
    this.task,
  });

  ProgressBoardEntriesModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    columnId = int.tryParse(json['column_id']?.toString() ?? '');
    data = json['data'] != null ? jsonDecode(json['data']?.toString() ?? "") : null;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    color = json['color']?.toString();
    productionBoardColumn = (json['productionBoardColumn'] != null && (json['productionBoardColumn'] is Map)) ? ProductionBoardColumn.fromJson(json['productionBoardColumn']) : null;
    task = (json['task'] != null && (json['task'] is Map)) ? TaskListModel.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['column_id'] = columnId;
    data['data'] = this.data;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['color'] = color;
    if (productionBoardColumn != null) {
      data['productionBoardColumn'] = productionBoardColumn!.toJson();
    }
    return data;
  }
}