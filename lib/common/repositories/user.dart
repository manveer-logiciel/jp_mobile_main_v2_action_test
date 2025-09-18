import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class UserRepository {
  /// Getting all users from api
  /// with sub users & inactive users
  Future<List<UserModel>> getAll() async {
    List<UserModel> users = [];

    Map<String,dynamic> params = {
      'limit': 0,
      'with_inactive': 1
    };

    try {
      final response = await dio.get(Urls.user, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic user) => {
        users.add(UserModel.fromApiJson(user))
      });
      return users;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUser(
      Map<String, dynamic> params) async {
    try {
      int userId = params['id'];

      final response =
          await dio.get("${Urls.user}/$userId", queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> addSignature(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(
        params
      );
      final response =
      await dio.post(Urls.userSignature, data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<T?> viewSignature<T>(Map<String, dynamic> params, {bool rawSignature = false}) async {
    try {

      final response =
      await dio.get(Urls.userSignature, queryParameters: params);
      final jsonData = json.decode(response.toString());
      if(jsonData['status'] == 200 && jsonData['data']?.isNotEmpty) {
        String signature = jsonData['data'][0]['signature'].toString();

        if (rawSignature) {
          return signature as T;
        }
        
        return base64Decode(Helper.formatBase64String(signature)) as T;
        
      }

      return null;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> userTracking(Map<String, dynamic> params) async {
    try {
      await dio.post(Urls.userTracking, data: params);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<void> saveDeviceSession(Map<String, dynamic> params) async {
    try {
      await dio.post(Urls.deviceSession, data: params);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
