import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import 'package:jobprogress/modules/clock_in_clock_out/widgets/footer.dart';
import 'package:jobprogress/modules/clock_in_clock_out/widgets/header.dart';
import 'package:jobprogress/modules/clock_summary/timelog_details/widgets/clock_in_clock_out_card/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'form.dart';

class ClockInClockOutContent extends StatelessWidget {
  const ClockInClockOutContent({
    super.key,
    required this.controller
  });

  final ClockInClockOutController controller;

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          controller: controller.scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 16
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// header
              ClockInClockOutHeader(
                duration: controller.duration,
                data: controller.selectedJob,
                previousSelectedJob: controller.previousSelectedJob,
                onTapSelect: controller.selectJob,
              ),

              if(controller.forClockOut)...{
                /// check-in details
                ClockInClockOutCard(
                  title: 'clock_in'.tr.toUpperCase(),
                  date:  DateTimeHelper.formatDate(controller.timeLogDetails?.startDateTime ?? "", DateFormatConstants.dateOnlyFormat),
                  time: DateTimeHelper.formatDate(controller.timeLogDetails?.startDateTime ?? "", DateFormatConstants.timeOnlyFormat),
                  address: controller.timeLogDetails?.location,
                  image: controller.timeLogDetails?.checkInImage,
                  isPlatformMobile: controller.timeLogDetails?.checkInPlatform == 'mobile',
                  note: controller.timeLogDetails?.clockInNote,
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                  color: JPAppTheme.themeColors.dimGray,
                )
              },

              const SizedBox(
                height: 20,
              ),

              /// check-in / check-out form
              ClockInClockOutForm(
                title: controller.forClockOut
                    ? 'clock_out'.tr.toUpperCase()
                    : 'clock_in'.tr.toUpperCase(),
                address: controller.address,
                noteController: controller.notesController,
                dateTime: controller.entryTime,
                image: controller.fileImage,
                onTapSelectImage: controller.takePhoto,
                onTapTextField: controller.scrollToEnd,
              ),

              const SizedBox(
                height: 10,
              ),

              /// footer buttons
              ClockInClockOutFooter( 
                controller: controller,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
