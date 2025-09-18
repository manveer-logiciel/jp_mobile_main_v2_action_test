import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/account.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/constants/financial_constants.dart';
import '../../../enums/sheet_line_item_type.dart';
import '../../financial_product/financial_product_model.dart';
import '../../sheet_line_item/sheet_line_item_model.dart';
import '../../worksheet/worksheet_detail_category_model.dart';

class AddItemBottomSheetData {
  AddItemBottomSheetData({
    required this.update,
    required this.pageType,
    this.sheetLineItemModel,
    this.categoryId,
    this.srsBranchCode,
    this.shipToSequenceId,
    this.isDefaultTaxable = true,
    this.beaconAccount,
    this.beaconBranchCode,
    this.beaconJobNumber,
    this.forSupplierId,
    this.abcBranchCode,
    this.supplierAccountId
  });

  final VoidCallback update; // update method from respective controller to refresh ui from service itself

  JPInputBoxController activityController = JPInputBoxController();
  JPInputBoxController priceController = JPInputBoxController();
  JPInputBoxController qtyController = JPInputBoxController();
  JPInputBoxController unitController = JPInputBoxController();
  JPInputBoxController taxController = JPInputBoxController();
  JPInputBoxController depreciationController = JPInputBoxController();
  JPInputBoxController totalPriceController = JPInputBoxController();
  JPInputBoxController tradeController = JPInputBoxController();
  JPInputBoxController workTypeController = JPInputBoxController();

  FinancialProductModel? selectedActivityProduct;
  SheetLineItemModel? sheetLineItemModel;
  JPSingleSelectModel? selectedTrade;
  JPSingleSelectModel? selectedWorkType;

  bool validateItemFormOnDataChange = false;
  bool isLoading = false;
  bool isTaxable = true;
  bool isDefaultTaxable;
  bool isDefaultTaxableCopy = false;

  List<SheetLineItemModel> items = [];
  List<JPSingleSelectModel> tradesList = []; // used to store trades for dropdown
  List<JPSingleSelectModel> workTypeList = []; // used to store trades for dropdown
  List<MeasurementFormulaModel> measurementFormulas = [];

  double totalPrice = 0.00;
  double itemTotalPrice = 0.00;

  String productId = '';
  String? productSupplierId;
  String? productBranchCode;
  String? productCode ;
  String? categoryId;
  String? srsBranchCode;
  String? shipToSequenceId;

  String? beaconBranchCode;
  String? beaconJobNumber;
  int? forSupplierId;
  BeaconAccountModel? beaconAccount;
  String? abcBranchCode;
  String? supplierAccountId;

  final AddLineItemFormType pageType;
  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  ///////////////////////////     INIT FORM FIELDS     /////////////////////////
  
  void initFormData() {
    isDefaultTaxableCopy = isDefaultTaxable;
    if(sheetLineItemModel != null) {
      measurementFormulas = sheetLineItemModel?.measurementFormulas ?? [];
      productId = sheetLineItemModel?.productId ?? "-1";
      productCode = sheetLineItemModel?.productCode ?? '';
      unitController.text = sheetLineItemModel?.unit ?? '';
      taxController.text = sheetLineItemModel?.tax ?? '';
      depreciationController.text = sheetLineItemModel?.depreciation ?? '';
      activityController.text = sheetLineItemModel?.title ?? "";
      priceController.text = sheetLineItemModel?.price ?? "";
      qtyController.text = sheetLineItemModel?.qty ?? "";
      isTaxable = sheetLineItemModel?.isTaxable ?? true;
      getDataFromTrade(sheetLineItemModel?.tradeType?.id.toString() ?? "");
      selectedWorkType = sheetLineItemModel?.workType;
      workTypeController.text = selectedWorkType?.label ?? "";
      if(sheetLineItemModel?.productCategorySlug == FinancialConstant.noCharge) isDefaultTaxable = false;

      selectedActivityProduct = FinancialProductModel(
        id: int.tryParse(productId),
        name: sheetLineItemModel?.title ?? "",
        sellingPrice: sheetLineItemModel?.price ?? "",
        productCategory: WorksheetDetailCategoryModel(slug: sheetLineItemModel?.productCategorySlug)
      );

      productSupplierId = sheetLineItemModel?.supplierId;
      productBranchCode = sheetLineItemModel?.branchCode;
    }
    if(!isDefaultTaxable) isTaxable = false;
    initialJson = addItemFormJson();
    update();
  }

  /////////////////////////////     SAVE TRADES     ////////////////////////////
  void getDataFromTrade(String val) {
    selectedTrade = tradesList.firstWhereOrNull((element) => element.id == val);
    tradeController.text = selectedTrade?.label ?? "";
    workTypeList = [];
    workTypeController.text = "";
    selectedWorkType = null;
    selectedTrade?.additionalData.forEach((dynamic element) {
      workTypeList.add(JPSingleSelectModel(
        id: element.id.toString(),
        label: element.label,
      ));
    });
    update();
  }

  Map<String, dynamic> addItemFormJson() {
    final data = <String, dynamic>{};

    data['product_id'] = productId;
    data['activity'] = activityController.text;

    data['trade_id'] = selectedTrade?.id;
    data['trade_label'] = selectedTrade?.label;

    data['work_type_id'] = selectedWorkType?.id;
    data['work_type_label'] = selectedWorkType?.label;

    data['price'] = priceController.text;
    data['quantity'] = qtyController.text;

    data['depreciation_value'] = depreciationController.text;
    data['tax'] = taxController.text;

    data['is_taxable'] = isTaxable;

    return data;
  }
}