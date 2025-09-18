import 'dart:convert';
import 'package:jobprogress/common/models/quick_book_sync_error.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';


class QuickBookErrorRepository {

  static Future<QuickBookSyncErrorModel> fetchQuickBookError(Map<String, dynamic> quickBookErrorParam) async {
    try {
      final response = await dio.get(Urls.quickBookError, queryParameters: quickBookErrorParam);
      final jsonData = json.decode(response.toString());
      return QuickBookSyncErrorModel.fromJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
