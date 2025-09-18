import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/details_listing_tile/widgets/label_value_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/models/job/job_division.dart';
import '../../../../common/services/worksheet/helpers.dart';

class SheetLineItemWorksheetAdditionalInfo extends StatelessWidget {

  const SheetLineItemWorksheetAdditionalInfo({
    super.key,
    required this.itemModel,
    this.jobDivision,
    this.isMaterialSupplier = false
  });

  final SheetLineItemModel itemModel;

  final DivisionModel? jobDivision;

  final bool isMaterialSupplier;

  WorksheetSettingModel get settings => itemModel.workSheetSettings!;

  bool get showDescription => settings.descriptionOnly ?? false;
  bool get isDescriptionNotEmpty => !Helper.isValueNullOrEmpty(itemModel.description);
  bool get showTradeType => (itemModel.tradeType?.label.isNotEmpty ?? false) && (!showDescription || settings.showTradeType!);
  bool get showWorkType => (itemModel.workType?.label.isNotEmpty ?? false) && (!showDescription || settings.showWorkType!);
  bool get showStyle => !Helper.isValueNullOrEmpty(itemModel.style) && (!showDescription || settings.showStyle!) && !showVariants;
  bool get showColor => !Helper.isValueNullOrEmpty(itemModel.color) && (!showDescription || settings.showColor!) && !showVariants;
  bool get showSize => !Helper.isValueNullOrEmpty(itemModel.size) && (!showDescription || settings.showSize!) && !showVariants;
  bool get showSupplier => !Helper.isValueNullOrEmpty(itemModel.supplier?.name) && (!showDescription || settings.showSupplier!);
  bool get showProfit => !settings.descriptionOnly! && settings.applyLineItemProfit! && itemModel.product?.productCategory?.slug != FinancialConstant.noCharge;
  bool get showTax => !settings.descriptionOnly! && settings.addLineItemTax! && itemModel.product?.productCategory?.slug != FinancialConstant.noCharge;
  /// [showVariants] will help in displaying the variants only if line item has variant
  bool get showVariants => !Helper.isValueNullOrEmpty(itemModel.variantModel?.name) &&
      (!showDescription || Helper.isTrue(settings.showVariation));

  bool get isUnassignedLabel => jobDivision?.id != null
      && itemModel.supplier?.id != null
      && !isMaterialSupplier
      && !Helper.isValueNullOrEmpty(itemModel.supplier?.divisions)
      && (jobDivision?.enableAllSupplierSearch ?? false)
      && !WorksheetHelpers.isDivisionMatches(itemModel.supplier?.divisions, jobDivision?.id);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 28),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDescriptionNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 2),
                  child: JPText(
                    text: itemModel.description!,
                    textAlign: TextAlign.start,
                    maxLine: 3,
                    overflow: TextOverflow.ellipsis,
                    textSize: JPTextSize.heading5,
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: getColChildren(isColumnOne: true)
                        )
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getColChildren(),
                        )
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 2,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showProfit) Expanded(
                    child: getProfit(),
                  ),
                  if (showTax) Expanded(
                    child: getTax(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getColChildren({bool isColumnOne = false}) {
    List<Widget> cols = <Widget>[];
    if(showSupplier) {
      cols.add(LabelValueTile(
        textSize: JPTextSize.heading5,
        label: "${"supplier".tr}:",
        value: itemModel.supplier?.name ?? "",
        enablePadding: true,
        isLabelPadding: isUnassignedLabel,
        extraContent: isUnassignedLabel ? Container(
          margin: const EdgeInsets.only(left: 5),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
          decoration: BoxDecoration(
            color: JPAppTheme.themeColors.lightBlue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: JPText(
            text: 'unassigned'.tr,
            textSize: JPTextSize.heading5,
          ),
        ) : null,
      ));
    }

    if(showTradeType) {
      cols.add(LabelValueTile(
        textSize: JPTextSize.heading5,
        label: "${"trade_type".tr}:",
        value: itemModel.tradeType?.label ?? "",
        enablePadding: true,
        isLabelPadding: isUnassignedLabel
      ));
    }

    if(showWorkType) {
      cols.add(LabelValueTile(
        textSize: JPTextSize.heading5,
        label: "${"work_type".tr}:",
        value: itemModel.workType?.label ?? "",
        enablePadding: true,
        isLabelPadding: isUnassignedLabel
      ));
    }

    if(showStyle) {
      cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: "${'type_and_style'.tr.capitalize!}:",
          value: itemModel.style,
          enablePadding: true,
          isLabelPadding: isUnassignedLabel
      ));
    }

    if(showColor) {
      cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: "${'color'.tr.capitalize!}:",
          value: itemModel.color,
          enablePadding: true,
          isLabelPadding: isUnassignedLabel
      ));
    }

    if(showSize) {
      cols.add(LabelValueTile(
          textSize: JPTextSize.heading5,
          label: "${'size'.tr.capitalize!}:",
          value: itemModel.size,
          enablePadding: true,
          isLabelPadding: isUnassignedLabel
      ));
    }

    if(showVariants) {
      cols.add(LabelValueTile(
           textSize: JPTextSize.heading5,
           label: "${'variation'.tr.capitalize!}:",
           value: itemModel.variantModel?.name,
           enablePadding: true,
           isLabelPadding: isUnassignedLabel
      ));
    }

    bool isLengthEven = (cols.length % 2 == 0);

    double subLength = (cols.length / 2) + (isLengthEven ? 0 : 1);

    List<Widget> subList1 = cols.sublist(0, subLength.toInt());
    List<Widget> subList2 = cols.sublist(subLength.toInt());

    if(isColumnOne) return subList1;
    return subList2;
  }

  Widget getProfit() {

    final profitAmount = JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.lineProfitAmt);
    final profitPercent = JobFinancialHelper.getRoundOff(num.tryParse(itemModel.lineProfit ?? "") ?? 0);

    return LabelValueTile(
      textSize: JPTextSize.heading5,
      label: "${'profit'.tr.capitalize!}:",
      value: "$profitAmount ($profitPercent%)",
      enablePadding: true,
      fontWeight: JPFontWeight.medium,
      valueColor: JPAppTheme.themeColors.text,
    );
  }

  Widget getTax() {
    final taxAmount = JobFinancialHelper.getCurrencyFormattedValue(value: itemModel.lineTaxAmt);
    final taxPercent = JobFinancialHelper.getRoundOff(num.tryParse(itemModel.lineTax ?? "") ?? 0);

    return LabelValueTile(
      textSize: JPTextSize.heading5,
      label: "${'tax'.tr.capitalize!}:",
      value: "$taxAmount ($taxPercent%)",
      enablePadding: true,
      fontWeight: JPFontWeight.medium,
      valueColor: JPAppTheme.themeColors.text,
    );
  }
}
