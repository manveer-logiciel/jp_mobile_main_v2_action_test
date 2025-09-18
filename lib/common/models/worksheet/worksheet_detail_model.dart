import 'worksheet_detail_category_model.dart';

class WorksheetDetailModel {

  int? id;
  String? tier1;
  String? tier2;
  String? tier3;
  String? tier1Description;
  String? tier2Description;
  String? tier3Description;
  String? supplierId;
  int? order;
  String? quantity;
  String? productName;
  String? productId;
  String? unit;
  String? unitCost;
  String? sellingPrice;
  String? description;
  int? worksheetId;
  List<int?>? attachmentIds;
  String? invoiceNumber;
  String? chequeNumber;
  String? invoiceDate;
  String? actualUnitCost;
  int? actualQuantity;
  String? productCode;
  String? branchCode;
  String? style;
  String? size;
  String? color;
  String? acv;
  String? rcv;
  String? tax;
  String? depreciation;
  String? workTypeId;
  String? tradeId;
  String? formula;
  String? formulaUpdatedWithNewSlug;
  String? lineTax;
  String? lineProfit;
  String? customTaxId;
  String? qbTaxCodeId;
  String? tier1MeasurementId;
  String? tier2MeasurementId;
  String? tier3MeasurementId;
  String? abcAdditionalData;
  String? livePricing;
  WorksheetDetailCategoryModel? category;
  String? supplier;
  String? product;
  String? workType;
  String? trade;

  WorksheetDetailModel({
    this.id,
    this.tier1,
    this.tier2,
    this.tier3,
    this.tier1Description,
    this.tier2Description,
    this.tier3Description,
    this.supplierId,
    this.order,
    this.quantity,
    this.productName,
    this.productId,
    this.unit,
    this.unitCost,
    this.sellingPrice,
    this.description,
    this.worksheetId,
    this.attachmentIds,
    this.invoiceNumber,
    this.chequeNumber,
    this.invoiceDate,
    this.actualUnitCost,
    this.actualQuantity,
    this.productCode,
    this.branchCode,
    this.style,
    this.size,
    this.color,
    this.acv,
    this.rcv,
    this.tax,
    this.depreciation,
    this.workTypeId,
    this.tradeId,
    this.formula,
    this.formulaUpdatedWithNewSlug,
    this.lineTax,
    this.lineProfit,
    this.customTaxId,
    this.qbTaxCodeId,
    this.tier1MeasurementId,
    this.tier2MeasurementId,
    this.tier3MeasurementId,
    this.abcAdditionalData,
    this.livePricing,
    this.category,
    this.supplier,
    this.product,
    this.workType,
    this.trade,
  });

  WorksheetDetailModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    tier1 = json['tier1']?.toString();
    tier2 = json['tier2']?.toString();
    tier3 = json['tier3']?.toString();
    tier1Description = json['tier1_description']?.toString();
    tier2Description = json['tier2_description']?.toString();
    tier3Description = json['tier3_description']?.toString();
    supplierId = json['supplier_id']?.toString();
    order = int.tryParse(json['order']?.toString() ?? '');
    quantity = json['quantity']?.toString();
    productName = json['product_name']?.toString();
    productId = json['product_id']?.toString();
    unit = json['unit']?.toString();
    unitCost = json['unit_cost']?.toString();
    sellingPrice = json['selling_price']?.toString();
    description = json['description']?.toString();
    worksheetId = int.tryParse(json['worksheet_id']?.toString() ?? '');
    if(json['attachment_ids'] != null && (json['attachment_ids'] is List)) {
      attachmentIds = <int>[];
      json['attachment_ids'].forEach((dynamic v) {
        attachmentIds!.add(int.tryParse(v.toString()));
      });
    }
    invoiceNumber = json['invoice_number']?.toString();
    chequeNumber = json['cheque_number']?.toString();
    invoiceDate = json['invoice_date']?.toString();
    actualUnitCost = json['actual_unit_cost']?.toString();
    actualQuantity = int.tryParse(json['actual_quantity']?.toString() ?? '');
    productCode = json['product_code']?.toString();
    branchCode = json['branch_code']?.toString();
    style = json['style']?.toString();
    size = json['size']?.toString();
    color = json['color']?.toString();
    acv = json['acv']?.toString();
    rcv = json['rcv']?.toString();
    tax = json['tax']?.toString();
    depreciation = json['depreciation']?.toString();
    workTypeId = json['work_type_id']?.toString();
    tradeId = json['trade_id']?.toString();
    formula = json['formula']?.toString();
    formulaUpdatedWithNewSlug = json['formula_updated_with_new_slug']?.toString();
    lineTax = json['line_tax']?.toString();
    lineProfit = json['line_profit']?.toString();
    customTaxId = json['custom_tax_id']?.toString();
    qbTaxCodeId = json['qb_tax_code_id']?.toString();
    tier1MeasurementId = json['tier1_measurement_id']?.toString();
    tier2MeasurementId = json['tier2_measurement_id']?.toString();
    tier3MeasurementId = json['tier3_measurement_id']?.toString();
    abcAdditionalData = json['abc_additional_data']?.toString();
    livePricing = json['live_pricing']?.toString();
    category = (json['category'] != null && (json['category'] is Map)) ? WorksheetDetailCategoryModel.fromJson(json['category']) : null;
    supplier = json['supplier']?.toString();
    product = json['product']?.toString();
    workType = json['work_type']?.toString();
    trade = json['trade']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['tier1'] = tier1;
    data['tier2'] = tier2;
    data['tier3'] = tier3;
    data['tier1_description'] = tier1Description;
    data['tier2_description'] = tier2Description;
    data['tier3_description'] = tier3Description;
    data['supplier_id'] = supplierId;
    data['order'] = order;
    data['quantity'] = quantity;
    data['product_name'] = productName;
    data['product_id'] = productId;
    data['unit'] = unit;
    data['unit_cost'] = unitCost;
    data['selling_price'] = sellingPrice;
    data['description'] = description;
    data['worksheet_id'] = worksheetId;
    if (attachmentIds != null) {
      data['attachment_ids'] = <dynamic>[];
      for (var v in attachmentIds!) {
        data['attachment_ids'].add(v);
      }
    }
    data['invoice_number'] = invoiceNumber;
    data['cheque_number'] = chequeNumber;
    data['invoice_date'] = invoiceDate;
    data['actual_unit_cost'] = actualUnitCost;
    data['actual_quantity'] = actualQuantity;
    data['product_code'] = productCode;
    data['branch_code'] = branchCode;
    data['style'] = style;
    data['size'] = size;
    data['color'] = color;
    data['acv'] = acv;
    data['rcv'] = rcv;
    data['tax'] = tax;
    data['depreciation'] = depreciation;
    data['work_type_id'] = workTypeId;
    data['trade_id'] = tradeId;
    data['formula'] = formula;
    data['formula_updated_with_new_slug'] = formulaUpdatedWithNewSlug;
    data['line_tax'] = lineTax;
    data['line_profit'] = lineProfit;
    data['custom_tax_id'] = customTaxId;
    data['qb_tax_code_id'] = qbTaxCodeId;
    data['tier1_measurement_id'] = tier1MeasurementId;
    data['tier2_measurement_id'] = tier2MeasurementId;
    data['tier3_measurement_id'] = tier3MeasurementId;
    data['abc_additional_data'] = abcAdditionalData;
    data['live_pricing'] = livePricing;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['supplier'] = supplier;
    data['product'] = product;
    data['work_type'] = workType;
    data['trade'] = trade;
    return data;
  }
}