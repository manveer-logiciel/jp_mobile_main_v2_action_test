
import 'dart:convert';

import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanyCityRepo {

  static Future<Map<String, dynamic>> fetchCompanyCities(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.companyCityList, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<String> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic json) => {dataToReturn['list'].add(json['name'].toString())});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}