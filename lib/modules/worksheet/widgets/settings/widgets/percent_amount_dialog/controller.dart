import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';

class WorksheetPercentAmountController extends GetxController {

  WorksheetPercentAmountController(this.settings, this.type);

  final WorksheetSettingModel settings;
  WorksheetPercentAmountDialogType type;

  JPInputBoxController percentController = JPInputBoxController();
  JPInputBoxController amountController = JPInputBoxController();

  num calculatedPercent = 0;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool validateFieldsOnDataChange = false;
  bool isProfitMarkup = true;

  String get title {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
        return (settings.applyLineAndWorksheetProfit ?? false) ? "projected_worksheet_profit".tr : "add_profit".tr;

      case WorksheetPercentAmountDialogType.lineItemProfit:
        return (settings.applyLineAndWorksheetProfit ?? false) ? "update_line_item_profit".tr :"add_profit".tr;

      case WorksheetPercentAmountDialogType.lineItemTax:
        return "add_tax".tr;

      case WorksheetPercentAmountDialogType.commission:
        return "add_commission".tr;

      case WorksheetPercentAmountDialogType.overhead:
        return "add_overhead".tr;

      case WorksheetPercentAmountDialogType.discount:
        return "add_discount".tr;
      
      case WorksheetPercentAmountDialogType.cardFee:
        return "apply_processing_fee".tr;
    }
  }

  String get percentFieldLabel {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        return "profit_percent".tr;

      case WorksheetPercentAmountDialogType.lineItemTax:
        return "tax_percent".tr;

      case WorksheetPercentAmountDialogType.commission:
        return "commission_percent".tr;

      case WorksheetPercentAmountDialogType.overhead:
        return "overhead_percent".tr;

      case WorksheetPercentAmountDialogType.discount:
        return "discount_percent".tr;
      
      case WorksheetPercentAmountDialogType.cardFee:
        return "processing_fee_percent".tr;
    }
  }

  String get amountFieldLabel {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        return "profit_amount".tr;

      case WorksheetPercentAmountDialogType.lineItemTax:
        return "";

      case WorksheetPercentAmountDialogType.commission:
        return "commission_amount".tr;

      case WorksheetPercentAmountDialogType.overhead:
        return "overhead_amount".tr;

      case WorksheetPercentAmountDialogType.discount:
        return "discount_amount".tr;
      
      case WorksheetPercentAmountDialogType.cardFee:
        return "processing_fee_amount".tr;
    }
  }

  bool get showAmountField {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.commission:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.discount:
      case WorksheetPercentAmountDialogType.cardFee:
        return true;

      default:
        return false;
    }
  }

  bool get showMarkupMargin {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        return true;

      default:
        return false;
    }
  }

  /// [percentageFraction] helps in deciding number of decimal places allowed
  /// in the percentage input. By default it is 2.
  int get percentageFraction {
    switch (type) {
      case WorksheetPercentAmountDialogType.cardFee:
      case WorksheetPercentAmountDialogType.discount:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.commission:
        return 20;

      default:
        return 2;
    }
  }

  /// [allowZeroInput] helps in allowing zero value to be filled in percentage
  /// and amount fields while filling in the dialog
  bool get allowZeroInput {
    switch (type) {
      case WorksheetPercentAmountDialogType.commission:
      case WorksheetPercentAmountDialogType.overhead:
      case WorksheetPercentAmountDialogType.cardFee:
      case WorksheetPercentAmountDialogType.discount:
      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        return true;
      default:
        return false;
    }
  }

  @override
  void onInit() {
    setUpFields();
    super.onInit();
  }

  void setUpFields() {
    switch (type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
        percentController.text = getRoundOff(settings.getOverAllProfitRate);
        isProfitMarkup = settings.getIsOverAllProfitMarkup;
        onPercentChange(settings.getOverAllProfitRate.toString());
        break;

      case WorksheetPercentAmountDialogType.lineItemProfit:
        percentController.text = getRoundOff(settings.getLineItemProfitRate);
        isProfitMarkup = settings.getIsLineItemProfitMarkup;
        break;

      case WorksheetPercentAmountDialogType.lineItemTax:
        percentController.text = getRoundOff(settings.lineItemTaxPercent);
        break;

      case WorksheetPercentAmountDialogType.commission:
        percentController.text = getRoundOff(settings.getCommissionRate);
        onPercentChange(settings.getCommissionRate.toString());
        break;

      case WorksheetPercentAmountDialogType.overhead:
        percentController.text = getRoundOff(settings.getOverHeadRate);
        onPercentChange(settings.getOverHeadRate.toString());
        break;

      case WorksheetPercentAmountDialogType.discount:
        percentController.text = getRoundOff(settings.getDiscount);
        onPercentChange(settings.getDiscount.toString());
      
      case WorksheetPercentAmountDialogType.cardFee:
        percentController.text = getRoundOff(settings.getCardFeeRate);
        onPercentChange(percentController.text);
        break;
    }
  }

  void changeProfitType(dynamic val) {
    isProfitMarkup = val as bool;
    Helper.hideKeyboard();
    percentController.text = (isProfitMarkup ? settings.markup : settings.margin) ?? "";
    onPercentChange(percentController.text);
    update();
  }

  void onPercentChange(String value) {
    num? percent = num.tryParse(value);
    num subTotal = getTotal();
    num result = WorksheetCalculations.percentToAmount(percent, subTotal, margin: !isProfitMarkup);
    setAmountOnPercentageChange(result);
    amountController.text = JobFinancialHelper.getRoundOff(result, fractionDigits: 2, avoidZero: !allowZeroInput);
    validateForm();
  }

  void onAmountChange(String value) {
    num? amount = num.tryParse(value);
    num subTotal = getTotal();
    num result = WorksheetCalculations.amountToPercent(amount, subTotal, margin: !isProfitMarkup);
    calculatedPercent = result;
    percentController.text = JobFinancialHelper.getRoundOff(result, fractionDigits: percentageFraction, avoidZero: !allowZeroInput);
    validateForm();
  }

  bool validateForm() {
    if (!validateFieldsOnDataChange) return false;
    return formKey.currentState?.validate() ?? false;
  }

  void onUpdate() {
    validateFieldsOnDataChange = true;
    bool isValid = !showAmountField || validateForm();
    if (isValid) {
      updateValuesForType();
      Get.back();
    }
  }

  void updateValuesForType() {
    switch (type) {

      case WorksheetPercentAmountDialogType.overAllProfit:
        settings.overAllProfitPercent = updateSettingsIfChanged(calculatedPercent, percentController.text);
        settings.overAllProfitAmount = updateSettingsIfChanged(settings.overAllProfitAmount, amountController.text);
        settings.isOverAllProfitMarkup = isProfitMarkup;
        break;

      case WorksheetPercentAmountDialogType.lineItemProfit:
        settings.lineItemProfitPercent = updateSettingsIfChanged(settings.lineItemProfitPercent ?? 0, percentController.text);
        settings.lineItemTempProfitPercent = updateSettingsIfChanged(settings.lineItemTempProfitPercent ?? 0, percentController.text);
        settings.isLineItemProfitMarkup = isProfitMarkup;
        break;

      case WorksheetPercentAmountDialogType.lineItemTax:
        settings.lineItemTaxPercent = updateSettingsIfChanged(settings.lineItemTaxPercent, percentController.text);
        break;

      case WorksheetPercentAmountDialogType.commission:
        settings.commissionPercent = updateSettingsIfChanged(calculatedPercent, percentController.text);
        settings.commissionAmount = updateSettingsIfChanged(settings.commissionAmount, amountController.text);
        break;

      case WorksheetPercentAmountDialogType.overhead:
        settings.overriddenOverHeadRate = updateSettingsIfChanged(calculatedPercent, percentController.text);
        settings.overHeadAmount = updateSettingsIfChanged(settings.overHeadAmount, amountController.text);
        break;

      case WorksheetPercentAmountDialogType.discount:
        settings.discountPercent = updateSettingsIfChanged(calculatedPercent, percentController.text);
        settings.discountAmount = updateSettingsIfChanged(settings.discountAmount, amountController.text);
      
      case WorksheetPercentAmountDialogType.cardFee:
        settings.creditCardFeePercent = updateSettingsIfChanged(calculatedPercent, percentController.text);
        settings.cardFeeAmount = updateSettingsIfChanged(settings.cardFeeAmount, amountController.text);
        break;
    }
  }

  num? updateSettingsIfChanged(num? value, String controllerText) {
    var tempValue = JobFinancialHelper.getRoundOff(
      value ?? 0,
      fractionDigits: percentageFraction,
      avoidZero: !allowZeroInput,
    );
    if (tempValue != controllerText) {
      return num.tryParse(controllerText);
    }
    return value;
  }

  String getRoundOff(num? price) => JobFinancialHelper.getRoundOff(
    num.tryParse(price.toString()) ?? 0,
    fractionDigits: percentageFraction,
    avoidZero: !allowZeroInput,
  );

  void setAmountOnPercentageChange(num result) {
    switch(type) {
      case WorksheetPercentAmountDialogType.overAllProfit:
        settings.overAllProfitAmount = result;
        break;
      case WorksheetPercentAmountDialogType.commission:
        settings.commissionAmount = result;
        break;
      case WorksheetPercentAmountDialogType.overhead:
        settings.overHeadAmount = result;
        break;
      case WorksheetPercentAmountDialogType.discount:
        settings.discountAmount = result;
      
      case WorksheetPercentAmountDialogType.cardFee:
        settings.cardFeeAmount = result;
        break;
      default:
        break;
    }
  }

  num getDiscount() {
    if(settings.applyDiscount ?? false){
      num total = (settings.subTotalAmount ?? 0) + (settings.overHeadAmount ?? 0) + (settings.overAllProfitAmount ?? 0) + (settings.lineItemProfitAmount ?? 0);
      return WorksheetCalculations.percentToAmount(settings.getDiscount, total, margin: !isProfitMarkup);
    }
    return 0;
  }
  
  /// [getTotal] gives the amount on which calculation is to be performed as per the type
  /// of [WorksheetPercentAmountDialogType]
  num getTotal() {
    num totalAmount = settings.subTotalAmount ?? 0;
    switch (type) {
      // In case of [WorksheetPercentAmountDialogType.commission] we need to add the
      // [overHeadAmount] and [overAllProfitAmount] to the sub total amount
      case WorksheetPercentAmountDialogType.commission:
        
        totalAmount += (settings.overHeadAmount ?? 0) + (settings.overAllProfitAmount ?? 0) + (settings.lineItemProfitAmount ?? 0) - (getDiscount());
        break;
      // In case of [WorksheetPercentAmountDialogType.cardFee] the total to be used should be
      // the [listTotal] instead of the [subTotal]
      case WorksheetPercentAmountDialogType.cardFee:
        totalAmount = (settings.listTotalAmount ?? 0);
        break;

      case WorksheetPercentAmountDialogType.overAllProfit:
      case WorksheetPercentAmountDialogType.lineItemProfit:
        totalAmount = settings.getPercentDialogueTotal;
        break;

      case WorksheetPercentAmountDialogType.discount:
        totalAmount += (settings.overHeadAmount ?? 0) + (settings.overAllProfitAmount ?? 0) + (settings.lineItemProfitAmount ?? 0);
        break;

      default:
        break;
    }
    return totalAmount;
  }

}