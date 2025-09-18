import 'dart:convert';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import '../models/customer/customer.dart';

class CustomerListingRepository {
  Future<Map<String, dynamic>> fetchCustomerList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.customer, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<CustomerModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic customer) => dataToReturn['list'].add(CustomerModel.fromJson(customer)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchMetaList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.customerMeta, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<CustomerModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic customer) => dataToReturn['list'].add(CustomerModel.fromJson(customer)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
