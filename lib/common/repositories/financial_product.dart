import 'dart:convert';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_price.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/core/constants/urls.dart';
import '../../core/utils/helpers.dart';
import '../models/financial_product/financial_product_model.dart';
import '../providers/http/interceptor.dart';

class FinancialProductRepository {
   Future<Map<String,dynamic>> getSearchResult(Map<String,dynamic> params) async {
     try{
       final response = await dio.get(Urls.financialProducts,queryParameters: params);
       final myJson = json.decode(response.toString());
       List<FinancialProductModel> list = [];
       Map<String, dynamic> dataToReturn = {
         "list": list,
         "pagination": myJson["meta"]["pagination"]
       };

       myJson["data"].forEach((dynamic map) => dataToReturn['list'].add(FinancialProductModel.fromJson(map)));
       return dataToReturn;
     } catch(e) {
       rethrow;
     }
   }

  Future<Map<String,dynamic>> getSrsProductResult(Map<String, dynamic> params) async {
     try{
       final response = await dio.get(Urls.financialProducts, queryParameters: params);

       final jsonData = json.decode(response.toString());

       final Map<String, FinancialProductModel> productsJson = {};

       jsonData["data"].forEach((dynamic product) {
        FinancialProductModel productModel = FinancialProductModel.fromJson(product);
        if (productModel.code != null) {
          productsJson[productModel.code!] = productModel;
        }
       });

       Map<String, dynamic> dataToReturn = {
         "products_json": productsJson,
         "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"]),
       };

       return dataToReturn;
     } catch(e) {
       rethrow;
     }
   }

   /// [getPriceList] Retrieves the price list based on the specified parameters and material supplier type.
   ///
   /// Returns a Future containing a Map of product prices and deleted item codes.
   Future<Map<String,dynamic>> getPriceList(Map<String, dynamic> params, {
     required MaterialSupplierType type,
     required int? srsSupplierId
   }) async {
     try {
       // The URL for fetching the price list.
       String getPriceListUrl = "";

       switch (type) {
         case MaterialSupplierType.srs:
           // Set the URL for SRS material supplier.
           getPriceListUrl = Helper.isSRSv2Id(srsSupplierId) ?
           Urls.srsGetPriceListV2 : Urls.srsGetPriceList;
           break;
         case MaterialSupplierType.beacon:
           // Set the URL for Beacon material supplier.
           getPriceListUrl = Urls.beaconGetPriceList;
           break;
         case MaterialSupplierType.abc:
         // Set the URL for Beacon material supplier.
           getPriceListUrl = Urls.abcGetPriceList;
           break;
       }
       // In case URL is not set, return an empty map
       if (getPriceListUrl.isEmpty) return {};

       final response = await dio.get(getPriceListUrl, queryParameters: params);
       final jsonData = json.decode(response.toString());

       // Map to store product prices.
       final Map<String, FinancialProductPrice> productsPriceJson = {};
       // List to store deleted item codes.
       final List<String> deletedItemsCode = [];

       // Iterate through the data and process each product price.
       jsonData["data"].forEach((dynamic productPrice) {
         // Create a product price model from the JSON data.
         FinancialProductPrice productPriceModel = FinancialProductPrice.fromJson(productPrice);
         // Check if the item code is not null.
         if (productPriceModel.itemCode != null) {
           // Add the product price to the map
           productsPriceJson[productPriceModel.itemCode!] = productPriceModel;
         }
       });

       // Iterate through the deleted items and process each one.
       jsonData["deleted_items"]?.forEach((dynamic productPrice) {
         // Create a product price model from the JSON data.
         FinancialProductPrice productPriceModel = FinancialProductPrice.fromJson(productPrice);
         // Check if the item code is not null.
         if (productPriceModel.itemCode != null) {
           // Add the item code to the list of deleted items.
           deletedItemsCode.add(productPriceModel.itemCode!);
         }
       });

       Map<String, dynamic> dataToReturn = {
         "data": productsPriceJson,
         "deleted_items": deletedItemsCode,
       };

       // Return the processed data.
       return dataToReturn;
     } catch(e) {
       rethrow;
     }
   }
}