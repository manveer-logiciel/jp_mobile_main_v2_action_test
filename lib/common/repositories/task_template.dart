import 'dart:convert';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class TaskTemplatelListingRepository {
  static Future<Map<String, dynamic>> fetchTemplateList(Map<String, dynamic> tasksParams) async {
    try {
      final response = await dio.get(Urls.taskTemplateList, queryParameters: tasksParams);
      final jsonData = json.decode(response.toString());
      List<TaskListModel> list = [];
      Map<String, dynamic> dataToReturn ;
      dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};
      

      jsonData["data"].forEach((dynamic tasks) => {dataToReturn['list'].add(TaskListModel.fromJson(tasks))});
      return dataToReturn;
    } catch (e) {
      rethrow;
    }
  }
}