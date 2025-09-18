import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_meta.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/common/extensions/String/index.dart';

/// [WorksheetCalculations] helps in performing various worksheet calculations
class WorksheetCalculations {

  /// [getTierAmounts] calculates to tier level from it's sub items and sub tiers
  /// and helps in setting display the calculations at Tier level
  static WorksheetAmounts getTierAmounts(List<SheetLineItemModel> items) {
    WorksheetAmounts amounts = WorksheetAmounts();
    for (var item in items) {
      amounts.lineItemProfit += double.tryParse(item.lineProfitAmt ?? "") ?? 0;
      amounts.lineItemTax += double.tryParse(item.lineTaxAmt ?? "") ?? 0;
      amounts.listTotal += (double.tryParse(item.tiersLineTotal ?? "") ?? 0);
      amounts.subTotal += double.tryParse(item.totalPrice ?? "") ?? 0;
    }
    return amounts;
  }

  /// [setGetLineAmount] helps in updating the line item details and also performs
  /// calculations on them as per worksheet settings
  static num setGetLineAmount(SheetLineItemModel item) {

    num unitCost = double.tryParse(item.unitCost ?? "0") ?? 0;
    num sellingPrice = double.tryParse(item.price ?? "") ?? 0;
    num quantity = double.tryParse(item.qty ?? "") ?? 0;

    bool isSellingPriceEnabled = item.workSheetSettings?.enableSellingPrice ?? true;

    final amountToUse = isSellingPriceEnabled ? sellingPrice : unitCost;
    num total = amountToUse * quantity;

    num taxAmount = setLineItemTax(item, total);
    num profitAmount = setLineItemProfit(item, total);

    item.tiersLineTotal = total.toString(); // setting up cost by excluding additional values
    item.totalPrice = (total + taxAmount + profitAmount).toString();
    item.lineItemTotal = convertToFixedNum(total);
    return item.lineItemTotal ?? 0;
  }

  /// [setLineItemProfit] updates the line item profit to perform calculation
  static num setLineItemProfit(SheetLineItemModel item, num total) {

    num profitAmount = 0;
    WorksheetSettingModel? settings = item.workSheetSettings;
    bool isNoChargeItem = item.productCategorySlug == FinancialConstant.noCharge;

    if (isNoChargeItem) return profitAmount;

    if (settings?.lineItemProfitPercent != null && settings!.lineItemProfitPercent! >= 0) {
      item.lineProfit = settings.lineItemProfitPercent.toString();
    }

    bool hasLineItemProfit = !Helper.isValueNullOrEmpty(item.lineProfit);
    bool isLineItemProfitEnabled = (settings?.applyLineItemProfit ?? false);

    bool addLineItemProfit = hasLineItemProfit && isLineItemProfitEnabled;

    if (addLineItemProfit) {
      num? lineItemProfitRate = num.tryParse(item.lineProfit ?? "");
      bool isMarkup = item.workSheetSettings?.getIsLineItemProfitMarkup ?? false;
      num lineItemProfit = percentToAmount(lineItemProfitRate, total, margin: !isMarkup);
      lineItemProfit = lineItemProfit;
      item.lineProfitAmt = convertToFixedNum(lineItemProfit).toString();
      profitAmount = lineItemProfit;
    } else {
      item.lineProfit = item.lineProfitAmt = "";
    }
    return profitAmount;
  }

