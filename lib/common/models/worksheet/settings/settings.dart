import 'package:jobprogress/common/models/worksheet/settings/trade_type_default.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class WorksheetSheetSetting {
  bool? enableSellingPrice;
  bool? descriptionOnly;
  bool? showQuantity;
  bool? showUnit;
  bool? showStyle;
  bool? showSize;
  bool? showColor;
  bool? showSupplier;
  bool? showTradeType;
  bool? showWorkType;
  bool? applyLineItemProfit;
  bool? applyProfit;
  bool? applyLineAndWorksheetProfit;
  bool? applyOverhead;
  bool? applyDiscount;
  bool? applyProcessingFee;
  bool? applyCommission;
  bool? addLineItemTax;
  bool? applyTaxAll;
  bool? applyTaxMaterial;
  bool? applyTaxLabor;
  bool? hidePricing;
  bool? hideTotal;
  bool? showCalculationSummary;
  bool? showTierTotal;
  bool? showTierSubTotals;
  bool? showTierColor;
  bool? showLineTotal;
  bool? hideCustomerInfo;
  bool? showTaxes;
  bool? showVariation;
  bool? showDiscount;
  bool? tradeTypeDefault;
  bool? includeCost;
  WorksheetTradeTypeDefault? tradeTypeDefaultDetails;

  WorksheetSheetSetting({
    this.enableSellingPrice,
    this.descriptionOnly,
    this.showQuantity,
    this.showUnit,
    this.showStyle,
    this.showSize,
    this.showColor,
    this.showSupplier,
    this.showTradeType,
    this.showWorkType,
    this.applyLineItemProfit,
    this.applyProfit,
    this.applyLineAndWorksheetProfit,
    this.applyOverhead,
    this.applyDiscount,
    this.applyProcessingFee,
    this.applyCommission,
    this.addLineItemTax,
    this.applyTaxAll,
    this.applyTaxMaterial,
    this.applyTaxLabor,
    this.hidePricing,
    this.hideTotal,
    this.showCalculationSummary,
    this.showTierTotal,
    this.showTierSubTotals,
    this.showLineTotal,
    this.showTierColor,
    this.hideCustomerInfo,
    this.showTaxes,
    this.showDiscount,
    this.showVariation,
  });

  void fromJson(Map<String, dynamic>? json) {
    enableSellingPrice = Helper.isTrue(json?['enable_selling_price']);
    descriptionOnly = Helper.isTrue(json?['description_only']);
    showQuantity = Helper.isTrue(json?['show_quantity']);
    showUnit = Helper.isTrue(json?['show_unit']);
    showStyle = Helper.isTrue(json?['show_style']);
    showSize = Helper.isTrue(json?['show_size']);
    showColor = Helper.isTrue(json?['show_color']);
    showSupplier = Helper.isTrue(json?['show_supplier']);
    showTradeType = Helper.isTrue(json?['show_trade_type']);
    showWorkType = Helper.isTrue(json?['show_work_type']);
    applyLineItemProfit = Helper.isTrue(json?['apply_line_item_profit']);
    applyProfit = Helper.isTrue(json?['apply_profit']);
    applyLineAndWorksheetProfit = Helper.isTrue(json?['enable_line_worksheet_profit']);
    if(applyLineAndWorksheetProfit ?? false) {
      applyLineItemProfit = applyProfit = true;
    }
    applyOverhead = Helper.isTrue(json?['apply_overhead']);
    applyDiscount = Helper.isTrue(json?['apply_discount']);
    applyProcessingFee = Helper.isTrue(json?['apply_processing_fee']);
    applyCommission = Helper.isTrue(json?['apply_commission']);
    addLineItemTax = Helper.isTrue(json?['add_line_item_tax']);
    applyTaxAll = Helper.isTrue(json?['apply_tax_all']);
    applyTaxMaterial = Helper.isTrue(json?['apply_tax_material']);
    applyTaxLabor = Helper.isTrue(json?['apply_tax_labor']);
    hidePricing = Helper.isTrue(json?['hide_pricing']);
    hideTotal = Helper.isTrue(json?['hide_total'] ?? true);
    showCalculationSummary = Helper.isTrue(json?['show_calculation_summary']);
    showTierTotal = Helper.isTrue(json?['show_tier_total']);
    showTierSubTotals = Helper.isTrue(json?['show_tier_sub_totals']);
    showLineTotal = Helper.isTrue(json?['show_line_total']);
    hideCustomerInfo = Helper.isTrue(json?['hide_customer_info']);
    showTierColor = Helper.isTrue(json?['show_tier_color'] ?? true);
    showTaxes = Helper.isTrue(json?['show_taxes']);
    showDiscount = Helper.isTrue(json?['show_discount']);
    showVariation = Helper.isTrue(json?['show_variation']);
    tradeTypeDefault = Helper.isTrue(json?['trade_type_default']);
    includeCost = Helper.isTrue(json?['include_cost']);
    if (AuthService.isStandardUser()) {
      if(!PermissionService.hasUserPermissions([PermissionConstants.viewUnitCost])) {
        enableSellingPrice = true;
      }
    }
  }

  /// [fromDefaultSettingsJson] - Parses the JSON object to initialize the `defaultSettings` property.
  void fromDefaultSettingsJson(Map<String, dynamic>? json) {
    if (Helper.isTrue(tradeTypeDefault)) {
      tradeTypeDefaultDetails = WorksheetTradeTypeDefault.fromJson(json?['trade_type_default']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable_selling_price'] = enableSellingPrice;
    data['description_only'] = descriptionOnly;
    data['show_quantity'] = showQuantity;
    data['show_unit'] = showUnit;
    data['show_style'] = showStyle;
    data['show_size'] = showSize;
    data['show_color'] = showColor;
    data['show_supplier'] = showSupplier;
    data['show_trade_type'] = showTradeType;
    data['show_work_type'] = showWorkType;
    data['apply_line_item_profit'] = applyLineItemProfit;
    data['apply_profit'] = applyProfit;
    data['enable_line_worksheet_profit'] = applyLineAndWorksheetProfit;
    data['apply_overhead'] = applyOverhead;
    data['apply_commission'] = applyCommission;
    data['add_line_item_tax'] = addLineItemTax;
    data['apply_tax_all'] = applyTaxAll;
    data['apply_tax_material'] = applyTaxMaterial;
    data['apply_tax_labor'] = applyTaxLabor;
    data['hide_pricing'] = hidePricing;
    data['hide_total'] = hideTotal;
    data['show_calculation_summary'] = showCalculationSummary;
    data['show_tier_total'] = showTierTotal;
    data['show_tier_sub_totals'] = showTierSubTotals;
    data['show_line_total'] = showLineTotal;
    data['show_taxes'] = showTaxes;
    data['show_discount'] = showDiscount;
    data['show_variation'] = showVariation;
    return data;
  }
}
