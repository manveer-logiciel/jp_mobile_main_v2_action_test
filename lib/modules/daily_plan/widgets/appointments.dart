import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/assets_files.dart';

class DailyPlanAppointmentListTile extends StatelessWidget {

  const DailyPlanAppointmentListTile({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.appointmentItem,});

  final AppointmentModel appointmentItem;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    String getDates() {
      return appointmentItem.isAllDay
          ? '${DateTimeHelper.convertHyphenIntoSlash(appointmentItem.startDateTime.toString())} - ${DateTimeHelper.convertHyphenIntoSlash(appointmentItem.endDateTime.toString())}'
          : '${DateTimeHelper.formatDate(appointmentItem.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)} - ${DateTimeHelper.formatDate(appointmentItem.endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}';
    }

    return Material(
      color: JPAppTheme.themeColors.base,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 16),
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8),
                ),
                child: Center(
                  child: JPIcon(
                    Icons.today_outlined,
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
                                      text: appointmentItem.title ?? '',
                                      fontWeight: JPFontWeight.medium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if(appointmentItem.attachments != null && appointmentItem.attachments!.isNotEmpty)
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
                                  if(Helper.isTrue(appointmentItem.isCompleted))
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
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Image.asset(appointmentItem.isRecurring
                              ? AssetsFiles.recurringIcon
                              : AssetsFiles.notRecurringIcon,
                              width: 13, height: 14
                            ),
                          ],
                        ),
                        if (appointmentItem.description != null &&
                            appointmentItem.description != '')
                          Column(
                            children: [
                              const SizedBox(height: 7),
                              Align(
                                alignment: Alignment.topLeft,
                                child: JPText(
                                  text: TrimEnter(appointmentItem.description!).trim(),
                                  overflow: TextOverflow.ellipsis,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        if (appointmentItem.location != null && appointmentItem.location!.isNotEmpty)
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
                                        textColor:
                                            JPAppTheme.themeColors.darkGray,
                                      ),
                                      Flexible(
                                        child: JPText(
                                          text: appointmentItem.location!,
                                          overflow: TextOverflow.ellipsis,
                                          textSize: JPTextSize.heading5,
                                          textColor:
                                              JPAppTheme.themeColors.tertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                        if (appointmentItem.job != null)
                          if (appointmentItem.job!.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 5),
                                JobNameWithCompanySetting(
                                    job: appointmentItem.job![0],
                                    textSize: JPTextSize.heading5,
                                    textColor: JPAppTheme.themeColors.tertiary),
                              ],
                            ),
                        if (appointmentItem.user != null)
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  JPProfileImage(
                                    src:appointmentItem.user!.profilePic,
                                    color:appointmentItem.user!.color,
                                    initial:appointmentItem.user!.intial
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  JPText(
                                    text: appointmentItem.user!.fullName.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    textSize: JPTextSize.heading5,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 12,
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
      ),
    );
  }
}
