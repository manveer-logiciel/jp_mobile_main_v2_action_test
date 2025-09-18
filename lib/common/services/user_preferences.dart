import '../../core/constants/shared_pref_constants.dart';
import '../../main.dart';
import '../enums/user_preferences.dart';

class UserPreferences {

  static bool? hasNearByAccess;
  static bool? hasSaveToGalleryAccess;

  static Future<void> getUserPermission() async {
    String? data = (await preferences.read(PrefConstants.userPreferences));
    if(data == null) {
      hasNearByAccess = true;
      hasSaveToGalleryAccess = true;
    } else if(data.isEmpty) {
      hasNearByAccess = false;
      hasSaveToGalleryAccess = false;
    } else {
      List<String>? preferencesList = data.split(",");
      hasNearByAccess = preferencesList.contains(UserPreferencesEnum.nearByJobAccess.toString());
      hasSaveToGalleryAccess = preferencesList.contains(UserPreferencesEnum.saveToGallery.toString());
    }
  }

  static Future<void> setUserPermission(List<UserPreferencesEnum> userPreferences) async {
    await preferences.save(PrefConstants.userPreferences, userPreferences.map((e) => e.toString()).join(","));
    await getUserPermission();
  }

  static UserPreferencesEnum getEnumFromString(String userPreferencesEnum) {
    switch(userPreferencesEnum) {
      case "UserPreferencesEnum.nearByJobAccess":
        return UserPreferencesEnum.nearByJobAccess;
      case "UserPreferencesEnum.saveToGallery":
        return UserPreferencesEnum.saveToGallery;
      default:
        return UserPreferencesEnum.nearByJobAccess;
    }
  }
}