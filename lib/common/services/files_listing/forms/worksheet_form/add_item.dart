import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item.dart';
import 'package:jobprogress/common/models/forms/worksheet/add_item_params.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/repositories/financial_product.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/worksheet/calculations.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/constants/common_constants.dart';
import '../../../../enums/supplier_form_type.dart';
import '../../../../models/financial_product/financial_product_price.dart';
import '../../../worksheet/helpers.dart';
import 'add_item_conditions.dart';

/// [WorksheetAddItemService] helps in updating and manipulating the add item forms data
class WorksheetAddItemService extends WorksheetAddItemData {

  WorksheetAddItemService({
    required WorksheetAddItemParams params,
    required this.update,
    required this.validateForm,
  }) : super(params);

  VoidCallback update; // helps in updating ui from service
  VoidCallback validateForm; // helps in realtime validations

  /// [initService] initialises the form with data and several conditions
  Future<void> initService() async {
    try {
      // setting form data
      setFormData();
      // setting up conditions
      conditionsService = WorksheetAddItemConditionsService.forItem(this);
    } catch(e) {
      rethrow;
    } finally {
      // setting product category details to fill in product details
      setProductCategory();
    }
  }

  /// Selectors ---------------------------------------------------------------

  void selectType() {
    FormValueSelectorService.openSingleSelect(
        list: params.allCategories,
        selectedItemId: selectedCategoryId,
        controller: typeController,
        title: 'select_type'.tr,
        onValueSelected: setType,
    );
  }

  void selectSupplier() {
    FormValueSelectorService.openSingleSelect(
      list: params.allSuppliers,
      selectedItemId: selectedSupplierId,
      controller: supplierController,
      title: 'select_supplier'.tr,
      onValueSelected: setSupplier,
    );
  }

  void selectTrade() {
    FormValueSelectorService.openSingleSelect(
      list: params.allTrade,
      selectedItemId: selectedTradeId,
      controller: tradeTypeController,
      title: 'select_trade'.tr,
      onValueSelected: (id) {
        setWorkTypesList(id);
        update();
      },
    );
  }

  void selectWorkType() {
    FormValueSelectorService.openSingleSelect(
      list: workTypes,
      selectedItemId: selectedWorkTypeId,
      controller: workTypeController,
      title: 'select_work_type'.tr,
      onValueSelected: (id) {
        selectedWorkTypeId = id;
        update();
      },
    );
  }

  // [selectProduct] opens financial product search screen to select product from
  Future<void> selectProduct() async {

    String title = conditionsService.isMaterialWorksheet ? selectedCategorySlug : typeController.text.capitalize!;

    FinancialProductModel? result = await FormValueSelectorService.searchFinancialProduct(
      getProductSearchParams(title),
      AddLineItemFormType.worksheet,
      enableAddButton: false,
      worksheetType: conditionsService.worksheetType
    );

    if(result is FinancialProductModel) {
      updateItemData(result);
      validateForm();
      update();
    }
  }

  // [selectMaterialProp] helps in selecting material properties i.e color, size, style & unit
  void selectMaterialProp(WorksheetMaterialPropType type, String title) {

    Helper.hideKeyboard();
    // extracting options list according to type
    List<JPSingleSelectModel> optionsList = getMaterialPropList(type);
    // setting up controller according to type
    JPInputBoxController controller = geMaterialPropController(type);

    FormValueSelectorService.openSingleSelect(
      list: optionsList,
      selectedItemId: controller.text,
      controller: controller,
      title: title,
      onValueSelected: (val) async => await onMaterialPropSelected(type, val),
    );
  }

  /// [onMaterialPropSelected] is responsible for handing material properties selection
  /// some material properties require exceptional handling eg. [WorksheetMaterialPropType.variant]
  /// It handles all such scenarios
  Future<void> onMaterialPropSelected(WorksheetMaterialPropType type, String val) async {
    switch (type) {
      case WorksheetMaterialPropType.variant:
        setVariant(val: val);
        break;
      case WorksheetMaterialPropType.unit:
        setPriceOnSelectUnit(val);
      default:
        break;
    }
    // updating property controller's data
    geMaterialPropController(type).text = val;
    validateForm();
    update();
  }

  /// Getter -----------------------------------------------------------------

