import 'dart:convert';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanyRepository {
  Future<dynamic> getCompanyList() async {
    List<CompanyModel> companyList = [];

    Map<String, dynamic> params = {"limit": 0};

    try {
      final response = await dio.get(Urls.companyList, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic company) => {
        companyList.add(CompanyModel.fromApiJson(company))
      });

      return companyList;
    } catch (e) {
      rethrow;
    }
  }
}