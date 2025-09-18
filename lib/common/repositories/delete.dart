import 'dart:convert';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class DeleteRepository {
  static Future<dynamic> delete(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete('${Urls.customers}/${params['id']}',
        queryParameters: params,
      );
      return json.decode(response.toString())['message'];
    } catch (e) {
      rethrow;
    }
  }
}