import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';

class WorkSheetCalculationTestModel {
  late List<SheetLineItemModel> lineItems;
  WorksheetAmounts result;
  String description;
  WorksheetModel? worksheet;

  WorkSheetCalculationTestModel({
    required this.description,
    required this.result,
    this.lineItems = const [],
    this.worksheet,
  }) {
    if (lineItems.isEmpty) {
      lineItems = worksheet?.lineItems ?? [];
    }
  }

  WorksheetSettingModel getSettings() {
    final settings = WorksheetSettingModel();
    settings.fromWorksheetJson({}, worksheet);
    settings.hasNoChargeItem = worksheet?.lineItems
        ?.any((item) => item.productSlug == FinancialConstant.noCharge) ?? false;
    worksheet?.lineItems?.forEach((item) {
      item.workSheetSettings = settings;
    });
    return settings;
  }
}