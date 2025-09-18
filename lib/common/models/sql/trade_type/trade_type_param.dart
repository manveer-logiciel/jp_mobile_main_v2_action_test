import 'package:jobprogress/core/constants/pagination_constants.dart';

/// this modal is used for requesting data from local db
class TradeTypeParamModel {
  int limit;
  int page;
  bool inactive;
  bool withInactive;
  bool withInActiveWorkType;
  String name;
  List<String>? includes = [];
  
  TradeTypeParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 0,
    this.name = '',
    this.inactive = false,
    this.withInactive = false,
    this.withInActiveWorkType = false,
    this.includes = const [] // values -  work_type
  });
}