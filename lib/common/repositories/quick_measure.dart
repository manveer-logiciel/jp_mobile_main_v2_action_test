import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class QuickMeasureRepository {
  Future<Map<String, dynamic>> createQuickMeasure(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.createQuickMeasure, data: formData);
      final jsonData = json.decode(response.toString());
      Map<String, dynamic> data = {
        "data" : "create_quick_measure",
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateQuickMeasure(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.createQuickMeasure, data: formData);
      final jsonData = json.decode(response.toString());
      Map<String, dynamic> data = {
        "data" : "update_quick_measure",
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      rethrow;
    }
  }
}