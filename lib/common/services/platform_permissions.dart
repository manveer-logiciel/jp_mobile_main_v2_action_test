import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/app_state.dart';
import 'package:jobprogress/common/enums/permission_type.dart';
import 'package:jobprogress/common/services/home.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:permission_handler/permission_handler.dart';


class PlatformPermissionService {
  // Checking if storage permission exist
  static Future<bool> hasStoragePermissions() async {
    // Android 13 or higher do no require special storage permission
    if (await isAndroid13OrHigher()) return true;
    // Checking the current permission status
    final permissionStatus = await Permission.storage.status;

    switch(permissionStatus) {
      // If the permission is denied i.e., 'Ask Every' or 'Never Requested'
      // simply showing platform permission dialog for requesting permission
      case PermissionStatus.denied:
        await Permission.storage.request();
        // In case permission in denied no need to proceed further
        if((await Permission.storage.status).isDenied) {
          break;
        } else {
          // In case permission is not denied, rechecking permission status
          return await hasStoragePermissions();
        }
      case PermissionStatus.permanentlyDenied:
        // In case permission is permanently denied, manually asking for permission
        await showRequestPermissionDialog(PermissionRequestType.storage);
        // In case permission is set to 'Ask Every Time' re-requesting permission
        await Permission.camera.request();
        // In case permission is not denied, rechecking permission status
        return (await Permission.storage.status).isGranted;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return false;
      case PermissionStatus.granted:
        return true;
    }
    return false;
  }

  static Future<bool> hasCameraPermission() async {
    // Checking the current permission status
    final status = await Permission.camera.status;

    switch (status) {
      // If the permission is denied i.e., 'Ask Every' or 'Never Requested'
      // simply showing platform permission dialog for requesting permission
      case PermissionStatus.denied:
        // In case permission in denied no need to proceed further
        await Permission.camera.request();
        // In case permission is denied no need to proceed further
        if((await Permission.camera.status).isDenied) {
          break;
        } else {
          // In case permission is not denied, rechecking permission status
          return await hasCameraPermission();
        }
      case PermissionStatus.permanentlyDenied:
        // In case permission is permanently denied, manually asking for permission
        await showRequestPermissionDialog(PermissionRequestType.camera);
        // In case permission is set to 'Ask Every Time' re-requesting permission
        await Permission.camera.request();
        // In case permission is not denied, rechecking permission status
        return (await Permission.camera.status).isGranted;
      default:
        break;
    }
    return await Permission.camera.isGranted;
  }

  static Future<bool> requestExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }

  static Future<bool> isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    final info = await Helper.getDeviceInfo();
    String? baseVersion = info?.deviceVersion?.split(".")[0];
    bool isReleaseVersion13orAbove = int.parse(baseVersion ?? "0") >= 13;
    return isReleaseVersion13orAbove;
  }

  static (String?, String?, IconData?) getPermissionRequestDetails(PermissionRequestType permissionRequestType) {
    switch (permissionRequestType) {
      case PermissionRequestType.location:
        return ('location_permission_title'.tr, 'location_permission_subtitle'.tr, Icons.location_on_outlined);

      case PermissionRequestType.locationService:
        return ('location_service_permission_title'.tr, 'location_service_permission_subtitle'.tr, Icons.my_location_outlined);

      case PermissionRequestType.camera:
        return ('camera_permission_title'.tr, 'camera_permission_subtitle'.tr, Icons.camera_alt_outlined);

      case PermissionRequestType.storage:
        return ('storage_permission_title'.tr, 'storage_permission_subtitle'.tr, Icons.storage);

      case PermissionRequestType.contact:
        return ('contact_permission_title'.tr, 'contact_permission_subtitle'.tr, Icons.contacts_outlined);

      case PermissionRequestType.notification:
        return ('notification_permission_title'.tr, 'notification_permission_subtitle'.tr, Icons.notifications_outlined);
    }
  }

  static Future<void> showRequestPermissionDialog(PermissionRequestType type, {
    Future<bool> Function()? action
  }) async {
    final (title, subTitle, icon) = getPermissionRequestDetails(type);
    // In case app is loading data or permission is not known
    // then don't show permission dialog
    if (appState == JPAppState.loadingData || title == null) return;
    // Creating a temporary permission stream subscription
    StreamSubscription<String>? permissionStreamSubscription;

    await showJPBottomSheet(
        child: (_) => JPConfirmationDialog(
          title: title,
          subTitle: subTitle,
          icon: icon,
          suffixBtnText: 'settings'.tr.toUpperCase(),
          prefixBtnText: 'cancel'.tr.toUpperCase(),
          onTapSuffix: () async {
            permissionStreamSubscription = HomeService.appLifeCycleState.stream.listen((event) async {
              if(event == "AppLifecycleState.resumed") {
                // closing the dialog when user returns to app
                Get.back();
              }
            });
            // Executing the desired action
            action != null ? await action() : await openAppSettings();
          },
        )
    );
    // cancelling out the stream subscription
    permissionStreamSubscription?.cancel();
  }
}