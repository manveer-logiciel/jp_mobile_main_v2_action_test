import 'dart:convert';
import 'package:jobprogress/common/models/workflow/project_stages.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class WorkflowStagesRepository {

  static Future<String> changeStageDate(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.changeStageDate, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['data']['completed_date'];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<int> fetchIncompleteTaskLockCount(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.incompleteTaskLockCount, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['data']['incomplete_task_lock_count'];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveToStage(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.jobStage, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> markAsCompleteLastStage(Map<String, dynamic> params) async {
    try {
      final response = await dio.put(Urls.markLastStageCompleted, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<ProjectStageModel>> getProjectStages(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.projectStatusManager, queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<ProjectStageModel> list = [];

      jsonData['data'].forEach((dynamic stage) {
        list.add(ProjectStageModel.fromJson(stage));
      });

      return list;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateProjectStatus(Map<String, dynamic> params) async {
    try {

      int jobId = params['parent_id'];

      final response = await dio.put(Urls.projectStatusUpdate(jobId), queryParameters: params);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> makeProjectAwarded(Map<String, dynamic> params) async {
    try {

      int jobId = params['id'];

      final response = await dio.put(Urls.projectAwarded(jobId), queryParameters: params);
      final jsonData = json.decode(response.toString());

      return jsonData['status'] == 200;

    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}