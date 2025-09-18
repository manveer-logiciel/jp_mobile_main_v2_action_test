import 'dart:convert';
import 'package:jobprogress/common/services/count.dart';
import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class DailyPlanRepository {

  static Future<void> setDailyPlanCount() async {
    try {
      final response = await dio.get(Urls.dailyPlanCount);
      final jsonData = json.decode(response.toString());
      if(jsonData['status'] == 200 ) {
        CountService.myDailyCount = jsonData['count'];
      }
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
