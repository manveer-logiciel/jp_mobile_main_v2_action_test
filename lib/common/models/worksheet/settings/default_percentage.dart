import 'applied_percentage.dart';

mixin class WorksheetDefaultPercentage {

  late bool isMarkup;
  String? markup;
  String? margin;
  String? type;
  WorksheetAppliedPercentage? defaultCommission;
  WorksheetAppliedPercentage? defaultTaxAll;
  WorksheetAppliedPercentage? defaultTaxMaterial;
  WorksheetAppliedPercentage? defaultTaxLabor;
  WorksheetAppliedPercentage? defaultLineItemTax;
  WorksheetAppliedPercentage? defaultDiscount;
  WorksheetAppliedPercentage? defaultFeeRate;

  void fromDefaultJson(Map<String, dynamic> json) {
    markup = json['markup']?.toString();
    margin = json['margin']?.toString();
    type = json['type'];
    isMarkup = type == 'markup';
    defaultCommission = json['apply_commission'] != null
        ? WorksheetAppliedPercentage.fromJson(json['apply_commission'])
        : null;
    defaultTaxAll = json['apply_tax_all'] != null
        ? WorksheetAppliedPercentage.fromJson(json['apply_tax_all'])
        : null;
    defaultTaxMaterial = json['apply_tax_material'] != null
        ? WorksheetAppliedPercentage.fromJson(json['apply_tax_material'])
        : null;
    defaultTaxLabor = json['apply_tax_labor'] != null
        ? WorksheetAppliedPercentage.fromJson(json['apply_tax_labor'])
        : null;
    defaultLineItemTax = json['add_line_item_tax'] != null
        ? WorksheetAppliedPercentage.fromJson(json['add_line_item_tax'])
        : null;
    defaultDiscount = json['apply_discount'] is Map
        ? WorksheetAppliedPercentage.fromJson(json['apply_discount']):
        null;
    // Parsing default card fee only if it has valid json data
    defaultFeeRate = json['apply_processing_fee'] is Map
        ? WorksheetAppliedPercentage.fromJson(json['apply_processing_fee'])
        : null;
  }

  Map<String, dynamic> toDefaultJson() {
    Map<String, dynamic> data = {};
    data['markup'] = markup;
    data['margin'] = margin;
    data['type'] = type;
    data['apply_commission'] = defaultCommission?.toJson();
    data['apply_processing_fee'] = defaultFeeRate?.toJson();
    data['apply_tax_all'] = defaultTaxAll?.toJson();
    data['apply_tax_material'] = defaultTaxMaterial?.toJson();
    data['apply_tax_labor'] = defaultTaxLabor?.toJson();
    data['add_line_item_tax'] = defaultLineItemTax?.toJson();
    data['apply_discount'] = defaultDiscount?.toJson();
    return data;
  }
}
