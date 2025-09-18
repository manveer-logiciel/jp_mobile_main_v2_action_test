import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/common/extensions/String/index.dart';

import '../../../core/constants/assets_files.dart';

class AppointmentListingTile extends StatelessWidget {

  const AppointmentListingTile({
    required this.appointment,
    this.onTap,
    this.onLongPress,
    super.key});

  final AppointmentModel appointment;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    String getDates() {
      return appointment.isAllDay
          ? DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dayDateTimeFormat)
          : '${DateTimeHelper.formatDate(appointment.startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)} - ${DateTimeHelper.formatDate(appointment.endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}';
    }
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
                        text: TrimEnter(appointment.title!).trim() ,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis
                      ),
                    ), 
                    if(appointment.attachments != null && appointment.attachments!.isNotEmpty)                 
                    Container(
                      margin: const EdgeInsets.only(left: 2), 
                      child: const JPIcon(Icons.attachment_outlined)
                    ),
                    if(Helper.isTrue(appointment.isCompleted))
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
      
                if(appointment.description != null && appointment.description != '')
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: JPText(
                    text: TrimEnter(appointment.description!).trim(),
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
                          text: appointment.isRecurring
                              ? RecurringService.getRecOption(appointment)
                              : "${"recurring".tr}: ${"no".tr}",
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left : 5),
                        child: Image.asset(appointment.isRecurring
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
                      text: getDates(),
                      overflow: TextOverflow.ellipsis,
                      textSize: JPTextSize.heading5,
                      textColor: JPAppTheme.themeColors.tertiary,
                    ),
                  ),
                ),
                if(appointment.user != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      JPProfileImage(
                        src:appointment.user!.profilePic,
                        color:appointment.user!.color,
                        initial:appointment.user!.intial
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      JPText(
                        text: appointment.user!.fullName.toString(),
                        overflow: TextOverflow.ellipsis,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ],
                  ),
                ),         
            ],
          ),
        ),
      ),
    );
  }
}
