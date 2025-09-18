import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/templates.dart';
import 'package:jobprogress/common/models/templates/table/style.dart';
import 'dropdown.dart';
import 'object.dart';

class TemplateTableCellModel {

  String? text;
  String? cssClass;
  String? isNumber;
  String? refDb;
  String? id;
  String? spanId;
  String? ddId;
  double? width;
  int? row;
  int? column;
  TemplateTableDropdownModel? dropdown;
  TemplateTableCellObjectModel? obj;
  TemplateTableStyleModel? style;
  List<VoidCallback>? listener;
  late TextEditingController controller;
  late TableCellType type;
  late bool avoidListeners;

  String get formattedText => controller.text.replaceAll("\n", "<br>");

  TemplateTableCellModel({
    this.text = "",
    this.cssClass = 'cell-with-dropdown',
    this.isNumber,
    this.refDb,
    this.id,
    this.spanId,
    this.ddId,
    this.dropdown,
    this.obj,
    this.width,
    this.listener,
    this.type = TableCellType.body,
    this.row,
    this.column,
    this.avoidListeners = false,
  }) {
    // prefilling the table cell with the text
    controller = TextEditingController(text: text);
    style = TemplateTableStyleModel();
  }

  TemplateTableCellModel.fromJson(Map<String, dynamic> json, {
    required this.type,
  }) {
    text = json['text']?.replaceAll("<br>", "\n");
    cssClass = json['cssClass'];
    isNumber = json['isNumber'];
    refDb = json['refDb'];
    id = json['id'];
    spanId = json['spanId'];
    ddId = json['ddId'];
    width = double.tryParse((json['width'] ?? 0).toString());
    dropdown = TemplateTableDropdownModel.fromJson(json['dropdown']);
    obj = TemplateTableCellObjectModel.fromJson(json['obj']);
    style = TemplateTableStyleModel.fromJson(json['style']);
    if ((dropdown?.selectedText?.isEmpty ?? false) && (text?.isEmpty ?? false)) {
      text = 'select'.tr;
    }
    controller = TextEditingController(text: text);
    row = json['row'];
    column = json['col'];
    avoidListeners = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['cssClass'] = cssClass;
    data['isNumber'] = isNumber;
    data['refDb'] = refDb;
    data['id'] = id;
    data['spanId'] = spanId;
    data['ddId'] = ddId;
    return data;
  }

  /// [addListener] can be used to add listener on table cell, This functions
  /// also keep track of added listener to remove it in future
  void addListener(VoidCallback? callback) {

    if (callback == null || avoidListeners) return;
    // initializing listener list is empty
    listener ??= [];
    // there can be multiple listeners of single cell, so adding them to list
    listener!.add(callback);
    controller.addListener(listener![listener!.length - 1]);
  }

  /// [removeListeners] will remove all the listeners from cell, It is useful
  /// while adding new cell or removing previous cell
  void removeListeners() {

    if (avoidListeners) return;

    for (VoidCallback tempListener in listener ?? []) {
      controller.removeListener(tempListener);
    }
    listener?.clear();
  }

  /// [callAllListeners] calls all the listener to execute all the calculations
  void callAllListeners() {

    if (avoidListeners) return;

    for (VoidCallback tempListener in listener ?? []) {
      tempListener.call();
    }
  }

  String getCellData() {
    if (avoidListeners) return "";
    return controller.text;
  }
}
