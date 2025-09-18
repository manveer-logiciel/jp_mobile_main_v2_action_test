import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import '../../../../../core/constants/financial_constants.dart';
import '../../../../../core/utils/form/db_helper.dart';
import '../../../../../core/utils/form/validators.dart';
import '../../../../../global_widgets/financial_form/add_item_bottom_sheet/controller.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../enums/sheet_line_item_type.dart';
import '../../../../models/financial_product/financial_product_model.dart';
import '../../../../models/forms/add_item_bottom_sheet/index.dart';
import '../../../../models/sheet_line_item/sheet_line_item_model.dart';
import '../../../forms/value_selector.dart';

class AddItemBottomSheetService extends AddItemBottomSheetData {

  AddItemBottomSheetService({
    required super.update,
    required this.validateForm,
    super.categoryId,
    super.srsBranchCode,
    super.shipToSequenceId,
    required super.pageType,
    super.sheetLineItemModel,
    super.isDefaultTaxable,
    super.beaconBranchCode,
    super.beaconJobNumber,
    super.forSupplierId,
    super.beaconAccount,
    super.abcBranchCode,
    super.supplierAccountId
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  AddItemBottomSheetController? _controller; // helps in managing controller without passing object

  AddItemBottomSheetController get controller => _controller ?? AddItemBottomSheetController();

  set controller(AddItemBottomSheetController value) => _controller = value;

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();
    try {
      await setUpData(); // loading form data from server
      initFormData(); // filling form data
    } catch (e) {
      rethrow;
    } finally {
      calculatePriceChange();
      isLoading = false;
      Get.back();
      update();
    }
  }

  //////////////////////////     FETCH DATA FORM DB     ////////////////////////

  Future<void> setUpData() async {
    try {
      updateIsLoading();
      tradesList = await FormsDBHelper.getAllTrades();
    } catch(e) {
      rethrow;
    } finally {
      updateIsLoading();
    }
  }

  ///////////////////////////     SELECT ACTIVITY     //////////////////////////

  Future<void> selectActivity() async {
    FinancialProductModel? result = await FormValueSelectorService.searchFinancialProduct(
      FinancialProductSearchModel(
        name: activityController.text.toString(),
        categoryId: categoryId,
        includeSrsProducts: srsBranchCode != null,
        srsBranchCode: srsBranchCode,
        includes: srsBranchCode != null ? ['financial_product_detail'] : [],
        shipToSequenceId: shipToSequenceId,
        beaconBranchCode: beaconBranchCode,
        beaconJobNumber: beaconJobNumber,
        forSupplierId: forSupplierId,
        beaconAccount: beaconAccount,
        abcBranchCode: abcBranchCode,
        supplierAccountId: supplierAccountId
      ),
      pageType,
    );
    if(result != null) {
      saveItemValues(result);
      if(validateItemFormOnDataChange) {
        validateForm();
      }
      update();
    }
  }

  void saveItemValues(FinancialProductModel financialProductModel) {
    switch (pageType) {
      case AddLineItemFormType.insuranceForm:
        saveInsuranceItemValues(financialProductModel);
        break;
      default:
        saveDefaultItemValues(financialProductModel);
    }
  }

  void saveInsuranceItemValues(FinancialProductModel financialProductModel){
    productId = financialProductModel.id?.toString() ?? '';
    activityController.text = financialProductModel.name.toString();
    productCode = financialProductModel.code ?? '';
    unitController.text = financialProductModel.unit ?? '';
    priceController.text = financialProductModel.unitCost ?? '';
    measurementFormulas = financialProductModel.measurementFormulas ?? []; 
    productSupplierId = financialProductModel.supplier?.id.toString();
    productBranchCode = financialProductModel.branchCode;
    validateForm();
  }
  
  void saveDefaultItemValues(FinancialProductModel financialProductModel) {
    selectedActivityProduct = financialProductModel;
    productId = financialProductModel.id?.toString() ?? "";
    activityController.text = getActivityText(financialProductModel);
    priceController.text = financialProductModel.sellingPrice ?? '';
    if(financialProductModel.productCategory?.slug == FinancialConstant.noCharge) {
      isDefaultTaxable = false;
      isTaxable = false;
      update();
    } else {
      isDefaultTaxable = isDefaultTaxableCopy;
      isTaxable = isDefaultTaxable;
      update();
    }
    productSupplierId = financialProductModel.supplier?.id?.toString();
    productBranchCode = financialProductModel.branchCode;
    validateForm();
    onChangePriceOrQty();
  }

  String getActivityText(FinancialProductModel financialProductModel) {
    String text = "";
    ///   product name
    if(financialProductModel.productCategory?.slug == FinancialConstant.noCharge) {
      text += financialProductModel.productCategory?.name ?? "";
      text += text.isEmpty ? "" : " / ";
    }
    ///   name
    text += financialProductModel.name ?? "";
    text += text.isNotEmpty && (financialProductModel.description?.isEmpty ?? true) ? "" : " - ";
    ///   description
    text += financialProductModel.description ?? "";

    return text;
  }

  /////////////////////////     PRICE CALCULATIONS    //////////////////////////

  void onChangePriceOrQty() {
    double price = 0.0;
    double qty = 0.0;
    if(FormValidator.validatePrice(priceController.text.trim()) == null) {
      price = double.tryParse(priceController.text.toString()) ?? 0;
    }
    if(FormValidator.validateQty(qtyController.text.trim()) == null) {
      qty = double.tryParse(qtyController.text.toString()) ?? 0;
    }
    itemTotalPrice = price * qty;
    update();
  }

  double calculateItemsPrice() {
    var sumOfPrice = 0.0;
    for (var item in items) {
      sumOfPrice += double.parse(item.totalPrice ?? "0");
    }
    return sumOfPrice;
  }

  ////////////////////////////     SELECT TRADES     ///////////////////////////

  void selectTrade() {
    FormValueSelectorService.openSingleSelect(
        title: 'select_trade'.tr,
        list: tradesList,
        controller: tradeController,
        selectedItemId: selectedTrade?.id ?? "",
        onValueSelected: getDataFromTrade);
  }

  ///////////////////////////     SELECT WORK TYPE     /////////////////////////

  void selectWorkType() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_work_type'.tr,
      list: workTypeList,
      controller: workTypeController,
      selectedItemId: selectedWorkType?.id ?? "",
      onValueSelected: updateWorkType);
  }

  void updateWorkType(String val) {
    selectedWorkType = workTypeList.firstWhereOrNull((element) => element.id == val);
    workTypeController.text = selectedWorkType?.label ?? "";
    update();
  }

  //////     saveForm():  makes a network call to save/update form     /////////

  Future<void> saveForm({Function(SheetLineItemModel p1)? onSave}) async {
    try {
      onSave!(SheetLineItemModel(
        pageType: pageType,
        currentIndex: sheetLineItemModel?.currentIndex,
        productId: productId,
        unit: unitController.text,
        depreciation: depreciationController.text,
        tax: taxController.text,
        title: activityController.text.toString(),
        price:priceController.text.isEmpty ? '0.0' : num.parse(priceController.text.toString()).toString(),
        qty: qtyController.text.isEmpty ? '0': num.parse(qtyController.text.toString()).toString(),
        totalPrice: itemTotalPrice.toString(),
        tradeType: selectedTrade,
        workType: selectedWorkType,
        isTaxable: isTaxable,
        measurementFormulas: measurementFormulas,
        productCategorySlug: selectedActivityProduct?.productCategory?.slug,
        supplierId: productSupplierId,
        branchCode: productBranchCode
      ));
      totalPrice = calculateItemsPrice();
      update();
      Get.back();
    } catch (e) {
      rethrow;
    }
  }

  //////////////////////////////////////////////////////////////////////////////

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    if (FormValidator.requiredFieldValidator(activityController.text) != null) {
      activityController.scrollAndFocus();
    } else if(FormValidator.validatePrice(priceController.text) != null) {
      priceController.scrollAndFocus();
    } else if(FormValidator.validateQty(qtyController.text) != null) {
      qtyController.scrollAndFocus();
    } else if(FormValidator.validateUnit(unitController.text) != null) {
      unitController.scrollAndFocus();
    }
  }

  void updateIsLoading() {
    isLoading = !isLoading;
    update();
  }

  void toggleIsTaxable(bool val) {
    isTaxable = !isTaxable;
    update();
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = addItemFormJson();
    return initialJson.toString() != currentJson.toString();
  }

  void priceQtyChange(String value) {
    calculatePriceChange();
    validateForm();
  }

  void calculatePriceChange() {
    double price = double.tryParse(priceController.text) ?? 0;
    double qty = double.tryParse(qtyController.text) ?? 0;
    itemTotalPrice = price * qty;
    update();
  }
}