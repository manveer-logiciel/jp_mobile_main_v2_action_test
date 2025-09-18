import 'dart:convert';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class FavouriteListingRepository {
  
  static Future<Map<String, dynamic>> fetchFavouriteListing(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.favouriteListing, queryParameters: params);
      final jsonData = json.decode(response.toString());
      
      List<FilesListingModel> list = [];
      
      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": jsonData["meta"]["pagination"]
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic estimate) =>
      { 
        dataToReturn['list'].add(FilesListingModel.fromFavouriteListingJson(estimate))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }


}
