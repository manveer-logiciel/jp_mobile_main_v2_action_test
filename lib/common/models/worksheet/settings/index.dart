import 'package:jobprogress/common/models/worksheet/settings/settings.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import 'default_percentage.dart';

class WorksheetSettingModel extends WorksheetSheetSetting with WorksheetDefaultPercentage {

  bool hasMaterialItem = false;
  bool hasLaborItem = false;
  bool hasNoChargeItem = false;
  late bool hasTier;
  late bool isQbWorksheet;
  late bool isMaterialWorkSheet;
  late bool isWorkOrderSheet;
  late bool hasSupplierIdAsSRSId;
  bool? isOverAllProfitMarkup;
  bool? isLineItemProfitMarkup;
  num? lineItemTaxPercent;
  num? lineItemProfitPercent;
  num? lineItemProfitAmount;
  num? lineItemTempProfitPercent;
  num? overAllProfitPercent;
  num? overAllProfitAmount;
  num? commissionPercent;
  num? discountPercent;
  num? discountAmount;
  num? creditCardFeePercent;
  num? commissionAmount;
  num? subTotalAmount;
  num? listTotalAmount;
  num? laborTaxRate;
  num? materialTaxRate;
  num? taxRate;
  num? overriddenLaborTaxRate;
  num? overriddenMaterialTaxRate;
  num? overriddenTaxRate;
  num? overHeadRate;
  num? overriddenOverHeadRate;
  num? overHeadAmount;
  num? cardFeeAmount;
  num? revisedTaxAll;
  num? revisedMaterialTax;
  num? revisedLaborTax;
  String? selectedTaxRateId;
  String? selectedMaterialTaxRateId;
  String? selectedLaborTaxRateId;
  bool? isRevisedTaxApplied;
  bool? isRevisedMaterialTaxApplied;
  bool? isRevisedLaborTaxApplied;
  bool? profitLossAmount;
  num? fixedPriceAmount;
  bool? isEstimateOrProposalWorksheet;

  num get getMaterialTaxRate => appliedRevisedMaterialTax ?? overriddenMaterialTaxRate ?? materialTaxRate ?? 0;
  num get getLaborTaxRate => appliedRevisedLaborTax ?? overriddenLaborTaxRate ?? laborTaxRate ?? 0;
  num get getTaxAllRate => appliedRevisedTax ?? overriddenTaxRate ?? taxRate ?? 0;
  num get getOverHeadRate => overriddenOverHeadRate ?? overHeadRate ?? 0;
  num? get getOverAllProfitRate => overAllProfitPercent ?? (getIsOverAllProfitMarkup ? num.tryParse(markup ?? "") : num.tryParse(margin ?? "")) ?? 0;
  num? get getLineItemProfitRate => lineItemProfitPercent ?? lineItemTempProfitPercent ?? (getIsLineItemProfitMarkup ? num.tryParse(markup ?? "") : num.tryParse(margin ?? "")) ?? 0;
  num get getCommissionRate => commissionPercent ?? defaultCommission?.rate ?? 0;
  num get getDiscount => discountPercent ?? defaultDiscount?.discount ?? 0;
  num get getCardFeeRate => creditCardFeePercent ?? defaultFeeRate?.rate ?? 0;
  num get getLineItemTaxRate => lineItemTaxPercent ?? 0;

  bool get isOverAllTaxSelected => (applyTaxMaterial! && hasMaterialItem) || (applyTaxLabor! && hasLaborItem) || applyTaxAll!;

  bool get getIsOverAllProfitMarkup => isOverAllProfitMarkup ?? isMarkup;
  bool get getIsLineItemProfitMarkup => isLineItemProfitMarkup ?? isMarkup;

  num? get appliedRevisedTax => getRevisedRate(revisedTaxAll, isApplied: isRevisedTaxApplied);
  num? get appliedRevisedMaterialTax => getRevisedRate(revisedMaterialTax, isApplied: isRevisedMaterialTaxApplied);
  num? get appliedRevisedLaborTax => getRevisedRate(revisedLaborTax, isApplied: isRevisedLaborTaxApplied);

