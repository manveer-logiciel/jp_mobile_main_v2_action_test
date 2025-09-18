import 'package:geolocator/geolocator.dart';
import 'package:jobprogress/common/models/google_maps/place_details.dart';
import 'package:jobprogress/common/repositories/google_maps.dart';
import 'dart:async';
import 'package:jobprogress/common/enums/permission_type.dart';
import 'package:jobprogress/common/services/platform_permissions.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import '../run_mode/index.dart';

class LocationService {

  /// Location settings for the fetching the location
  ///
  /// This sets the accuracy of the location to low.
  static const LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.low,
  );

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<Position> getCoordinates({bool lastKnownCoordinates = false}) async {
    if(RunModeService.isUnitTestMode) {
      return getMockCoordinates();
    } else {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // If under some scenarios we want to access last known coordinates we can set
      // lastKnownCoordinates to true
      if (lastKnownCoordinates) {
        return await Geolocator.getLastKnownPosition() ?? await Geolocator.getCurrentPosition(
            locationSettings: locationSettings
        );
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings
      );
    }
  }

  static Future<Map<String, dynamic>> getAddress() async {

    try {

      Position position = await LocationService.getCoordinates();

      final address = getFormattedAddressFromCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return {
        'position' : position,
        'address' : address
      };
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> getFormattedAddressFromCoordinates({
    double latitude = 0,
    double longitude = 0,
  }) async {
    try {     
      PlaceDetailsModel placeData = await GoogleMapRepository().fetchPlaceDetailsFromLatLng(lat: latitude, lng: longitude);
      return placeData.formattedAddress ?? "-";
    } catch (e) {
      Helper.recordError(e);
    }

    return null;
  }

  static Future<bool> hasLocationPermission() async {
    final permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      case LocationPermission.unableToDetermine:
        return false;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        return true;
    }
  }

  /// [requestPermission] should request location permission
  static Future<void> requestPermission() async {
    bool isPermissionGranted = await hasLocationPermission();
    if (!isPermissionGranted) {
      await Geolocator.requestPermission();
    }
  }

  static Position getMockCoordinates() => Position(
    altitudeAccuracy: 10,
    headingAccuracy: 10,
    longitude: 100.0, latitude: 100.0, timestamp: DateTime.now(), accuracy: 50.6,
      altitude: 20.0, heading: 120, speed: 150.9, speedAccuracy: 10.0);

  /// [checkAndReRequestPermission] helps in checking and requesting permission
  static Future<bool> checkAndReRequestPermission() async {
    if (RunModeService.isUnitTestMode) return false;
    // Checking the current status of location permission
    final result = await Geolocator.checkPermission();
    // If the permission is denied i.e., 'Ask Every' or 'Never Requested'
    // simply showing platform permission dialog for requesting permission
    if (result == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      // In case permission is still denied no need to proceed further
      if (permission == LocationPermission.denied) return false;
    }

    // Otherwise checking whether permission is granted or not
    // If permission is granted then no need to show permission request dialog
    // otherwise it'll be shown
    bool isPermissionGranted = await hasLocationPermission();
    if (!isPermissionGranted) {
      // adding a delay to show permission request dialog so to complete route navigation
      await Future<void>.delayed(const Duration(milliseconds: 500));
      // Asking for permission manually
      await PlatformPermissionService.showRequestPermissionDialog(
        PermissionRequestType.location,
      );
      // Checking the current status of location permission
      final result = await Geolocator.checkPermission();
      // In case permission is set to 'Ask Every Time', re-requesting permission
      // Other simply proceeding further and checking the permission status
      if (result == LocationPermission.denied) {
        // Re-requesting permission
        final permission = await Geolocator.requestPermission();
        // In case permission is still denied no need to proceed further
        if (permission == LocationPermission.denied) return false;
      }
      // Checking the permission status
      isPermissionGranted = await hasLocationPermission();
      // In case permission is not granted no need to proceed further
      if (!isPermissionGranted) return false;
    }

    // In permission is granted, now checking whether location service is enabled or not
    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    // In case location service is not enabled, requesting user to enable location service.
    if (!isServiceEnabled) {
      await PlatformPermissionService.showRequestPermissionDialog(
        PermissionRequestType.locationService,
        action: Geolocator.openLocationSettings,
      );
      // Re-checking whether location service is enabled or not
      isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    }
    // location will be fetched only when service is enabled and location permission is granted
    return isServiceEnabled && isPermissionGranted;
  }

}
