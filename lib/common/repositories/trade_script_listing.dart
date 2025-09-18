

import 'dart:convert';

import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/trade_script_listing/trade_script_listing.dart';

import '../../core/constants/urls.dart';
import '../providers/http/interceptor.dart';

class TradeScriptListingRepository {
  Future<Map<String, dynamic>> fetchSnippetList(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.tradeScripts, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<TradeScriptListModel> list = [];

      Map<String, dynamic> dataToReturn = {
        "list": list,
        "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"]),
      };

      //Converting api data to model
      jsonData["data"].forEach((dynamic snippet) =>
      {dataToReturn['list'].add(TradeScriptListModel.fromJson(snippet))});

      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
