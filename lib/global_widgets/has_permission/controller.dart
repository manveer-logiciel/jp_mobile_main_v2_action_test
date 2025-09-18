import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/permission.dart';

class HasPermissionController extends GetxController {

  //Check if user have given permissions or not
  bool hasUserPermissions(
      List<String> permissions, {
        bool isAllRequired = false,
        bool forSubcontractor = false
      }) {
    // in case of sub contractor, permission check will only take place when user will be sub user
    if(forSubcontractor && !AuthService.isPrimeSubUser()) {
      return true;
    }
    return PermissionService.hasUserPermissions(permissions, isAllRequired: isAllRequired);
  }
}
