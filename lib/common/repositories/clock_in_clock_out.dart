import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ClockInClockOutRepository {

  static Future<ClockSummaryTimeLogDetails> checkIn(
      Map<String, dynamic> params) async {
    try {


      if(params['check_in_image'] != null) {
        params['check_in_image'] = await MultipartFile.fromFile(params['check_in_image']);
      }

      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.timeLogsCheckIn, data: formData);
      final jsonData = json.decode(response.toString());

      return ClockSummaryTimeLogDetails.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> checkOut(
      Map<String, dynamic> params) async {
    try {


      if(params['check_out_image'] != null) {
        params['check_out_image'] = await MultipartFile.fromFile(params['check_out_image']);
      }

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.timeLogsCheckOut, data: formData);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<ClockSummaryTimeLogDetails> fetchCheckInDetails(
      Map<String, dynamic> params) async {
    try {

      // This delay is used because when we check-in server takes some time to store data (check-in details)
      // Without this delayer app tries to fetch data from server which is not even stored yet
      // as fetchCheckInDetails() and checkIn() are linked checkIn -> fetchCheckInDetails
      await Future<void>.delayed(const Duration(milliseconds: 800));
      
      final response = await dio.get(Urls.timeLogsCurrentUserCheckIn, queryParameters: params);
      final jsonData = json.decode(response.toString());

      return ClockSummaryTimeLogDetails.fromJson(jsonData['data']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}