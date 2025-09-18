import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import '../forms/worksheet/index.dart';

class WorksheetHeaderActionParams {

  String action;
  bool hasTiers;
  WorksheetFormData data;
  Function(String, {dynamic data})? onActionComplete;
  Function(List<SheetLineItemModel>, {String? name})? worksheetJson;

  WorksheetHeaderActionParams({
    this.action = "",
    this.hasTiers = false,
    this.onActionComplete,
    required this.data,
    this.worksheetJson,
  });

}