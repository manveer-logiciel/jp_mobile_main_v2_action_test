import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/home.dart';
import 'package:jobprogress/common/services/language.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/enums/user_preferences.dart';
import '../../common/models/device_info.dart';
import '../../common/models/sql/user/user.dart';
import '../../common/models/timezone/timezone_model.dart';
import '../../common/repositories/device.dart';
import '../../common/repositories/timezone_repository.dart';
import '../../common/repositories/user.dart';
import '../../common/services/auth.dart';
import '../../common/services/company_settings.dart';
import '../../core/constants/company_seetings.dart';
import '../../core/constants/shared_pref_constants.dart';
import '../../core/utils/date_time_helpers.dart';
import '../../core/utils/single_select_helper.dart';

class SettingController extends GetxController {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  DeviceInfo? deviceInfo;
  DeviceInfo? deviceInfoFromServer;
  LocationPermission? permission;
  JPSingleSelectModel? selectedTimeZone;
  Map<String,dynamic> device = {};
  String timeZone = "";

  bool isPrimaryDeviceUpdating = false;
  bool isTimezoneUpdating = true;
  bool isLocationUpdating = true;
  bool isPrimaryDevice = false;
  bool darkModeToggle = false;
  bool openSetting = false;
  bool? isSettingUpdated;
  bool? savePhotosToggle;
  bool? nearByJobToggle;

  List<JPSingleSelectModel> timezoneList = [];
  List<UserPreferencesEnum> userPreferences = [];

  StreamSubscription<String>? lifeCycleStreamSubscription;

  bool isLanguageUpdating = false;
  JPSingleSelectModel? selectedLanguage;

  @override
  void onInit() async {
    super.onInit();
    lifeCycleStreamSubscription = HomeService.appLifeCycleState.stream.listen((event) async {
      if(event == "AppLifecycleState.resumed") {
        openSetting = false;
        loadLanguagePreference();
        getLocationPermission();
      }
    });
    await fetchPrimaryDevice();
    await getLocationPermission();
    await getUserPermission();
    fetchTimeZones();
    getDeviceInfo();
    await loadLanguagePreference();
  }

  //////////////////////////    FETCH PRIMARY DEVICE   /////////////////////////

  Future<void> fetchPrimaryDevice() async {

    try {
      toggleIsPrimaryDeviceUpdating();
      UserModel loggedInUser = await AuthService.getLoggedInUser();

      Map<String, dynamic> userParams = {
        "id": loggedInUser.id,
        "includes[0]": "primary_device"
      };
      Map<String, dynamic> response = (await UserRepository.getUser(userParams))["data"];

      if(response.containsKey('primary_device')) {
        final jsonResponse = response["primary_device"];
        deviceInfoFromServer = DeviceInfo.fromJson(jsonResponse);
      }

      preferences.read(PrefConstants.device).then((dynamic device) {
        this.device = device;
        update();
      });

    } catch (e) {
      rethrow;
    } finally {
      toggleIsPrimaryDeviceUpdating();
    }
  }

  ////////////////////////    FETCH DEVICE INFORMATION   ///////////////////////

  void getDeviceInfo() {
    Helper.getDeviceInfo().then((deviceInfo) {
      this.deviceInfo = deviceInfo;
      isPrimaryDevice = deviceInfoFromServer?.uuid == this.deviceInfo?.uuid;
      update();
    });
  }

  ////////////////////////////    FETCH TIME ZONES   ///////////////////////////

