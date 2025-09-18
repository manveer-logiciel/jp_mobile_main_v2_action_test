import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanySwitchRepository {
  Future<dynamic> switchCompanyData(int companyId) async {
    Map<String, dynamic> params = {"company_id": companyId};
    var formData = FormData.fromMap(params);
    try {
      dynamic response = await dio.post(Urls.switchCompany, data: formData);
      dynamic data = json.decode(response.toString());

      if (data is Map) {
        final currentUserCompanies = AuthService.userDetails?.allCompanies ?? [];
        List<Map<String, dynamic>> allCompanies = currentUserCompanies
            .map((company) => company.toJson()).toList();

        data['data']?['all_companies'] = {
          'data': allCompanies,
        };

        data['data']?['company_details'] = currentUserCompanies
            .firstWhere((company) => company.id == companyId).toJson();
      }

      return data;
    } catch (e) {
      rethrow;
    }
  }
  
}
