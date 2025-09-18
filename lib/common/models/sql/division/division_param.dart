import 'package:jobprogress/core/constants/pagination_constants.dart';

/// this modal is used for requesting data from local db
class DivisionParamModel {
  int limit;
  int page;
  bool inactive;
  bool withInactive;
  String name;
  List<String>? includes = [];
  
  DivisionParamModel({
    this.limit = PaginationConstants.pageLimit,
    this.page = 0,
    this.inactive = false,
    this.withInactive = false,
    this.name = '',
    this.includes = const [] // values - users
  });
}
