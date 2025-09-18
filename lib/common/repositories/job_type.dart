import 'dart:convert';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class JobTypeRepository {

  static Future<Map<String, dynamic>> fetchCategories(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.jobType(1), queryParameters: params);
      final jsonData = json.decode(response.toString());

      List<JobTypeModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic val) =>
      {dataToReturn['list'].add(JobTypeModel.fromJson(val))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

}