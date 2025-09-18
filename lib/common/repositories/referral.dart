import 'dart:convert';

import 'package:jobprogress/common/models/sql/referral_source/referral_source.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ReferralRepository {
  // Getting all Referral Sources from api
  Future<List<ReferralSourcesModel>> getAll() async {
    List<ReferralSourcesModel> list = [];

    try {
      final response = await dio.get(Urls.referrals);
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic item) => {
        list.add(ReferralSourcesModel.fromApiJson(item))
      });
      return list;
    } catch (e) {
      rethrow;
    }
  }
}
