import 'dart:convert';

import 'package:get/get.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/global_widgets/has_permission/controller.dart';

class PermissionRepository {
  static Future<void> getPermissions() async {
    await dio.get(Urls.permissions).then((res) {
      final jsonData = json.decode(res.toString());
      List<String> permissionData = [];

      //Converting api data to model
      jsonData["data"].forEach((dynamic permission) => permissionData.add(permission));

      //Setting permission data into service and updating controller
      PermissionService.permissionList = permissionData;
      
      if(!Get.isRegistered<HasPermissionController>()) {
        Get.put(HasPermissionController());
      }

      final hasPermissionController = Get.find<HasPermissionController>();
      hasPermissionController.update();
    });
  }
}