  FinancialProductSearchModel getProductSearchParams(String title) {
    return FinancialProductSearchModel(
      name: nameController.text.toString(),
      categoryId: selectedCategoryId,
      systemCategoryId: selectedSystemCategoryId,
      title: title,
      selectedCategorySlug: selectedCategorySlug,
      isSellingPriceEnabled: params.settings.enableSellingPrice,
      srsBranchCode: params.srsBranchCode,
      shipToSequenceId: params.shipToSequenceId,
      beaconBranchCode: params.beaconBranchCode,
      beaconJobNumber: params.beaconJobNumber,
      forSupplierId: params.forSupplierId,
      beaconAccount: params.beaconAccount,
      supplierBranch: params.supplierBranch,
      srsSupplierId: params.srsSupplierId,
      abcBranchCode: params.abcBranchCode,
      supplierAccountId: params.supplierAccountId,
      jobDivision: params.jobDivision
    );
  }

  /// Setters -----------------------------------------------------------------

  Future<void> setType(String id) async {
    selectedCategoryId = id;
    setProductCategory();
    // additional delay for value to set up
    await Future<void>.delayed(const Duration(milliseconds: 200));
    validateForm();
    update();
  }

  void setSupplier(String id) {
    selectedSupplierId = id;
    final selectedOption = FormValueSelectorService.getSelectedSingleSelect(params.allSuppliers, id);
    product.supplier = (selectedOption.additionalData as SuppliersModel?);
    update();
  }

  /// [setVariant] is responsible for setting a variant for line item when:
  /// 1. Product is selected
  /// 2. Variant is selected
  /// It is also responsible for updating the uom(Units Of Measurement) options
  void setVariant({VariantModel? variant, String? val}) {
    if (val != null) {
      variant = product.variants?.firstWhereOrNull((element) => element.name == val);
      setVariantPrice(variant);
    }
    selectedVariant = variant;
    // Updating product code on variant selection if productCode is unavailable or SRS is enabled
    if (Helper.isValueNullOrEmpty(product.code) || !(params.isSRSEnabled ?? false)) {
      product.code = selectedVariant?.code;
      params.lineItem?.productCode = selectedVariant?.code;
    }

    variantController.text = variant?.name ?? "";
    unitController.text = Helper.isValueNullOrEmpty(variant?.uom) ? unitController.text : (variant?.uom?[0] ?? "");
    selectedVariant?.unit = unitController.text;
    String? desc = WorksheetHelpers.getItemCodeInDescription(
        supplierId: product.supplier?.id,
        productCode: product.code,
        variantCode: selectedVariant?.code,
        productDescription: product.description,
        lineItemDescription: params.lineItem?.description
    );
    if(desc != null) {
      descriptionController.text = desc;
    }
  }

  /// Helpers -----------------------------------------------------------------

  // [getMaterialPropList] returns a list of material property options
  // on the basis of [type]
  List<JPSingleSelectModel> getMaterialPropList(WorksheetMaterialPropType type) {
    List<String> tempOptionList = [];
    switch (type) {
      case WorksheetMaterialPropType.unit:
        // In case uom (Units of Measurement) is not available, using product units
        // as the selection options and uom otherwise
        tempOptionList = (Helper.isValueNullOrEmpty(selectedVariant?.uom)
            ? product.units
            : selectedVariant?.uom) ?? [];
        break;

      case WorksheetMaterialPropType.color:
        tempOptionList = product.colors ?? [];
        break;

      case WorksheetMaterialPropType.size:
        tempOptionList = product.sizes ?? [];
        break;

      case WorksheetMaterialPropType.style:
        tempOptionList = product.styles ?? [];
        break;

      case WorksheetMaterialPropType.variant:
        // using variant names as the variant options
        tempOptionList = product.variants?.map((e) => e.name ?? "").toSet().toList() ?? [];
        break;
    }

    return tempOptionList.map((option) => JPSingleSelectModel(
      label: option,
      id: option)
    ).toList();
  }

  // [getMaterialPropList] returns a list of material property controller
  // on the basis of [type] so data can be updated and selected option can be shown
  JPInputBoxController geMaterialPropController(WorksheetMaterialPropType type) {
    switch (type) {
      case WorksheetMaterialPropType.unit:
        return unitController;

      case WorksheetMaterialPropType.color:
        return colorController;

      case WorksheetMaterialPropType.size:
        return sizeController;

      case WorksheetMaterialPropType.style:
        return typeStyleController;

      case WorksheetMaterialPropType.variant:
        return variantController;
    }
  }

