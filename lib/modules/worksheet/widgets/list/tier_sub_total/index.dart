import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [WorksheetTierSubTotals] is a widget that helps in displaying
/// Tier Sub total as a selector in Tier header and as option too
class WorksheetTierSubTotals extends StatelessWidget {
  const WorksheetTierSubTotals({
    required this.value,
    required this.tierItem,
    required this.service,
    this.isSelector = false,
    this.textColor,
    super.key,
  });

  /// [textColor] is used to decide the color of the text in the widget
  /// this prop will be effective only when [isSelector] is [True]
  final Color? textColor;

  /// [value] is used to display the value of the sub total
  final String value;

  /// [isSelector] is used to decide whether the widget is a selector or not
  final bool isSelector;

  /// [tierItem] is used to get all the tier details so that calculations
  /// can be extracted and displayed accordingly
  final SheetLineItemModel? tierItem;

  /// [service] helps in accessing functions from service directly
  final WorksheetFormService service;

  /// [amount] is used to display the amount of the sub total
  String get amount => JobFinancialHelper
      .getCurrencyFormattedValue(value: service.getTierSubTotalAmount(value, tierItem));

  @override
  Widget build(BuildContext context) {
    if (isSelector) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          JPText(
            text: service.getTierSubtotalTitle(value),
            textColor: textColor ?? JPAppTheme.themeColors.tertiary,
            textSize: JPTextSize.heading5,
          ),
          const SizedBox(
            width: 4,
          ),
          /// Amount
          Flexible(
            child: JPText(
              text: amount,
              textColor: textColor,
              fontWeight: JPFontWeight.medium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          /// Selector Icon
          JPIcon(
            Icons.arrow_drop_down_outlined,
            color: textColor,
            size: 20,
          )
        ],
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                /// Title
                JPText(
                  text: service.getTierSubtotalTitle(value),
                  textColor: JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                ),
                const SizedBox(
                  width: 10,
                ),
                /// Amount
                Flexible(
                  child: JPText(
                    text: amount,
                    textColor: JPAppTheme.themeColors.text,
                    fontWeight: JPFontWeight.medium,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          /// Options Separator
          const Divider(
            height: 2,
            thickness: 1,
          ),
        ],
      );
    }
  }
}
