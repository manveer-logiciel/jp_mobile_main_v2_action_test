import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/label_value_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetCalculationsTaxTile extends StatelessWidget {
  const WorksheetCalculationsTaxTile({
    super.key,
    required this.title,
    required this.amount,
    this.percent,
    this.isVisible = false,
    this.hidePercentage = false,
    this.isNegative = false,
    this.onTapEdit,
    this.revisedTaxRate,
    this.onTapRevisedTax,
    this.isRevisedTaxApplied,
    this.percentFraction = 2,
  });

  /// [title] displays the title of the tile
  final String title;

  /// [percent] displays the percentage
  final num? percent;

  /// [amount] can be used to show amount
  final num amount;

  /// [isVisible] helps in show/hide entire tile
  final bool? isVisible;

  /// [hidePercentage] helps in hiding percentage
  final bool hidePercentage;

  /// [isNegative] can be used to display -ve sign before amount
  final bool isNegative;

  /// [onTapEdit] handles tap on edit icon
  final VoidCallback? onTapEdit;

  /// [revisedTaxRate] helps in showing revised tax rate's value
  final num? revisedTaxRate;

  /// [isRevisedTaxApplied] helps in enabling disabling toggle visually
  final bool? isRevisedTaxApplied;

  /// [onTapRevisedTax] handles tap on revised tax
  final Function(bool)? onTapRevisedTax;

  /// [percentFraction] helps in deciding the number the decimals to be displayed in percentage
  final int percentFraction;

  String get percentage => WorksheetHelpers.formatPercentage(percent ?? 0, fractionDigits: percentFraction);

  @override
  Widget build(BuildContext context) {

    if (!(isVisible ?? false)) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetLabelValueTile(
            labelWidget: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [ 
                JPText(
                  text: title,
                  textAlign: TextAlign.start,
                ),
                JPText(
                  text: (!hidePercentage ? " - (${percentage.isEmpty ? "0" : percentage}%)" : ""),
                  textAlign: TextAlign.start,
                ),
                if (onTapEdit != null) ...{
                  const SizedBox(
                    width: 5,
                  ),
                  JPTextButton(
                    icon: Icons.edit_outlined,
                    color: JPAppTheme.themeColors.primary,
                    onPressed: onTapEdit,
                    padding: 3,
                    iconSize: 14,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                }
              ],
            ),
            valueWidget: JPText(
              text: (isNegative ? "-" : "") + JobFinancialHelper.getCurrencyFormattedValue(value: amount),
              textColor: JPAppTheme.themeColors.text,
            ),
          ),
          /// Apply revised tax
          if (revisedTaxRate != null)
            Transform.translate(
            offset: const Offset(-6, 0),
            child: JPCheckbox(
              selected: isRevisedTaxApplied ?? false,
              onTap: onTapRevisedTax,
              padding: EdgeInsets.zero,
              borderColor: JPAppTheme.themeColors.themeGreen,
              separatorWidth: 0,
                text: "${"apply_revised".tr} $title ${'rate'.tr} (${WorksheetHelpers.formatPercentage(revisedTaxRate!)}%)",
            ),
          ),
        ],
      ),
    );
  }
}