  bool get canShowTierSubTotals => Helper.isTrue(applyLineItemProfit) || Helper.isTrue(addLineItemTax);

  num get getPercentDialogueTotal => (applyLineAndWorksheetProfit ?? false)
      ? (subTotalAmount ?? 0) + (lineItemProfitAmount ?? 0)
      : subTotalAmount ?? 0;

  /// These getters help in deciding which calculation results is to be displayed
  /// [showTaxOnly] - helps in displaying only tax section
  /// [showTotalOnly] - helps in displaying only total section
  /// [showTaxOrTotal] - helps in displaying tax and total section
  /// [showEntireSummary] - helps in displaying all the calculation results
  bool get isAnyTaxApplied => applyTaxMaterial! || applyTaxLabor! || applyTaxAll! || addLineItemTax!;
  bool get showTaxOnly => (showTaxes ?? false) && (isAnyTaxApplied);
  bool get showTotalOnly => !(hideTotal ?? false);
  bool get showEntireSummary => !(hidePricing ?? false) || (showCalculationSummary ?? false);
  bool get showTaxOrTotalOrDiscount => showTotalOnly || showTaxOnly || (showDiscount ?? false);
  bool get showProcessingFee => showEntireSummary && (applyProcessingFee ?? false);

  bool isFixedPrice = false;
  bool isSRSEnable = false;
  bool isBeaconEnable = false;

  WorksheetSettingModel({
    this.hasMaterialItem = false,
    this.hasLaborItem = false,
    this.hasTier = false,
    this.lineItemTaxPercent = 0,
    this.lineItemProfitAmount = 0,
    this.overAllProfitPercent = 0,
    this.overAllProfitAmount = 0,
    this.commissionPercent = 0,
    this.commissionAmount = 0,
    this.subTotalAmount = 0,
    this.listTotalAmount = 0,
    this.isOverAllProfitMarkup = false,
    this.isLineItemProfitMarkup = false,
    this.isQbWorksheet = false,
    this.isMaterialWorkSheet = false,
    this.hasSupplierIdAsSRSId = false,
    this.isSRSEnable = false,
    this.isBeaconEnable = false,
    this.isEstimateOrProposalWorksheet = false
  });

  WorksheetSettingModel.fromJson(Map<String, dynamic> json) {
    isQbWorksheet = false;
    hasSupplierIdAsSRSId = false;
    isWorkOrderSheet = false;
    isMaterialWorkSheet = json['is_material_work_sheet'] ?? false;
    isFixedPrice = json['is_fixed_price'] ?? false;
    fixedPriceAmount ??= num.tryParse((json['fixed_price_amount'] ?? ['fixed_price']).toString());
    super.fromJson(json['settings']);
    super.fromDefaultSettingsJson(json['default_settings']);
    super.fromDefaultJson(json['default_percentage'] ?? {});
  }

