import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SheetLineItemTotalPrice extends StatelessWidget {
  const SheetLineItemTotalPrice({
    super.key,
    required this.totalPrice,
  });

  final String  totalPrice;

  @override
  Widget build(BuildContext context) {
    return JPText(
      text: JobFinancialHelper.getCurrencyFormattedValue(
        value: totalPrice),
      textSize: JPTextSize.heading4,
      textColor: JPAppTheme.themeColors.primary,
    );
  }
}