  /// [setLineItemTax] updates the line item tax to perform calculation
  static num setLineItemTax(SheetLineItemModel item, num total) {

    num taxAmount = 0;
    final settings = item.workSheetSettings;
    bool isNoChargeItem = item.productCategorySlug == FinancialConstant.noCharge;

    if (isNoChargeItem) return taxAmount;

    if (settings?.lineItemTaxPercent != null && settings!.lineItemTaxPercent! > 0) {
      item.lineTax = settings.lineItemTaxPercent.toString();
    }

    bool hasLineItemTax = !Helper.isValueNullOrEmpty(item.lineTax);
    bool isLineItemTaxEnabled = (settings?.addLineItemTax ?? false);

    bool addLineItemTax = hasLineItemTax && isLineItemTaxEnabled;

    if (addLineItemTax) {
      num? lineItemTaxRate = num.tryParse(item.lineTax ?? "");
      num lineItemTax = percentToAmount(lineItemTaxRate, total);
      item.lineTaxAmt = convertToFixedNum(lineItemTax).toString();
      taxAmount = lineItemTax;
    } else {
      item.lineTaxAmt = item.lineTax = "";
    }
    return taxAmount;
  }

  /// [calculateAmounts] iterates through all the line items and performs calculations
  /// on the basis of applied settings and update all the amounts accordingly
  static WorksheetAmounts calculateAmounts({
    required List<SheetLineItemModel> lineItems,
    required WorksheetSettingModel settings,
  }) {

    num subTotal = 0;
    num materialItemTotal = 0;
    num laborItemTotal = 0;
    num lineItemTax = 0;
    num lineItemProfit = 0;
    num noChargeAmount = 0;

    WorksheetAmounts amounts = WorksheetAmounts(
      fixedPrice: settings.fixedPriceAmount ?? 0
    );

    for (SheetLineItemModel item in lineItems) {

      num lineTotal = setGetLineAmount(item);
      String? itemSlug = item.category?.slug;
      bool isMaterialItem = itemSlug == FinancialConstant.material;
      bool isLaborItem = itemSlug == FinancialConstant.labor;
      bool isNoCharge = itemSlug == FinancialConstant.noCharge;

      if (isMaterialItem) materialItemTotal += lineTotal;
      if (isLaborItem) laborItemTotal += lineTotal;
      if (isNoCharge) noChargeAmount += lineTotal;
      if (item.lineTaxAmt != null) lineItemTax += num.tryParse(item.lineTaxAmt!) ?? 0;
      if (item.lineProfitAmt != null) lineItemProfit += num.tryParse(item.lineProfitAmt!) ?? 0;

      if (isNoCharge) lineTotal = 0;

      subTotal += lineTotal;
    }

    amounts.subTotal = settings.subTotalAmount = subTotal;
    settings.lineItemProfitAmount = lineItemProfit;

    if (settings.applyOverhead ?? false) {
      amounts.overhead = percentToAmount(settings.getOverHeadRate, subTotal);
      settings.overHeadAmount = amounts.overhead;
    }

    if (settings.applyProfit ?? false) {
    if (settings.getIsOverAllProfitMarkup) {
        amounts.profitMarkup = percentToAmount(settings.getOverAllProfitRate, settings.getPercentDialogueTotal);
        settings.overAllProfitAmount = amounts.profitMarkup;
      } else {
        amounts.profitMargin = percentToAmount(settings.getOverAllProfitRate, settings.getPercentDialogueTotal, margin: true);
        settings.overAllProfitAmount = amounts.profitMargin;
      }
    } else {
      settings.overAllProfitAmount = 0;
    }

    if (settings.applyTaxMaterial ?? false) amounts.materialTax = convertToFixedNum(percentToAmount(settings.getMaterialTaxRate, materialItemTotal));
    if (settings.applyTaxLabor ?? false) amounts.laborTax = convertToFixedNum(percentToAmount(settings.getLaborTaxRate, laborItemTotal));
    if (settings.addLineItemTax ?? false) amounts.lineItemTax = convertToFixedNum(lineItemTax);
    amounts.lineItemProfit = (settings.applyLineItemProfit ?? false) ? convertToFixedNum(lineItemProfit) : 0;
    if (settings.hasNoChargeItem) amounts.noChargeAmount = noChargeAmount;
    
    if(settings.applyDiscount ?? false) {
      final total = convertToFixedNum(subTotal)
          + convertToFixedNum(amounts.overhead)
          + convertToFixedNum(amounts.profitMarkup)
          + convertToFixedNum(amounts.profitMargin)
          + amounts.lineItemProfit;
      amounts.discount = convertToFixedNum(percentToAmount(settings.getDiscount, total));
    }

    if (settings.applyCommission ?? false) {
      final listTotal = convertToFixedNum(amounts.subTotal)
          + convertToFixedNum(amounts.overhead)
          + convertToFixedNum(amounts.profitMarkup)
          + convertToFixedNum(amounts.profitMargin)
          + amounts.lineItemProfit
          - amounts.discount ;
      amounts.commission = convertToFixedNum(percentToAmount(settings.getCommissionRate, listTotal));
    }

    amounts.listTotal = convertToFixedNum(amounts.subTotal)
        + convertToFixedNum(amounts.overhead)
        + convertToFixedNum(amounts.materialTax, forceTrim: true)
        + convertToFixedNum(amounts.laborTax, forceTrim: true)
        + convertToFixedNum(amounts.taxAll, forceTrim: true)
        + convertToFixedNum(amounts.profitMarkup)
        + convertToFixedNum(amounts.profitMargin)
        + convertToFixedNum(amounts.lineItemProfit, forceTrim: true)
        + convertToFixedNum(amounts.lineItemTax)
        + convertToFixedNum(amounts.commission, forceTrim: true)
        - convertToFixedNum(amounts.discount, forceTrim: true);

    if (settings.applyTaxAll ?? false) {
      final total = amounts.listTotal
          - convertToFixedNum(amounts.materialTax)
          - convertToFixedNum(amounts.laborTax);
      amounts.taxAll = convertToFixedNum(percentToAmount(settings.getTaxAllRate, total));
      amounts.listTotal += amounts.taxAll;
    }

    if (settings.isFixedPrice) {
      amounts.profitLossAmount = amounts.fixedPrice - amounts.listTotal;
      amounts.listTotal = amounts.fixedPrice;
    }

    // setting up credit card fee amount if card fee is applied
    if (settings.applyProcessingFee ?? false) {
      amounts.creaditCardFee = percentToAmount(settings.getCardFeeRate, amounts.listTotal);
      settings.cardFeeAmount = amounts.creaditCardFee;
    }

    settings.lineItemTaxPercent = null;
    settings.lineItemProfitPercent = null;

    return amounts;
  }

