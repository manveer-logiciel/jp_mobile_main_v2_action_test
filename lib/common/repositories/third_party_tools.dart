import 'dart:convert';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/third_party_tools/all_trades.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class ThirdPartyToolsRepository {
  Future<Map<String, dynamic>> fetchAllToolsList(
      Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.thirdPartyTools, queryParameters: params);

      final jsonData = json.decode(response.toString());
      List<ThirdPartyToolsModel> list = [];

     
      Map<String, dynamic> dataToReturn = {"list": list, "pagination": PaginationModel.fromJson(jsonData["meta"]["pagination"])};

      jsonData["data"].forEach((dynamic tools) => {dataToReturn['list'].add(ThirdPartyToolsModel.fromJson(tools))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchCount(Map<String, dynamic> params) async {
    try {
      final response = await dio.get(Urls.companyTrades, queryParameters: params);
      final jsonData = json.decode(response.toString());
      List<CompanyTradesModel> list = [];

      Map<String, dynamic> dataToReturn = {"list": list};
      jsonData["data"].forEach((dynamic tools) => {dataToReturn['list'].add(CompanyTradesModel.fromJson(tools))});
      return dataToReturn;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }
}
