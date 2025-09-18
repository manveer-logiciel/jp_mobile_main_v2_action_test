
import 'package:jobprogress/common/models/srs_smart_template/branch_order_history_templates_model.dart';

import '../financial_product/financial_product_model.dart';

class SrsSmartTemplateModel {
  List<FinancialProductModel>? orderHistoryTemplates;
  List<BranchOrderHistoryTemplatesModel>? branchOrderHistroyTemplates;
  List<FinancialProductModel>? suggestedProducts;

  SrsSmartTemplateModel({this.orderHistoryTemplates, this.branchOrderHistroyTemplates, this.suggestedProducts});

  SrsSmartTemplateModel.fromJson(dynamic json) {
    if (json['order_history_templates'] != null) {
      orderHistoryTemplates = [];
      json['order_history_templates'].forEach((dynamic v) {
        orderHistoryTemplates?.add(FinancialProductModel.fromJson(v));
      });
    }
    if (json['branch_order_histroy_templates'] != null) {
      branchOrderHistroyTemplates = [];
      json['branch_order_histroy_templates'].forEach((dynamic v) {
        branchOrderHistroyTemplates?.add(BranchOrderHistoryTemplatesModel.fromJson(v));
      });
    }
    if (json['suggested_products'] != null) {
      suggestedProducts = [];
      json['suggested_products'].forEach((dynamic v) {
        suggestedProducts?.add(FinancialProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orderHistoryTemplates != null) {
      map['order_history_templates'] = orderHistoryTemplates?.map((v) => v.toJson()).toList();
    }
    if (branchOrderHistroyTemplates != null) {
      map['branch_order_histroy_templates'] = branchOrderHistroyTemplates?.map((v) => v.toJson()).toList();
    }
    if (suggestedProducts != null) {
      map['suggested_products'] = suggestedProducts?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}