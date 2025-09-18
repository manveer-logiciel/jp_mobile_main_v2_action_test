import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_limited.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/global_widgets/animated_open_container/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/appointment_details/page.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/assets_files.dart';

class CalendarAppointmentTile extends StatelessWidget {
  const CalendarAppointmentTile({
    super.key,
    required this.appointment,
    required this.onAppointmentDelete,
    required this.onAppointmentUpdate
  });

  final AppointmentLimitedModel appointment;

  final VoidCallback? onAppointmentDelete;

  final Function(AppointmentModel appointment)? onAppointmentUpdate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      child: JPOpenContainer(
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
                                color: ColorHelper.getHexColor(appointment.appointmentHexColor ?? ''),
                                width: 2.8
                            )
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: JPText(
                          text: appointment.appointmentTimeString ?? '',
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.secondaryText,
                        ),
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
                                text: appointment.title ?? "",
                                textSize: JPTextSize.heading4,
                                textAlign: TextAlign.start,
                                fontWeight: JPFontWeight.medium,
                                maxLine: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if(appointment.hasAttachments)...{
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
                                  ),
                              ),
                            },
                            if(appointment.isCompleted ?? false)...{
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
                      Image.asset(appointment.isRecurring
                        ? AssetsFiles.recurringIcon
                          : AssetsFiles.notRecurringIcon,
                        width: 13, height: 14
                      ),
                    ],
                  ),
                  if(appointment.description?.isNotEmpty ?? false)...{
                    const SizedBox(
                      height: 5,
                    ),
                    JPText(
                      text: appointment.description ?? '',
                      textSize: JPTextSize.heading5,
                      textAlign: TextAlign.start,
                      textColor: JPAppTheme.themeColors.tertiary,
                      maxLine: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  },

                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if(appointment.user != null)...{
                          JPProfileImage(
                            src: appointment.user?.profilePic,
                            color: appointment.user?.color,
                            initial: appointment.user?.intial
                          ),
                        } else... {
                          JPAvatar(
                            size: JPAvatarSize.small,
                            borderColor: JPAppTheme.themeColors.secondaryText,
                            borderWidth: 2,
                            child: Image.asset('assets/images/profile-placeholder.png'),
                          )
                        },
                        const SizedBox(
                          width: 5,
                        ),
                        JPText(
                          text: appointment.user?.fullName.toString() ?? 'Unassigned',
                          overflow: TextOverflow.ellipsis,
                          textSize: JPTextSize.heading5,
                          textColor: JPAppTheme.themeColors.tertiary,
                        ),
                      ],
                    ),
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
        openWidget: AppointmentDetailsView(
          appointmentId: appointment.id,
          onAppointmentDelete: onAppointmentDelete,
          onAppointmentUpdate: onAppointmentUpdate,
        ),
      ),
    );
  }
}
