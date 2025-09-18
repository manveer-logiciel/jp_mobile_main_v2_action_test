import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item_conditions.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'add_item_params.dart';

/// [WorksheetAddItemData] is responsible for handling worksheet add item's data
/// It also handles conversion of forms data to sheet line item
class WorksheetAddItemData {

  String totalPrice = "0.00";
  String selectedCategoryId = "";
  String selectedSystemCategoryId = "";
  String selectedSupplierId = "";
  String selectedTradeId = "";
  String selectedWorkTypeId = "";
  String selectedCategorySlug = "";
  String taxAmount = "0";
  String profitAmount = "0";
  String taxPercent = "0";
  String profitPercent = "0";

  JPInputBoxController typeController = JPInputBoxController();
  JPInputBoxController nameController = JPInputBoxController();
  JPInputBoxController supplierController = JPInputBoxController();
  JPInputBoxController tradeTypeController = JPInputBoxController();
  JPInputBoxController workTypeController = JPInputBoxController();
  JPInputBoxController typeStyleController = JPInputBoxController();
  JPInputBoxController colorController = JPInputBoxController();
  JPInputBoxController sizeController = JPInputBoxController();
  JPInputBoxController unitController = JPInputBoxController();
  JPInputBoxController priceController = JPInputBoxController();
  JPInputBoxController quantityController = JPInputBoxController();
  JPInputBoxController profitPercentController = JPInputBoxController();
  JPInputBoxController profitAmountController = JPInputBoxController();
  JPInputBoxController descriptionController = JPInputBoxController();
  JPInputBoxController noteController = JPInputBoxController();
  JPInputBoxController taxPercentController = JPInputBoxController();
  JPInputBoxController taxAmountController = JPInputBoxController();
  JPInputBoxController variantController = JPInputBoxController();

  List<JPSingleSelectModel> workTypes = [];
  List<JPSingleSelectModel> allCategories = [];
  List<JPSingleSelectModel> allSuppliers = [];

  // handles product's data
  FinancialProductModel product = FinancialProductModel();

  SuppliersModel? selectedSupplier;

  // holds the selected product variant
  // Reason: uom(Units Of Measurement) is a dynamic single select which requires
  // selected variant to display selection options accordingly
  VariantModel? selectedVariant;

  // handles all the show/hide field conditions
  late WorksheetAddItemConditionsService conditionsService;

  // holds the data coming from parent eg. (Trades, Supplier, Categories)
  WorksheetAddItemParams params;

  // [isConfirmedVariation] is used to determine if the item is a confirmed variation
  bool? isConfirmedVariation;

  WorksheetAddItemData(this.params);

