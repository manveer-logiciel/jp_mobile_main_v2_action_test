import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/macro.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';
import '../../../common/enums/supplier_form_type.dart';
import '../../../common/models/financial_product/financial_product_price.dart';
import '../../../common/models/macros/index.dart';
import '../../../common/models/sheet_line_item/sheet_line_item_model.dart';
import '../../../common/models/snippet_listing/snippet_list_param.dart';
import '../../../common/repositories/financial_product.dart';
import '../../../common/repositories/macros.dart';
import '../../../common/services/run_mode/index.dart';
import '../../../common/services/worksheet/helpers.dart';
import '../../loader/index.dart';

class MacroProductController extends GetxController {

  bool isLoading = true;
  bool isLoadingMore = false;
  
  CancelToken? cancelToken = CancelToken();
  
  String? macroId = Get.arguments?[ NavigationParams.macroId];
  MacrosListType type = Get.arguments?[NavigationParams.macroType];
  bool? isEnableSellingPrice = Get.arguments?[NavigationParams.isEnableSellingPrice];
  String? beaconBranchCode = Get.arguments?[NavigationParams.beaconBranchCode];
  String? srsBranchCode = Get.arguments?[NavigationParams.srsBranchCode];
  String? abcBranchCode = Get.arguments?[NavigationParams.abcBranchCode];
  String? shipToSequenceId = Get.arguments?[NavigationParams.shipToSequenceId];
  int? srsSupplierId = Get.arguments?[NavigationParams.srsSupplierId];

  List<SheetLineItemModel> macroDetail = [];

  List<JPSingleSelectModel> macroDetailPricingList = [
    JPSingleSelectModel(id: 'true', label: 'selling_price'.tr),
    JPSingleSelectModel(id: 'false', label: 'unit_cost'.tr),
  ];

  SnippetListingParamModel macroListingParam = SnippetListingParamModel();

  String? beaconAccountId;
  String? abcAccountId;

