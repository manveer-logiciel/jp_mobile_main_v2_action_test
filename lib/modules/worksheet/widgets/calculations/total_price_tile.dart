import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/label_value_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetCalculationsTotalPriceTile extends StatelessWidget {
  const WorksheetCalculationsTotalPriceTile({
    required this.price,
    this.label,
    super.key,
  });

  final num price;

  /// [label] is used to displayed custom label in the tile
  /// by default label is going to be Total Price
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SheetLabelValueTile(
      labelWidget: JPText(
        text: label ?? 'total_price'.tr.capitalize!,
        textSize: JPTextSize.heading3,
        fontWeight: JPFontWeight.medium,
      ),
      valueWidget: JPText(
        text: JobFinancialHelper.getCurrencyFormattedValue(value: price),
        textColor: JPAppTheme.themeColors.text,
        fontWeight: JPFontWeight.bold,
        textSize: JPTextSize.heading3,
      ),
    );
  }
}
