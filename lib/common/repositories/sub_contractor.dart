import 'dart:convert';

import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class SubContractorRepository {
  Future<List<UserModel>> getAll() async {
    List<UserModel> users = [];

    Map<String,dynamic> params = {"includes[]": "divisions",'limit': 0};

    try {
      final response = await dio.get(Urls.subContractor, queryParameters: params);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic user) => {
        users.add(UserModel.fromSubContractorApiJson(user))
      });
      return users;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
