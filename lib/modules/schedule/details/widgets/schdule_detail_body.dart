import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/String/index.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/convert_remainder_time/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';
import 'package:jobprogress/modules/schedule/details/widgets/chip_status_widget_.dart';
import 'package:jobprogress/modules/schedule/details/widgets/header.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_count.dart';
import 'package:jobprogress/modules/schedule/details/widgets/time_details.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailBody extends StatelessWidget {
  const ScheduleDetailBody({
    super.key,
    required this.controller
  });

  final ScheduleDetailController controller;

  @override
  Widget build(BuildContext context) {
    String jobAddress = '';

    if(controller.jobModel != null && controller.jobModel!.address != null) {
      jobAddress = Helper.convertAddress(controller.jobModel!.address);
    }

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: JPAppTheme.themeColors.base),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScheduleDetailHeader(
                schedule: controller.schedulesDetails!,
                type: controller.schedulesDetails!.type!,
                onMarkAsComplete: controller.handleComplete
              ),

              if(controller.schedulesDetails!.customer != null && controller.jobModel != null)
                JobNameWithCompanySetting(
                  job: controller.jobModel!,
                  textColor: JPAppTheme.themeColors.darkGray,
                  textDecoration: TextDecoration.underline,
                  isClickable: true,
                ),
              
              if(controller.schedulesDetails!.type == 'schedule' && controller.canShowScheduleConfirmationStatus) ...{
                    ScheduleDetailConfirmationCount(controller: controller),
              } else ... {
                    const SizedBox(height: 20),
              },
              Align(
                alignment: Alignment.centerLeft,
                child: JPText(
                  text: controller.schedulesDetails!.title ?? '',
                  textSize: JPTextSize.heading3,
                  textAlign: TextAlign.left,
                ),
              ),
              if(controller.jobModel != null && controller.jobModel!.description!.isNotEmpty) ...{
                Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    JPReadMoreText(
                      TrimEnter(controller.jobModel!.description.toString()).trim(),
                      textAlign: TextAlign.start,
                      textColor: JPAppTheme.themeColors.tertiary,
                      dialogTitle: 'note_description'.tr,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 21,
                ),
              } else
                const SizedBox(
                  height: 10,
                ),

                ScheduleDetailTimeDetails(
                  startDateTime: controller.schedulesDetails!.startDateTime,
                  endDateTime: controller.schedulesDetails!.endDateTime,
                  isRecurring: controller.schedulesDetails!.isRecurring,
                ),

                const SizedBox(
                  height: 10,
                ),

                if(jobAddress.isNotEmpty)
                  Column(
                    children: [
                      getLocation(
                        Icons.location_on_outlined, 
                        TrimEnter(Helper.convertAddress(controller.jobModel!.address)).trim()
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),

                if (!Helper.isValueNullOrEmpty(controller.schedulesDetails?.remainder))
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPIcon(
                            Icons.notifications_outlined,
                            color: JPAppTheme.themeColors.darkGray,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: getRemainder(controller.schedulesDetails!),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),

                if (controller.schedulesDetails!.createdBy != null)
                  getIconWithText(
                    Icons.person_outline,
                    'By ${controller.schedulesDetails!.createdBy!.fullName} at ${DateTimeHelper.formatDate(controller.schedulesDetails!.createdAt.toString(), DateFormatConstants.dateTimeFormatWithoutSeconds)}',
                  ),

              if(jobAddress.isNotEmpty ||
                 !Helper.isValueNullOrEmpty(controller.schedulesDetails?.remainder) ||
                  controller.schedulesDetails!.createdBy != null
              )
                const SizedBox(
                  height: 10,
                ),
                if (controller.schedulesDetails!.workCrew != null && controller.schedulesDetails!.workCrew!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      JPText(
                        text: 'work_crew'.tr,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textSize: JPTextSize.heading5,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getParticipants(controller.schedulesDetails!.workCrew!),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )
            ]
          )
        )
    );
  }

  List<Widget> getRemainder(SchedulesModel schedule) {
    List<Widget> remainderList = [];
    for (int i = 0; i < schedule.remainder!.length; i++) {
      remainderList.add(Padding(
        padding: (schedule.remainder!.length < 2)
            ? const EdgeInsets.only(top: 3)
            : const EdgeInsets.only(bottom: 5),
        child: JPText(
          text: RemainderTime().getRemainder(
              int.parse(schedule.remainder![i].minutes.toString()),
              schedule.remainder![i].type!),
          textAlign: TextAlign.left,
        ),
      ));
    }
    return remainderList;
  }

  Widget getIconWithText(IconData icon, String text) {
    return Row(
      children: [
        JPIcon(
          icon,
          color: JPAppTheme.themeColors.darkGray,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: JPText(
            text: text,
            textAlign: TextAlign.left,
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

    Widget getLocation(IconData icon, String text) {
    return Row(
      children: [
        JPIcon(
          icon,
          color: JPAppTheme.themeColors.darkGray,
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: JPText(
            text: text,
            textAlign: TextAlign.left,
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        JPTextButton(
              icon: Icons.location_on,
              onPressed: () {
                controller.launchMapCallback(text);
              },
              iconSize: 24,
              color: JPAppTheme.themeColors.primary,
            ),
      ],
    );
  }

  Widget getParticipants(List<UserLimitedModel> workCrew) {
    int length = 5;

    if(workCrew.length < 5) {
      length = workCrew.length;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Wrap(
            runSpacing: 5.0,
            direction: Axis.horizontal,
            children: [
              for (int i = 0; i < length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ScheduleDetailWorkCrewChip(
                    workCrew: workCrew[i],
                    onStatusTap: (PopoverActionModel selected) {
                      controller.handleStatusActions(selected.value);
                    },
                  )
                ),
              if (workCrew.length > 5)
                Material(
                  color: JPColor.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      controller.conformationStatus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      child: JPText(
                        text: '+${workCrew.length - 5} ${'more'.tr}',
                        textSize: JPTextSize.heading4,
                        fontWeight: JPFontWeight.medium,
                        textColor: JPAppTheme.themeColors.primary,
                      ),
                    ),
                  ),
                )

            ],
          ),
        )
      ],
    );
  }
}