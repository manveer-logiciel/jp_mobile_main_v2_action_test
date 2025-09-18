import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class HoverRepository {

  static Future<Map<String, dynamic>> getHoverUsers(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.hoverUsers, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<HoverUserModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic user) =>
          dataToReturn['list'].add(HoverUserModel.fromJson(user)));

      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> jobSync(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.hoverJobSync, data: formData);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> captureRequest(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.hoverCaptureRequest, data: formData);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

}
