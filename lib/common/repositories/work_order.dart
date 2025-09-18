
import 'dart:convert';

import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class WorkOrderRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.workOrders, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      {dataToReturn['list'].add(FilesListingModel.fromWorkOrderJson(estimate))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> fileRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.workOrderRename(int.parse(params['id'])), queryParameters: params);
      final jsonData = json.decode(response.toString());


      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> folderRename(Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.workOrderFolderRename(params['id']), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> rotateImage(
    String id, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.workOrderRotateImage(id), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return FilesListingModel.fromWorkOrderJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> moveFiles(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(Urls.workOrderMoveFiles, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeFile(String id) async {
    try {
      final response = await dio.delete(Urls.deleteWorkOrderFile(id));
      final jsonData = json.decode(response.toString());

      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete(Urls.deleteWorkOrderFolder(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> createDirectory(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.workOrderFolder, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["data"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromMaterialListsJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> unMarkAsFavourite(int id) async {
    try {
      final response =
      await dio.delete(Urls.unMarkFavouriteEntities(id));
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> changeWorkOrderStatus(String id, Map<String, dynamic> requestedParams) async {
    try {
      final response = await dio.put(Urls.changeWorkOrderStatus(id), queryParameters: requestedParams);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id) async {
    try {
      final response = await dio.get(Urls.workOrder(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromEmailJson(jsonData, FLModule.workOrder);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> updateAssignedUser(Map<String, dynamic> params, String workOrderid) async {
    try {
      final response = await dio.put(Urls.workOrderAssignedUser(workOrderid), queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