  /// [updateItemData] is responsible for updating items data on the basis of
  /// selected product including (selling price, unit cost etc.)
  void updateItemData(FinancialProductModel selectedItem) {
    selectedItem.productCategory ??= product.productCategory;
    selectedItem.categoryId ??= product.categoryId;
    product = selectedItem;
    nameController.text = product.name ?? "";
    unitController.text = product.unit ?? unitController.text;
    bool isSellingPriceEnabled = params.settings.enableSellingPrice ?? true;
    if(isSellingPriceEnabled) {
      if (!Helper.isValueNullOrEmpty(product.sellingPrice) && !Helper.isTrue(product.isSellingPriceNotAvailable)) {
        priceController.text = product.sellingPrice!;
      }
    } else {
      if (!Helper.isValueNullOrEmpty(product.unitCost)) {
        priceController.text = product.unitCost!;
      }
    }
    quantityController.text = "";
    selectedSupplier = product.supplier;
    supplierController.text = product.supplier?.name ?? "";
    selectedSupplierId = product.supplier?.id?.toString() ?? "";
    descriptionController.text = Helper.isValueNullOrEmpty(product.description) ? descriptionController.text : product.description!;
    // setting variant on selecting product
    setVariant(variant: !Helper.isValueNullOrEmpty(product.variants) ? product.variants![0] : null);
    priceQtyChange("");
  }

  /// Updaters ----------------------------------------------------------------

  /// [priceQtyChange] updates the total amount on the basis of price and quantity
  /// It is also responsible for updating the tax and profit amount whenever changes made in
  /// price or quantity
  void priceQtyChange(_) {
    final price = num.tryParse(priceController.text) ?? 0;
    final quantity = num.tryParse(quantityController.text) ?? 0;
    final total = price * quantity;
    // updating total price
    totalPrice = JobFinancialHelper.getRoundOff(total, fractionDigits: 2);
    // updating percentage amount
    onPercentChange(profitPercentController.text);
    // updating tax amount
    onPercentChange(taxPercentController.text, forTax: true);
    validateForm();
    update();
  }

  /// [onPercentChange] is responsible for updating the amount on the basis of percentage
  /// for both profit and tax
  /// flag [forTax] can be used to differentiate which amount has to be updated
  /// [true] - in case of updating tax amount
  /// [false] - in case of updating profit amount
  /// flag [avoidZero] can be used to avoid rounding fill in zero as a result
  void onPercentChange(String value, {
    bool forTax = false,
    bool avoidZero = true,
  }) {
    String result = "";
    // if value is empty no need to perform any calculations
    if (value.isNotEmpty) {
      num? percent = num.tryParse(value);
      num total = num.tryParse(totalPrice) ?? 0;
      // making margin calculation in case profit margin is selected
      bool isMargin = !params.settings.getIsLineItemProfitMarkup && !forTax;
      // calculating amount
      final tempResult = WorksheetCalculations.percentToAmount(percent, total, margin: isMargin);
      result = JobFinancialHelper.getRoundOff(tempResult, fractionDigits: 2, avoidZero: avoidZero);
    }
    // updating respective controller with calculated result
    if (forTax) {
      taxAmountController.text = result;
      taxAmount = result;
      taxPercent = value;
    }
    if (!forTax) {
      profitAmountController.text = result;
      profitAmount = result;
      profitPercent = value;
    }
  }

  /// [onAmountChange] is responsible for updating the percentage on the basis of amount
  /// for both profit and tax
  /// flag [forTax] can be used to differentiate which amount has to be updated
  /// [true] - in case of updating tax percent
  /// [false] - in case of updating profit percent
  /// flag [avoidZero] can be used to avoid rounding fill in zero as a result
  void onAmountChange(String value, {
    bool forTax = false,
    bool avoidZero = true,
  }) {
    String result = "";
    num tempResult = 0;
    // if value is empty no need to perform any calculations
    if (value.isNotEmpty) {
      num? amount = num.tryParse(value);
      num total = num.tryParse(totalPrice) ?? 0;
      // making margin calculation in case profit margin is selected
      bool isMargin = !params.settings.getIsLineItemProfitMarkup && !forTax;
      // calculating percentage
      tempResult = WorksheetCalculations.amountToPercent(amount, total, margin: isMargin);
      result = JobFinancialHelper.getRoundOff(tempResult, fractionDigits: 2, avoidZero: avoidZero);
    }
    // updating respective controller with calculated result
    if (forTax) {
      taxPercentController.text = result;
      taxPercent = tempResult.toString();
      taxAmount = value;
    }
    if (!forTax) {
      profitPercentController.text = result;
      profitPercent = tempResult.toString();
      profitAmount = value;
    }
  }

  void clearForm() {
    reInitialiseValues();
    update();
  }

  /// Validators --------------------------------------------------------------

