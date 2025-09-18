
import 'dart:convert';

import 'package:jobprogress/common/models/clock_summary/clock_summary_entry.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_timelog.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ClockSummaryRepository {

  static Future<Map<String, dynamic>> fetchTimeLogs(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.timeLogsListing, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<ClockSummaryTimeLog> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(ClockSummaryTimeLog.fromJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> fetchTotalDuration(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.timeLogsDuration, queryParameters: params);
      final jsonData = json.decode(response.toString());

      return jsonData['data']['duration'];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchTimeEntries(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.timeLogsEntries, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<ClockSummaryEntry> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(ClockSummaryEntry.fromJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchTimLogEntryDetails(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.timeLogDetails(params['id'].toString()), queryParameters: params);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "data": ClockSummaryTimeLogDetails.fromJson(jsonData['data']),
      };

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}