import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../../enums/sheet_line_item_type.dart';

class FinancialProductModel {
  int? id;
  int? categoryId;
  String? name;
  String? unit;
  String? unitCost;
  String? code;
  String? description;
  WorksheetDetailCategoryModel? productCategory;
  int? laborId;
  String? sellingPrice;
  SuppliersModel? supplier;
  int? manufacturerId;
  String? affectedFrom;
  String? abcAdditionalData;
  String? branch;
  String? branchCode;
  String? branchLogo;
  String? qbDesktopId;
  int? companyId;
  int? active;
  int? supplierId;
  bool? forAllTrades;
  List<MeasurementFormulaModel>? measurementFormulas;
  List<String>? colors;
  List<String>? styles;
  List<String>? sizes;
  List<String>? units;
  late bool notAvailable;
  late bool notAvailableInPriceList;
  /// [isBeaconProduct] is used to check whether the product is beacon product or not
  /// In case of beacon product a static logo will be displayed that's why a special
  /// check is made for that product
  bool? isBeaconProduct;
  /// [variants] holds all the variants of the product which can be then used to
  /// select a variant and uom(Unit of Measurement)
  List<VariantModel>? variants;
  /// [variantsString] is a comma separated string of variant names
  String? variantsString;
  /// [variantModel] holds the line item's selected variant
  VariantModel? variantModel;
  bool? isSellingPriceNotAvailable;
  /// [isAbcProduct] is used to check whether the product is ABC product or not
  /// In case of ABC product a static logo will be displayed that's why a special
  /// check is made for that product
  bool? isAbcProduct;

  FinancialProductModel({
    this.id,
    this.categoryId,
    this.name,
    this.unit,
    this.unitCost,
    this.code,
    this.description,
    this.productCategory,
    this.laborId,
    this.sellingPrice,
    this.supplier,
    this.manufacturerId,
    this.affectedFrom,
    this.abcAdditionalData,
    this.branch,
    this.branchCode,
    this.branchLogo,
    this.qbDesktopId,
    this.companyId,
    this.active,
    this.measurementFormulas,
    this.forAllTrades,
    this.supplierId,
    this.colors,
    this.sizes,
    this.styles,
    this.units,
    this.notAvailable = false,
    this.notAvailableInPriceList = false,
    this.isBeaconProduct = false,
    this.variants,
    this.variantsString,
    this.isSellingPriceNotAvailable,
    this.isAbcProduct = false
  });

  factory FinancialProductModel.copy(FinancialProductModel other) {
    return FinancialProductModel(
        id: other.id,
        categoryId: other.categoryId,
        name: other.name,
        unit: other.unit,
        unitCost: other.unitCost,
        code: other.code,
        description: other.description,
        productCategory: other.productCategory,
        laborId: other.laborId,
        sellingPrice: other.sellingPrice,
        supplier: other.supplier,
        manufacturerId: other.manufacturerId,
        affectedFrom: other.affectedFrom,
        abcAdditionalData: other.abcAdditionalData,
        branch: other.branch,
        branchCode: other.branchCode,
        branchLogo: other.branchLogo,
        qbDesktopId: other.qbDesktopId,
        companyId: other.companyId,
        active: other.active,
        measurementFormulas: other.measurementFormulas,
        forAllTrades: other.forAllTrades,
        supplierId: other.supplierId,
        colors: other.colors,
        sizes: other.sizes,
        styles: other.styles,
        units: other.units,
        notAvailable: other.notAvailable,
        notAvailableInPriceList: other.notAvailableInPriceList,
        isBeaconProduct: other.isBeaconProduct,
        variants: other.variants,
        variantsString: other.variantsString,
        isSellingPriceNotAvailable: other.isSellingPriceNotAvailable,
        isAbcProduct: other.isAbcProduct,
    );
  }

  FinancialProductModel.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    unit = json['unit'];
    unitCost = json['unit_cost']?.toString() ?? "";
    branch = json['branch'];
    if(Helper.isValueNullOrEmpty(json['name'])){
      name = json['description'];
    } else {
      name = json['name'];
      description = json['description'];
    }
    
    productCategory = json['category'] != null ? WorksheetDetailCategoryModel.fromJson(json['category']) : null;
    laborId = json['labor_id'];

