import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/assets_files.dart';
import '../../../core/constants/date_formats.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../core/utils/helpers.dart';

class DailyPlanSchedulesListTile extends StatelessWidget {

  const DailyPlanSchedulesListTile({
    super.key,
    required this.scheduleItem,
    this.onTap,
    this.onLongPress
  });

  final SchedulesModel scheduleItem;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  String getChipTitle() {
    if (scheduleItem.type == 'schedule') {
      return 'job_schedule'.tr;
    }
    return 'event'.tr;
  }

  @override
  Widget build(BuildContext context) {
    String jobAddress = '';
    if(scheduleItem.job != null) jobAddress = Helper.convertAddress(scheduleItem.job!.address);

    String getDates() {
      return scheduleItem.isAllDay
          ? '${DateTimeHelper.convertHyphenIntoSlash(scheduleItem.startDateTime.toString())} - ${DateTimeHelper.convertHyphenIntoSlash(scheduleItem.endDateTime.toString())}'
          : '${DateTimeHelper.formatDate(scheduleItem.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)} - ${DateTimeHelper.formatDate(scheduleItem.endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}';
    }

    return InkWell(
      onTap: onTap,
      onLongPress:onLongPress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 15),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8),
              ),
              child: Center(
                child: JPIcon(
                  Icons.work_outline,
                  size: 16,
                  color: JPAppTheme.themeColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, right: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: JPText(
                                    textAlign: TextAlign.start,
                                    text: scheduleItem.title ?? '',
                                    fontWeight: JPFontWeight.medium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 5)
                              ],
                            ),
                          ),
                          Image.asset(
                            scheduleItem.isRecurring
                                ? AssetsFiles.recurringIcon
                                : AssetsFiles.notRecurringIcon,
                            width: 14,
                            height: 14),
                        ],
                      ),
                      if (jobAddress.isNotEmpty)
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                JPText(
                                  text: '${'location'.tr}: ',
                                  overflow: TextOverflow.ellipsis,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.darkGray,
                                ),
                                Flexible(
                                  child: JPText(
                                    text: Helper.convertAddress(scheduleItem.job!.address),
                                    overflow: TextOverflow.ellipsis,
                                    textSize: JPTextSize.heading5,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        (scheduleItem.startDateTime != null && scheduleItem.endDateTime != null)
                        ? Column(
                            children: [
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: JPText(
                                  text: getDates(),
                                  overflow: TextOverflow.ellipsis,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                      (scheduleItem.job != null)
                          ? Column(
                            children: [
                              const SizedBox(height: 5),
                              JobNameWithCompanySetting(
                                job: scheduleItem.job!,
                                textSize: JPTextSize.heading5,
                                textColor: JPAppTheme.themeColors.tertiary
                              ),
                            ],
                          )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: JPChip(
                          backgroundColor: JPAppTheme.themeColors.inverse,
                          textColor: JPAppTheme.themeColors.tertiary,
                          text: getChipTitle(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  thickness: 1,
                  color: JPAppTheme.themeColors.dimGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
