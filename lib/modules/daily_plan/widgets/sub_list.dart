import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/services/appointment/quick_actions.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/schedule_details/quick_actions.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/task_tile/index.dart';
import 'package:jobprogress/modules/daily_plan/controller.dart';
import 'package:jobprogress/modules/daily_plan/widgets/schedules.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'appointments.dart';

class DailyPlanSubList<T> extends StatelessWidget {
  const DailyPlanSubList({
    super.key,
    required this.title,
    required this.list,
    required this.controller,
  });

  /// [list] holds the daily plans
  final List<T> list;

  /// [title] is used to display title of
  final String title;

  /// [controller] is used to handle plan actions
  final DailyPlanController controller;

  @override
  Widget build(BuildContext context) {
    if (list.isNotEmpty) {
      return StickyHeader(
        header: Container(
          color: JPAppTheme.themeColors.base,
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10, left: 16, top: 16),
          transform: Matrix4.translationValues(0.0, -0.25, 0.0),
          child: JPText(
            text: '${title.toUpperCase()} (${list.length})',
            textAlign: TextAlign.left,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        content: Container(
          padding: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(color: JPAppTheme.themeColors.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JPListView(
                listCount: list.length - 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return getPlanTile(index);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getPlanTile(int index) {
    final dailyPlan = list[index];

    if (dailyPlan is AppointmentModel) {
      return appointmentTile(dailyPlan, index);
    } else if (dailyPlan is TaskListModel) {
      return taskTile(dailyPlan);
    } else if (dailyPlan is SchedulesModel) {
      return scheduleTile(dailyPlan, index);
    } else {
      return const SizedBox();
    }
  }

  Widget appointmentTile(AppointmentModel dailyPlan, int index) {
    return DailyPlanAppointmentListTile(
      appointmentItem: dailyPlan,
      onLongPress: () {
        AppointmentService.openQuickActions(
          dailyPlan,
          controller.handleAppointmentQuickActionUpdate,
        );
      },
      onTap: () {
        controller.navigateToAppointmentDetails(index);
      },
    );
  }

  Widget taskTile(TaskListModel dailyPlan) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: InkWell(
        onTap: (() {
          TaskService.openTaskdetail(
            task: dailyPlan,
            callback: controller.handleTaskQuickActionUpdate,
          );
        }),
        onLongPress: () {
          TaskService.openQuickActions(
            dailyPlan,
            controller.handleTaskQuickActionUpdate,
            actionFrom: 'daily_plan',
          );
        },
        child: DailyPlanTasksListTile(
          taskItem: dailyPlan,
        ),
      ),
    );
  }

  Widget scheduleTile(SchedulesModel dailyPlan, int index) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: DailyPlanSchedulesListTile(
        scheduleItem: dailyPlan,
        onTap: () {
          controller.navigateToScheduleDetails(index);
        },
        onLongPress: () {
          if (PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule])) {
            ScheduleService.openQuickActions(
              dailyPlan,
              controller.handleScheduleQuickActionUpdate,
              actionFrom: 'daily_plan',
            );
          }
        },
      ),
    );
  }
}
