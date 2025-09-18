
import 'package:jobprogress/core/constants/pagination_constants.dart';

class JPSingleSelectParams {

  int page;
  int limit;
  int total;
  bool canShowLoadMore;
  String keyword;
  String? accountId;

  JPSingleSelectParams({
    this.page = 1,
    this.limit = PaginationConstants.pageLimit,
    this.keyword = '',
    this.total = 0,
    this.canShowLoadMore = true,
    this.accountId,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['limit'] = limit;
    json['page'] = page;
    json['keyword'] = keyword;
    if (accountId != null) json['account_id'] = accountId;
    return json;
  }
}