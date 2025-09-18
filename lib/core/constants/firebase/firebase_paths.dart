
class FirebasePaths {

  String compId;
  String userId;

  FirebasePaths(this.compId, this.userId);

  String get companyBasePath => "company/$compId/";
  String get userBasePath => "company/$compId/users/$userId/";
  String get countBasePath => "${userBasePath}count/";
  String get settingBasePath => "${userBasePath}settings/";

}