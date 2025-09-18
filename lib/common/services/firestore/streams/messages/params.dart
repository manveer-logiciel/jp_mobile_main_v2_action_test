
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';

class GroupsMessageRequestParams {

  static GroupsMessageRequestParams get instance {
    return GroupsMessageRequestParams();
  }

  int defaultPaginationLimit = PaginationConstants.pageLimit50;
  String defaultSortBy = 'updated_at';
  int? companyId = AuthService.userDetails?.companyDetails?.id;
  int? userId = AuthService.userDetails?.id;

}