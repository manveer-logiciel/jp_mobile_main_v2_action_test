import 'dart:convert';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/push_notifications/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/common_events.dart';
import '../../core/constants/shared_pref_constants.dart';
import '../../core/constants/urls.dart';
import '../../core/utils/helpers.dart';
import '../models/application_info.dart';
import 'package:jobprogress/common/libraries/global.dart' as globals;
import '../providers/http/interceptor.dart';

class DeviceRepository {
  static Future<bool> registerDevice() async {
    try {
      String? token = await PushNotificationsService.getToken();
      if (token == null) return false;
      Map<String, dynamic>? device = await preferences.read(PrefConstants.device);

      if (device == null || Helper.isValueNullOrEmpty(device["id"])) {
        return false;
      }

      Map<String, dynamic> params = {
        "device_id": device["id"].toString(),
        "device_token": token,
        "uuid": device["uuid"],
      };

      final response = await dio.put(
        Urls.registerDevice(device["id"].toString()),
        queryParameters: params,
      );

      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      MixPanelService.trackEvent(event: MixPanelCommonEvent.deviceRegisterFailure);
      return false;
    }
  }

  static Future<bool> setPrimaryDevice(String deviceId) async {
    try {
      final response = await dio.put(Urls.setDefaultDevice(deviceId),);
      final jsonData = json.decode(response.toString());
      return jsonData['status'] == 200;
    } catch (e) {
      //Handle error
      rethrow;
    }
  }

  static Future<ApplicationInfo> checkForAppUpdate() async {
    try {

      Map<String, dynamic> params = {
        "built": globals.appVersion,
        "device": globals.appPlatform,
      };

      final response = await dio.get(Urls.latestUpdate, queryParameters: params);
      final jsonData = json.decode(response.toString());
      return ApplicationInfo.fromJson(jsonData["data"] is Map<String, dynamic> ? jsonData["data"] : {});
    } catch (e) {
      rethrow;
    }
  }
}
