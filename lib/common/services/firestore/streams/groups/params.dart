
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/screen.dart';

class GroupsRequestParams {

  static GroupsRequestParams get instance {
    return GroupsRequestParams();
  }

  int defaultPaginationLimit = JPScreen.isMobile ? PaginationConstants.pageLimit10 : PaginationConstants.pageLimit;
  String defaultSortBy = FirestoreKeys.updatedAt;
  int? companyId = AuthService.userDetails?.companyDetails?.id;
  int? userId = AuthService.userDetails?.id;

}