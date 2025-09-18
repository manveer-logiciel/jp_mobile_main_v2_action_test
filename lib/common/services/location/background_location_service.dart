import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/auth.dart' as auth;
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connectivity.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/background_location/controller.dart';
import 'loaction_service.dart';

class BackgroundLocationService {

  /// [isSendingLocationToServer] is a flag which helps in avoiding multiple
  /// requests to server at the same time
  static bool isSendingLocationToServer = false;

  /// [controller] is used to update data of the [JPBackgroundLocationController]
  /// which is a global controller can be used by widgets that require updated
  /// data of location updates
  static JPBackgroundLocationController? controller;

  /// [distanceInMeters] can be used to update location at certain distance only
  /// 0 - continuous location updates
  /// >0 - location updates at certain distance
  static int distanceInMeters = 0;

  /// [trackingDetails] is used to store the settings of the tracking and timezone information
  static Map<String, dynamic>? trackingDetails;

  /// [locationStream] is used to listen to the location
  static StreamSubscription<Position>? locationStream;

  /// [delayTimer] is used to terminate interval time for sending location data to server
  static Timer? delayTimer;

  /// [isUserTrackingEnabled] is controlled by Launch Darkly Feature Flag [LDFlagKeyConstants.userLocationTracking]
  /// and it is responsible for enabling/disabling user location tracking
  static bool get isUserTrackingEnabled => LDService.hasFeatureEnabled(LDFlagKeyConstants.userLocationTracking);

  /// [minutesDelay] is the delay in minutes to send request to server
  /// It is retrieved from Launch Darkly Feature Flag [LDFlagKeyConstants.userLocationsTrackingPollingInterval]
  /// In case its not available, it will send request to server at every 15 minutes
  static int get minutesDelay => LDService.getValue<int>(LDFlagKeyConstants.userLocationsTrackingPollingInterval) ?? 15;

  /// [init] can be called to initialize the background location service
  static Future<void> init() async {
    if (!isUserTrackingEnabled) return;
    // setting up controller for widget updates
    setUpController();
    // starting background tracking
    await stopAndInitiateService();
  }


  /// [setUpController] is responsible for initializing the controller
  static void setUpController() {
    controller = JPBackgroundLocationController();
    controller?.onInit();
  }


  /// [fetchLocationCallback] receives location from background service and decides
  /// whether to send location data to server or not
  static void fetchLocationCallback(Position location) async {
    if (!isUserTrackingEnabled) return;

    if (trackingDetails == null || !ConnectivityService.isInternetConnected) return;

    // deciding whether to send data to server or not
    bool canMakeRequest = !isSendingLocationToServer && doTrackLocation();
    if (!canMakeRequest) return;

    // sending location updates to server
    await updateLocationOnServer(location.latitude, location.longitude);
    debugPrint('BG ->  (${DateTime.now().toIso8601String()}) : ${location.latitude}, ${location.longitude}');
  }