  // [scrollAndFocus] helps in focusing on the error field in case validation fails
  void scrollAndFocus() {
    // checking for failed validation
    bool isCategoryError = FormValidator.requiredFieldValidator(typeController.text) != null;
    bool isNameError = FormValidator.requiredFieldValidator(nameController.text) != null;
    bool isUnitError = FormValidator.requiredFieldValidator(unitController.text) != null;

    if (isCategoryError) {
      typeController.scrollAndFocus();
    } else if (isNameError) {
      nameController.scrollAndFocus();
    } else if (isUnitError) {
      unitController.scrollAndFocus();
    }
  }

  void onNoteChange(String? note) {
  noteController.text = note ?? '';
  update();
  }

  Future<void> setPriceDetails() async {
    try {
      showJPLoader();
      final Map<String, dynamic> param = getPriceListParams();

      final Map<String, dynamic> response = await FinancialProductRepository().getPriceList(param, type: getSupplierType(), srsSupplierId: params.srsSupplierId);

      FinancialProductPrice? financialProductPrice;
      if(response['data'][product.code] is FinancialProductPrice) {
        financialProductPrice = response['data'][product.code] as FinancialProductPrice?;
      }
      if(response['data'][selectedVariant?.code] is FinancialProductPrice) {
        financialProductPrice = response['data'][selectedVariant?.code] as FinancialProductPrice?;
      }

      if(financialProductPrice?.price != null) {
        product.unitCost = financialProductPrice?.price;
      }

      if(params.settings.enableSellingPrice ?? false) {
        priceController.text = product.sellingPrice ?? '';
      } else {
        priceController.text = financialProductPrice?.price ?? "";
      }
      if(response['deleted_items'].contains(product.code) || response['deleted_items'].contains(selectedVariant?.code)) {
        product.notAvailable = true;
        product.notAvailableInPriceList = true;
      } else {
        product.notAvailable = false;
        product.notAvailableInPriceList = false;
      }
    } on DioException catch (e) {
      if(getSupplierType() == MaterialSupplierType.beacon) {
        WorksheetHelpers.handleBeaconError(e);
      } else {
        Helper.recordError(e);
      }
    } catch(e) {
      Helper.recordError(e);
    } finally {
      Get.back();
    }
  }

  void setVariantPrice(VariantModel? variantModel) {
    if (selectedVariant != variantModel) {
      Future<void>.delayed(const Duration(milliseconds: 200), () {
        setPriceDetails();
      });
    }
  }

  Map<String, dynamic> getPriceListParams() {
    return {
      'stop_price_compare': '1',
      if(Helper.isTrue(params.isSRSEnabled)) ...{
        'product_detail[0][product_code]': product.code,
        'product_detail[0][product_name]': product.name,
        'product_detail[0][variant_code]': selectedVariant?.code,
        'product_detail[0][unit]': selectedVariant?.unit,
        'branch_code': params.srsBranchCode,
        'supplier_id': params.srsSupplierId,
        'ship_to_sequence_number': params.shipToSequenceId
      },
      if(Helper.isTrue(params.isBeaconEnabled)) ...{
        'item_detail[0][item_code]': selectedVariant?.code,
        'item_detail[0][unit]': selectedVariant?.unit,
        'branch_code': params.beaconBranchCode,
        'account_id': params.beaconAccount?.accountId,
        'supplier_id': Helper.getSupplierId(key: CommonConstants.beaconId),
        'job_number': params.beaconJobNumber,
        ...CommonConstants.ignoreToastQueryParam
      },
      if (Helper.isTrue(params.isAbcEnabled)) ...{
        'item_detail[0][item_code]': selectedVariant?.code,
        'item_detail[0][unit]': selectedVariant?.unit,
        'branch_code': params.abcBranchCode,
        'supplier_account_id': params.supplierAccountId
      },
    };
  }

  MaterialSupplierType getSupplierType() {
    if(Helper.isTrue(params.isSRSEnabled)) {
      return MaterialSupplierType.srs;
    } else if(Helper.isTrue(params.isBeaconEnabled)) {
      return MaterialSupplierType.beacon;
    } else {
      return MaterialSupplierType.abc;
    }
  }

  void setPriceOnSelectUnit(String value) {
    if(selectedVariant != null) {
      Future<void>.delayed(const Duration(milliseconds: 200), () {
        selectedVariant?.unit = value;
        setPriceDetails();
      });
    }
  }

  /// [toggleConfirmedVariation] - toggles the confirmed variation flag of the line item
  void toggleConfirmedVariation() {
    isConfirmedVariation = !(isConfirmedVariation ?? false);
    update();
  }
}