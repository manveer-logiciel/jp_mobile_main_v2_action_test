import 'dart:convert';

import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class UserTokenRepo {

  // isCallingFirstTime helps to retry retrieving token from server if failed
  // first time, but not more than twice
  static bool isCallingFirstTime = true;

  static Future<String> getUserToken(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(
        Urls.firebaseToken,
        queryParameters: params,
      );
      final jsonData = json.decode(response.toString())['data'];

      return jsonData['token'];
    } catch (e) {
      // in case api fails, requesting token again
      if (isCallingFirstTime) {
        isCallingFirstTime = false;
        return await getUserToken(params);
      } else {
        // throwing error on second time
        isCallingFirstTime = true;
        rethrow;
      }
    }
  }
}
