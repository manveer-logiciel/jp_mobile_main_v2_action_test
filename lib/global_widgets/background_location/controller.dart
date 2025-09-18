import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/location/loaction_service.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../../common/services/auth.dart';

class JPBackgroundLocationController extends GetxController {

  Map<dynamic, dynamic> lastLocationDetails = {}; // stores the location details

  String rawLastTrackedTime = ""; // holds the un-formatted last location update time
  String formattedLastTrackedTime = ""; // holds the formatted last location update time
  String lastTrackedAddress = ""; // holds the late location update address

  bool isServiceRunning = false; // helps in deciding whether service is running or not

  Timer? timer; // helps in refreshing widget every minute

  bool get doShowUserLiveTacking => isServiceRunning && !Helper.isValueNullOrEmpty(rawLastTrackedTime);
  bool get doShowLastTracking => !Helper.isValueNullOrEmpty(rawLastTrackedTime);

  @override
  void onInit() {
    timer = Timer(const Duration(minutes: 1), update);
    setLocationDetails();
    super.onInit();
  }

  /// [setLocationDetails] helps in setting up location details
  /// when [details] is null it tries to access data from local prefs
  /// otherwise when [details] are not null it sets location data from details
  Future<void> setLocationDetails({Map<dynamic, dynamic>? details}) async {
    final trackingDetails = details ?? await preferences.read(PrefConstants.gpsTrackDetails);
    if (trackingDetails is Map) {
      rawLastTrackedTime = trackingDetails['time'];
      formattedLastTrackedTime = DateTimeHelper.formatDate(rawLastTrackedTime, DateFormatConstants.dateTimeFormatWithoutSeconds);
      await preferences.save(PrefConstants.gpsTrackDetails, trackingDetails);
    }
    update();
  }

  /// [toggleServiceRunning] helps in toggling service running state
  void toggleServiceRunning(bool val) {
    isServiceRunning = val;
    if (val) {
      timer = Timer(const Duration(minutes: 1), update);
    } else {
      timer?.cancel();
    }
    update();
  }

  void close() {
    timer?.cancel();
  }

  String timeAgo() {
    return DateTimeHelper.formatDate(rawLastTrackedTime, 'am_time_ago');
  }

  Future<void> addLastTrackedAddress() async {
    final trackingDetails = await preferences.read(PrefConstants.gpsTrackDetails);
    if (trackingDetails is Map && Helper.isValueNullOrEmpty(trackingDetails['address'])) {
      trackingDetails['address'] = await LocationService.getFormattedAddressFromCoordinates(
          latitude: trackingDetails['latitude'],
          longitude: trackingDetails['longitude']
      ) ?? "-";
    }
    lastTrackedAddress = trackingDetails['address'] ?? "-";
    preferences.save(PrefConstants.gpsTrackDetails, trackingDetails);
    update();
  }

}