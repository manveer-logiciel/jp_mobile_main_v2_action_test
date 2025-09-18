import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/single_child_scroll_view.dart/index.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';
import 'package:jobprogress/modules/schedule/details/widgets/attachments.dart';
import 'package:jobprogress/modules/schedule/details/widgets/job_details.dart';
import 'package:jobprogress/modules/schedule/details/widgets/schdule_detail_body.dart';
import 'package:jobprogress/modules/schedule/details/widgets/shimmer.dart';
import 'package:jobprogress/modules/schedule/details/widgets/workcrew_notes.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailMainBody extends StatelessWidget {
  const ScheduleDetailMainBody({
    required this.controller,
    super.key,
  });
  final ScheduleDetailController controller;

  @override
  Widget build(BuildContext context) {
    String type = controller.schedulesDetails?.type ?? '';
    return JPSafeArea(
      child: controller.schedulesDetails == null
          ? const ScheduleDetailsShimmer()
          : Column(
              children: [
                JPSingleChildScrollView(
                  item: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (type == 'schedule' &&
                          controller.canShowScheduleConfirmationStatus)
                        getUserStatusConfirmationNotification(),
                      const SizedBox(
                        height: 20,
                      ),
                      ScheduleDetailBody(controller: controller),
                      const SizedBox(
                        height: 20,
                      ),
                      if (controller.jobModel != null) ...{
                        ScheduleJobDetail(
                          updateScreen: controller.refreshPage,
                          scheduleDetail: controller.schedulesDetails!,
                          job: controller.jobModel!,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      },

                      if (type == 'schedule' &&
                          (controller.schedulesDetails!.workCrewNote?.isNotEmpty ?? false)) ...{
                        ScheduleDetailWorkCrewNotes(
                          workCrewNote: controller.schedulesDetails!
                              .workCrewNote!,),
                        const SizedBox(
                          height: 20,
                        ),
                      },
                      if (type == 'schedule' &&
                          controller.schedulesDetails!.workOrder != null &&
                          (controller.schedulesDetails!.workOrder?.isNotEmpty ?? false))
                        Column(
                          children: [
                            ScheduleDetailAttachments(
                              title: 'work_orders'.tr.toUpperCase(),
                              attachments:
                                  controller.schedulesDetails!.workOrder!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      if (type == 'schedule' &&
                          controller.schedulesDetails!.materialList != null &&
                          (controller.schedulesDetails!.materialList?.isNotEmpty ?? false))
                        Column(
                          children: [
                            ScheduleDetailAttachments(
                              title: 'material_list'.tr.toUpperCase(),
                              attachments:
                                  controller.schedulesDetails!.materialList!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      if (type == 'schedule' &&
                          controller.schedulesDetails!.attachments != null &&
                          (controller.schedulesDetails!.attachments?.isNotEmpty ?? false))
                        Column(
                          children: [
                            ScheduleDetailAttachments(
                              title: 'attachments'.tr.toUpperCase(),
                              attachments:
                                  controller.schedulesDetails!.attachments!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  getUserStatusConfirmationNotification() {
    return controller.showNotification
        ? Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5),
          border: Border.all(color: JPAppTheme.themeColors.primary)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JPText(
                  text: 'confirmation'.tr,
                  textColor: JPAppTheme.themeColors.primary,
                  fontWeight: JPFontWeight.medium,
                  textSize: JPTextSize.heading5,
                ),
                const SizedBox(
                  height: 5,
                ),
                JPText(text: 'invited_message'.tr),
              ],
            ),
            Row(
              children: [
                JPTextButton(
                  onPressed: (() {
                    controller.markAction('mark_as_accept');
                    controller.update();
                  }),
                  text: 'accept'.tr,
                  textSize: JPTextSize.heading5,
                  color: JPAppTheme.themeColors.success,
                  fontWeight: JPFontWeight.medium,
                ),
                JPText(
                  text: '|',
                  textColor: JPAppTheme.themeColors.darkGray,
                  fontWeight: JPFontWeight.medium,
                ),
                JPTextButton(
                  onPressed: (() {
                    controller.markAction('mark_as_decline');
                    controller.update();
                  }),
                  text: 'decline'.tr,
                  textSize: JPTextSize.heading5,
                  color: JPAppTheme.themeColors.secondary,
                  fontWeight: JPFontWeight.medium,
                ),
              ],
            )
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}
