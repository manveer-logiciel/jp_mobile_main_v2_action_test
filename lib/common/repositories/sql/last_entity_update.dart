
import 'dart:convert';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class SqlLastEntityUpdate {

  static Future<Map<String, dynamic>> fetchLastUpdatedEntities() async {
    try {
      final response = await dio.get(Urls.lastEntityUpdate);
      final jsonData = json.decode(response.toString());

      return jsonData['data'] ?? {};
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}