  void fetchTimeZones() async {
    try {
      isTimezoneUpdating = true;
      timeZone = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.timeZone);
      update();
      dynamic response = await TimezoneRepository.fetchTimezones();
      List<TimezoneModel> list = response["list"];
      for (var element in list) {
        timezoneList.add(JPSingleSelectModel(
          id: element.id.toString(),
          label: element.name ?? "",));
      }
      selectedTimeZone = timezoneList.firstWhereOrNull((element) => element.label.replaceAll(r'\', r'') == timeZone);
      update();
    } catch (e) {
      //Handle error
      rethrow;
    } finally {
      isTimezoneUpdating = false;
      update();
    }
  }

  /////////////////////////    GET LOCATION PERMISSION   ///////////////////////

  Future<void> getLocationPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied
        || permission == LocationPermission.deniedForever) {
      permission = LocationPermission.denied;
      if(openSetting) {
        await Helper.openAppSetting();
      }
    }
    if(permission == LocationPermission.whileInUse
        || permission == LocationPermission.always) {
      permission = LocationPermission.always;
      if(openSetting) {
        await Helper.openAppSetting();
      }
    }
    isLocationUpdating = false;
    update();
  }

  ////////////////////    GET NEAR BY JOB ACCESS PERMISSION   //////////////////

  Future<void> getUserPermission() async {
    String? data = (await preferences.read(PrefConstants.userPreferences));
    List<String>? preferencesList = data?.split(",");
    userPreferences = [];
    preferencesList?.forEach((element) => userPreferences.add(UserPreferences.getEnumFromString(element)));
    await UserPreferences.getUserPermission();
    nearByJobToggle = UserPreferences.hasNearByAccess;
    savePhotosToggle = UserPreferences.hasSaveToGalleryAccess;
    update();
  }

  ///////////////////////////    SET PRIMARY DEVICE   //////////////////////////

  void setAsPrimaryDevice() async {
    try {
      toggleIsPrimaryDeviceUpdating();
      dynamic response = await DeviceRepository.setPrimaryDevice(device["id"].toString());
      if(response) {
        isPrimaryDevice = true;
        device["is_primary_device"] = isPrimaryDevice ? 1:0;
        updateSharePreferences();
        isSettingUpdated = true;
        update();
      }
    } catch (e) {
      rethrow;
    } finally {
      toggleIsPrimaryDeviceUpdating();
    }
  }

  /////////////////////////////    UPDATE TRIGGER   ////////////////////////////

  void updateLocationPermission(bool isAllowed) {
    if (isAllowed) {
      Helper.openAppSetting();
    } else {
      openSetting = true;
      update();
      getLocationPermission();
    }
  }

  void updateSavePhotosToggle(bool value) async {
    if(value) {
      userPreferences.add(UserPreferencesEnum.saveToGallery);
    } else {
      userPreferences.remove(UserPreferencesEnum.saveToGallery);
    }
    await UserPreferences.setUserPermission(userPreferences);
    savePhotosToggle = UserPreferences.hasSaveToGalleryAccess ?? false;
    isSettingUpdated = true;
    update();
  }

  void updateNearByJobToggle(bool value) async {
    if(value) {
      if(!userPreferences.contains(UserPreferencesEnum.nearByJobAccess)) {
        userPreferences.add(UserPreferencesEnum.nearByJobAccess);
      }
    } else {
      userPreferences.remove(UserPreferencesEnum.nearByJobAccess);
    }
    await UserPreferences.setUserPermission(userPreferences);
    nearByJobToggle = UserPreferences.hasNearByAccess ?? false;
    isSettingUpdated = true;
    update();
  }

  void updateDarkModeToggle(bool value) async {
    darkModeToggle = value;
    update();
    if (darkModeToggle) {
      //    this delay is given for displaying animation of trigger switching
      await Future<void>.delayed(const Duration(milliseconds: 300));
      Helper.showToastMessage("to_be_implemented".tr);
      updateDarkModeToggle(false);
    }
  }

  void updateSharePreferences() async {
    await preferences.save(PrefConstants.device, device);
  }

  ////////////////////////////    UPDATE TIMEZONE   ////////////////////////////

  void showTimezonePicker() {
    SingleSelectHelper.openSingleSelect(
        timezoneList,
        selectedTimeZone?.id,
        "select_timezone".tr,
        (value) {
          Get.back();
          selectedTimeZone = timezoneList.firstWhereOrNull((element) => element.id == value);
          updateTimezone();
        },
        isFilterSheet: true);
  }

  void updateTimezone() async {
    try {
      isTimezoneUpdating = true;
      update();
      Map<String, dynamic> params = {
        "key": "TIME_ZONE",
        "name": "Time Zone",
        "value": selectedTimeZone?.label.replaceAll(r'\', r''),
        "user_id": AuthService.userDetails?.id
      };
      dynamic response = await TimezoneRepository.updateTimezones(params);
      if (response) {
        CompanySettingsService.updateCompanySettingByKey(CompanySettingConstants.timeZone, selectedTimeZone?.label.replaceAll(r'\', r'') ?? timeZone);
        update();
        DateTimeHelper.setUpTimeZone();
        isSettingUpdated = true;
        update();
      }
    } catch (e) {
      rethrow;
    } finally {
      isTimezoneUpdating = false;
      update();
    }
  }

  void toggleIsPrimaryDeviceUpdating(){
    isPrimaryDeviceUpdating = !isPrimaryDeviceUpdating;
    update();
  }

  void onDispose() {
    lifeCycleStreamSubscription?.cancel();
  }

  /// Loads the user's language preference from the LanguageService.
  /// Updates the controller state with the selected language.
  Future<void> loadLanguagePreference() async {
    // Get the current language selection from the language service
    selectedLanguage = await LanguageService.getCurrentLanguage();
    // Update the UI to reflect the current language
    update();
  }

  /// Shows a language selection dialog to the user.
  /// Displays all available languages and allows the user to select one.
  /// When a language is selected, it calls updateLanguage with the selected language ID.
  void showLanguagePicker() {
    // Open a single select dialog with all available language options
    SingleSelectHelper.openSingleSelect(
      // List of available languages from the language service
      LanguageService.languageList,
      // Currently selected language or default to device language
      selectedLanguage?.id ?? "device",
      // Dialog title translated to current language
      "select_language".tr,
      // Callback when user selects a language
      (value) {
        // Close the dialog
        Get.back();
        // Update the app with the selected language
        updateLanguage(value);
      },
      // Enable filtering in the selection sheet
      isFilterSheet: true,
    );
  }

  /// Updates the application language based on the selected language ID.
  /// 
  /// @param languageId The ID of the selected language (e.g., "en_US", "es_US", or "device")
  /// 
  /// Sets isLanguageUpdating flag during the update process.
  /// Calls LanguageService to apply the language change.
  /// Updates the controller state with the new selected language.
  /// Forces the app to update to reflect the language change.
  Future<void> updateLanguage(String languageId) async {
    try {
      // Set flag to show loading state
      isLanguageUpdating = true;
      // Update UI to show loading indicator
      update();

      // Call language service to change the app language
      await LanguageService.setLanguage(languageId);

      // Find and store the selected language model for UI display
      selectedLanguage = LanguageService.languageList.firstWhereOrNull((element) => element.id == languageId);

      // Mark settings as updated for UI feedback
      isSettingUpdated = true;
    } catch (e) {
      // Propagate any errors that occur during language change
      rethrow;
    } finally {
      // Reset loading state regardless of success or failure
      isLanguageUpdating = false;
      // Force the entire app to update with the new language
      Get.forceAppUpdate();
    }
  }
}
