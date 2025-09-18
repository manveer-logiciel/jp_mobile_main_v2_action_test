import 'dart:convert';

import 'package:jobprogress/common/models/timezone/timezone_model.dart';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class TimezoneRepository {
  static Future<Map<String, dynamic>> fetchTimezones() async {
    try {
      final response = await dio.get(Urls.getTimezones);
      final jsonData = json.decode(response.toString());
      List<TimezoneModel> list = [];
      Map<String, dynamic> dataToReturn = {
        "list": list,
      };
      jsonData["data"].forEach((dynamic jobs) => dataToReturn['list'].add(TimezoneModel.fromJson(jobs)));
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateTimezones(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.companySettings, data: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}