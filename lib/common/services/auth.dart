import 'package:jobprogress/common/models/beacon_client_model.dart';
import 'package:jobprogress/common/models/sql/division/division.dart';
import 'package:jobprogress/common/models/sql/division/division_limited.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import '../enums/user_preferences.dart';

SharedPrefService preferences = SharedPrefService();

class AuthService {
  static UserModel? userDetails;
  static bool isRestricted = false;

  static saveAccessToken(String token) async {
    await preferences.save(PrefConstants.accessToken, token);
  }

  static UserModel? getUserDetails() {
    return userDetails;
  }

  static Future<UserModel> getLoggedInUser() async {
    var data = await preferences.read(PrefConstants.user);
    isRestricted = (await preferences.read(PrefConstants.isRestricted)) ?? false;
    userDetails = UserModel.fromSharedPrefJson(data);
    MixPanelService.setUser(); // setting up mix-panel with current user info
    return UserModel.fromSharedPrefJson(data);
  }
  
  static Future<int> getCompanyId() async {
    var data = await preferences.read(PrefConstants.user);
    return data[PrefConstants.companyId];
  }

  static saveUserData(dynamic user) async {
    await preferences.save(PrefConstants.user, user);
    userDetails = UserModel.fromSharedPrefJson(user);
    MixPanelService.setUser(); // setting up mix-panel with current user info
    PhoneMasking.setUp(); // setting up phone masking from company settings
  }

  static updateUserData(Map<String, dynamic> user) async {
    Map<String, dynamic> tempData = await preferences.read(PrefConstants.user);
    tempData.addEntries({...user}.entries);
    saveUserData(tempData);
  }

  static saveDevice(dynamic device) async {
    await preferences.save(PrefConstants.device, device);
  }

  static saveRestriction(bool? val) async {

    if(val is! bool) return;

    await preferences.save(PrefConstants.isRestricted, val);
    isRestricted = val;
  }

  static saveUserPreferences( ) async {
    List<UserPreferencesEnum> userPreferences = [
      UserPreferencesEnum.saveToGallery,
      UserPreferencesEnum.nearByJobAccess
    ];
    await UserPreferences.setUserPermission(userPreferences);
  }

  static saveLoggedInUserData(dynamic data) {
    saveAccessToken(data["token"]["access_token"].toString());
    saveUserData(data['user']);
    saveDevice(data['device']);
    saveRestriction(data['is_restricted']);
    saveUserPreferences();
  }

  static bool isAdmin() {
    return userDetails?.groupId == UserGroupIdConstants.admin || userDetails?.groupId == UserGroupIdConstants.owner;
  }

  static bool isOwner() {
    return userDetails?.groupId == UserGroupIdConstants.owner;
  }

  static bool isStandardUser() {
    return userDetails?.groupId == UserGroupIdConstants.standard;
  }

  static bool hasExternalTemplateUser(){
    return AppEnv.config[CommonConstants.externalTemplateCompanyIds].contains(userDetails?.companyDetails?.id);
  }
  
  static bool isSubUser() {
    return userDetails?.groupId == UserGroupIdConstants.subContractor;
  }

  static bool isPrimeSubUser() {
    return userDetails?.groupId == UserGroupIdConstants.subContractorPrime;
  }

  static bool isSystemUser() {
    return userDetails?.groupId == UserGroupIdConstants.anonymous;
  }

  static String getfullNameorCompanyName({required dynamic user}){
   if(user.roleName == AuthConstant.subContractorPrime){
     return user.companyName ?? '';
   }
   else{
     return user.fullName ?? '';
   }

  }

  static String  getUserInitialorCompanyInitial({required dynamic user}){
   if(user.roleName == AuthConstant.subContractorPrime){
     return user.companyInitial ?? '';
   }
   else{
     return user.intial ?? '';
   }

  }

  static Future<String> getAccessToken() async {
    var data = await preferences.read(PrefConstants.accessToken);
    return data;
  }

  static void updateDivisions(List<DivisionModel> divisions) {
    final user = AuthService.userDetails!;

    user.divisions ??= [];
    user.divisions?.clear();

    for (var division in divisions) {
     user.divisions?.add(DivisionLimitedModel.fromJson(division.toJson()));
    }
  }

  static bool isUserBeaconConnected() {
   final BeaconClientModel? beaconClientModel = AuthService.userDetails?.beaconClient;
   if(beaconClientModel != null) {
     if (beaconClientModel.refreshExpiryDateTime != null) {
       return DateTimeHelper.isFutureDate(
           beaconClientModel.refreshExpiryDateTime!,
           DateFormatConstants.dateTimeServerFormat);
     }
   }
   return false;
  }
}
