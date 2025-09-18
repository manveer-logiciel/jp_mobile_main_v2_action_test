import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../core/utils/job_financial_helper.dart';
import 'controller.dart';

class FinancialFormNoChargePriceTile extends StatelessWidget {
  const FinancialFormNoChargePriceTile({
    super.key,
    this.noChargeItemsList,
    this.noChargeItemsTotal = 0,
    required this.pageType,
  });

  final List<SheetLineItemModel>? noChargeItemsList;
  final num noChargeItemsTotal;
  final AddLineItemFormType pageType;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<FinancialFormNoChargePriceTileController>(
      init: FinancialFormNoChargePriceTileController(noChargeItemsList: noChargeItemsList, pageType: pageType),
      global: false,
      builder: (controller) => Material(
        color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: controller.viewNoChargeItems,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const JPIcon(Icons.visibility_outlined, size: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: JPText(
                        text: "no_charge_amount".tr,
                        textColor: JPAppTheme.themeColors.text,
                      ),
                    ),
                  ],
                ),
                JPText(
                  text: '-${JobFinancialHelper.getCurrencyFormattedValue(value: noChargeItemsTotal)}',
                  textColor: JPAppTheme.themeColors.text,
                  textSize: JPTextSize.heading2,
                  fontWeight: JPFontWeight.medium,
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
