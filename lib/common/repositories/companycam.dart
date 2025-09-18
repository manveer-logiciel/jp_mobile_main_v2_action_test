import 'dart:convert';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class CompanyCamListingRepository {
  static Future<Map<String, dynamic>> fetchFiles(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.companycamProjects, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["params"]
      };
      //Converting api data to model
      jsonData["data"].forEach((dynamic list) => {dataToReturn['list'].add(FilesListingModel.fromCompanyCamJson(list))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<FilesListingModel> fetchFile(String id) async {
    try {
      final response = await dio.get('${Urls.companycamProjects}/$id');
      final jsonData = json.decode(response.toString());
      FilesListingModel dataToReturn = FilesListingModel.fromCompanyCamJson(jsonData["data"]);
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchImages(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.companycamProjectsPhotos, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list};
      //Converting api data to model
      jsonData["data"].forEach((dynamic list) => {dataToReturn['list'].add(FilesListingModel.fromCompanyCamImagesJson(list))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


}
