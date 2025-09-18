import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/uploads/controller.dart';

class ConnectivityService {
  static StreamSubscription<List<ConnectivityResult>>? internetConnectionStream;
  static bool isInternetConnected = false;

  static void setUpConnectivity() {
    internetConnectionStream =
        Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      isInternetConnected = results.any((result) => result != ConnectivityResult.none);
      onNetworkLost(!isInternetConnected);
    });
  }

  static void onNetworkLost(bool isLost) {
    if (isLost) {
      if (Get.isRegistered<UploadsListingController>()) {
        final uploadController = Get.find<UploadsListingController>();
        uploadController.pauseAll(forcePause: true);
      }
    }
  }

  static Future<void> disposeConnectivity() async {
    await internetConnectionStream?.cancel();
    internetConnectionStream = null;
  }
}
