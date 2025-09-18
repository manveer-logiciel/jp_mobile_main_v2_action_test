import 'dart:convert';

import 'package:jobprogress/common/models/sql/trade_type/trade_type.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/core/constants/urls.dart';

class TradeRepository {
  /// Getting all trade types with worktypes
  Future<List<TradeTypeModel>> getAll() async {
    List<TradeTypeModel> list = [];

    try {
      final response = await dio.get(Urls.trades, queryParameters: {'unassign_work_types': 1});
      final dataList = json.decode(response.toString())['data'];

      dataList.forEach((dynamic item) => {
        list.add(TradeTypeModel.fromApiJson(item))
      });

      return list;
    } catch (e) {
      rethrow;
    }
  }
}
