import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'confirmation.dart';
import 'status.dart';

class ScheduleListingTile extends StatelessWidget {

  const ScheduleListingTile({
    required this.schedule,
    this.onTap,
    this.onLongPress,
    this.onAccept,
    this.onDecline,
    this.canShowConfirmation = false,
    super.key});

  final SchedulesModel schedule;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  final bool canShowConfirmation;

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 0,
      shadowColor: JPAppTheme.themeColors.darkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide.none,
      ),
      color: JPAppTheme.themeColors.base,
      margin: const EdgeInsets.only(bottom: 10, right: 16, left: 16),
      child: InkWell(
        borderRadius:  BorderRadius.circular(12.0),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.5, top: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: JPText(
                        text: TrimEnter(schedule.title!).trim() ,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis
                    ),
                  ),

                  if(schedule.attachments != null && schedule.attachments!.isNotEmpty)
                    Container(margin: const EdgeInsets.only(left: 2), child: const JPIcon(Icons.attachment_outlined)),

                  if (canShowConfirmation && Helper.isTrue(schedule.doShowNotification))
                    ScheduleListingConfirmationButtons(
                      onAccept: onAccept,
                      onDecline: onDecline,
                    ),
                ],
              ),

              if(schedule.description != null && schedule.description != '')
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: JPText(
                      text: TrimEnter(schedule.description!).trim(),
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5,
                      overflow: TextOverflow.ellipsis
                  ),
                ),

              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Row(
                  children: [
                    Flexible(
                      child: JPText(
                          text: getRecurringDetails(),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left : 5),
                      child: Image.asset(schedule.isRecurring
                          ? AssetsFiles.recurringIcon
                          : AssetsFiles.notRecurringIcon, width: 14, height: 13),
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: JPText(
                    text: schedule.getDates(),
                    overflow: TextOverflow.ellipsis,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                  ),
                ),
              ),

              if (!Helper.isValueNullOrEmpty(schedule.tradesString))
                Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: JPText(
                    text: "${'trades'.tr.capitalize!}: ${schedule.tradesString!}",
                    overflow: TextOverflow.ellipsis,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                  ),
                ),
              ),

              if (!Helper.isValueNullOrEmpty(schedule.job?.addressString))
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: JPText(
                      text: "${'job_address'.tr.capitalize!}: ${schedule.job!.addressString!}",
                      overflow: TextOverflow.ellipsis,
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.tertiary,
                    ),
                  ),
                ),

              if(!schedule.isStatusNotAvailable())
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ScheduleTileStatus(
                    schedule: schedule,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  String getRecurringDetails() {
    if (schedule.isRecurring) {
      return "${schedule.repeat?.capitalizeFirst}, ${schedule.occurence} ${"times".tr}";
    } else {
      return "${"recurring".tr}: ${"no".tr}";
    }
  }
}
