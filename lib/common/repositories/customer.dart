import 'dart:convert';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/sub_option.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CustomerRepository {
  static Future<CustomerModel> getCustomer(Map<String, dynamic> params) async {
    try {
      final response = await dio.get('${Urls.customers}/${params['id']}', queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];
      return CustomerModel.fromJson(jsonData);
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> deleteCustomer(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete('${Urls.customers}/${params['id']}',
        queryParameters: params,
      );
      return json.decode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }

  static Future<PhoneConsentModel> fetchPhoneConsent(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.phoneConsentStatus(params['number']), queryParameters: params);
      final jsonData = json.decode(response.toString());
      return PhoneConsentModel.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    } 
  }

  static Future<PhoneConsentModel> sendConsentEmail(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.phoneConsent, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];
      return PhoneConsentModel.fromJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<CustomFormFieldsModel>> getCustomFields(Map<String, dynamic> params) async {
    try {
      List<CustomFormFieldsModel> fields = [];
      final response = await dio.get(Urls.customFields, queryParameters: params);
      final jsonData = json.decode(response.toString())['data'];
      jsonData.forEach((dynamic field) {
        fields.add(CustomFormFieldsModel.fromJson(field));
      });
      return fields;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getCustomFieldsSubOptions(Map<String, dynamic> params) async {
    try {
      List<CustomFormFieldSubOption> fields = [];
      final response = await dio.get(Urls.customFieldSubOptions(params['field_id'], params['option_id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "list": fields,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic json) {
        dataToReturn['list'].add(CustomFormFieldSubOption.fromJson(json));
      });

      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  /// [addCustomer]
  /// [isRestricted] helps in deciding if customer is restricted or not
  static Future<dynamic> addCustomer(Map<String, dynamic> params, {
    required bool isRestricted
  }) async {
    try {
      final response = await dio.post(Urls.customers, queryParameters: params);
      final jsonData = json.decode(response.toString());

      if(isRestricted) {
        return jsonData['status'] == 200;
      }

      return CustomerModel.fromJson(jsonData['customer']);
    } catch (e) {
      rethrow;
    }
  }
}