  /// [startTracking] creates a background service to listen to location updates
  /// It is also responsible for creating notification for android
  static Future<void> startTracking() async {
    if (!isUserTrackingEnabled) return;

    final settings = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.gpsTracking);
    final timeZone = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.timeZone, onlyValue: false);
    final hanPermission = await LocationService.hasLocationPermission();

    // if location permission is not give then no need to track location
    if (!hanPermission) return;

    // in case tracking is not enabled no need to track user location
    if (settings is! Map || !Helper.isTrue(settings['enable'])) return;

    trackingDetails = {
      CompanySettingConstants.gpsTracking: settings,
      CompanySettingConstants.timeZone: timeZone,
    };

    if (!doTrackLocation()) {
      // stopping tracking if it can't be tracked on
      // number of conditions
      stopTracking();
    } else {
      bgPrint('STARTED TRACKING');
      locationStream = Geolocator.getPositionStream(
          locationSettings: getLocationSettings()
      ).listen(fetchLocationCallback);
    }
  }


  /// [stopAndInitiateService] can be used to re-initiate service
  static Future<void> stopAndInitiateService() async {
    if (!isUserTrackingEnabled) return;

    // checking and stoping whether service is already running
    await stopTracking(toggleRunningStatus: false);
    enableServerSend();
    await Future<void>.delayed(const Duration(seconds: 2));
    await startTracking();
    bool isBgServiceRunning = locationStream != null;
    controller?.toggleServiceRunning(isBgServiceRunning);
  }


  /// [stopTracking] is a wrapper over disposing a service
  static Future<void> stopTracking({bool toggleRunningStatus = true}) async {
    if (!isUserTrackingEnabled) return;

    await locationStream?.cancel();
    locationStream = null;
    trackingDetails = null;
    if(toggleRunningStatus) controller?.toggleServiceRunning(false);
  }


  /// [doTrackLocation] checks the available settings and decides whether current
  /// day and current time falls in for location to be tracked
  static bool doTrackLocation() {
    // Confirm from user permissions whether user has permission to get tracked
    bool hasUserTrackingPermission = PermissionService.hasUserPermissions([PermissionConstants.userMobileTracking]);
    // in case user does not have permission no need to track location
    if (!hasUserTrackingPermission) return false;

    final settings = trackingDetails?[CompanySettingConstants.gpsTracking];
    // in case settings not available no need to track location
    if (settings == null) return false;
    // setting up current time as per timezone selected
    final timeAsPerTimezone = DateTimeHelper.formatDate(DateTimeHelper.now().toString(), DateFormatConstants.dateTimeServerFormat);
    final currentTime = DateTime.parse(timeAsPerTimezone);

    // checking whether to track location today or not
    final doTrackToday = doTrackFromCurrentDay(settings, currentTime);

    if (!doTrackToday) return false;

    final startTime = DateTimeHelper.addCurrentDayToHourDetails(settings!['start_time']);
    final endTime = DateTimeHelper.addCurrentDayToHourDetails(settings!['end_time']);

    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }


  /// [doTrackFromCurrentDay] helps in deciding whether location can be tracked
  /// today or not as per available settings
  static bool doTrackFromCurrentDay(dynamic settings, DateTime currentTime) {
    // tracking only if settings are enabled
    if (settings is Map && Helper.isTrue(settings['enable'])) {
      String todayIndex = (currentTime.weekday == DateTime.sunday ? 0 : currentTime.weekday).toString();
      // checking whether current day is in list or not
      List<String> days = (settings['days'] ?? <dynamic>[]).cast<String>();
      return (days.contains(todayIndex));
    }
    return false;
  }


  /// [getLocationSettings] - get the location settings on the basis of platform
  static LocationSettings getLocationSettings() {
    LocationSettings locationSettings = const LocationSettings();
    // Using the single userLocationTracking flag for both background and foreground tracking
    bool allowBackgroundLocationUpdates = isUserTrackingEnabled;

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          distanceFilter: distanceInMeters,
          foregroundNotificationConfig: allowBackgroundLocationUpdates ? ForegroundNotificationConfig(
              notificationIcon: const AndroidResource(name: 'ic_notification'),
              notificationText: 'app_is_using_location_in_background'.tr,
              notificationTitle: 'app_is_running_in_background'.tr,
              setOngoing: true,
          ) : null
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        activityType: ActivityType.fitness,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: allowBackgroundLocationUpdates,
        distanceFilter: distanceInMeters,
        allowBackgroundLocationUpdates: allowBackgroundLocationUpdates
      );
    }

    return locationSettings;
  }


  /// [updateLocationOnServer] is responsible for parsing the coordinates to address
  /// and makes and api call to server to update last tracked location
  static Future<void> updateLocationOnServer(double latitude, double longitude) async {
    if (!isUserTrackingEnabled) return;

    try {
      bgPrint('SENDING REQUEST TO SERVER ${DateTime.now()}');
      // setting flag to true to avoid concurrent requests
      BackgroundLocationService.disableServerSend();

      // reading necessary data from local
      Map<String, dynamic>? device = await auth.preferences.read(PrefConstants.device);
      final user = await AuthService.getLoggedInUser();

      // setting up params
      Map<String, dynamic> params = {
        "device_id": device?['id'],
        "device_uuid": device?['uuid'],
        "latitude": latitude,
        "longitude": longitude,
        "user_id": user.id,
        "location": "",
      };

      // requesting location update
      await UserRepository.userTracking(params);

      // sending data to main thread for update UI
      controller?.setLocationDetails(details: {
        'time': DateTimeHelper.now().toString(),
        "latitude": latitude,
        "longitude": longitude,
      });

      bgPrint('REQUEST COMPLETE FOR USER: ${user.id}');
    } catch(e) {
      rethrow;
    } finally {
      // additional delay to save server from too many requests
      delayTimer = Timer(Duration(minutes: minutesDelay), enableServerSend);
    }
  }

  /// [disableServerSend] is used to stop sending location data to server
  static void disableServerSend() {
    bgPrint('SERVER SEND DISABLED');
    delayTimer?.cancel();
    isSendingLocationToServer = true;
  }

  /// [enableServerSend] is used to start sending location data to server
  static void enableServerSend() {
    bgPrint('SERVER SEND ENABLED');
    delayTimer?.cancel();
    isSendingLocationToServer = false;
  }

  static void bgPrint(String data) {
    debugPrint('BG: $data');
  }

}