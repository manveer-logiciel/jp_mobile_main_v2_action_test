import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/single_child_scroll_view.dart/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/shimmer.dart';
import 'widgets/sub_list.dart';
import '../../core/constants/widget_keys.dart';

class DailyTask extends StatelessWidget {
  const DailyTask({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DailyPlanController>(
      init: DailyPlanController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          endDrawer: JPMainDrawer(
            selectedRoute: 'my_daily_plans',
            onRefreshTap: () {
              controller.refreshList(showLoading: true);
            },
          ),
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            onBackPressed: () {
              Get.back();
            },
            title: 'daily_plan'.tr,
            actions: [
              IconButton(
                splashRadius: 20,
                onPressed: () {
                  controller.scaffoldKey.currentState!.openEndDrawer();
                },
                icon: JPIcon(
                  Icons.menu,
                  color: JPAppTheme.themeColors.base,
                ),
              )
            ],
          ),
          body: JPSafeArea(
            child: controller.isLoading
                ? const DailyPlanShimmer()
                : (controller.showPlaceHolder)
                    ? NoDataFound(
                        icon: Icons.ballot,
                        title: 'no_plan_found'.tr.capitalize,
                        descriptions:
                            'no_work_planned_for_today'.tr.capitalizeFirst,
                      )
                    : Column(
                        children: [
                          JPSingleChildScrollView(
                            onRefresh: () async {
                              await controller.refreshList();
                            },
                            item: Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      JPResponsiveDesign.floatingButtonSize),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Appointments
                                  DailyPlanSubList<AppointmentModel>(
                                    title: 'appointments'.tr,
                                    list: controller.appointmentList,
                                    controller: controller,
                                  ),

                                  /// Tasks
                                  DailyPlanSubList<TaskListModel>(
                                    title: 'tasks'.tr,
                                    list: controller.taskList,
                                    controller: controller,
                                  ),

                                  /// Schedules
                                  DailyPlanSubList<SchedulesModel>(
                                    title: 'schedules'.tr,
                                    list: controller.schedulesList,
                                    controller: controller,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
          floatingActionButton: JPButton(
            key: const ValueKey(WidgetKeys.addButtonKey),
            size: JPButtonSize.floatingButton,
            iconWidget: JPIcon(
              Icons.add,
              color: JPAppTheme.themeColors.base,
            ),
            onPressed: controller.openQuickActions,
          ),
        );
      },
    );
  }
}
