import 'package:jobprogress/common/models/forms/worksheet/index.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';

class WorksheetTierParams {

  int? jobId;
  int totalCollections;
  SheetLineItemModel lineItem;
  SheetLineItemModel rootItem;
  WorksheetFormData data;
  Function(String, {dynamic data}) onActionComplete;
  Map<String, dynamic> Function(List<SheetLineItemModel>, {String? name}) worksheetJson;

  WorksheetTierParams({
    required this.rootItem,
    required this.lineItem,
    required this.onActionComplete,
    required this.worksheetJson,
    required this.data,
    required this.totalCollections,
    this.jobId,
  });
}
