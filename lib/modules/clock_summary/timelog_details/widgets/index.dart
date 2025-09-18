import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/controller.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/clock_in_clock_out_card/index.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/clock_in_clock_out_card/shimmer.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/log_details_header/index.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/log_details_header/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TimeLogDetailsContent extends StatelessWidget {
  const TimeLogDetailsContent({super.key, required this.controller});

  final TimeLogDetailsController controller;

  @override
  Widget build(BuildContext context) {
    if(controller.isLoading) {
      /// shimmer
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16
        ),
        child: Column(
          children: [
            const TimeLogDetailsHeaderShimmer(),
            ClockInClockOutCardShimmer(
              title: 'clock_in'.tr,
            ),
            Divider(
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
              thickness: 1,
            ),
            ClockInClockOutCardShimmer(
              title: 'clock_out'.tr,
            ),
            Divider(
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
              thickness: 1,
            ),
          ],
        ),
      );
    } else if(controller.timeLogDetails == null) {
      /// placeholder
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: NoDataFound(
              icon: Icons.lock_clock,
              title: 'data_not_found'.tr,
            ),
          ),
        ],
      );
    } else {
      /// log details
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            vertical: 16
        ),
        child: Column(
          children: [
            TimeLogDetailsHeader(
              data: controller.timeLogDetails!,
            ),
            ClockInClockOutCard(
              title: 'clock_in'.tr,
              date: controller.timeLogDetails?.startDate ?? "",
              time: controller.timeLogDetails?.startTime ?? "",
              address: controller.timeLogDetails?.location,
              image: controller.timeLogDetails?.checkInImage,
              isPlatformMobile: controller.timeLogDetails?.checkInPlatform == 'mobile',
              note: controller.timeLogDetails?.clockInNote,
            ),
            Divider(
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
              thickness: 1,
            ),
            ClockInClockOutCard(
              title: 'clock_out'.tr,
              date: controller.timeLogDetails?.endDate ?? "",
              time: controller.timeLogDetails?.endTime ?? "",
              address: controller.timeLogDetails?.checkOutLocation,
              image: controller.timeLogDetails?.checkOutImage,
              isPlatformMobile: controller.timeLogDetails?.checkOutPlatform == 'mobile',
              note: controller.timeLogDetails?.clockOutNote,
            ),
            Divider(
              height: 1,
              color: JPAppTheme.themeColors.dimGray,
              thickness: 1,
            ),
          ],
        ),
      );
    }
  }
}
