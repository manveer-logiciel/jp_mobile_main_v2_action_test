import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanySettingRepository {

  static Future<void> fetchCompanySettings() async {
    try {
      final response = await dio.get(Urls.companySettings);
      final jsonData = json.decode(response.toString());
      CompanySettingsService.setCompanySettings(jsonData['data']);

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> saveSettings(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      await dio.post(Urls.companySettings, data: formData);

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> fetchCompanyGoogleAccountStatus() async {
    try{
      final response = await dio.get(Urls.companyGoogleAccount);
      final jsonData = json.decode(response.toString());
      CompanySettingsService.companyGoogleAccount = jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> fetchCompanySettingsByDivision(Map<String, dynamic> queryParams) async {
    try {
      final response = await dio.get(Urls.companySettingsByDivision, queryParameters: queryParams);
      final jsonData = json.decode(response.toString());
      CompanySettingsService.mapDivisionCompanySettingsWithGlobalSettings(jsonData['data']);

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}