  @override

  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      await viewMacroDetail(macroId!);
      await updateSupplierProductDetails();
    } catch (e) {
      rethrow;
    } finally {
      togglePriceSelection(isEnableSellingPrice);
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> viewMacroDetail(String macroId) async {
    String? branchCode = WorksheetHelpers.getBranchCode(srsBranchCode, beaconBranchCode, abcBranchCode);
    int? supplierId = WorksheetHelpers.getSupplierId(srsBranchCode, abcBranchCode, srsSupplierId);

    final params = MacroListingModel.getViewMacrosParams(macroId, branchCode: branchCode, supplierId: supplierId);
    Map<String, dynamic> response = await MacrosRepository().fetchMacroDetail(params, macroId);
    if (!response["data"].entries.isEmpty) {
      setAccountId(response["data"]);
    }
    List<SheetLineItemModel> list = response['list'];

    if (!isLoadingMore) {
      macroDetail = [];
    }

    for (var item in list) {
      item.totalPrice = (num.tryParse(item.qty  ?? '0')! * num.tryParse(item.price ?? '0')!).toString();
      item.sellingPrice ??= item.product?.sellingPrice ?? '';
      item.showSellingPrice = Helper.isTrue(isEnableSellingPrice);
      macroDetail.add(item.. canShowName = type != MacrosListType.xactimateEstimate);
    }
  }
   
  void cancelOnGoingRequest() {
     cancelToken?.cancel();
  }
  /// [showPriceSelectionSheet] opens up worksheet pricing sheet to switch pricing
  void showPriceSelectionSheet() {
    FormValueSelectorService.openSingleSelect(
      list: macroDetailPricingList,
      title: 'set_worksheet_pricing'.tr,
      selectedItemId: isEnableSellingPrice.toString(),
      onValueSelected: (id) {
        isEnableSellingPrice = Helper.isTrue(id);
        togglePriceSelection(isEnableSellingPrice);
        Future.delayed(const Duration(milliseconds: 500), () {
          updateSupplierProductDetails();
        });
      },
    );
  }
  

  /// [togglePriceSelection] toggle pricing selection to switch pricing
  void togglePriceSelection(bool? isEnableSellingPrice) {
    for (int i = 0; i < macroDetail.length; i++) {
      SheetLineItemModel detail = macroDetail[i];
      double qty = double.tryParse(detail.qty ?? "") ?? 0;

      final tempPrice = isEnableSellingPrice ?? false ? detail.sellingPrice : detail.price;
      double price = double.tryParse(tempPrice ?? "") ?? 0;
      detail.totalPrice = (qty * price).toString();
      detail.showSellingPrice = isEnableSellingPrice ?? false;
    }
    update();
  }

  /// [updateSupplierProductDetails] helps to check product item is available on selected branch & update their product details
  Future<void> updateSupplierProductDetails() async {
    if (RunModeService.isUnitTestMode) return;

    // Otherwise loading the price and product details, updating them and
    // then calculating the price
    try {
      showJPLoader();
      await updateSupplierProducts();
    } catch (e) {
      rethrow;
    } finally {
      Get.back(); // close loader dialog
      update();
    }
  }

  Future<void> updateSupplierProducts() async {
    List<SheetLineItemModel> items = WorksheetHelpers.getParsedItems(lineItems: macroDetail);
    MaterialSupplierType? supplierType = getSelectedSupplier();
    List<Map<String, dynamic>> itemDetails = [];

    if(supplierType == MaterialSupplierType.srs) {
      bool hasSRSItem = items.any((item) => Helper.isSRSv1Id(int.tryParse(item.supplierId!)) || Helper.isSRSv2Id(int.tryParse(item.supplierId!)));
      if (items.isEmpty || !hasSRSItem) return;
    } else if(supplierType == MaterialSupplierType.beacon) {
      bool hasBeaconItem = items.any((item) => Helper.isBeaconSupplierId(int.tryParse(item.supplierId ?? '')));
      if (items.isEmpty || !hasBeaconItem) return;
    } else if(supplierType == MaterialSupplierType.abc) {
      bool hasAbcItem = items.any((item) => Helper.isABCSupplierId(int.tryParse(item.supplierId ?? '')));
      if (items.isEmpty || !hasAbcItem) return;
    } else {
      return;
    }
    setParamsForSupplierProductApi(items, itemDetails);
    await fetchProductPrice(items, itemDetails);
  }

  /// [setParamsForSupplierProductApi] helps to set parameters for product detail & price api
  void setParamsForSupplierProductApi(List<SheetLineItemModel> items, List<Map<String, dynamic>> itemDetails) {

    for (SheetLineItemModel lineItem in items) {
      String? productCode = lineItem.productCode ?? lineItem.product?.code;

      VariantModel? variantModel = lineItem.variants?.firstOrNull;
      if(!Helper.isValueNullOrEmpty(variantModel)) {
        if(abcBranchCode == null) {
          productCode ??= variantModel?.code;
        } else {
          productCode = variantModel?.code;
        }
        lineItem.unit ??= variantModel?.uom?.firstOrNull;
      }

      if (lineItem.unit != null) {
        if(Helper.isSRSv2Id(srsSupplierId)) {
          itemDetails.add({
            'product_code': productCode,
            'unit': lineItem.unit!,
            'product_name': lineItem.name,
            'variant_code': variantModel?.code,
          });
        } else {
          itemDetails.add({
            'item_code': productCode,
            'unit': lineItem.unit!,
          });
        }
      }
    }
  }

  /// [fetchProductPrice] helps to fetch all product prices
  Future<void> fetchProductPrice(List<SheetLineItemModel> items, List<Map<String, dynamic>> itemDetails) async {
    final Map<String, FinancialProductPrice> productsPriceJson = {};
    final selectedSupplier = getSelectedSupplier();

    if (itemDetails.isNotEmpty && selectedSupplier != null) {
      final params = {
        if (shipToSequenceId != null) ...{
          'ship_to_sequence_number': shipToSequenceId,
          'supplier_id': srsSupplierId,
          'branch_code': srsBranchCode,
        },
        if(beaconBranchCode != null)
          'account_id': beaconAccountId,
        if(abcBranchCode != null) ...{
          'branch_code': abcBranchCode,
          'supplier_account_id': abcAccountId
        },
        if(Helper.isSRSv2Id(srsSupplierId)) ...{
          'product_detail': itemDetails,
        } else ...{
          'item_detail': itemDetails,
        }
      };
      Map<String, dynamic> priceListResult = await FinancialProductRepository()
          .getPriceList(params, type: selectedSupplier, srsSupplierId: srsSupplierId);

      if (priceListResult['data'] != null) {
        productsPriceJson.addAll(priceListResult['data']);
      }
    }

    for (SheetLineItemModel lineItem in items) {
      setProductDetails(lineItem, productsPriceJson);
    }
  }

  /// [setProductDetails] helps to set all product detail & price in lineItem
  void setProductDetails(SheetLineItemModel lineItem, Map<String, FinancialProductPrice> productsPriceJson) {
    String? productCode = lineItem.productCode ?? lineItem.product?.code;
    if(abcBranchCode == null) {
      productCode ??= lineItem.variants?.firstOrNull?.code;
    } else {
      productCode = lineItem.variants?.firstOrNull?.code;
    }
    final tempProduct = lineItem.product;

    if (productCode != null) {
      if (productsPriceJson.containsKey(productCode)) {
        final productPrice = productsPriceJson[productCode];
        if(Helper.isTrue(isEnableSellingPrice)) {
          lineItem.price = lineItem.product?.sellingPrice = productPrice?.selllingPrice ?? tempProduct?.sellingPrice ?? '';
        } else {
          lineItem.price = productPrice?.price ?? tempProduct?.sellingPrice ?? '';
        }
      }
    }
    updateTotalPrice();
  }

  MaterialSupplierType? getSelectedSupplier() {
    if(srsBranchCode != null) {
      return MaterialSupplierType.srs;
    } else if(beaconBranchCode != null) {
      return MaterialSupplierType.beacon;
    } else if(abcBranchCode != null) {
      return MaterialSupplierType.abc;
    } else {
      return null;
    }
  }

  void updateTotalPrice() {
    for(SheetLineItemModel item in macroDetail) {
      item.totalPrice = (num.tryParse(item.qty  ?? '0')! * num.tryParse(item.price ?? '0')!).toString();
      item.sellingPrice ??= item.product?.sellingPrice ?? '';
      item.showSellingPrice = Helper.isTrue(isEnableSellingPrice);
    }
    update();
  }

  void setAccountId(Map<String, dynamic> branch) {
    if(beaconBranchCode != null && !Helper.isValueNullOrEmpty(branch["beacon_account"]["account_id"])) {
      beaconAccountId = branch["beacon_account"]["account_id"]?.toString();
    } else if(abcBranchCode != null && !Helper.isValueNullOrEmpty(branch["supplier_accounts"]["data"])) {
      if(branch["supplier_accounts"]["data"][0]["account_id"] != null) {
        abcAccountId = branch["supplier_accounts"]["data"][0]["account_id"];
      }
    }
  }
}
