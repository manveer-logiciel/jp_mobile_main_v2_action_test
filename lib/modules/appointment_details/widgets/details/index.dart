
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/convert_remainder_time/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/appointment_details/widgets/details/attendees.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'detail_tile.dart';

class AppointmentDetailsCard extends StatelessWidget {

  const AppointmentDetailsCard({
    super.key,
    required this.appointment,
    this.onTapComplete,
    this.onTapJobs,
    this.location,
  });

  final AppointmentModel appointment;

  final VoidCallback? onTapComplete;

  final VoidCallback? onTapJobs;

  final VoidCallback? location;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// card title with done icon
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 8,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          JPText(
                            text: 'appointment_detail'.tr.toUpperCase(),
                            textAlign: TextAlign.start,
                            fontWeight: JPFontWeight.medium,
                            textSize: JPTextSize.heading3,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: onTapComplete,
                            constraints: const BoxConstraints(
                              maxHeight: 24,
                              minWidth: 24
                          ),
                        padding: EdgeInsets.zero,
                        splashRadius: 16,
                        icon: appointment.isCompleted ?? false ? JPIcon(
                          Icons.check_circle,
                          color: JPAppTheme.themeColors.success,
                        ) : const JPIcon(
                          Icons.check_circle_outline,
                        ),
                      ),
                        ],
                      ),
                      if(!Helper.isValueNullOrEmpty(appointment.job) && !Helper.isValueNullOrEmpty(appointment.job?.first.customer))...{
                        const SizedBox(
                          width: 12,
                        ),
                        JPButton(
                          size: JPButtonSize.extraSmall,
                          text: appointment.job!.length == 1 ? '${appointment.job!.length} ${'job'.tr.toUpperCase()}' : '${appointment.job!.length} ${'jobs'.tr.toUpperCase()}',
                          onPressed: onTapJobs,
                        ),
                      }
                    ],
                  ),
                ),
              ],
            ),
            if(appointment.customer != null)...{
               const SizedBox(
                height: 5,
              ),
              if(!Helper.isValueNullOrEmpty(appointment.job) && appointment.job?.length == 1)...{
                JobNameWithCompanySetting(
                  job: appointment.job!.first,
                  isClickable: true,
                  textDecoration: TextDecoration.underline,
                  textColor: JPAppTheme.themeColors.darkGray,
                ),
              } else ...{
                InkWell(
                  onTap: (() => Get.toNamed(Routes.customerDetailing, arguments: {NavigationParams.customerId: appointment.customerId})),
                  child:JPText(
                    overflow: TextOverflow.ellipsis,
                    text:appointment.customer?.fullName ?? '',
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.darkGray,
                    textDecoration: TextDecoration.underline,
                  )
                ),
              }
            },
            const SizedBox(
              height: 14,
            ),
            /// appointment title
            JPText(
              text: appointment.title ?? "",
              textSize: JPTextSize.heading3,
              textAlign: TextAlign.start,
            ),

            if(appointment.description != null && appointment.description!.isNotEmpty)...{
              const SizedBox(
                height: 8,
              ),
              /// appointment description
              JPReadMoreText(
                appointment.description!,
                textAlign: TextAlign.start,
                textColor: JPAppTheme.themeColors.tertiary,
                dialogTitle: 'description'.tr.toUpperCase(),
              ),
            },

            const SizedBox(
              height: 16,
            ),

            AppointmentDetailTile(
              icon: Icons.event,
              title: appointment.user?.fullName ?? 'Unassigned',
            ),

            const SizedBox(
              height: 16,
            ),

            AppointmentDetailTile(
                icon: Icons.access_time_outlined,
                title: getAppointmentDate(),
                subTitle: appointment.isAllDay ? null : JPText(
                  text: '${appointment.startTime} - ${appointment.endTime}',
                  textAlign: TextAlign.start,
                ),
                isRecurringField: true,
                isRecurring: appointment.isRecurring
            ),

            if(appointment.location != null && appointment.location!.isNotEmpty)...{
              const SizedBox(
                height: 16,
              ),
              AppointmentDetailTile(
                icon: Icons.location_on_outlined,
                title: appointment.location!,
                checkForMultiline: true,
                location: location,
              ),
            },

            const SizedBox(
              height: 16,
            ),

            if(appointment.reminders != null && appointment.reminders!.isNotEmpty)...{
              Column(
                children: [
                  AppointmentDetailTile(
                    icon: Icons.notifications_outlined,
                    title: '',
                    subTitle: ListView.separated(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (_, index) {
                        final reminder = appointment.reminders![index];
                        return JPText(
                          text: RemainderTime().getRemainder(int.parse(reminder.minutes!), reminder.type!),
                          textAlign: TextAlign.start,
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 6,),
                      itemCount: appointment.reminders!.length,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              )
            },

            AppointmentDetailTile(
              icon: Icons.person_outline,
              title: '${'by'.tr.capitalize!} ${appointment.createdBy?.fullName ?? 'unassigned'.tr.capitalize!} ${'at'.tr} ${DateTimeHelper.formatDate(appointment.createdAt!, DateFormatConstants.dateTimeFormatWithoutSeconds)} ',
            ),

            if(appointment.attendees != null && appointment.attendees!.isNotEmpty && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))...{
              const SizedBox(
                height: 20,
              ),
              AppointmentAttendees(
                attendees: appointment.attendees!,
              ),
            } else...{
              const SizedBox(height: 5,),
            }
          ],
        ),
      ),
    );
  }

  String getAppointmentDate() {
    if(appointment.startDate == appointment.endDate || appointment.isAllDay) {
      return appointment.startDate!;
    } else {
      return '${appointment.startDate} - ${appointment.endDate}';
    }
  }

}
