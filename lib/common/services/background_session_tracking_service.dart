import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/user.dart';
import '../../core/constants/shared_pref_constants.dart';
import '../../core/utils/helpers.dart';
import '../models/device_info.dart';
import 'home.dart';
import 'package:jobprogress/common/services/auth.dart' as auth;

class BackgroundSessionTrackingService extends GetxService {
  /// [_timer] is used to schedule periodic API calls
  Timer? _timer;

  /// [isAppInForeground] indicates whether the app is in the foreground
  bool isAppInForeground = true;

  /// [appLifecycleSubscription] - used to listen to app lifecycle changes
  StreamSubscription<String>? appLifecycleSubscription;

  /// [minutesDelay] - the delay in minutes for the API call
  final int minutesDelay = 10;

  /// [distanceInMeters] - the distance in meters for location updates
  final int distanceInMeters = 0;

  /// [init] initializes the service
  static BackgroundSessionTrackingService setUp() => Get.put(BackgroundSessionTrackingService());

  /// [get] retrieves the service instance
  static BackgroundSessionTrackingService? get() {
    if(Get.isRegistered<BackgroundSessionTrackingService>()) {
      final BackgroundSessionTrackingService sessionTrackingService = Get.find<BackgroundSessionTrackingService>();
      return sessionTrackingService;
    }
    return null;
  }

  /// [startApiCallTimer] starts a timer that makes an API call every 10 minutes
  Future<void> startApiCallTimer() async {
    bgPrint('START TIMER');
    if(_timer?.isActive == true) {
      stopTimer();
    }
    _addAppLifecycleListener();

    dynamic isUserLoggedIn = await auth.preferences.read(PrefConstants.accessToken);
    if(isUserLoggedIn != null) {
      await _callSaveDeviceSessionApi();
    }
    // Schedule the API call every 10 minutes
    _timer = Timer.periodic(Duration(minutes: minutesDelay), (timer) {
      if(isUserLoggedIn != null && isAppInForeground) {
        _callSaveDeviceSessionApi();
      }
    });
  }

  /// [callSaveDeviceSessionApi] makes an API call to save the device session
  Future<void> _callSaveDeviceSessionApi() async {
    final Position? location = await getLocation();

    try {
      bgPrint('CALLING API: ${DateTime.now()}');

      DeviceInfo? deviceInfo = await Helper.getDeviceInfo();

      final Map<String, String> params = {
        'device_id': deviceInfo?.uuid ?? '',
        'device_type': 'mobile',
        'os': deviceInfo?.platform ?? '', // IOS or Android
        'platform': deviceInfo?.deviceModel ?? '', // Model name
        'user_agent': getUserAgent(deviceInfo), // Device & App version
        if(location != null) ...{
          'lat': location.latitude.toString(),
          'long': location.longitude.toString(),
        }
      };
      bgPrint('PARAMS: $params');
    await UserRepository.saveDeviceSession(params);
    } catch (e) {
      Helper.handleError(e);
    }
  }

  /// [stopTimer] stops the periodic API call
  void stopTimer() {
    bgPrint('STOP TIMER');
    _timer?.cancel();
    _timer = null;
    appLifecycleSubscription?.cancel();
    appLifecycleSubscription = null;
  }

  /// [_addAppLifecycleListener] helps in listening to app lifecycle changes
  void _addAppLifecycleListener() {
    appLifecycleSubscription = HomeService.appLifeCycleState.stream.listen((state) async {
      if (state == AppLifecycleState.resumed.toString()) {
        isAppInForeground = true;
      } else if (state == AppLifecycleState.paused.toString()) {
        isAppInForeground = false;
      }
    });
  }

  @override
  void onClose() {
    stopTimer();
    super.onClose();
  }

  /// [bgPrint] prints debug information
  static void bgPrint(String data) {
    debugPrint('BG Session Tracking: $data');
  }

  /// [getUserAgent] returns the user agent string
  String getUserAgent(DeviceInfo? deviceInfo) => '${'os_version'.tr}: ${deviceInfo?.deviceVersion},'
      ' ${'app_version'.tr.capitalize}: ${deviceInfo?.appVersion}';

  /// [getLocation] retrieves the current location of the device
  Future<Position?> getLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final LocationPermission permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.denied || permission != LocationPermission.deniedForever) {
        final Position position = await Geolocator.getCurrentPosition(locationSettings: getLocationSettings());
        return position;
      }
    } catch (e) {
      bgPrint('Permission Error: $e');
    }

    return null;
  }

  /// [getLocationSettings] - get the location settings on the basis of platform
  LocationSettings getLocationSettings() {
    LocationSettings locationSettings = const LocationSettings();

    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
          distanceFilter: distanceInMeters
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
          activityType: ActivityType.fitness,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: false,
          distanceFilter: distanceInMeters,
          allowBackgroundLocationUpdates: false
      );
    }
    return locationSettings;
  }

}
