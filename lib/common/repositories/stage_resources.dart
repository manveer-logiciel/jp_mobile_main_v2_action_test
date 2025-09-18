import 'dart:convert';

import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class StageResourcesRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.resources, queryParameters: params);
      dynamic jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        'pagination' : PaginationModel(
          count: jsonData.length,
          perPage: jsonData.length,
          currentPage: 1,
          totalPages: 1,
          total: jsonData.length,
        ).toJson()
      };

      //Converting api data to model
      if(jsonData is Map) {
        for (var element in (jsonData).keys) {
          dataToReturn['list'].add((FilesListingModel.fromStageResourceJson(jsonData[element])));
        }
      }

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> renameResource(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.resourcesRename, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromStageResourceJson(jsonData["resource"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> removeFile(int id) async {
    try {
      final response = await dio.delete(Urls.deleteFile + id.toString());
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["message"];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> removeMultipleResource(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.delete(Urls.deleteMultipleResource,
          queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["message"];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> rotateImage(
      String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.rotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromCompanyFilesJson(jsonData["resource"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<List<WorkFlowStageModel>> fetchStages({Map<String, dynamic>? params}) async {
    try {
      final response = await dio.get(Urls.workFlowStages, queryParameters: params);
      dynamic jsonData = json.decode(response.toString());
      List<WorkFlowStageModel> list = [];
      jsonData['data'].forEach((dynamic json) {
        list.add(WorkFlowStageModel.fromJson(json));
      });
      return list;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}