  /// [setFormData] initialises the form with sheet line items data
  /// to be edited or updated
  void setFormData() {
    SheetLineItemModel? lineItem = params.lineItem;
    allCategories.addAll(params.allCategories);
    allSuppliers.addAll(params.allSuppliers);

    // in case of add there is no need to initialise form with data
    if (lineItem == null) {
      final defaultTrade = params.tradeTypeDefault;
      if (defaultTrade != null) {
        selectedTradeId = defaultTrade.id?.toString() ?? "";
        tradeTypeController.text = defaultTrade.name ?? "";
      }
      return;
    }

    // Setting up selector Id's
    selectedCategoryId = lineItem.category?.id.toString() ?? "";
    selectedSystemCategoryId = getSelectedSystemCategoryId(lineItem.category?.systemCategory);
    selectedSupplierId = lineItem.supplierId ?? "";
    selectedTradeId = lineItem.tradeId?.toString() ?? "";

    if (lineItem.supplier != null) {
      selectedSupplier = lineItem.supplier!;
      bool foundSupplierInList = allSuppliers.any((supplier) => supplier.id == lineItem.supplierId?.toString());
      if (!foundSupplierInList) {
        allSuppliers.add(lineItem.supplier!.toSingleSelect());
      }
    }

    // Getting selected items from line item details
    JPSingleSelectModel category = FormValueSelectorService.getSelectedSingleSelect(allCategories, selectedCategoryId);
    JPSingleSelectModel supplier = FormValueSelectorService.getSelectedSingleSelect(allSuppliers, selectedSupplierId);
    JPSingleSelectModel trade = FormValueSelectorService.getSelectedSingleSelect(params.allTrade, selectedTradeId);

    if (Helper.isValueNullOrEmpty(category.id)) {
      category = JPSingleSelectModel(
          label: lineItem.category?.name ?? "",
          id: lineItem.category?.id.toString() ?? "",
          additionalData: lineItem.category
      );
      allCategories.add(category);
    }

    typeController.text = category.label;
    supplierController.text = supplier.label;
    tradeTypeController.text = trade.label;
    setWorkTypesList(selectedTradeId, workTypeId: lineItem.workTypeId?.toString());
    
    nameController.text = lineItem.title ?? "";
    typeStyleController.text = lineItem.style ?? "";
    sizeController.text = lineItem.size ?? "";
    colorController.text = lineItem.color ?? "";
    unitController.text = lineItem.unit ?? "";
    // Coping the product's data to avoid reference issues
    if (lineItem.product != null) product = FinancialProductModel.copy(lineItem.product!);
    product.supplier = (supplier.additionalData as SuppliersModel?);
    product.measurementFormulas = lineItem.measurementFormulas;
    bool isSellingPriceEnabled = params.settings.enableSellingPrice ?? true;
    priceController.text = formatCalcValue((isSellingPriceEnabled ? lineItem.price : lineItem.unitCost));
    quantityController.text = formatCalcValue(lineItem.qty);
    profitPercentController.text = formatCalcValue(lineItem.lineProfit);
    profitAmountController.text = formatCalcValue(lineItem.lineProfitAmt);
    profitPercent = lineItem.lineProfit ?? "";
    profitAmount = lineItem.lineProfitAmt ?? "";
    taxAmountController.text = formatCalcValue(lineItem.lineTaxAmt);
    taxPercentController.text = formatCalcValue(lineItem.lineTax);
    taxAmount = lineItem.lineTaxAmt ?? "";
    taxPercent = lineItem.lineTax ?? "";
    descriptionController.text = lineItem.description ?? "";
    noteController.text = lineItem.note ?? "";

    totalPrice = lineItem.lineTotalAmount ?? lineItem.totalPrice ?? '';
    selectedCategorySlug = lineItem.productCategorySlug ?? "";

    // In case variant data is available
    if (!Helper.isValueNullOrEmpty(lineItem.variantModel)) {
      variantController.text = lineItem.variantModel?.name ?? "";
      selectedVariant = lineItem.variantModel;
      // Unit coming within line item will be priority, In case it is not available
      // unit from the variant will be used
      unitController.text = lineItem.unit ?? lineItem.variantModel?.unit ?? "";
    }
    isConfirmedVariation = lineItem.isConfirmedVariation ?? false;
  }

  /// [toLineItem] will convert forms data to line item details
  SheetLineItemModel toLineItem() {

    // Getting selected options values
    final selectedCategory = FormValueSelectorService.getSelectedSingleSelect(allCategories, selectedCategoryId);
    final selectSupplier = FormValueSelectorService.getSelectedSingleSelect(allSuppliers, selectedSupplierId);
    final selectedWorkType = FormValueSelectorService.getSelectedSingleSelect(workTypes, selectedWorkTypeId);
    final selectedTradeType = FormValueSelectorService.getSelectedSingleSelect(params.allTrade, selectedTradeId);
    final selectedFormula = product.measurementFormulas?.firstWhereOrNull((measurement) => measurement.tradeId.toString() == selectedTradeId);
    selectedVariant?.unit = unitController.text;

    bool isSellingPriceEnabled = params.settings.enableSellingPrice ?? true;

    selectedCategory.additionalData ??= product.productCategory;

    if(!Helper.isTrue(product.isSellingPriceNotAvailable)) {
      // Update unavailable selling price status
      product.isSellingPriceNotAvailable = isSellingPriceEnabled && priceController.text.isEmpty;
    }

    if(selectSupplier.additionalData is SuppliersModel?) {
      (selectSupplier.additionalData as SuppliersModel?)?.divisions = selectedSupplier?.divisions;
    }
    return SheetLineItemModel(
      category: selectedCategory.additionalData as WorksheetDetailCategoryModel?,
      supplier: selectSupplier.additionalData ?? selectedSupplier,
      tradeType: selectedTradeType,
      workType: selectedWorkType,
      tradeId: int.tryParse(selectedTradeId),
      workTypeId: int.tryParse(selectedWorkTypeId),
      productName: nameController.text,
      style: typeStyleController.text,
      color: colorController.text,
      size: sizeController.text,
      unit: unitController.text,
      unitCost: isSellingPriceEnabled ? product.unitCost : priceController.text,
      lineProfit: profitPercent,
      lineProfitAmt: profitAmount,
      description: descriptionController.text,
      product: FinancialProductModel.copy(product),
      supplierId: selectedSupplierId,
      productId: product.id.toString(),
      title: nameController.text,
      productCategorySlug: selectedCategorySlug,
      price: isSellingPriceEnabled ? priceController.text : Helper.isTrue(product.isSellingPriceNotAvailable) ? '' : product.sellingPrice ?? '',
      qty: quantityController.text,
      totalPrice: totalPrice,
      lineTax: taxPercent,
      lineTaxAmt: taxAmount,
      measurementFormulas: product.measurementFormulas,
      formula: selectedFormula?.formula,
      workSheetSettings: params.settings,
      type: WorksheetConstants.item,
      lineTotalAmount: totalPrice,
      variantModel: selectedVariant,
      // Branch code is required to for fetching variants of a product
      branchCode: product.branchCode,
      note: noteController.text,
      isConfirmedVariation: isConfirmedVariation,
      isConfirmedVariationRequired: params.lineItem?.isConfirmedVariationRequired
    );
  }

