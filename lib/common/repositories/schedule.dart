import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/pagination_model.dart';

import '../../core/constants/urls.dart';
import '../models/schedules/schedules.dart';
import '../providers/http/interceptor.dart';

class ScheduleRepository {
  Future<Map<String, dynamic>> fetchScheduleList(
      Map<String, dynamic> param, {bool useV2Url = false}) async {
    try {
      final response =
          await dio.get(useV2Url ? Urls.schedulesV2 : Urls.schedules, queryParameters: param);
      final jsonData = json.decode(response.toString());
      List<SchedulesModel> list = [];

      final paginationJson = jsonData?['meta']?['pagination'];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        if (paginationJson != null) "pagination": PaginationModel.fromJson(paginationJson)
      };

      jsonData["data"].forEach((dynamic schedules) =>
          {dataToReturn['list'].add(SchedulesModel.fromApiJson(schedules))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchJobCount(Map<String, dynamic> param) async {
    try {
      final response = await dio.get(Urls.jobCount, queryParameters: param);
      final jsonData = json.decode(response.toString());

      Map<String, dynamic> dataToReturn = {
        "schedule_jobs": (jsonData["data"]?["schedule_jobs"] ?? 0) + (jsonData["data"]?["schedule_projects"] ?? 0),
        "un_schedule_jobs": (jsonData["data"]?["without_schedule_jobs"] ?? 0) + (jsonData["data"]?["without_schedule_projects"] ?? 0),
      };

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUnscheduledList(Map<String, dynamic> param) async {
    try {
      final response =
          await dio.get(Urls.unscheduledJobs, queryParameters: param);
      final jsonData = json.decode(response.toString());
      List<JobModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"],
      };

      jsonData["data"].forEach((dynamic schedules) =>
          {dataToReturn['list'].add(JobModel.fromJson(schedules))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<SchedulesModel> fetchScheduleDetails(
      Map<String, dynamic> param, String id) async {
    try {
      String url = '${Urls.schedules}/$id';
      final response = await dio.get(url, queryParameters: param);
      final jsonData = json.decode(response.toString());
      SchedulesModel schedulesDetails =
          SchedulesModel.fromApiJson(jsonData['schedule']);
      return schedulesDetails;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>>  createSchedule(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post("${Urls.schedules}/${params["id"]}", data: formData);
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

  static Future<SchedulesModel> fetchScheduleDetailsByJobId(
      Map<String, dynamic> param, int id) async {
    try {
      final response = await dio.get(Urls.schedules, queryParameters: param);
      final jsonData = json.decode(response.toString());
      SchedulesModel schedulesDetails = SchedulesModel.fromApiJson(jsonData['data'][0]);
      return schedulesDetails;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
