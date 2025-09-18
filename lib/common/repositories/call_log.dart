import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/call_logs/call_log_listing.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';


class CallLogListRepository {
 Future<Map<String, dynamic>> fetchCallLogList(Map<String, dynamic> callLogParams) async {
    try {
      final response = await dio.get(Urls.callLog, queryParameters: callLogParams);
      final jsonData = json.decode(response.toString());
      List<CallLogModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])
      };

      jsonData["data"].forEach((dynamic callLogList) => {dataToReturn['list'].add(CallLogModel.fromJson(callLogList))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveCallLog(Map<String, dynamic> callLogCaptureParam) async {
    try {
      var formData = FormData.fromMap(callLogCaptureParam);

      await dio.post(Urls.callLog, data: formData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
