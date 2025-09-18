import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailHeader extends StatelessWidget {
  const ScheduleDetailHeader({
    super.key,
    required this.type,
    required this.schedule,
    this.onMarkAsComplete,
  });

  final String type;
  final SchedulesModel schedule;
  final VoidCallback? onMarkAsComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JPText(
                text: (type == 'schedule')
                    ? 'job_schedule_detail'.tr
                    : 'event_detail'.tr,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.left,
              ),

              schedule.iscompleted ?
                Material(
                  shape: const CircleBorder(),
                  clipBehavior: Clip.hardEdge,
                  color: JPAppTheme.themeColors.base,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minHeight: 30, minWidth: 30),
                    icon: JPIcon(
                      Icons.check_circle,
                      color: JPAppTheme.themeColors.success,
                    ),
                    onPressed: onMarkAsComplete,
                  ),
                )
                : Material(
                  shape: const CircleBorder(),
                  color: JPAppTheme.themeColors.base,
                  clipBehavior: Clip.hardEdge,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minHeight: 30, minWidth: 30),
                    icon: const JPIcon(
                      Icons.check_circle_outline_outlined,
                    ),
                    onPressed: onMarkAsComplete,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
