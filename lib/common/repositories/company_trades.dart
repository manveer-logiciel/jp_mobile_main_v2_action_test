
import 'dart:convert';

import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CompanyTradesRepository {
  Future<List<JPSingleSelectModel>> fetchTradeList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.companyTrades, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<JPSingleSelectModel> tradeList = [];
      //Converting api data to model
      jsonData["data"].forEach((dynamic snippet) => tradeList.add(JPSingleSelectModel(
        id: snippet["id"].toString(),
        label: snippet["name"] ?? "",
      )));

      return tradeList;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
