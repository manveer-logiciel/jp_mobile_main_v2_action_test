import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/models/sql/work_type/work_type.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/amounts.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/models/macros/macro_category.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../enums/sheet_line_item_type.dart';
import '../../services/worksheet/helpers.dart';
import '../financial_product/variants_model.dart';
import 'measurement_formula_model.dart';
import '../../../core/constants/financial_constants.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';

class SheetLineItemModel {
  String? name;
  String? description;
  MacroCategoryModel? macrosCategory;
  int? currentIndex;
  int? id;
  String? productId;
  String? title;
  String? price;
  String? totalPrice;
  /// [tiersLineTotal] is used to hold up the total cost of the line item
  /// of the tiers excluding the profit. It is local used in calculations for
  /// storing the result so it needs not to be re-calculated everytime
  String? tiersLineTotal;
  String? qty;
  String? actualQty;
  String? categoryName;
  String? actualUnitCost;
  int? actualQuantity;
  bool? isTaxable;
  String? productCode;
  String? unit;
  String? tax;
  String? depreciation;
  JPSingleSelectModel? accountingHeadModel;
  String? rcv;
  String? formula;
  WorksheetDetailCategoryModel? category;
  List<MeasurementFormulaModel>? measurementFormulas;
  AddLineItemFormType? pageType;
  JPSingleSelectModel? tradeType;
  JPSingleSelectModel? workType;
  int? changeOrderId;
  int? tradeId;
  int? workTypeId;
  bool? isChargeable;
  String? productCategorySlug;
  String? tier1;
  String? tier2;
  String? tier3;
  String? tier1Description;
  String? tier2Description;
  String? tier3Description;
  String? supplierId;
  SuppliersModel? supplier;
  int? order;
  String? productName;
  String? unitCost;
  int? worksheetId;
  List<int?>? attachmentIds;
  String? invoiceNumber;
  String? chequeNumber;
  String? invoiceDate;
  String? branchCode;
  String? style;
  String? size;
  String? color;
  String? acv;
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
  FinancialProductModel? product;
  TradeTypeModel? trade;
  WorkTypeModel? workTypeModel;
  String? type;
  int? tier;
  bool? tierCollapse;
  String? tierDescription;
  int? tierMeasurementId;
  String? tierName;
  String? lineAmount;
  String? lineTotalAmount;
  String? taxAmount;
  String? quantity;
  String? sellingPrice;
  String? profitAmount;
  int? total;
  String? lineTaxAmt;
  int? roundedLineTax;
  String? lineProfitAmt;
  int? roundedLineProfit;
  num? lineItemTotal;
  int? categoryId;
  int? systemCategoryId;
  List<SheetLineItemModel>? subTiers;
  List<SheetLineItemModel>? subItems;
  MeasurementModel? tierMeasurement;
  WorksheetSettingModel? workSheetSettings;
  SheetLineItemModel? parent;
  bool? isFixedPriceItem;
  bool? isTierExpanded;
  bool? showSellingPrice; // For displaying selling price in line item (rn only used in macros)
  bool? canShowName;
  VariantModel? variantModel;  // holds the line item's selected variant
  // holds all the list of variants, Its required because actual variant comes with limited
  // data i.e., name & code only. So to extract all the details of a variant we need
  // list of variants having all the details
  List<VariantModel>? variants;
  // is a comma separated string of variant names
  String? variantsString;
  String? note;
  /// [isMacroNotFound] helps in highlighting individual tier in case of macro not found
  bool? isMacroNotFound;
  /// [emptyTier] helps in saving the empty tier on that misses macro ID
  bool? emptyTier;
  /// [isConfirmedVariation] is used to check if the variation is confirmed or not
  bool? isConfirmedVariation;
  /// [isConfirmedVariationRequired] is used to check if the variation confirmation is required or not
  bool? isConfirmedVariationRequired;

  SheetLineItemModel({
    this.pageType,
    this.currentIndex,
    required this.productId,
    this.actualUnitCost,
    this.actualQuantity,
    this.name,
    required this.title,
    required this.price,
    required this.qty,
    required this.totalPrice,
    this.depreciation,
    this.id,
    this.tax,
    this.actualQty,
    this.isTaxable,
    this.tradeType,
    this.workType,
    this.productCode,
    this.unit,
    this.rcv,
    this.category,
    this.accountingHeadModel,
    this.measurementFormulas,
    this.formula,
    this.productCategorySlug,
    this.changeOrderId,
    this.tradeId,
    this.workTypeId,
    this.isChargeable,
    this.tier1,
    this.tier2,
    this.tier3,
    this.tier1Description,
    this.tier2Description,
    this.tier3Description,
    this.supplierId,
    this.supplier,
    this.order,
    this.productName,
    this.unitCost,
    this.description,
    this.worksheetId,
    this.attachmentIds,
    this.invoiceNumber,
    this.chequeNumber,
    this.invoiceDate,
    this.branchCode,
    this.style,
    this.size,
    this.color,
    this.acv,
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
    this.product,
    this.trade,
    this.type,
    this.tier,
    this.tierCollapse,
    this.tierDescription,
    this.tierMeasurementId,
    this.tierName,
    this.lineAmount,
    this.lineTotalAmount,
    this.subTiers,
    this.taxAmount,
    this.profitAmount,
    this.isTierExpanded = true,
    this.workSheetSettings,
    this.lineTaxAmt,
    this.lineProfitAmt,
    this.lineItemTotal,
    this.systemCategoryId,
    this.canShowName = false,
    this.variantModel,
    this.variants,
    this.note,
    this.sellingPrice,
    this.isMacroNotFound,
    this.emptyTier,
    this.isConfirmedVariation,
    this.isConfirmedVariationRequired
  });

