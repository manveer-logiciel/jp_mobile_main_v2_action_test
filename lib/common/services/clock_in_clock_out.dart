import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/clock_in_clock_out.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/floating_clock/controller.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class ClockInClockOutService {

  /// checkInDetails are used to store checkInData so, can be used globally
  static ClockSummaryTimeLogDetails? checkInDetails;
  static String? checkInJobId;

  /// controller is used to manage floating clock duration
  static ClockInClockOutController? controller;

  static bool isCheckInWithoutJob = false;

  // setUpCheckInDetails() : use to manage value of checkInDetails while check-in/check-out
  static Future<void> setUpCheckInDetails({ClockSummaryTimeLogDetails? details}) async {

    if (checkInDetails == null && (isCheckInWithoutJob || checkInJobId.toString() != "null")) {
      try {
        Map<String, dynamic> params = {
          'type': 'job',
        };

        // if details data available assigning it directly, otherwise loading from server
        checkInDetails = details ?? await ClockInClockOutRepository.fetchCheckInDetails(params);

        // setting up job, if check-in is with job
        if (checkInDetails?.jobId != null) {
          checkInDetails?.jobModel = (await JobRepository.fetchJob(checkInDetails!.jobId!))['job'];
        }

        // updating controller values to display floating clock
        controller?.initCheckIn();
      } catch (e) {
        rethrow;
      }
    } else {
      // while checkout removing data
      checkInDetails = null;
      controller?.disposeCheckIn();
    }
  }

  static void init() {
    // setting up global controller
    Get.put(ClockInClockOutController());

    if (Get.isRegistered<ClockInClockOutController>()) {
      controller = Get.find<ClockInClockOutController>();
    }
  }

  // dispose() : will remove all the data (used while switching account with check-in)
  static Future<void> dispose() async {
    controller?.disposeCheckIn();
    checkInDetails = null;
    isCheckInWithoutJob = false;
    checkInJobId = null;
    await Get.delete<ClockInClockOutController>();
  }

  static Future<void> handleOrientationChange() async {
    if (Get.isRegistered<FloatingClockController>()) {
      // additional duration to get ui rendered before updating clock position
      await Future<void>.delayed(const Duration(milliseconds: 100));
      final controller = Get.find<FloatingClockController>();
      controller.onPanEnd();
  }
  }

  static void setJob(JobModel? jobModel) {
    controller?.selectedJob = jobModel;
    checkInDetails?.jobModel = jobModel;
  }

  static String get clockOutConfirmationMsg {
    String? customerName = checkInDetails?.jobModel?.customer?.fullNameMobile ?? '';
    String? jobNumber = checkInDetails?.jobModel?.number ?? '';
    if(Helper.isValueNullOrEmpty(customerName) || Helper.isValueNullOrEmpty(jobNumber)) {
      return '${'auto_clocked_out_confirmation_msg'.tr}${'existing_clock_in'.tr} ${'press_confirm_to_proceed'.tr.capitalizeFirst!}';
    }
    return '${'auto_clocked_out_confirmation_msg'.tr}$customerName / $jobNumber. ${'press_confirm_to_proceed'.tr.capitalizeFirst!}';
  }

  static void openAutoClockedOutConfirmationDialog(JobModel switchToJob) {
    showJPBottomSheet(child: (_) {
      return JPConfirmationDialog(
        icon: Icons.report_problem_outlined,
        title: 'confirmation'.tr,
        subTitle: clockOutConfirmationMsg,
        suffixBtnText: 'confirm'.tr,
        onTapSuffix: () {
          Get.back();
          controller?.switchJob(switchToJob);
        },
      );
    });
  }
}
