import 'dart:convert';

import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class DivisionRepository {
  /// Getting all divisions from api 
  /// with users list
  Future<List<DivisionModel>> getAll() async {
    List<DivisionModel> divisions = [];
    
    Map<String,dynamic> params = {
      "limit": 0,
      'includes[]': 'users',
    };

    try {
      final response = await dio.get(Urls.divisions, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic division) => {
        divisions.add(DivisionModel.fromApiJson(division))
      });
      return divisions;
    } catch (e) {
      rethrow;
    }
  }
}
