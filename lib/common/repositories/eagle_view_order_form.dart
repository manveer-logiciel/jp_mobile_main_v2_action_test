import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/urls.dart';
import '../models/files_listing/eagle_view/product.dart';
import '../providers/http/interceptor.dart';

class EagleViewOrderFormRepository {
  static Future<List<JPSingleSelectModel>> getMeasurementList() async {
    try {
      final response = await dio.get(Urls.eagleViewMeasurements);
      final jsonData = json.decode(response.toString())['data'];
      List<JPSingleSelectModel> list = [];
      jsonData.forEach((dynamic data) => list.add(JPSingleSelectModel(label: data["name"], id: data["id"]?.toString() ?? '')));
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<EagleViewProductModel>> getProducts(Map<String, dynamic> param) async {
    try {
      final response = await dio.get(Urls.eagleViewProducts, queryParameters: param);
      final jsonData = json.decode(response.toString())['data'];
      List<EagleViewProductModel> list = [];
      jsonData.forEach((dynamic data) => list.add(EagleViewProductModel.fromJson(data)));
      return list;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> createEagleViewOrder(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.eagleViewOrder, data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> updateEagleViewOrder(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.eagleViewOrder, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

}