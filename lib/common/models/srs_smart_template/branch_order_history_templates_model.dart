
import '../financial_product/financial_product_model.dart';

class BranchOrderHistoryTemplatesModel {
  int? templateNumber;
  String? templateName;
  List<FinancialProductModel>? templateProducts;

  BranchOrderHistoryTemplatesModel({
      this.templateNumber, 
      this.templateName, 
      this.templateProducts,});

  BranchOrderHistoryTemplatesModel.fromJson(dynamic json) {
    templateNumber = json['template_number'];
    templateName = json['template_name'];
    if (json['template_products'] != null) {
      templateProducts = [];
      templateProducts = json['template_products']
          .map<FinancialProductModel>((dynamic map) => FinancialProductModel.fromJson(map)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['template_number'] = templateNumber;
    map['template_name'] = templateName;
    if (templateProducts != null) {
      map['template_products'] = templateProducts?.map((FinancialProductModel model) => model.toJson()).toList();
    }
    return map;
  }
}