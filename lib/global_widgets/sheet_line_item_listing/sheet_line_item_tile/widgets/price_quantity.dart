import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SheetLineItemPriceQuantityTile extends StatelessWidget {
  const SheetLineItemPriceQuantityTile({
    super.key,
    required this.itemModel,
    this.pageType
  });

  final SheetLineItemModel itemModel;
  final AddLineItemFormType? pageType;

  WorksheetSettingModel? get settings => itemModel.workSheetSettings!;

  bool get showQuantity => settings?.showQuantity ?? true;
  bool get showUnit => !Helper.isValueNullOrEmpty(itemModel.unit) && ((settings?.showUnit ?? true) || !(settings?.descriptionOnly ?? false));
  bool get showPrice => !(settings?.descriptionOnly ?? false) && !(settings?.hidePricing ?? false);
  bool get showUnitPrice => !(settings?.enableSellingPrice ?? false);
  bool get isSellingPriceEnabled => Helper.isTrue(settings?.enableSellingPrice);
  bool get isSellingPriceUnavailable => Helper.isTrue(itemModel.product?.showSellingPriceNotAvailable(
      pageType,
      Helper.isTrue(settings?.isEstimateOrProposalWorksheet),
      isSellingPriceEnabled));

  @override
  Widget build(BuildContext context) {
    if (pageType == AddLineItemFormType.worksheet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          if (showPrice)
            JPText(
              text: JobFinancialHelper.getCurrencyFormattedValue(
                     isPlaceholder: isSellingPriceUnavailable,
                     value: isSellingPriceEnabled ?
                      itemModel.price : itemModel.unitCost
              ),
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
            ),

          if (showQuantity || showPrice) ...{
            const SizedBox(width: 4,),
            JPText(text: "x",
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
            const SizedBox(width: 3,),
          },

          if (showQuantity || showPrice)
            JPText(text: itemModel.qty?.isEmpty ?? true ? '0' : itemModel.qty ?? "",
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
            ),

          if (showUnit) ...{
            const SizedBox(width: 2),
            JPText(text: itemModel.unit!,
              textSize: JPTextSize.heading6,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
          }
        ],
      );
    }

    return Visibility(
      visible: pageType != AddLineItemFormType.insuranceForm,
      child: Wrap(
        children: [
          JPText(text: JobFinancialHelper.getCurrencyFormattedValue(
              value: itemModel.price),
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
          ),
          const SizedBox(width: 3,),
          JPText(text: "x",
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
          ),
          const SizedBox(width: 3,),
          JPText(text: itemModel.qty ?? "",
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
          ),
        ],
      ),
    );
  }
}