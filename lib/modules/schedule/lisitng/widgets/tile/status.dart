
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_icon.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleTileStatus extends StatelessWidget {
  const ScheduleTileStatus({
    super.key,
    required this.schedule
  });

  final SchedulesModel schedule;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
          tileStatus(status: 'accept', count: schedule.confirmedCount, title: 'confirmed'.tr),
          tileStatus(status: 'decline', count: schedule.declinedCount, title: 'declined'.tr),
          tileStatus(status: 'pending', count: schedule.pendingCount, title: 'pending'.tr),
      ],
    );
  }

  Widget tileStatus({
    required String status,
    required String title,
    int? count = 0,
  }) {
    return Row(
      children: [
        ScheduleDetailStatusIcon(status: status),
        const SizedBox(
          width: 5,
        ),
        JPText(
          text: "${count ?? 0} $title",
          textSize: JPTextSize.heading5,
          textColor: JPAppTheme.themeColors.tertiary,
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
