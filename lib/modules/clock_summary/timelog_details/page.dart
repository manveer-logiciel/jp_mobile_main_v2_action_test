import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/controller.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TimeLogDetailsView extends StatelessWidget {
  const TimeLogDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimeLogDetailsController>(
      init: TimeLogDetailsController(),
      global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: () async {
              controller.cancelOnGoingApiRequest();
              return true;
            },
            child: JPScaffold(
              scaffoldKey: controller.scaffoldKey,
              backgroundColor: JPAppTheme.themeColors.base,
              appBar: JPHeader(
                title: controller.title,
                titleColor: JPAppTheme.themeColors.text,
                backgroundColor: JPAppTheme.themeColors.base,
                backIconColor: JPAppTheme.themeColors.text,
                centerTitle: true,
                onBackPressed: () {
                  controller.cancelOnGoingApiRequest();
                  Get.back();
                },
                actions: [
                  JPTextButton(
                    icon: Icons.menu,
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openEndDrawer();
                    },
                    color: JPAppTheme.themeColors.text,
                    iconSize: 25,
                  ),
                  const SizedBox(
                    width: 8,
                  )
                ],
              ),
              endDrawer: JPMainDrawer(
                selectedRoute: '',
              ),
              body: TimeLogDetailsContent(
                controller: controller,
              ),
            ),
          );
        },
    );
  }
}