  /// [percentToAmount] makes a conversion from percent -> amount
  /// [margin] can be set to true for performing margin calculation
  static num percentToAmount(num? percent, num total, {bool margin = false}) {
    percent ??= 0;
    num result = 0;
    if (margin) result = (100 * total) / (100 - percent) - total;
    if (!margin) result = (total * percent) / 100;
    return result.isFinite ? result : 0;
  }

  /// [amountToPercent] makes a conversion from amount -> percent
  /// [margin] can be set to true for performing margin calculation
  static num amountToPercent(num? amount, num total, {bool margin = false}) {
    amount ??= 0;
    num result = 0;
    if (margin) result = 100 - (100 * total / (amount + total));
    if (!margin) result = (amount * 100) / total;
    return result.isFinite && result >= 0 ? result : 0;
  }

  static num convertToFixedNum(num val, {
    bool forceTrim = false
  }) {
    return (num.tryParse(val.toString().roundToDecimalPlaces(2, forceTrim: forceTrim)) ?? 0);
  }

  /// [calculateAmountForResource] helps is calculating amounts for resource files
  /// which can further used for displaying amount in quick action and sending request params
  static WorksheetAmounts calculateAmountForResource(WorksheetModel worksheet) {

    bool isSellingPriceEnabled = worksheet.isEnableSellingPrice ?? false;
    WorksheetMeta meta = worksheet.meta ?? WorksheetMeta();
    WorksheetAmounts amounts = WorksheetAmounts(
        fixedPrice: num.tryParse(worksheet.fixedPrice.toString()) ?? 0
    );

    String subTotal = (isSellingPriceEnabled ? worksheet.sellingPriceTotal : worksheet.total).toString();
    amounts.subTotal = num.tryParse(subTotal) ?? 0;

    num? overHeadPercent = num.tryParse(worksheet.overhead.toString());
    amounts.overhead = convertToFixedNum(percentToAmount(overHeadPercent, amounts.subTotal));

    if (Helper.isTrue(worksheet.lineMarginMarkup) && meta.totalLineProfit >= 0) {
      amounts.lineItemProfit = meta.totalLineProfit;
    }

    final subTotalWithLineProfit = amounts.subTotal + amounts.lineItemProfit;

    num? profitPercent = num.tryParse(worksheet.profit.toString());
    bool isMargin = Helper.isTrue(worksheet.margin) ||
        (Helper.isTrue(worksheet.isEnableLineAndWorksheetProfit) && Helper.isTrue(worksheet.projectedProfitMargin));
    if (isMargin) {
      amounts.profitMargin = convertToFixedNum(percentToAmount(profitPercent, subTotalWithLineProfit, margin: true));
    } else {
      amounts.profitMarkup = convertToFixedNum(percentToAmount(profitPercent, subTotalWithLineProfit));
    }

    if (!Helper.isValueNullOrEmpty(worksheet.discount)) {
      final total = convertToFixedNum(amounts.subTotal)
        + convertToFixedNum(amounts.overhead)
        + convertToFixedNum(amounts.profitMarkup)
        + convertToFixedNum(amounts.profitMargin)
        + amounts.lineItemProfit;
      num? discount = num.tryParse(worksheet.discount.toString());
      amounts.discount = convertToFixedNum(percentToAmount(discount, total));
    }
    if (!Helper.isValueNullOrEmpty(worksheet.commission)) {
      num? commissionPercent = num.tryParse(worksheet.commission.toString());
      final listTotal = convertToFixedNum(amounts.subTotal)
          + convertToFixedNum(amounts.overhead)
          + convertToFixedNum(amounts.profitMarkup)
          + convertToFixedNum(amounts.profitMargin)
          + amounts.lineItemProfit
          - convertToFixedNum(amounts.discount)
          ;
      amounts.commission = convertToFixedNum(percentToAmount(commissionPercent, listTotal));
    }

    if (!Helper.isValueNullOrEmpty(worksheet.laborTaxRate)) {
      num laborTaxAmount = isSellingPriceEnabled ? meta.laborSellingPriceTotal : meta.laborCostTotal;
      num? laborTaxRate = num.tryParse(worksheet.laborTaxRate.toString());
      amounts.laborTax = percentToAmount(laborTaxRate, laborTaxAmount);
    }

    if (!Helper.isValueNullOrEmpty(worksheet.materialTaxRate)) {
      num materialTaxAmount = isSellingPriceEnabled ? meta.materialsSellingPriceTotal : meta.materialsCostTotal;
      num? materialTaxRate = num.tryParse(worksheet.materialTaxRate.toString());
      amounts.materialTax = percentToAmount(materialTaxRate, materialTaxAmount);
    }

    amounts.listTotal = convertToFixedNum(amounts.subTotal)
        + convertToFixedNum(amounts.overhead)
        + convertToFixedNum(amounts.materialTax)
        + convertToFixedNum(amounts.laborTax)
        + convertToFixedNum(amounts.taxAll)
        + convertToFixedNum(amounts.profitMarkup)
        + convertToFixedNum(amounts.profitMargin)
        + convertToFixedNum(amounts.lineItemProfit)
        + convertToFixedNum(amounts.lineItemTax)
        + convertToFixedNum(amounts.commission)
        - convertToFixedNum(amounts.discount)
        ;
    
    if (amounts.fixedPrice > 0) {
      amounts.profitLossAmount = amounts.fixedPrice - amounts.listTotal;
    }

    return amounts;
  }

}