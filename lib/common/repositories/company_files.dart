import 'dart:convert';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/expires_on.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanyFilesRepository {
  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.resources, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData?["meta"]?["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic task) =>
      {dataToReturn['list'].add(FilesListingModel.fromCompanyFilesJson(task))});

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
      {dataToReturn['list'].add(FilesListingModel.fromCompanyFilesJson(task))});

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
      return FilesListingModel.fromCompanyFilesJson(jsonData["resources"]);
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
      return FilesListingModel.fromCompanyFilesJson(jsonData["resource"]);
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

  static Future<AttachmentResourceModel> getAttachment(String id)async{
    try {
      final response =
      await dio.get(Urls.resourcesAttachment(id));
      final jsonData = json.decode(response.toString());
      // Converting api data to model
      return AttachmentResourceModel.fromJson(jsonData["data"]);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<String> removeDirectory(String id) async {
    try {
      final response =
      await dio.delete('${Urls.deleteDirectory}$id/true');
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

  static Future<ExpiresOnModel> expiresOn(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.post(Urls.documentExpire, queryParameters: params);
      final jsonData = json.decode(response.toString());

      // Converting api data to model
      return ExpiresOnModel.fromJson(jsonData);
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> resetExpireOn(
      Map<String, dynamic> params) async {
    try {
      final response =
      await dio.delete('${Urls.documentExpire}/${params['id']}');
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<bool> resourceCopyTo(Map<String, dynamic> params, FLModule type) async {
    try {
      dynamic response;
      switch (type) {
        case FLModule.estimate:
        case FLModule.jobProposal:
        case FLModule.jobPhotos:
          response = await dio.post(Urls.dropBoxSaveFile, queryParameters: params);
          break;
        case FLModule.companyFiles:
        case FLModule.stageResources:
          response = await dio.post(Urls.copyResources, queryParameters: params);
          break;
        case FLModule.dropBoxListing:
          response = await dio.post(Urls.dropBoxSaveFile, queryParameters: params);
          break;  
        case FLModule.companyCamProjectImages:
          response = await dio.post(Urls.companycamSavePhoto, queryParameters: params);
          break;
        default:
          response = null;
          break;
      }
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
