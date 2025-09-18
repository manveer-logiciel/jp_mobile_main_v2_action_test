import 'dart:convert';

import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class TagRepository {
  /// Getting all Tags(Groups) from api
  /// with users list
  Future<List<TagModel>> getAll() async {
    List<TagModel> tags = [];

    Map<String,dynamic> params = {
      'limit': 0,
      'includes[]': 'users',
      'include_inactive_users': 1
    };

    try {
      final response = await dio.get(Urls.tags, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic tag) => {
        tags.add(TagModel.fromApiJson(tag))
      });
      return tags;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchTagsList(
      Map<String, dynamic> tagsParams) async {
    try {
      final response = await dio.get(Urls.tags, queryParameters: tagsParams);
      final jsonData = json.decode(response.toString());
      List<TagModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list
      };

      jsonData["data"].forEach((dynamic tags) =>
          {dataToReturn['list'].add(TagModel.fromJson(tags))});
     return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
