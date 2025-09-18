import 'dart:convert';
import '../../core/constants/urls.dart';
import '../models/files_listing/files_listing_model.dart';
import '../providers/http/interceptor.dart';

class DropBoxRepository {
  static Future<Map<String, dynamic>> fetchFiles(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.dropBoxList, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<FilesListingModel> list = [];


      Map<String, dynamic> dataToReturn = {
        "list": list,
        "next_page_token": jsonData["meta"]["next_page_token"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic file) =>
      {dataToReturn['list'].add(FilesListingModel.fromDropboxJson(file))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}