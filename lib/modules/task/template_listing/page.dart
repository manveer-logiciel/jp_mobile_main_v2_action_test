import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/task/template_listing/controller.dart';
import 'package:jobprogress/modules/task/template_listing/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskTemplateListingView extends GetView<TaskTemplateListingController> {
  const TaskTemplateListingView({ Key? key }) : super(key: key);
@override
  Widget build(BuildContext context) {
    return GetBuilder<TaskTemplateListingController>(
      builder: (_) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: 'Task Templates'.tr,
            onBackPressed: () {
              controller.cancelOnGoingRequest();
              Get.back();
            },
          ),
          body: body()
        ),
      ),
    );
  }

  Widget body() => JPSafeArea(
    child: TaskTemplateList(
      controller: controller
    ),
  );
}