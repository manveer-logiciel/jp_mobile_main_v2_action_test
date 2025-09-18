import 'dart:convert';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CountryRepository {
  Future<dynamic> getCountryList() async {
    List<CountryModel> countryList = [];

    Map<String, dynamic> params = {
      "limit": 0,
      "company_id": AuthService.userDetails?.companyDetails?.id
    };

    try {
      final response = await dio.get(Urls.country, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic country) => {
        countryList.add(CountryModel.fromJson(country))
      });

      return countryList;
    } catch (e) {
      rethrow;
    }
  }
}