  /// [setWorkTypesList] will set work types list on the basis of selected
  /// trade types and clears previous work types data if any
  void setWorkTypesList(String id, {String? workTypeId}) {
    selectedTradeId = id;
    selectedWorkTypeId = "";
    workTypeController.text = "";
    workTypes.clear();
    final selectedTrade = FormValueSelectorService.getSelectedSingleSelect(params.allTrade, id);
    final tradeWorkTypes = (selectedTrade.additionalData as List<JPMultiSelectModel>?);
    for (var workType in tradeWorkTypes ?? []) {
      if (workTypeId != null && workType.id == workTypeId) {
        selectedWorkTypeId = workTypeId;
        workTypeController.text = workType.label;
      }
      workTypes.add(JPSingleSelectModel(label: workType.label, id: workType.id));
    }
  }

  /// [reInitialiseValues] will clear the all the entered forms data
  void reInitialiseValues() {
    totalPrice = "0.00";
    if (!conditionsService.isMaterialWorksheet) {
      selectedCategoryId = "";
      typeController.text = "";
      selectedCategorySlug = "";
      selectedSystemCategoryId = "";
    }
    selectedSupplierId = "";
    selectedTradeId = "";
    selectedWorkTypeId = "";
    nameController.text = "";
    supplierController.text = "";
    tradeTypeController.text = "";
    workTypeController.text = "";
    typeStyleController.text = "";
    colorController.text = "";
    sizeController.text = "";
    unitController.text = "";
    priceController.text = "";
    quantityController.text = "";
    profitPercentController.text = "";
    profitAmountController.text = "";
    descriptionController.text = "";
    noteController.text = "";
    taxPercentController.text = "";
    taxAmountController.text = "";
    product = FinancialProductModel();
    workTypes.clear();
  }

  /// [setProductCategory] opens up product category search screen to
  /// select product from and update product's data
  void setProductCategory() {
    // in case of material list category selection will not be available
    // so setting up default category as material
    if (params.worksheetType == WorksheetConstants.materialList) {
      selectedCategoryId = allCategories
          .firstWhereOrNull((category) => (category.additionalData)?.slug == FinancialConstant.material)?.id ?? "";
    }

    final selectedOption = FormValueSelectorService.getSelectedSingleSelect(allCategories, selectedCategoryId);
    final selectedCategory = (selectedOption.additionalData as WorksheetDetailCategoryModel?);
    selectedSystemCategoryId = getSelectedSystemCategoryId(selectedCategory);
    product.productCategory = selectedCategory;
    selectedCategorySlug = selectedCategory?.slug ?? "";
  }

  /// [getSelectedSystemCategoryId] determines when to include system category ID for API performance
  ///
  /// Performance Fix:
  /// - Only returns systemCategoryId when it's actually needed for filtering
  /// - Criteria: Must be a material category AND have supplier integration enabled
  /// - This prevents unnecessary system category parameters that caused backend delays
  ///
  /// Returns:
  /// - System category ID string if material category with enabled suppliers
  /// - Empty string otherwise (prevents sending null/empty values to API)
  String getSelectedSystemCategoryId(WorksheetDetailCategoryModel? category) {
    bool isMaterial = category?.slug?.toLowerCase() == WorksheetConstants.categoryMaterials.toLowerCase();
    bool isAnySupplierEnabled = params.isAnySupplierEnabled();
    if (isMaterial && isAnySupplierEnabled) {
      return category?.systemCategory?.id?.toString() ?? '';
    }
    return "";
  }

  /// [formatCalcValue] format the calculation values (tax, profit, price)
  /// so they can be displayed in proper editable format
  String formatCalcValue(String? value) {
    num tempValue = num.tryParse(value ?? "") ?? 0;
    return JobFinancialHelper.getRoundOff(tempValue, fractionDigits: 2, avoidZero: true);
  }
}