  void fromWorksheetJson(Map<String, dynamic> json, WorksheetModel? worksheet) {

    if (worksheet == null) return;

    isQbWorksheet = false;
    hasSupplierIdAsSRSId = false;
    super.fromJson(json);
    overriddenMaterialTaxRate = num.tryParse(worksheet.materialTaxRate.toString());
    applyTaxMaterial = overriddenMaterialTaxRate != null;
    overriddenLaborTaxRate = num.tryParse(worksheet.laborTaxRate.toString());
    applyTaxLabor = overriddenLaborTaxRate != null;
    overriddenTaxRate = num.tryParse(worksheet.taxRate.toString());
    applyTaxAll = overriddenTaxRate != null;
    addLineItemTax = Helper.isTrue(worksheet.lineTax);
    overriddenOverHeadRate = num.tryParse(worksheet.overhead.toString());
    applyOverhead = overriddenOverHeadRate != null && overriddenOverHeadRate! >= 0;
    overAllProfitPercent = num.tryParse(worksheet.profit.toString());
    applyProfit = overAllProfitPercent != null && overAllProfitPercent! >= 0;
    isOverAllProfitMarkup = !Helper.isTrue(worksheet.margin);
    applyLineItemProfit = Helper.isTrue(worksheet.lineMarginMarkup);
    isLineItemProfitMarkup = !Helper.isTrue(worksheet.margin);
    if(worksheet.isEnableLineAndWorksheetProfit ?? false) {
      isOverAllProfitMarkup = !Helper.isTrue(worksheet.projectedProfitMargin);
      applyLineAndWorksheetProfit = Helper.isTrue(worksheet.isEnableLineAndWorksheetProfit);
    }
    commissionPercent = num.tryParse(worksheet.commission.toString());
    discountPercent = num.tryParse(worksheet.discount.toString());
    applyDiscount = discountPercent != null && discountPercent! >= 0;
    applyCommission = commissionPercent != null;
    // Setting up card fee coming from the worksheet. Also marking it as enabled
    // when credit card fee is present
    creditCardFeePercent = num.tryParse(worksheet.processingFee.toString());
    applyProcessingFee = creditCardFeePercent != null;
    enableSellingPrice = Helper.isTrue(worksheet.isEnableSellingPrice);
    selectedTaxRateId = worksheet.customTaxId;
    selectedLaborTaxRateId = worksheet.laborCustomTaxId;
    selectedMaterialTaxRateId = worksheet.materialCustomTaxId;
    isFixedPrice = worksheet.fixedPrice != null;
    if (isFixedPrice) setFixedPrice(num.parse(worksheet.fixedPrice!));
    // Manually hiding total for work-order and material-list as total alone
    // can't be displayed in these worksheets
    bool isWorkOrderOrMaterial = worksheet.type == WorksheetConstants.workOrder
        || worksheet.type == WorksheetConstants.materialList;
    if (isWorkOrderOrMaterial) hideTotal = true;
    // In case line item profit and line item tax is not applied
    // tier subtotal settings should not be displayed
    if (!canShowTierSubTotals) showTierSubTotals = false;
  }

  void checkForRevisedTax() {
    bool reviseMaterialTax = doApplyRevisedTax(overriddenMaterialTaxRate, materialTaxRate, isApplied: applyTaxMaterial);
    if (reviseMaterialTax) revisedMaterialTax = materialTaxRate;
    bool reviseLaborTax = doApplyRevisedTax(overriddenLaborTaxRate, laborTaxRate, isApplied: applyTaxLabor);
    if (reviseLaborTax) revisedLaborTax = laborTaxRate;
    bool reviseTaxAll = doApplyRevisedTax(overriddenTaxRate, taxRate, isApplied: applyTaxAll);
    if (reviseTaxAll) revisedTaxAll = taxRate;
  }

  bool doApplyRevisedTax(num? oldTax, num? newTax, {
    bool? isApplied
  }) {
    if (isApplied ?? false) {
      return oldTax != newTax;
    }
    return false;
  }

  num? getRevisedRate(num? rate, {bool? isApplied}) {
    return isApplied ?? false ? rate : null;
  }

  void setFixedPrice(num tempFixedPrice) {
    fixedPriceAmount = tempFixedPrice + (fixedPriceAmount ?? 0);
    isFixedPrice = fixedPriceAmount! > 0;
    if (isFixedPrice) {
      lineItemProfitPercent = null;
      lineItemTempProfitPercent = null;
      isLineItemProfitMarkup = null;
      overAllProfitAmount = overAllProfitPercent = null;
      isOverAllProfitMarkup = null;
      applyProfit = false;
      applyLineItemProfit = false;
      applyLineAndWorksheetProfit = false;
    }
  }

  Map<String, dynamic> toAutoSavedResourceJson() {
    Map<String, dynamic> data = {};
    data['is_material_work_sheet'] = isMaterialWorkSheet;
    data['is_fixed_price'] = isFixedPrice;
    data['fixed_price_amount'] = fixedPriceAmount;
    data['settings'] = super.toJson();
    data['default_percentage'] = super.toDefaultJson();
    return data;
  }
}
