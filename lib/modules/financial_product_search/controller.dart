import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_price.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/financial_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/component/debounce.dart';
import '../../common/models/financial_product/financial_product_model.dart';
import '../../common/models/financial_product_search/financial_product_search.dart';
import '../../common/models/pagination_model.dart';
import '../../common/repositories/financial_product.dart';
import '../../common/services/worksheet/helpers.dart';

class FinancialProductController extends GetxController {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TextEditingController searchTextController = TextEditingController();

  bool isLoading = false;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool enableAddButton = Get.arguments?[NavigationParams.enabledAddButton] ?? true;
  bool isAddButtonVisible = false;

  List<FinancialProductModel> financialProducts = [];

  FinancialProductSearchModel filterKeys = Get.arguments?[NavigationParams.filterParams] ?? FinancialProductSearchModel();

  AddLineItemFormType? pageType = Get.arguments?[NavigationParams.addLineItemFormType];

  dynamic isRestrictCustomProduct = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.restrictCustomProductAddition);

  final Debounce _debounce = Debounce(const Duration(milliseconds: 0));

  String? worksheetType = Get.arguments?[NavigationParams.worksheetType];

  bool get isEstimateOrProposalWorksheet => worksheetType == WorksheetConstants.estimate ||
      worksheetType == WorksheetConstants.proposal;

  @override
  void onInit() {
    super.onInit();
    initialSearch();
  }

  Future<void> loadMore() async {
    filterKeys.page += 1;
    isLoadMore = true;
    await fetchSearchResults();
  }

  String getHintText() {
    switch (pageType) {
      case AddLineItemFormType.insuranceForm:
        return 'search_material_product_here'.tr.capitalize!;
      case AddLineItemFormType.worksheet:
        return '${'search'.tr} ${filterKeys.title!.toLowerCase()} ${'here'.tr}';
      default:
        return 'search_financial_product_here'.tr;
    }
  }

  Future<void> fetchSearchResults() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();
      Map<String, dynamic> response = await FinancialProductRepository().getSearchResult(queryParams);

      if (!isLoadMore) {
        financialProducts.clear();
      }

      if (pageType != AddLineItemFormType.changeOrderForm && pageType != AddLineItemFormType.invoiceForm) {
        await fetchProductPriceList(response["list"]);
      }
      financialProducts.addAll(response["list"]);

      PaginationModel pagination = PaginationModel.fromJson(response['pagination']);

      canShowLoadMore = financialProducts.length < (pagination.total ?? 0);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }

  MaterialSupplierType? getSupplierType() {
    if (filterKeys.srsBranchCode != null) {
      return MaterialSupplierType.srs;
    } else if (filterKeys.beaconBranchCode != null) {
      return MaterialSupplierType.beacon;
    } else if (filterKeys.abcBranchCode != null) {
      return MaterialSupplierType.abc;
    }
    return null;
  }

  Future<void> fetchProductPriceList(List<FinancialProductModel> list) async {
    try {
      MaterialSupplierType? supplierType = getSupplierType();
      if (list.isNotEmpty && supplierType != null) {
            final params = getPriceListParams(list);
            if(isProductItemDetailsEmpty(supplierType, params)) return;

            Map<String, dynamic> priceListResult = await FinancialProductRepository().getPriceList(params, type: supplierType, srsSupplierId: filterKeys.srsSupplierId);

            if (priceListResult['data'] != null) {
              final Map<String, FinancialProductPrice> productsPriceJson = priceListResult['data'];
              final List<String> deletedProductsCode = priceListResult['deleted_items'];

              if(supplierType == MaterialSupplierType.beacon || supplierType == MaterialSupplierType.abc) {
                for(var i = 0; i < list.length; i++) {
                  String? productCode = list[i].variants?.firstOrNull?.code;
                  if(!Helper.isValueNullOrEmpty(productCode)) {
                    final productPrice = productsPriceJson[productCode];
                    list[i].sellingPrice = productPrice?.selllingPrice ?? list[i].sellingPrice ?? '';
                    list[i].unitCost = productPrice?.price ?? list[i].unitCost ?? '';

                    if (deletedProductsCode.contains(productCode)) {
                      list[i].notAvailableInPriceList = true;
                    }
                  }
                }
              } else {
                for (var i = 0; i < list.length; i++) {
                  String? productCode = list[i].code;
                  final productPrice = productsPriceJson[productCode];
                  list[i].sellingPrice = productPrice?.selllingPrice ?? list[i].sellingPrice ?? '';
                  list[i].unitCost = productPrice?.price ?? list[i].unitCost ?? '';

                  if (deletedProductsCode.contains(productCode)) {
                    list[i].notAvailableInPriceList = true;
                  }

                }
              }
            }
          }
    } on DioException catch (e) {
      if (getSupplierType() == MaterialSupplierType.beacon) {
        WorksheetHelpers.handleBeaconError(e);
      }
    }
  }

  Map<String, dynamic> getPriceListParams(List<FinancialProductModel> list) {
    final supplierType = getSupplierType();

    switch (supplierType) {
      case MaterialSupplierType.srs:
        final List<Map<String, dynamic>> itemsCodesList = [];
         for(var item in list) {
           if (!Helper.isValueNullOrEmpty(item.variants)) {
             itemsCodesList.add({
               if(!Helper.isValueNullOrEmpty(item.variants?.firstOrNull?.code))
                 'product_code': item.code,
               'unit': Helper.isValueNullOrEmpty(
                   item.variants?.firstOrNull?.uom) ?
               '' : item.variants?.firstOrNull?.uom?.firstOrNull?.toString(),
               'product_name': item.name,
               'variant_code': item.variants?.firstOrNull?.code,
             });
           } else {
             itemsCodesList.add({
               if(!Helper.isValueNullOrEmpty(item.code))
                 'item_code': item.code,
               'unit': item.unit
             });
           }
         }
        return {
          'ship_to_sequence_number': filterKeys.shipToSequenceId!,
          'branch_code': filterKeys.srsBranchCode!,
          if(Helper.isSRSv2Id(filterKeys.srsSupplierId))
          'product_detail': itemsCodesList.toList()
          else
          'item_detail': itemsCodesList.toList()
        };
      case MaterialSupplierType.beacon:
      /// Get list of variant code
        final List<String> itemCodes = [];
        for (var item in list) {
          if (item.variants != null) {
            for (var variant in item.variants!) {
              if (!itemCodes.contains(variant.code) && !Helper.isValueNullOrEmpty(variant.code)) {
                itemCodes.add(variant.code!);
              }
            }
          } else if (!itemCodes.contains(item.code) && !Helper.isValueNullOrEmpty(item.code)) {
            itemCodes.add(item.code!);
          }
        }
        Map<String, dynamic> queryParams = {
          'account_id': filterKeys.beaconAccount?.accountId,
          'branch_code': filterKeys.beaconBranchCode,
          if (!Helper.isValueNullOrEmpty(filterKeys.beaconJobNumber))
            'job_number': filterKeys.beaconJobNumber,
          'item_detail': itemCodes.map((item) => {'item_code': item}).toList(),
          'ignoreToast': true
        };
        return queryParams;
      case MaterialSupplierType.abc:
        final List<Map<String, dynamic>> itemsCodesList = [];
        for(var item in list) {
          if(!Helper.isValueNullOrEmpty(item.variants)) {
            if (!Helper.isValueNullOrEmpty(item.variants?.first.uom)) {
              itemsCodesList.add({
                'item_code': item.variants?.first.code,
                'unit': item.variants!.first.uom?.first
              });
            }
          }
        }
        return {
          'supplier_account_id': filterKeys.supplierAccountId,
          'branch_code': filterKeys.abcBranchCode,
          'item_detail': itemsCodesList.toList(),
        };
      default:
        return {};
    }
  }

  Map<String, dynamic> getQueryParams() {
    switch (pageType) {
      case AddLineItemFormType.insuranceForm:
        return getInsuranceParams();
        
      case AddLineItemFormType.worksheet:
      case AddLineItemFormType.changeOrderForm:
      case AddLineItemFormType.invoiceForm:
        return getWorksheetParams();

      default:
        return getDefaultQueryParams();  
    }
  }

  Map<String, dynamic> getWorksheetParams() {
    filterKeys.name = searchTextController.text.trim().toString();
    filterKeys.onlyQbdProducts = 0;
    filterKeys.includeSrsProducts = filterKeys.srsBranchCode != null;
    filterKeys.includes = [
      'measurement_formulas',
      // 'variants' include helps in retrieving
      if (filterKeys.hasSupplier) 'variants',
      if (filterKeys.beaconBranchCode != null) ...{
        'measurement_formulas_count',
        'qbd_queue_status',
      },
      if (filterKeys.selectedCategorySlug == FinancialConstant.labor) 'labor',
      if(filterKeys.hasSupplier) 'financial_product_detail',
      'supplier.divisions'
    ];
    Map<String, dynamic> queryParams = filterKeys.toJson();
    if(!(filterKeys.jobDivision?.enableAllSupplierSearch ?? false)) {
      queryParams['supplier_division_ids[]'] = filterKeys.jobDivision?.id;
    }
    queryParams.removeWhere((dynamic key, dynamic value) => (key == null || value == null));
    return queryParams;

  }

  Map<String, dynamic> getInsuranceParams(){
    filterKeys.description = searchTextController.text.trim().toString();
    filterKeys.categoryName = 'INSURANCE';
    filterKeys.includes = ['measurement_formulas', 'trade'];
    Map<String, dynamic> queryParams = filterKeys.toJson();
    queryParams.removeWhere((dynamic key, dynamic value) => (key == null || value == null));
    return queryParams;
  }

  Map<String, dynamic> getDefaultQueryParams() {
    filterKeys.name = searchTextController.text.trim().toString();
    Map<String, dynamic> queryParams = filterKeys.toJson();
    queryParams.removeWhere((dynamic key, dynamic value) => (key == null || value == null));
    return queryParams;
  }

  void search(String val) {
    filterKeys.page = 1;
    isLoading = true;
    update();
    if (val.trim().isNotEmpty) {
      fetchSearchResults();
    } else {
      financialProducts.clear();
      isLoading = false;
      update();
    }
  }
  
  void initialSearch() {
    String query = filterKeys.name ?? '';
    if(query.isNotEmpty) {
     searchTextController.text = query;
     search(query);
    }
    setAddButtonVisibility();
  }

  void setAddButtonVisibility() {
    isAddButtonVisible = !Helper.isTrue(isRestrictCustomProduct) || enableAddButton;
  }

  void onTapItem({int? index}) {
    FinancialProductModel financialProductModel = getFinancialProduct(index);
    Get.back(result: financialProductModel);
  }
  
  FinancialProductModel getFinancialProduct(int? index) {
    if (index == null) {
      return FinancialProductModel(name: searchTextController.text.trim());
    } else {
      return financialProducts[index];
    }
  }

  bool isProductItemDetailsEmpty(MaterialSupplierType supplierType, Map<String, dynamic> params) {
    return (Helper.isSRSv2Id(filterKeys.srsSupplierId) &&
        supplierType == MaterialSupplierType.srs && Helper.isValueNullOrEmpty(params['product_detail'])) ||
        (!Helper.isSRSv2Id(filterKeys.srsSupplierId) &&
            supplierType == MaterialSupplierType.srs && Helper.isValueNullOrEmpty(params['item_detail'])) ||
        (supplierType == MaterialSupplierType.abc && Helper.isValueNullOrEmpty(params['item_detail']));
  }

  void debouncingSearch(String query) {
    int delay = 0;
    if (query.length == 1) {
      delay = 1500; // For 1 character
    } else if (query.length == 2) {
      delay = 1000; // For 2 character
    } else {
      delay = 700; // For 3 or more characters
    }

    _debounce.delay = Duration(milliseconds: delay);
    _debounce.call(() {
      Helper.cancelApiRequest();
      search(query);
    });
  }

  @override
  void dispose() {
    _debounce.dispose();
    super.dispose();
  }

  bool showSellingPriceUnavailable(int index) {
    return financialProducts[index].showSellingPriceNotAvailable(
        pageType,
        isEstimateOrProposalWorksheet,
        Helper.isTrue(filterKeys.isSellingPriceEnabled)
    );
  }
}

