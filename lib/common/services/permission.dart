class PermissionService {
  static List<String> permissionList = [];
  
  //Checking if given permission exist in permission list array or not 
  static bool hasUserPermissions(List<String> permissions, {bool isAllRequired = false}) {
    if(isAllRequired) return permissions.every((permission) => permissionList.contains(permission));
    return permissions.any((permission) => permissionList.contains(permission));
  }
}