import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/global_widgets/animated_open_container/index.dart';
import 'package:jobprogress/modules/schedule/details/page.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/assets_files.dart';

class CalendarScheduleTile extends StatelessWidget {
  const CalendarScheduleTile({
    super.key,
    required this.schedule,
    required this.eventColor,
    this.onScheduleDelete,
  });

  final SchedulesModel schedule;

  final VoidCallback? onScheduleDelete;

  final Color eventColor;

  @override
  Widget build(BuildContext context) {
    return JPOpenContainer(
      closeWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: eventColor,
                              width: 2.8
                          )
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    JPText(
                      text: schedule.scheduleTimeString ?? '',
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.secondaryText,
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: JPText(
                              text: schedule.title ?? "",
                              textSize: JPTextSize.heading4,
                              textAlign: TextAlign.start,
                              fontWeight: JPFontWeight.medium,
                            ),
                          ),

                          if(schedule.attachments?.isNotEmpty ?? false)
                            Container(
                              height: 15,
                              width: 24,
                              margin: const EdgeInsets.only(left: 6.5),
                              child: const FittedBox(
                                fit: BoxFit.cover,
                                child: JPIcon(
                                  Icons.attachment_outlined,
                                  textDirection: TextDirection.ltr,
                                ),
                              )),
                          if(schedule.iscompleted)...{
                            Container(
                              height: 18,
                              width: 18,
                              margin: const EdgeInsets.only(left: 6.5),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: JPIcon(
                                  Icons.check_circle,
                                  color: JPAppTheme.themeColors.success,
                                ),
                              ),
                            ),
                          }
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(schedule.isRecurring
                        ? AssetsFiles.recurringIcon
                        : AssetsFiles.notRecurringIcon,
                      width: 13, height: 14
                    ),
                  ],
                ),
                if(schedule.description?.isNotEmpty ?? false)...{
                  const SizedBox(
                    height: 5,
                  ),
                  JPText(
                    text: schedule.description ?? '',
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.tertiary,
                  ),
                },
                const SizedBox(
                  height: 10,
                ),
                JPChip(
                  backgroundColor: JPAppTheme.themeColors.inverse,
                  text: getChipTitle(),
                  textColor: JPAppTheme.themeColors.tertiary,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: JPAppTheme.themeColors.dimGray,
          )
        ],
      ),
      openWidget: ScheduleDetail(
        scheduleId: schedule.id.toString(),
        onScheduleDelete: onScheduleDelete,
      ),
    );
  }

  String getChipTitle() {
    if (schedule.type == 'schedule') {
      return 'job_schedule'.tr;
    }
    return 'event'.tr;
  }

}
