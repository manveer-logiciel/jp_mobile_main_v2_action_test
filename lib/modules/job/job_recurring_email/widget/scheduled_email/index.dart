import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/modules/job/job_recurring_email/controller.dart';
import 'package:jobprogress/modules/job/job_recurring_email/widget/scheduled_email/schedule_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleEmail extends StatelessWidget {
  const ScheduleEmail(
      {super.key,
      required this.controller,
      required this.recurringEmail,
      required this.index});

  final JobRecurringEmailController controller;

  final RecurringEmailModel recurringEmail;

  final int index;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: List.generate(recurringEmail.scheduleEmail!.length, (j) {
        if (doHideSchedule(j)) {
          return const SizedBox.shrink();
        } else {
          return ScheduledEmailTile(
            item: recurringEmail.scheduleEmail![j],
            controller: controller,
            canceledBy: recurringEmail.canceledBy ??'',
            cancelledNote: recurringEmail.cancelNote!,
            doShowRail: j < recurringEmail.scheduleEmail!.length - 1,
            historyButton: j == 0 ? historyButton : null,
          );
        }
      }),
    );
  }

  bool doHideSchedule(int j) =>
      !recurringEmail.scheduleEmail![j].isFirstEmail &&
      controller.recurringEmail![index].showHistory == false &&
      recurringEmail.scheduleEmail![j].status == 'success';

  Widget? get historyButton => recurringEmail.showHistoryButton
      ? Material(
          color: JPColor.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: JPTextButton(
              padding: 2,
              isExpanded: false,
              onPressed: () {
                controller.toggleshowHistory(index);
              },
              textSize: JPTextSize.heading5,
              color: JPAppTheme.themeColors.primary,
              icon: controller.recurringEmail![index].showHistory
                  ? Icons.keyboard_arrow_up_outlined
                  : Icons.keyboard_arrow_down_outlined,
              text: controller.recurringEmail![index].showHistory
                  ? '${'hide'.tr.capitalize!} ${'history'.tr.capitalize!}'
                  : '${'view'.tr.capitalize!} ${'history'.tr.capitalize!}',
            ),
          ),
        )
      : null;
}
