import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/task/list_tile/index.dart';
import 'package:jobprogress/modules/task/list_tile/shimmer.dart';
import 'package:jobprogress/modules/task/listing/controller.dart';
import 'package:jobprogress/modules/task/listing/secondary_header.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskListingView extends StatelessWidget {
  const TaskListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListingController>(
        global: false,
        init: TaskListingController(),
        builder: (controller) {
          return JPScaffold(
            scaffoldKey: controller.scaffoldKey,
            appBar: JPHeader(
              onBackPressed: () {
                Get.back();
              },
              title: controller.job != null
                  ? controller.job!.customer!.fullName!
                  : "tasks".tr,
              actions: [
                Center(
                  child: JPTextButton(
                    key: const Key(WidgetKeys.mainDrawerMenuKey),
                    onPressed: () {
                      controller.scaffoldKey.currentState!.openEndDrawer();
                    },
                    icon: Icons.menu,
                    color: JPAppTheme.themeColors.base,
                    iconSize: 24,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            endDrawer: JPMainDrawer(
              selectedRoute: controller.jobId != null ? '' : 'tasks',
              onRefreshTap: controller.refreshList,
            ),
            body: JPSafeArea(
              top: false,
              containerDecoration:
                  BoxDecoration(color: JPAppTheme.themeColors.inverse),
              child: Container(
                color: JPAppTheme.themeColors.inverse,
                child: Column(
                  children: [
                    TaskListSecondaryHeader(
                      taskController: controller,
                    ),
                    controller.isLoading
                        ? const Expanded(child: TaskListTileShimmer())
                        : controller.taskList.isNotEmpty
                            ? JPListView(
                                listCount: controller.taskList.length,
                                doAddFloatingButtonMargin: true,
                                onLoadMore: controller.canShowLoadMore
                                    ? controller.loadMore
                                    : null,
                                onRefresh: controller.refreshList,
                                itemBuilder: (context, index) {
                                  if (index < controller.taskList.length) {
                                    return InkWell(
                                      child: TaskListTile(
                                          controller.taskList[index],key: ValueKey('${WidgetKeys.taskListingKey}[$index]'),),
                                      onTap: () {
                                        TaskService.openTaskdetail(
                                            task: controller.taskList[index],
                                            callback: controller
                                                .handleQuickActionUpdate);
                                      },
                                      onLongPress: () {
                                        TaskService.openQuickActions(
                                            controller.taskList[index],
                                            controller.handleQuickActionUpdate);
                                      },
                                    );
                                  } else if (controller.canShowLoadMore) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Center(
                                          child: FadingCircle(
                                              color: JPAppTheme
                                                  .themeColors.primary,
                                              size: 25)),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              )
                            : Expanded(
                                child: NoDataFound(
                                  icon: Icons.task,
                                  title: "no_task_found".tr.capitalize,
                                ),
                              )
                  ],
                ),
              ),
            ),
            floatingActionButton: Visibility(
              visible: PhasesVisibility.canShowSecondPhase,
              child: JPButton(
                size: JPButtonSize.floatingButton,
                iconWidget: JPIcon(
                  Icons.add,
                  color: JPAppTheme.themeColors.base,
                ),
                onPressed: controller.navigateToCreateTask,
              ),
            ),
          );
        });
  }
}
