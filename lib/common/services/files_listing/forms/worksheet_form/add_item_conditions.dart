import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item.dart';
import 'package:jobprogress/common/models/worksheet/settings/settings.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemConditionsService {

  WorksheetAddItemData itemData;

  WorksheetAddItemConditionsService.forItem(this.itemData);

  /// Data extractors ------------------------------------------------------
  String get worksheetType => itemData.params.worksheetType;
  FinancialProductModel get product => itemData.product;
  List<JPSingleSelectModel> get suppliers => itemData.params.allSuppliers;
  WorksheetSheetSetting get settings => itemData.params.settings;

  /// Condition Helpers -------------------------------------------------------
  bool get hasProductCategory => product.productCategory != null;
  bool get hasProductSupplier => product.supplier != null;
  bool get hasProductSupplierCompanyId => product.supplier == null || product.supplier?.companyId != null;
  bool get hasProductQBDesktopId => !Helper.isValueNullOrEmpty(product.qbDesktopId);
  bool get isMaterialWorksheet => worksheetType == WorksheetConstants.materialList;
  bool get isMaterialProduct => itemData.selectedCategorySlug == FinancialConstant.material;
  bool get isNoChargeProduct => itemData.selectedCategorySlug == FinancialConstant.noCharge;
  bool get hasProductSupplierSRSId => Helper.isSRSv1Id(itemData.product.supplier?.id) || Helper.isSRSv2Id(itemData.product.supplier?.id);
  bool get hasProductSupplierBeaconId => itemData.product.supplier?.id == Helper.getSupplierId(key: CommonConstants.beaconId);
  bool get isActionForSRSMaterialList => itemData.params.isSRSEnabled ?? false;
  bool get isActionForBeaconMaterialList => itemData.params.isBeaconEnabled ?? false;
  bool get hasMultipleUOM => !Helper.isValueNullOrEmpty(itemData.selectedVariant?.uom);
  bool get hasProductSupplierAbcId => itemData.product.supplier?.id == Helper.getSupplierId(key: CommonConstants.abcSupplierId);

  /// Conditions --------------------------------------------------------------
  bool get showCategoryField => !isMaterialWorksheet;
  bool get disableCategory => isMaterialProduct && hasProductSupplier;
  bool get disableNameField => !((isMaterialWorksheet || hasProductCategory) && !hasProductSupplier && !hasProductQBDesktopId);
  bool get showSupplier => (suppliers.isNotEmpty || hasProductSupplier) && (isMaterialWorksheet || isMaterialProduct);
  bool get disableSupplier => !((isMaterialWorksheet || hasProductCategory) && (!hasProductSupplier));
  bool get disableTradeType => !isMaterialWorksheet && !hasProductCategory;
  bool get showTypeStyle => (isMaterialWorksheet || isMaterialProduct) && hasProductSupplierCompanyId;
  bool get showColor => (isMaterialWorksheet || isMaterialProduct) && (hasProductSupplierCompanyId || hasProductSupplierSRSId || hasProductSupplierBeaconId);
  bool get isColorRequired => (!Helper.isValueNullOrEmpty(product.colors) && (hasProductSupplierSRSId || hasProductSupplierBeaconId) && (isActionForSRSMaterialList || isActionForBeaconMaterialList || isMaterialWorksheet));
  bool get isColorDisabled => (hasProductSupplierSRSId || hasProductSupplierBeaconId);
  bool get isColorSingleSelect => !Helper.isValueNullOrEmpty(product.colors);
  bool get isStyleSingleSelect => !Helper.isValueNullOrEmpty(product.styles);
  bool get isVariantsSingleSelect => !Helper.isValueNullOrEmpty(product.variants);
  bool get showSize => (isMaterialWorksheet || isMaterialProduct) && hasProductSupplierCompanyId;
  bool get isSizeSingleSelect => !Helper.isValueNullOrEmpty(product.sizes);
  bool get isUnitSingleSelect => (hasProductSupplierSRSId || hasProductSupplierBeaconId || hasProductSupplierAbcId) && (hasMultipleUOM || !Helper.isValueNullOrEmpty(product.units));
  bool get disableUnit => (!isMaterialWorksheet && !hasProductCategory) || (hasProductSupplier && !hasMultipleUOM) || hasProductQBDesktopId;
  bool get hidePrice => settings.hidePricing ?? false;
  bool get disablePrice => (!isMaterialWorksheet && !hasProductCategory) || hasProductSupplier;
  bool get disableQuantity => !isMaterialWorksheet && !hasProductCategory;
  bool get showProfit => !settings.hidePricing! && settings.applyLineItemProfit! && !isMaterialWorksheet && !isNoChargeProduct;
  bool get disableProfit => !hasProductCategory;
  bool get showTax => !settings.hidePricing! && settings.addLineItemTax! && !isMaterialWorksheet && !isNoChargeProduct;
  bool get disableTax => !hasProductCategory;
  bool get disableDescription => (!isMaterialWorksheet && !hasProductCategory) || hasProductSupplier;
  bool get disableTypeStyle => !isMaterialWorksheet && !isMaterialProduct;
  bool get disableSize => !isMaterialWorksheet && !isMaterialProduct;
  bool get showVariants => !Helper.isValueNullOrEmpty(product.variants);

  bool get isConfirmedVariationRequired => itemData.params.lineItem?.isConfirmedVariationRequired ?? false;

}