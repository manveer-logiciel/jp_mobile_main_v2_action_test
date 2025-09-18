
import 'package:jobprogress/core/constants/pagination_constants.dart';

class JPNetworkMultiSelectParams {

  int page;
  int limit;
  String keyword;

  JPNetworkMultiSelectParams({
    this.page = 1,
    this.limit = PaginationConstants.pageLimit,
    this.keyword = ''
  });
}