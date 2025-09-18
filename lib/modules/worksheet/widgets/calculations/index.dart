import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/index.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/label_value_tile.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/tax_section.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/total_price_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../controller.dart';
import 'tax_tile.dart';

class WorksheetCalculationsTile extends StatelessWidget {
  const WorksheetCalculationsTile({
    super.key,
    required this.controller
  });

  final WorksheetFormController controller;

  WorksheetFormService get service => controller.service;

  WorksheetSettingModel? get settings => controller.service.settings;

  num get totalPrice => service.getGrandTotal();
  num get contractTotalPrice => service.getContractTotal();

  String get getWorksheetProfitTitle {
    String title = settings!.applyLineAndWorksheetProfit! ? 'projected_worksheet_profit'.tr : 'profit'.tr;
    title = "$title (${settings!.getIsOverAllProfitMarkup ? 'markup'.tr : 'margin'.tr})";
    return title;
  }

  String get getLineItemProfitTitle {
    String title = settings!.applyLineAndWorksheetProfit! ? 'projected_line_profit'.tr : 'profit'.tr;
    title = "$title (${settings!.getIsLineItemProfitMarkup ? 'markup'.tr : 'margin'.tr})";
    return title;
  }

  @override
  Widget build(BuildContext context) {

    final displaySummary = getCalculationSummary();

    if (displaySummary.isEmpty) {
      return const SizedBox();
    }

    return Opacity(
      opacity: service.isSavingForm ? 0.5 : 1,
      child: Padding(
          padding: EdgeInsets.only(top: controller.formUiHelper.verticalPadding),
          child: SheetTotalAmountSection(
            labelValueList: displaySummary,
          )
      ),
    );
  }

  List<Widget> getCalculationSummary() {
    if (settings!.showEntireSummary) {
      return getEntireSummary();
    } else if (settings!.showTaxOrTotalOrDiscount) {
      return getTaxOrTotalOrDiscount();
    } else {
      return [];
    }
  }

  List<Widget> getEntireSummary() {
    return [
      /// No charge amount
      WorksheetCalculationsTaxTile(
        title: 'no_charge_amount'.tr,
        hidePercentage: true,
        isNegative: true,
        amount: service.calculatedAmounts.noChargeAmount,
        isVisible: settings!.hasNoChargeItem,
      ),

      if (settings!.hasNoChargeItem)
        const SizedBox(height: 4),

      /// Sub total
      SheetLabelValueTile(
        labelWidget: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            JPText(
              text: 'sub_total'.tr.capitalize!,
              fontWeight: JPFontWeight.medium,
            ),
            if ((settings?.addLineItemTax ?? false) || (settings?.applyLineItemProfit ?? false)) ...{
              const SizedBox(width: 5),
              JPText(
                text: 'exclude_tax_and_profit'.tr,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading6,
              ),
            }
          ],
        ),
        valueWidget: JPText(
          text: JobFinancialHelper.getCurrencyFormattedValue(value: service.calculatedAmounts.subTotal),
          textColor: JPAppTheme.themeColors.text,
          fontWeight: JPFontWeight.bold,
        ),
      ),

      const SizedBox(height: 2),

      ///   Line item profit
      if (!settings!.isFixedPrice && (settings!.applyLineItemProfit! || settings!.applyLineAndWorksheetProfit!)) ...{
        WorksheetCalculationsTaxTile(
          title: getLineItemProfitTitle,
          hidePercentage: true,
          amount: service.calculatedAmounts.lineItemProfit,
          isVisible: settings!.applyLineItemProfit! || settings!.applyLineAndWorksheetProfit!,
        ),
      },

      ///   Worksheet Profit
      if (!settings!.isFixedPrice && (settings!.applyProfit! || settings!.applyLineAndWorksheetProfit!)) ...{
        WorksheetCalculationsTaxTile(
          title: getWorksheetProfitTitle,
          percent: settings!.getOverAllProfitRate,
          amount: settings!.getIsOverAllProfitMarkup ? service.calculatedAmounts.profitMarkup : service.calculatedAmounts.profitMargin,
          isVisible: settings!.getIsOverAllProfitMarkup || !settings!.getIsOverAllProfitMarkup,
          onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.overAllProfit),
        ),
      },

      /// Overhead
      WorksheetCalculationsTaxTile(
        title: 'overhead'.tr,
        amount: service.calculatedAmounts.overhead,
        percent: settings?.getOverHeadRate,
        isVisible: settings?.applyOverhead,
        onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.overhead),
      ),

      /// Discount
      FromLaunchDarkly(
        flagKey: LDFlagKeyConstants.metroBathFeature,
        child: (_)=> WorksheetCalculationsTaxTile(
          key:const Key(WidgetKeys.discount),
          title: 'discount'.tr,
          amount: service.calculatedAmounts.discount,
          percent: settings?.getDiscount,
          isVisible: settings?.applyDiscount ?? false,
          onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.discount),
        ),
      ),

      /// Commission
      WorksheetCalculationsTaxTile(
        title: 'commission'.tr,
        amount: service.calculatedAmounts.commission,
        percent: settings?.getCommissionRate,
        isVisible: settings?.applyCommission,
        onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.commission),
      ),

      /// Tax Section
      WorksheetCalculationsTaxSection(controller: controller),

      /// Line item tax
      WorksheetCalculationsTaxTile(
        title: 'profit_loss'.tr,
        amount: service.calculatedAmounts.profitLossAmount,
        isVisible: settings!.isFixedPrice,
        hidePercentage: true,
      ),

      const SizedBox(height: 2),

      /// Total price
      WorksheetCalculationsTotalPriceTile(price: totalPrice),

      /// Credit Card Fee & Contract Total
      /// (displayed conditionally from LaunchDarkly)
      if (Helper.isTrue(settings?.showProcessingFee)) ...{
        FromLaunchDarkly(
          flagKey: LDFlagKeyConstants.metroBathFeature,
          showHideOnly: true,
          child: (_) => Column(
            children: getContractTotal(),
          ),
        ),
      }

    ];
  }

  List<Widget> getTaxOrTotalOrDiscount() {
    return [
      if(settings?.showDiscount ?? false)
      FromLaunchDarkly(
        flagKey: LDFlagKeyConstants.metroBathFeature,
        child: (_)=> WorksheetCalculationsTaxTile(
          key: const Key(WidgetKeys.discount),
          title: 'discount'.tr,
          amount: service.calculatedAmounts.discount,
          percent: settings?.getDiscount,
          isVisible: settings?.applyDiscount ?? false,
          onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.discount),
        ),
      ),
      if (settings!.showTaxOnly)
        WorksheetCalculationsTaxSection(controller: controller),
      if (settings!.showTotalOnly) ...{
        const SizedBox(height: 2),
        WorksheetCalculationsTotalPriceTile(price: totalPrice),
      },
    ];
  }

  List<Widget> getContractTotal() {
    return [
      /// Credit Card Fee
      WorksheetCalculationsTaxTile(
        key: const Key(WidgetKeys.creditCardFeeKey),
        title: 'processing_fee'.tr,
        amount: service.calculatedAmounts.creaditCardFee,
        percent: settings?.getCardFeeRate,
        isVisible: settings?.applyProcessingFee,
        percentFraction: 3,
        onTapEdit: () => service.showAmountPercentDialog(WorksheetPercentAmountDialogType.cardFee),
      ),

      /// Contract Total
      WorksheetCalculationsTotalPriceTile(
        key: const Key(WidgetKeys.contractTotal),
        label: "contract_total".tr,
        price: contractTotalPrice,
      ),
    ];
  }
}
