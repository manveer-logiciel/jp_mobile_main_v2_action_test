import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/login.dart';
import 'package:jobprogress/common/models/login/demo_user.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/urls.dart';

import '../../core/constants/shared_pref_constants.dart';
import '../services/shared_pref.dart';

class LoginRepository {
  Future<dynamic> loginUser(LoginModel data) async {
    Map<String, dynamic> params = {
      "includes[0]": ["company_details"],
      "includes[1]": ["divisions"],
      "includes[2]": ["all_companies"],
      ...data.toJson()
    };

    var formData = FormData.fromMap(params);

    try {
      dynamic response = await dio.post(Urls.login, data: formData);
      dynamic data = json.decode(response.toString());
      AuthService.saveLoggedInUserData(data);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<DemoUserModel> getDemoUser() async {
    try {
      dynamic response = await dio.get(Urls.demoUser);
      dynamic jsonData = json.decode(response.toString());
      return DemoUserModel.fromJson(jsonData['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logoutUser() async {
    try {
      Map<String, dynamic>? device = await SharedPrefService().read(PrefConstants.device);
      if (device == null) {
        return false;
      }
      Map<String, dynamic> params = {
        "device_id": device["id"].toString(),
      };
      dynamic response = await dio.delete(Urls.logout, queryParameters: params);
      dynamic jsonData = json.decode(response.toString());
      return jsonData["status"] == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> logoutActiveSessions(Map<String, dynamic> params) async {
    try {
      dynamic response = await dio.delete(Urls.deviceSession, queryParameters: params);
      dynamic jsonData = json.decode(response.toString());
      return jsonData["status"] == 200;
    } catch (e) {
      rethrow;
    }
  }
}