    final financialDetailsSellingPrice = Helper.isValueNullOrEmpty(json['financial_product_detail']?['selling_price'])
        ? '0.00'
        : json['financial_product_detail']?['selling_price'].toString();
    sellingPrice = Helper.isValueNullOrEmpty(json['selling_price']) ? financialDetailsSellingPrice : json['selling_price']?.toString();
    isSellingPriceNotAvailable = Helper.isValueNullOrEmpty(json['selling_price'])
        && Helper.isValueNullOrEmpty(json['financial_product_detail']?['selling_price']);
    supplier = json['supplier'] is Map ? SuppliersModel.fromJson(json['supplier']) : null;
    manufacturerId = json['manufacturer_id'];
    affectedFrom = json['affected_from'];
    abcAdditionalData = json['abc_additional_data']?.toString();
    branch = json['branch'];
    branchCode = json['branch_code'];
    branchLogo = json['branch_logo'];
    qbDesktopId = json['qb_desktop_id'];
    companyId = json['company_id'];
    active = json['active'];
    forAllTrades = Helper.isTrue(json['for_all_trades']);
    if (json['measurement_formulas'] is Map && json['measurement_formulas']?["data"] != null) {
      measurementFormulas = [];
      json['measurement_formulas']?["data"].forEach((dynamic measurementFormula) {
        measurementFormulas?.add(
            MeasurementFormulaModel.fromJson(measurementFormula));
      });
    }
    if (json['measurement_formulas'] is List) {
      measurementFormulas = [];
      json['measurement_formulas']?.forEach((dynamic measurementFormula) {
        measurementFormulas?.add(
            MeasurementFormulaModel.fromJson(measurementFormula));
      });
    }
    supplierId = int.tryParse(json['supplier_id'].toString());
    sizes = json['sizes'] is List ? json['sizes'].cast<String>() : null;
    colors = json['colors'] is List ? json['colors'].cast<String>() : null;
    styles = json['styles'] is List ? json['styles'].cast<String>() : null;
    units = json['units'] is List ? json['units'].cast<String>() : null;
    notAvailable = false;
    notAvailableInPriceList = false;
    // A product is considered as beacon product if it has supplier
    // id as beacon as per app env
    if (supplierId != null) {
      isBeaconProduct = supplierId == Helper.getSupplierId(key: CommonConstants.beaconId);
      isAbcProduct = supplierId == Helper.getSupplierId(key: CommonConstants.abcSupplierId);
    }

    if(!Helper.isValueNullOrEmpty(json['variants'])) {
      variants = [];
      // In case variants are available there is no need of (color, style & size) because
      // that's all what a variant defines. Moreover it's done with the purpose of:
      // 1. In case there are no variants available and other options (color, style & size)
      //    are available they should be used. Otherwise variants should be used
      // 2. Both of the Variants & (color, style & size) can't be used together
      colors = styles = sizes = null;
      // Variants can come as list within 'variants' key or 'variants' can be object of 'data' holding variants list
      List<dynamic> tempVariantList = (json['variants'] is List ? json['variants'] : json['variants']?['data']) ?? [];
      for (var variant in tempVariantList) {
        variants?.add(VariantModel.fromJson(variant));
      }
      // Creating variant name string from variants list
      variantsString = variants?.map((variant) => variant.name).join(", ") ?? "";
    }
    code = json['code'] ?? json['item_code'] ?? variants?.firstOrNull?.code;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['category_id'] = categoryId;
    map['name'] = name;
    map['unit'] = unit;
    map['unit_cost'] = unitCost;
    map['code'] = code;
    map['description'] = description ?? name;
    if (productCategory != null) {
      map['category'] = productCategory?.toJson();
    }
    map['labor_id'] = laborId;
    map['selling_price'] = sellingPrice;
    map['supplier'] = supplier;
    map['manufacturer_id'] = manufacturerId;
    map['affected_from'] = affectedFrom;
    map['abc_additional_data'] = abcAdditionalData;
    map['branch'] = branch;
    map['branch_code'] = branchCode;
    map['branch_logo'] = branchLogo;
    map['qb_desktop_id'] = qbDesktopId;
    map['company_id'] = companyId;
    map['active'] = active;
    map['for_all_trades'] = forAllTrades;

    map['styles'] = styles;
    map['sizes'] = sizes;
    map['colors'] = colors;
    map['variants'] = variants;

    return map;
  }

  bool showSellingPriceNotAvailable(
      AddLineItemFormType? pageType,
      bool isEstimateOrProposalWorksheet,
      bool isSellingPriceSettingEnabled
      ) {
    return pageType == AddLineItemFormType.worksheet &&
        isEstimateOrProposalWorksheet &&
        isSellingPriceSettingEnabled &&
        Helper.isTrue(isSellingPriceNotAvailable);
  }

}