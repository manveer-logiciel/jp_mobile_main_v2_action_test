import 'dart:convert';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class ForgotPasswordRepository {

  static Future<Map<String, dynamic>> recoverPassword(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.forgotPassword, data: params);
      return jsonDecode(response.toString());
    } catch (e) {
      rethrow;
    }
  }
}