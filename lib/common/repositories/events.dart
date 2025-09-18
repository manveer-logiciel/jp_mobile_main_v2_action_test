import 'dart:convert';

import 'package:dio/dio.dart';

import '../../core/constants/urls.dart';
import '../models/schedules/schedules.dart';
import '../providers/http/interceptor.dart';

class EventsRepository {
  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.schedules, data: formData);
      final jsonData = json.decode(response.toString());
      SchedulesModel task = SchedulesModel.fromApiJson(jsonData['job_schedule']);
      Map<String, dynamic> data = {
        "data" : task,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateEvent(String eventId, Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.schedules}/$eventId", queryParameters: params,);
      final jsonData = json.decode(response.toString());
      SchedulesModel event = SchedulesModel.fromApiJson(jsonData['job_schedule']);
      Map<String, dynamic> data = {
        "data" : event,
        "status" : jsonData['status'] == 200
      };
      return data;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}