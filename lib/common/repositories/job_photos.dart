import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class JobPhotosRepository {

  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.resources, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic file) =>
      {dataToReturn['list'].add(FilesListingModel.fromJobPhotosJson(file))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchRecentFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.resourcesRecent, queryParameters: params);

      final jsonData = response.data;

      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
      };



      //Converting api data to model
      jsonData.forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromJobPhotosJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> recursiveSearch(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.recursiveSearch, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromJobPhotosJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> createDirectory(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.resourcesDirectories, queryParameters: params);
      final jsonData = json.decode(response.toString());

      jsonData["resources"]['is_dir'] = 1;
      // Converting api data to model
      return FilesListingModel.fromJobPhotosJson(jsonData["resources"]);
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
      return FilesListingModel.fromJobPhotosJson(jsonData["resource"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

    static sendTextMessage(Map<String, dynamic> params) async {
    try {
       await dio.post(Urls.shareViaJobProgress, queryParameters: params);
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

  static Future<bool> unLinkCompanyCam(Map<String, dynamic> params) async {
    try {
      final response = await dio.delete(Urls.unlinkCompanyCamProject, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> linkCompanyCam(Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.linkCompanyCamProject, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["status"] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  static Future<String> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete('${Urls.deleteDirectory}$id/1');
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
      return FilesListingModel.fromJobPhotosJson(jsonData["resource"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> moveMultipleResource(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.moveMultipleResource, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData["message"];
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> showHideOnCustomerWebPage(bool isInSelectionMode, Map<String, dynamic> params) async {
    try {
      final response =
      await dio.put(isInSelectionMode ? Urls.jobPhotosMultipleShareOnHop : Urls.jobPhotosShareOnHop(int.parse(params['id'])), queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


  static Future<FilesListingModel> saveEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.jobPhotosEditImage(params['id']), data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromJobPhotosJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> saveAsEditedImage(Map<String, dynamic> params) async {
    try {
      final formData = FormData.fromMap(params);
      final response = await dio.post(Urls.resourcesFile, data: formData);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromJobPhotosJson(jsonData['file']);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<AttachmentResourceModel> getAttachment(String id) async {
    try {
      final response = await dio.get(Urls.resourcesAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> resourceCopyTo(Map<String, dynamic> params) async {
    try {
      dynamic  response = await dio.post(Urls.dropBoxSaveFile, queryParameters: params);
      if(response != null){
        final jsonData = json.decode(response.toString());
        return jsonData['status'] == 200;
      } else {
        return false;
      }
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
