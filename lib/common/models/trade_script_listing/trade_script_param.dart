import 'package:jobprogress/core/constants/pagination_constants.dart';

class TradeScriptListParamModel {
  String? limit;
  int? page;
  String? title;
  String? tradeIds;

  TradeScriptListParamModel({
    this.limit = '${PaginationConstants.pageLimit}',
    this.page = 1,
    this.title = '',
    this.tradeIds = '',
  });

  TradeScriptListParamModel.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    page = json['page'];
    title = json['title'];
    tradeIds = json['trade_ids[]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['limit'] = limit;
    data['page'] = page;
    data['title'] = title;
    data['trade_ids[]'] = tradeIds;
    return data;
  }
}
