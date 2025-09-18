import 'dart:convert';
import '../../core/constants/urls.dart';
import '../models/files_listing/files_listing_model.dart';
import '../providers/http/interceptor.dart';

class InstantPhotoGalleryRepository {
  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.instantPhoto, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromInstantPhotoJson(task))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
  
  static Future<FilesListingModel> renameResource(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.resourcesRename, queryParameters: params);
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return FilesListingModel.fromInstantPhotoJson(jsonData["resource"]);
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

  static Future<bool> moveResourceToJob(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.post(Urls.moveMultipleResource, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      rethrow;
    }
  }
  
}