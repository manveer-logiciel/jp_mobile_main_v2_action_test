import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/automation.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class TaskListingRepository {
  Future<Map<String, dynamic>> fetchTaskList(Map<String, dynamic> params,
      {String? type}) async {
    try {
      final response = await dio.get(Urls.task, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<TaskListModel> list = [];
      Map<String, dynamic> dataToReturn = {};
      if (type == "dailyplan" || type == AutomationConstants.automation) {
        dataToReturn = {
          "list": list,
        };
      } 
       else {
        dataToReturn = {
          "list": list,
          "pagination": jsonData["meta"]["pagination"]
        };
      }

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
          {dataToReturn['list'].add(TaskListModel.fromJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchRecurringTaskList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.workflowTaskList, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<TaskListModel> list = [];
      Map<String, dynamic> dataToReturn = {};
        dataToReturn = {
          "list": list,
        }; 
      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>{dataToReturn['list'].add(TaskListModel.fromJson(task))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteTask(int id) async {
    try {
      String url = '${Urls.task}/$id';

      final response = await dio.delete(url);
      final jsonData = json.decode(response.toString());
      return jsonData;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<TaskListModel> markTaskAsComplete(int id, String? completed) async {
    try {
      String url = completed == null
          ? '${Urls.taskComplete}/$id'
          : '${Urls.taskPending}/$id';

      final response = await dio.get(url);
      final jsonData = json.decode(response.toString());

      TaskListModel task = TaskListModel.fromJson(jsonData['data']);
      return task;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<TaskListModel> getTask(Map<String, dynamic> params) async {
    try {
      String url = '${Urls.task}/${params['id']}';

      final response = await dio.get(url, queryParameters: params);
      final jsonData = json.decode(response.toString());

      TaskListModel task = TaskListModel.fromJson(jsonData['data']);
      return task;
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<TaskListModel> changeDueDate(Map<String, dynamic> params) async {
    var formData = FormData.fromMap(params);

    try {
      final response = await dio.post(Urls.changeDueDate, data: formData);
      final jsonData = json.decode(response.toString());
      TaskListModel task = TaskListModel.fromJson(jsonData['data']);
      return task;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> unlockStageChange(Map<String, dynamic> params, int id) async {
    try {
      final response = await dio.put(Urls.changeLockStatus(id), data: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendTaskListingModelData(Map<String, dynamic> taskListingModelParams) async {
    try {
      await dio.post(Urls.tasksJobWorkFlowTasks, data: taskListingModelParams);
        Helper.showToastMessage('Completed');
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> params) async {
    try {

      final formData = FormData.fromMap(params);

      final response = await dio.post(Urls.task, data: formData);
      final jsonData = json.decode(response.toString());
      TaskListModel task = TaskListModel.fromJson(jsonData['data']);
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

  Future<Map<String, dynamic>> updateTask(Map<String, dynamic> params) async {
    try {
      final response = await dio.put("${Urls.task}/${params['id']}", queryParameters: params, options: putRequestFormOptions);
      final jsonData = json.decode(response.toString());
      TaskListModel task = TaskListModel.fromJson(jsonData['data']);
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

  Future<bool> linkToJob(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.linkToJob, data: formData);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
}