  SheetLineItemModel.tier({
    required this.title,
    required this.totalPrice,
    required this.tier,
    required this.workSheetSettings,
    this.description = "",
    this.subItems,
    this.parent
  }) {
    productId = "";
    price = "";
    qty = "";
    type = WorksheetConstants.collection;
    isTierExpanded = true;
  }

  String? get productSlug => product?.productCategory?.slug;

  /// [emptyTierItem] - used to save empty tier with empty data
  SheetLineItemModel get emptyTierItem => SheetLineItemModel(
    productId: '',
    title: '',
    price: '',
    qty: '',
    totalPrice: '',
    unit: '0',
    unitCost: '',
    workSheetSettings: WorksheetSettingModel.fromJson({}),
    emptyTier: true,
    product: FinancialProductModel(
      id: 0,
      categoryId: 0,
    ),
  );

  SheetLineItemModel.empty();

  SheetLineItemModel.fromEstimateJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    sellingPrice = json['selling_price']?.toString();
    macrosCategory = json['category'] != null ? MacroCategoryModel.fromJson(json['category']) : null;
    qty = json['quantity'];
    productId = json['product_id'].toString();
    productCode = json['code']?.toString() ?? json['product_code']?.toString();
    title = json['description'] ?? '';
    if(json['quantity'] != null) {
      qty = JobFinancialHelper.removeDecimalZeroFormat(double.parse(json['quantity']));
    }
    price = json['unit_cost'];
    unit = json['unit'];
    tax = json['tax'] ?? '';
    depreciation = json['depreciation'] ?? '';
    totalPrice = json['acv'] ?? ((double.tryParse(qty ?? "") ?? 0) * (double.tryParse(price ?? "") ?? 0)).toString();
    rcv = json['rcv'];
    if(json["trade"] != null) {
      tradeType = JPSingleSelectModel(
          id: json["trade"]?["id"]?.toString() ?? "",
          label: json["trade"]?["name"] ?? ""
      );
    }
    if ( json['product']?['measurement_formulas'] != null) {
      measurementFormulas = [];
      json['product']['measurement_formulas'].forEach((dynamic measurementFormula) {
        measurementFormulas?.add(MeasurementFormulaModel.fromJson(measurementFormula));
      });
    }
    if (json['measurement_formulas']?['data'] != null) {
      measurementFormulas = [];
      json['measurement_formulas']['data'].forEach((dynamic measurementFormula) {
        measurementFormulas?.add(MeasurementFormulaModel.fromJson(measurementFormula));
      });
    }
    supplierId = json["supplier_id"]?.toString();
    branchCode = json["branch_code"]?.toString();
    if(json['financial_product_detail'] is Map) {
      // adding variants to product
      json['financial_product_detail']['variants'] = json['variants'];
      product = FinancialProductModel.fromJson(json['financial_product_detail']);
    }
    setVariant(json);
  }

  SheetLineItemModel.fromInsurancePdfJson(Map<String, dynamic> json) {
    title = Helper.removeSrNoFromDescription(json['description']);
    qty = json['quantity']?.toString() ?? '';
    unit = json['unit']?.toString() ?? '';
    price = json['price']?.toString() ?? '';
    tax = json['tax']?.toString() ?? '';
    rcv = json['rcv']?.toString().replaceAll(",", "");
    depreciation = json['depreciation']?.toString() ?? '';
    productId = '';
    totalPrice = '';
  }

  SheetLineItemModel.fromChangeOrderJson(Map<String, dynamic> json) {
    title = json['description'] ?? '';
    productId = json['product_id']?.toString() ?? '';
    changeOrderId = int.tryParse(json['change_order_id']?.toString() ?? '');
    title = json['description']?.toString() ?? "";
    qty = JobFinancialHelper.removeDecimalZeroFormat(double.tryParse(json['quantity'].toString()) ?? 0);
    price = JobFinancialHelper.removeDecimalZeroFormat(double.tryParse(json['amount'].toString()) ?? 0);
    totalPrice = ((double.tryParse(price ?? "") ?? 0) * (double.tryParse(qty ?? "") ?? 0)).toString();
    productId = json['product_id']?.toString() ?? "";
    tradeId = int.tryParse(json['trade_id']?.toString() ?? '');
    workTypeId = int.tryParse(json['work_type_id']?.toString() ?? '');
    isChargeable = Helper.isTrue(json['is_chargeable']);
    productCategorySlug = isChargeable ?? true ? "" : FinancialConstant.noCharge;
    isTaxable = Helper.isTrue(json['is_taxable']);
    if(json["trade"] != null) {
      tradeType = JPSingleSelectModel(
          id: json["trade"]?["id"]?.toString() ?? "",
          label: json["trade"]?["name"] ?? ""
      );
    }
    if(json["work_type"]?["id"] != null && json["work_type"]?["id"]?.toString() != "-1") {
      workType = JPSingleSelectModel(
          id: json["work_type"]?["id"]?.toString() ?? "",
          label: json["work_type"]?["name"] ?? "",
          color: ColorHelper.getHexColor(json["work_type"]?["color"] ?? "")
      );
    }
    supplierId = json["supplier_id"]?.toString();
    branchCode = json["branch_code"]?.toString();
  }

  SheetLineItemModel.fromJson(Map<String, dynamic> json) {
    title = json['description'] ?? '';
    productId = json['financial_account']?['id'].toString() ?? '';
    price = json['rate'];
    qty = JobFinancialHelper.removeDecimalZeroFormat(double.parse(json['quantity']));
    totalPrice = ((double.tryParse(price ?? "") ?? 0) * (double.tryParse(qty ?? "") ?? 0)).toString();
    accountingHeadModel = JPSingleSelectModel(
      label: json['financial_account']?['name'].toString() ?? '',
      id: json['financial_account']?['id'].toString() ?? '',
      subLabel: json['financial_account']?['account_sub_type'].toString() ?? '',
    );
    supplierId = json["supplier_id"]?.toString();
    branchCode = json["branch_code"]?.toString();
    tradeId = json["trade_id"];
    workTypeId = json["work_type_id"];
    setVariant(json);
  }

  SheetLineItemModel.fromFileListingJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    title = (json['product_name']?.toString() ?? "") + ((json["description"]?.toString() ?? "").isNotEmpty
        ? " - ${json["description"]?.toString() ?? ""}" : "");
    qty = JobFinancialHelper.removeDecimalZeroFormat(double.parse(json['quantity']?.toString() ?? ""));
    category = (json['category'] != null && (json['category'] is Map)) ? WorksheetDetailCategoryModel.fromJson(json['category']) : null;
    productId = json['product_id'].toString();
    unit = json['unit']?.toString();
    price = json['unit_cost']?.toString();
    unitCost = json['unit_cost']?.toString();
    sellingPrice = json['selling_price']?.toString();
    actualUnitCost = json['actual_unit_cost']?.toString();
    actualQuantity = int.tryParse(json['actual_quantity']?.toString() ?? '');
    productCode = json['product_code']?.toString();
    rcv = json['rcv']?.toString();
    tax = json['tax']?.toString();
    depreciation = json['depreciation']?.toString();
    category = (json['category'] != null && (json['category'] is Map)) ? WorksheetDetailCategoryModel.fromJson(json['category']) : null;
    supplierId = json["supplier_id"]?.toString();
    branchCode = json["branch_code"]?.toString();
    tradeId = int.tryParse(json['trade_id']?.toString() ?? '');
    workTypeId = int.tryParse(json['work_type_id']?.toString() ?? '');
    isChargeable = category?.slug != FinancialConstant.noCharge;
  }

  SheetLineItemModel.fromWorkSheetJson(Map<String, dynamic> json) {
    id = json['id'];
    tier = json['tier'];
    name = json['name'];
    tierCollapse = Helper.isTrue(json['tier_collapse']);
    tierDescription = json['tier_description'];
    tierMeasurementId = json['tier_measurement_id'];
    tierName = json['tier_name'];
    type = json['type'];
    tier1 = json['tier1'];
    tier2 = json['tier2'];
    tier3 = json['tier3'];
    tier1Description = json['tier1_description'];
    tier2Description = json['tier2_description'];
    tier3Description = json['tier3_description'];
    supplierId = json['supplier_id']?.toString();
    quantity = WorksheetCalculations.convertToFixedNum(num.tryParse(json['quantity'].toString()) ?? 0).toString();
    productName = json['product_name'] ?? "";
    productId = json['product_id']?.toString() ?? "";
    unit = json['unit'];
    unitCost = json['unit_cost'].toString();
    sellingPrice = json['selling_price']?.toString();
    description = json['description'] ?? tierDescription;
    note = json['note'];
    worksheetId = json['worksheet_id'];
    invoiceNumber = json['invoice_number']?.toString();
    chequeNumber = json['cheque_number']?.toString();
    invoiceDate = json['invoice_date']?.toString();
    actualUnitCost = json['actual_unit_cost']?.toString();
    actualQuantity = int.tryParse(json['actual_quantity'].toString());
    productCode = json['code']?.toString() ?? json['product_code']?.toString();
    product = FinancialProductModel(productCategory: WorksheetDetailCategoryModel(slug: json['product_slug'])) ;
    branchCode = json['branch_code']?.toString();
    style = json['style']?.toString();
    size = json['size']?.toString();
    color = json['color']?.toString();
    acv = json['acv']?.toString();
    rcv = json['rcv']?.toString();
    tax = json['tax']?.toString();
    depreciation = json['depreciation']?.toString();
    workTypeId = json['work_type_id'];
    tradeId = json['trade_id'];
    formulaUpdatedWithNewSlug = json['formula_updated_with_new_slug']?.toString();
    lineTax = json['line_tax']?.toString();
    lineProfit = json['line_profit']?.toString();
    tier1MeasurementId = json['tier1_measurement_id']?.toString();
    tier2MeasurementId = json['tier2_measurement_id']?.toString();
    tier3MeasurementId = json['tier3_measurement_id']?.toString();
    lineAmount = json['line_amount']?.toString();
    taxAmount = json['tax_amount']?.toString();
    profitAmount = json['profit_amount']?.toString();
    lineTotalAmount = json['line_total_amount']?.toString();
    abcAdditionalData = json['abc_additional_data']?.toString();
    livePricing = json['live_pricing'].toString();
    supplier = json['supplier'] is Map ? SuppliersModel.fromJson(json['supplier']) : null;
    if(json['product'] is Map) {
      // adding variants to product
      json['product']['variants'] = json['variants'];
      product = FinancialProductModel.fromJson(json['product']);
    }
    total = int.tryParse(json['total'].toString());
    lineTaxAmt = json['line_tax_amt']?.toString();
    roundedLineTax = json['rounded_line_tax'];
    lineProfitAmt = json['line_profit_amt']?.toString();
    roundedLineProfit = json['rounded_line_profit'];
    lineItemTotal = json['line_item_total'];
    title = tierName ?? name ?? productName ?? "";
    totalPrice = lineTotalAmount ?? "";
    price = sellingPrice ?? "";
    qty = JobFinancialHelper.removeDecimalZeroFormat(quantity ?? "");
    category = (json['category'] is Map) ? WorksheetDetailCategoryModel.fromJson(json['category']) : null;
    product ??= FinancialProductModel.fromJson(json);
    product?.productCategory = category;
    product?.unitCost = unitCost;
    if (!Helper.isValueNullOrEmpty(json['financial_product_detail']?['selling_price'])) {
      sellingPrice = json['financial_product_detail']?['selling_price'].toString();
    }
    product?.sellingPrice = sellingPrice;
    product?.isSellingPriceNotAvailable = Helper.isValueNullOrEmpty(sellingPrice);
    product?.notAvailable = json['is_product_available'] ?? false;
    product?.notAvailableInPriceList = json['is_product_price_list_available'] ?? false;
    if(!Helper.isValueNullOrEmpty(productCode)) {
      product?.code = productCode;
    }
    // Adding branch code and id to product, if it's missing as branch code and id is responsible for extracting
    // product variants and without these list of variants will be empty
    product?.id = int.tryParse(productId.toString());
    product?.branchCode ??= json['branch_code'];
    // adding variants to product
    setVariant(json);
    tierMeasurement = json['tier_measurement'] is Map ? MeasurementModel.fromJson(json['tier_measurement']) : null;

    if(json['styles'] is List) {
      product?.styles = [];
      for (var style in (json['styles'] as List)) {
        product?.styles?.add(style);
      }
    }

    if(json['sizes'] is List) {
      product?.sizes = [];
      for (var size in (json['sizes'] as List)) {
        product?.sizes?.add(size);
      }
    }

    if(json['colors'] is List) {
      product?.colors = [];
      for (var color in (json['colors'] as List)) {
        product?.colors?.add(color);
      }
    }

    if(json['units'] is List) {
      product?.units = [];
      for (var unit in (json['units'] as List)) {
        product?.units?.add(unit);
      }
    }

    categoryId = category?.id;
    systemCategoryId = category?.systemCategory?.id;
    categoryName = category?.name;
    isTierExpanded = true;
    if(json['trade'] is Map && !Helper.isValueNullOrEmpty(json['trade']["id"])) {
      trade = TradeTypeModel.fromJson(json['trade']);
    }
    if (trade != null) {
      tradeType = JPSingleSelectModel(label: trade!.name, id: trade!.id.toString());
    }
    if(json['work_type'] is Map && !Helper.isValueNullOrEmpty(json['work_type']["id"])) {
      workTypeModel = WorkTypeModel.fromJson(json['work_type']);
    }
    if(workTypeModel != null) {
      workType = JPSingleSelectModel(label: workTypeModel!.name, id: workTypeModel!.id.toString());
    }
    measurementFormulas = product?.measurementFormulas;
    isMacroNotFound = Helper.isTrue(json['macro_not_found']);
    setMeasurementFormula(json);

    if (json['data'] is List) {
      subTiers = <SheetLineItemModel>[];
      subItems = <SheetLineItemModel>[];
      json['data'].forEach((dynamic item) {
        if (item['type'] == 'item') {
          final tempItem = SheetLineItemModel.fromWorkSheetJson(item['data'] ?? item);
          tempItem.type = item['type'];
          tempItem.setParent(this);
          subItems?.add(tempItem);
        } else {
          final tempItem = SheetLineItemModel.fromWorkSheetJson(item);
          tempItem.setParent(this);
          subTiers?.add(tempItem);
        }
      });
    }

    isConfirmedVariationRequired = json['confirm_variation'] != null
        ? Helper.isTrue(json['confirm_variation'])
        : Helper.isTrue(json['requires_variation_confirmation']);

    if(json['is_variation_confirmed'] != null) {
      isConfirmedVariation = Helper.isTrue(json['is_variation_confirmed']);
    }
  }

  void setMeasurementFormula(Map<String, dynamic> json) {
    if (!Helper.isValueNullOrEmpty(json['measurement_formulas']?['data'])) {
      measurementFormulas = [];
      json['measurement_formulas']['data'].forEach((dynamic measurementFormula) {
        measurementFormulas?.add(MeasurementFormulaModel.fromJson(measurementFormula));
      });
      
      // Find a formula that matches the trade_id from the measurement formulas
      String? foundFormula = MeasurementHelper.findFormulaByTradeId(measurementFormulas, json['trade_id'].toString());
      if (foundFormula != null) {
        // If a matching formula is found, set it and exit the method
        formula = foundFormula;
        return;
      }
    }
    // Set formula from json if measurement formulas are empty or don't match trade_id
    formula = json['formula']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? '';
    data["amount"] = num.tryParse(price ?? "");
    data["description"] = title;
    data["is_chargeable"] = !(productCategorySlug == FinancialConstant.noCharge) ? 1 : 0;
    data["is_no_charge"] = productCategorySlug == FinancialConstant.noCharge;
    data["is_taxable"] = isTaxable ?? false ? 1 : 0;
    data["product_id"] = int.tryParse(productId ?? "");
    data["quantity"] = num.tryParse(qty ?? "");
    data["supplier_id"] = null;
    data["total"] = ((num.tryParse(price ?? "") ?? 0) * (num.tryParse(qty ?? "") ?? 0)).toString();
    data["trade_id"] = tradeType?.id;
    data["work_type_id"] = workType?.id;
    data["supplier_id"] = supplierId;
    data["branch_code"] = branchCode;
    data['variant'] = variantModel?.toJson();
    data['variants'] = {
      'data': product?.variants?.map((e) => e.toJson())
    };
    data['is_variation_confirmed'] = Helper.isTrueReverse(isConfirmedVariation);
    data['requires_variation_confirmation'] = Helper.isTrueReverse(isConfirmedVariationRequired);
    return data;
  }

  Map<String, dynamic> toJobProposeQuickActionJson({bool? isSellingPrice, bool isTaxable = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(data['amount'] == null) {
      data['amount'] = Helper.isTrue(isSellingPrice) ? num.tryParse(sellingPrice ?? "0.0") : num.tryParse(price ?? "0.0");
    }
    data["description"] = title;
    data["is_taxable"] = isTaxable ? 1 : 0;
    data["quantity"] = int.tryParse(qty ?? "");
    data["trade_id"] = tradeType?.id ?? tradeId;
    data["work_type_id"] = workType?.id ?? workTypeId;
    data["product_id"] = int.tryParse(productId ?? "");
    if(supplierId != null) {
      data["supplier_id"] = supplierId;
    }
    if(branchCode != null) {
      data['branch_code'] = branchCode;
    }
    data["is_chargeable"] = Helper.isTrue(category?.slug != FinancialConstant.noCharge) ? 1 : 0;
    return data;
  }

  Map<String, dynamic> toEstimateJson(int index,) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? '';
    data['acv'] = num.tryParse(totalPrice ?? "");
    data['category_id'] = category?.id;
    data['depreciation'] = num.tryParse(depreciation ?? '0');
    data['description'] = title;
    data['note'] = note;
    data['order'] = index;
    data['product_code'] = productCode;
    data['product_id'] = productId;
    data['product_name'] = null;
    data['quantity'] = num.tryParse(qty ?? "");
    data['rcv'] = rcv;
    data['tax'] = tax;
    data['unit'] = unit;
    data['unit_cost'] = price;
    data['trade_id'] = tradeType?.id ?? '';
    data["supplier_id"] = supplierId;
    data["branch_code"] = branchCode;
    return data;
  }

  Map<String, dynamic> toWorksheetJson({
    String? generateWorksheetType,
    bool isForUnsavedDB = false,
    bool isPreview = false,
    SupplierBranchModel? branchDetails,
  }) {

    bool isMaterialSheet = generateWorksheetType == WorksheetConstants.materialList;
    bool isWorkOrderSheet = generateWorksheetType == WorksheetConstants.workOrder;
    bool excludeTaxAndProfit = isMaterialSheet || isWorkOrderSheet;

    final Map<String, dynamic> data = <String, dynamic>{};
    data['trade_id'] = tradeId;
    data['trade'] = toJsonFromJPSingleSelect(tradeType);
    data['work_type_id'] = workTypeId;
    data['work_type'] = toJsonFromJPSingleSelect(workType);
    data['product_name'] = productName;
    data['quantity'] = qty?.isEmpty ?? true ? 0 : qty;
    data['description'] = description;
    data['product_code'] = productCode ?? product?.code;
    data['code'] = productCode ?? product?.code;
    // Using line-item id as product id in case it missing
    data['product_id'] = product?.id ?? id;
    if (product?.styles != null) {
      data['styles'] = product?.styles?.map((option) => option).toList();
    }
    data['style'] = style;
    if (product?.sizes != null) {
      data['sizes'] = product?.sizes?.map((option) => option).toList();
    }
    data['size'] = size;
    if (product?.colors != null) {
      data['colors'] = product?.colors!.map((option) => option).toList();
    }
    data['color'] = color;
    data['supplier_id'] = supplierId;
    // In case of beacon using branch code coming within branch details for beacon products
    data["branch_code"] = branchDetails?.branchCode ?? branchCode;
    data['qb_desktop_id'] = product?.qbDesktopId;
    data['unit_cost'] = unitCost == 'null' ? 0 : unitCost ?? 0;
    data['selling_price'] = Helper.isTrue(workSheetSettings?.enableSellingPrice) && Helper.isTrue(product?.isSellingPriceNotAvailable) ? null : price;
    if (product?.units != null) {
      data['units'] = product?.units?.map((option) => option).toList();
    }
    data['unit'] = variantModel?.unit ?? unit;

    data['variant'] = variantModel?.toLimitedJson();
    if (!Helper.isValueNullOrEmpty(product?.variants)) {
      data['variants'] = {
        'data': product?.variants?.map((e) => e.toJson()).toList()
      };
    }

    data['total'] = totalPrice;
    if (!excludeTaxAndProfit) {
      data['line_profit_amt'] = lineProfitAmt;
      if (lineProfit != null) {
        data['line_profit'] = lineProfit;
      }

      data['line_tax_amt'] = lineTaxAmt;
      if (lineTax != null) {
        data['line_tax'] = lineTax;
      }
    }
    data['rounded_line_profit'] = roundedLineProfit;
    data['line_item_total'] = lineItemTotal;
    data['tier1'] = tier1;
    data['tier2'] = tier2;
    data['tier3'] = tier3;
    data['tier1_measurement_id'] = tier1MeasurementId;
    data['tier2_measurement_id'] = tier2MeasurementId;
    data['tier3_measurement_id'] = tier3MeasurementId;
    data['tier1_description'] = tier1Description;
    data['tier2_description'] = tier2Description;
    data['tier3_description'] = tier3Description;
    data['setting'] = {
      'tier1_collapse': 0,
      'tier2_collapse': 0,
      'tier3_collapse': 0,
    };
    // Setting [empty_tier] to true, In case of empty line item
    if (emptyTier != null) {
      data['empty_tier'] = Helper.isTrueReverse(emptyTier);
    }
    data['category_id'] = product?.categoryId ?? product?.productCategory?.id;
    data['system_category_id'] = systemCategoryId ?? product?.productCategory?.systemCategory?.id;
    data['category_name'] = product?.productCategory?.name ?? title;
    data['formula'] = formula;
    data['name'] = title;
    data['product_name'] = title;
    if (measurementFormulas != null) {
      data['formulas'] = measurementFormulas?.map((formula) => formula.toJson()).toList();
    }

    if(isForUnsavedDB) {
      data["tier"] = tier;
      data['tier_collapse'] = tierCollapse;
      data['tier_description'] = tierDescription;
      data['tier_measurement_id'] = tierMeasurementId;
      data['tier_name'] = tierName;
      data['type'] = type ?? "item";
      data['category'] = product?.productCategory?.toJson();
      data['is_fixed_price_item'] = isFixedPriceItem;
      data['is_product_available'] = product?.notAvailable ?? false;
      data['is_product_price_list_available'] = product?.notAvailableInPriceList ?? false;
      if (tierMeasurement != null) {
        data['tier_measurement'] = tierMeasurement?.toJson();
      }
      data['supplier'] = supplier?.toJson();

      if (subTiers?.isNotEmpty ?? false) {
        data["data"] = subTiers?.map((tier) => tier.toWorksheetJson(isForUnsavedDB: isForUnsavedDB)).toList();
      } else if(subItems?.isNotEmpty ?? false) {
        data["data"] = subItems?.map((item) => item.toWorksheetJson(isForUnsavedDB: isForUnsavedDB)).toList();
      }

    }

    if(!Helper.isValueNullOrEmpty(note)) data['note'] = note;

    data['is_variation_confirmed'] = Helper.isTrueReverse(isConfirmedVariation);
    data['requires_variation_confirmation'] = Helper.isTrueReverse(isConfirmedVariationRequired);
    return data;
  }

  // converting json from JPSingleSelectModel
  Map<String, dynamic> toJsonFromJPSingleSelect(JPSingleSelectModel? jpSingleSelectModel) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = jpSingleSelectModel?.id;
    data['name'] = jpSingleSelectModel?.label;
    return data;
  }

  void itemToTierDetails(SheetLineItemModel item, int tierIndex) {
    SheetLineItemModel? level1Item = item.parent;
    SheetLineItemModel? level2Item = item.parent?.parent;
    SheetLineItemModel? level3Item = item.parent?.parent?.parent;

    if (tierIndex == 2) {
      if (level2Item?.tier == 1) level2Item = null;
      if (level3Item?.tier == 1) level3Item = null;
    } else if (tierIndex == 3) {
      level2Item = null;
    }

    SheetLineItemModel? tier3details = level1Item;
    SheetLineItemModel? tier2details = level2Item ?? level1Item;
    SheetLineItemModel? tier1details = level3Item ?? level2Item;

    if (tier3details != tier2details && tier2details == tier1details) {
      tier2details = tier3details;
      tier3details = null;
    }

    if (tier2details == tier3details) {
      tier1details = tier3details;
      tier2details = null;
      tier3details = null;
    }

    if (tier1details != null) {
      tier1 = tier1details.title;
      tier1Description = tier1details.description;
      tier1MeasurementId = (tier1details.tierMeasurementId ?? tier1details.tierMeasurement?.id).toString();
    }
    if (tier2details != null) {
      tier2 = tier2details.title;
      tier2Description = tier2details.description;
      tier2MeasurementId = (tier2details.tierMeasurementId ?? tier2details.tierMeasurement?.id).toString();
    }
    if (tier3details != null) {
      tier3 = tier3details.title;
      tier3Description = tier3details.description;
      tier3MeasurementId = (tier3details.tierMeasurementId ?? tier3details.tierMeasurement?.id).toString();
    }
  }

  bool doAddTierMeasurement(int tierLevel) {
    int tempLevel = 0;
    if (!Helper.isValueNullOrEmpty(tier1MeasurementId)) tempLevel = 1;
    if (!Helper.isValueNullOrEmpty(tier2MeasurementId)) tempLevel = 2;
    if (!Helper.isValueNullOrEmpty(tier3MeasurementId)) tempLevel = 3;
    if (!Helper.isValueNullOrEmpty(tierMeasurementId)) tempLevel = 4;
    return tempLevel > tierLevel;
  }

  bool hasTierMeasurement() {
    return !Helper.isValueNullOrEmpty(tier1MeasurementId)
        || !Helper.isValueNullOrEmpty(tier2MeasurementId)
        || !Helper.isValueNullOrEmpty(tier3MeasurementId)
        || !Helper.isValueNullOrEmpty(tierMeasurementId);
  }

  void attachTierDetails(SheetLineItemModel item) {
    tier1 = item.tier1;
    tier1Description = item.tier1Description;
    tier1MeasurementId = item.tier1MeasurementId.toString();
    tier2 = item.tier2;
    tier2Description = item.tier2Description;
    tier2MeasurementId = item.tier2MeasurementId.toString();
    tier3 = item.tier3;
    tier3Description = item.tier3Description;
    tier3MeasurementId = item.tier3MeasurementId.toString();
  }

  // This code will deAttach the tier detail
  void deAttachTierDetail() {
    tier1 = null;
    tier1Description = null;
    tier1MeasurementId = null;
    tier2 =  null;
    tier2Description = null;
    tier2MeasurementId = null;
    tier3 = null;
    tier3Description = null;
    tier3MeasurementId = null;
  }

  void setParent(SheetLineItemModel parent) {
    this.parent = parent;
  }

  static SheetLineItemModel getInitialInvoiceItem(JobModel jobModel, bool defaultWorkTradeTypeEnabled){
    int jobTradesCount = jobModel.trades?.length ?? 0;
    int jobWorkCount = jobModel.workTypes?.length ?? 0;
    List<CompanyTradesModel>? jobTradeType = jobModel.trades;
    List<JobTypeModel?>? jobWorkType = jobModel.workTypes;
    bool showTradeType = jobTradesCount == 1 && defaultWorkTradeTypeEnabled;
    bool showWorkType = jobWorkCount == 1 && defaultWorkTradeTypeEnabled;

    return SheetLineItemModel(
      productId: null,
      title: null,
      price: null,
      qty: null,
      totalPrice: null,
      tradeType: showTradeType ? JPSingleSelectModel(
        label: jobTradeType!.first.name.toString(),
        id: jobTradeType.first.id.toString()) : null,
      workType: showWorkType ? JPSingleSelectModel(
        label: jobWorkType!.first!.name.toString(),
        id: jobWorkType.first!.id.toString()) : null
    );
  }

  /// [setVariant] is responsible for setting up variant details. It first extracts a list of variants
  /// then it sets up the selected variant with all the details
  void setVariant(Map<String, dynamic> json) {
    final variantsJson = json['variants'] is Map ? (json['variants']?['data']) : json['variants'];
    // Extracting all the available variants
    if (!Helper.isValueNullOrEmpty(variantsJson)) {
      variants = [];
      variantsJson.forEach((dynamic variant) {
        variants?.add(VariantModel.fromJson(variant));
      });
      // adding variants to product
      product?.variants = variants;
      // Creating variant name string from variants list
      variantsString = variants?.map((variant) => variant.name).join(", ") ?? "";
      product?.variantsString = variantsString;
    }

    // setting up selected variant with all the details
    if(json['variant'] is Map) {
      final tempVariant = VariantModel.fromJson(json['variant']);
      if(variants?.isNotEmpty ?? false) {
        variantModel = variants?.firstWhereOrNull((element) => element.name == tempVariant.name);
      }
      product?.variantModel = variantModel;
      if(Helper.isValueNullOrEmpty(productCode)) {
      productCode = product?.code = variantModel?.code;
      }
    }
  }

  /// [setVariantOnMacro] is responsible for setting variant on macro,
  /// It looks for the first variant from the variants list and apply
  /// it selects it as the variant of the line item
  void setVariantOnMacro() {
    //  To set default value if no variant is selected
    variantModel ??= variants?.firstOrNull;
    product?.id ??= id;
    product?.variantModel ??= variantModel;
    // setting product code from product variant
    if(!Helper.isValueNullOrEmpty(product?.variantModel?.code) && !Helper.isSupplierHaveSrsItem([supplier ?? SuppliersModel()])) {
      product?.code = product?.variantModel?.code;
    }
    if(Helper.isValueNullOrEmpty(productCode)) {
      productCode = product?.code;
    }
    //  To get units from variants if available
    if(!Helper.isValueNullOrEmpty(variantModel?.uom)) {
      unit = variantModel?.uom?.firstOrNull;
    }

    String? desc = WorksheetHelpers.getItemCodeInDescription(
        supplierId: supplier?.id,
        productCode: productCode,
        variantCode: variantModel?.code,
        productDescription: product?.description,
        lineItemDescription: description
    );
    if (desc != null) {
      description = desc;
    }
  }

  /// [setTierSubTotals] sets the calculated values at tier level
  /// previously only amount was set but as per [LEAP-1347] now we have to set
  /// additional values at tier level including
  /// - Sub Total
  /// - Profit
  /// - Cost
  /// NOTE: This function can be extended for further calculations
  void setTierSubTotals(WorksheetAmounts amounts) {
    totalPrice = JobFinancialHelper.getRoundOff(amounts.subTotal, fractionDigits: 2);
    tiersLineTotal = JobFinancialHelper.getRoundOff(amounts.listTotal, fractionDigits: 2);
    lineProfitAmt = JobFinancialHelper.getRoundOff(amounts.lineItemProfit, fractionDigits: 2);
    lineTaxAmt = JobFinancialHelper.getRoundOff(amounts.lineItemTax, fractionDigits: 2);
  }

  /// [doHighlightTier] helps in highlighting tier in case of macro not found
  /// and tier is not available with line items and sub-tiers
  bool doHighlightTier() {
    // checking if tier has no sub items or sub tiers
    bool hasTierLineItems = !Helper.isValueNullOrEmpty(tier) && Helper.isValueNullOrEmpty(subItems) && Helper.isValueNullOrEmpty(subTiers);
    return Helper.isTrue(isMacroNotFound) && hasTierLineItems;
  }

  bool isEmptyTier() {
    return type == WorksheetConstants.collection
        && (subItems?.isEmpty ?? true)
        && (subTiers?.isEmpty ?? true);
  }
}