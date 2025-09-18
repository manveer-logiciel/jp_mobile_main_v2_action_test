import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/common/services/location/loaction_service.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

class ClockInClockOutController extends GetxController {

  bool isSwitchingJob = false; // helps in managing job switch loading state
  bool updatingCheckInStatus = false; // helps in managing loading state
  bool updatingCheckOutStatus = false; // helps in managing loading state
  bool forClockOut = ClockInClockOutService.checkInDetails != null; // helps is rending clock-in/clock-out ui

  String? fileImage; // used to store picked image
  String? address; // stores user address
  String? duration; // stores job duration

  Position? position; // used to stores users latitude/longitude
  JobModel? selectedJob; // used to stores selected job / checked-in job
  JobModel? previousSelectedJob; // used to check whether job is coming from previous screen or not.
  ClockSummaryTimeLogDetails? timeLogDetails; // stores check-in details

  DateTime entryTime = DateTimeHelper.now(); // helps to display entry time

  Timer timer = Timer(Duration.zero, () { }); // used to update duration

  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();


  @override
  void onInit() {
    clearClockInOut();
    if (Get.currentRoute == Routes.clockInClockOut) {
      LocationService.checkAndReRequestPermission().then((canAccessLocation) async {
        if (canAccessLocation) await setUpAddress();
      });
    }
    super.onInit();
  }

  // takePhoto() : opens camera to take picture
  Future<void> takePhoto() async {
    await FilePickerService.takePhoto().then((value) {
      if(value != null) {
        updateImagePath(value);
      }
    });
  }

  Future<void> clearClockInOut() async {
    notesController.text = "";
    previousSelectedJob = Get.arguments?[NavigationParams.jobModel];
    if(previousSelectedJob != null){
      selectedJob = previousSelectedJob;
    } else if(!forClockOut){
      selectedJob = null;
    }
    entryTime = DateTimeHelper.now();
    fileImage = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  void clearData() {
    clearClockInOut();
    Get.back();
  }

  // selectJob() : opens customer job listing to select job from
  //    doSwitchJob : used to switch job
  Future<void> selectJob({bool doSwitchJob = false}) async {
    final job = await Get.toNamed(Routes.customerJobSearch, arguments: {NavigationParams.pageType : PageType.selectJob});
    if(job != null) selectOrSwitchJob(doSwitchJob, job);
    update();
  }

  Future<void> setUpAddress() async {
      try {
        final data = await LocationService.getAddress();

        address = await data['address'];
        position = data['position'];
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
  }

  // createTimeStream() : will update check-in/check-out time and duration of checked-in job
  void createTimeStream() {

    updateEntryTime();

    timer = Timer(Duration(seconds: 60 - entryTime.second), () {

      timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        updateEntryTime();
      });

      updateEntryTime();
    });

  }

  void updateEntryTime() {
    entryTime = DateTimeHelper.now();
    setUpDuration();
    update();
  }

  Future<void> checkIn() async {
    try {

      toggleUpdatingCheckInStatus();

      Map<String, dynamic> params = {
        'clock_in_note': notesController.text,
        'location': address,
        'lat': position?.latitude,
        'long': position?.longitude,
        'job_id': selectedJob?.id,
        'check_in_image' : fileImage
      };

      final details = await ClockInClockOutRepository.checkIn(params);

      await ClockInClockOutService.setUpCheckInDetails(details: details);

      clearClockInOut();
      if(details.jobId != null && details.jobModel?.customerId != null && previousSelectedJob == null) {
        navigateToJobSummary(details.jobId!,details.jobModel!.customerId ); // checked-in for a job navigating to job summary of selected job
      } else {
        Get.back();
      }

      initCheckIn();

    } catch (e) {
      rethrow;
    } finally {
      Helper.hideKeyboard();
      toggleUpdatingCheckInStatus();
    }
  }

  Future<void> checkOut() async {
    try {

      toggleUpdatingCheckOutStatus();

      Map<String, dynamic> params = {
        'clock_out_note': notesController.text,
        'check_out_location': address,
        'check_out_lat': position?.latitude,
        'check_out_long': position?.longitude,
        'job_id': selectedJob?.id,
        'check_out_image' : fileImage
      };

      await ClockInClockOutRepository.checkOut(params);

      disposeCheckIn();

    } catch (e) {
      rethrow;
    } finally {
      toggleUpdatingCheckOutStatus();
    }
  }

  void toggleUpdatingCheckInStatus() {

    if(isSwitchingJob) return; // in case switching job no need to toggle loading state

    updatingCheckInStatus = !updatingCheckInStatus;
    update();
  }

  void toggleUpdatingCheckOutStatus() {

    if(isSwitchingJob) return; // in case switching job no need to toggle loading state

    updatingCheckOutStatus = !updatingCheckOutStatus;
    update();
  }

  void toggleIsSwitchingJob() {
    isSwitchingJob = !isSwitchingJob;
    update();
  }

  // setUpDuration() : will setup check-in duration
  void setUpDuration() {

    if(!forClockOut) return;

    duration = DateTimeHelper.getDuration(timeLogDetails!.startDateTime!);
  }

  // scrollToEnd() : lifts up form while adding note
  void scrollToEnd() {
    Timer(const Duration(milliseconds: 700), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  Future<void> switchJob(JobModel job) async {
    try {

      toggleIsSwitchingJob();

      showJPLoader(
        msg: 'switching_job'.tr
      );

      setAutoNote(forCheckOut: true);

      await checkOut();

      selectedJob = job;
      forClockOut = false;

      setAutoNote();
      update();

      Get.back();
      showJPLoader(
          msg: 'checking_in'.tr
      );

      await checkIn();
    } catch (e) {
      rethrow;
    } finally {
      toggleIsSwitchingJob();
    }
  }

  // initCheckIn() : setup variables for check-in entry
  void initCheckIn() {
    resetTimer();
    notesController.text = "";
    timeLogDetails = ClockInClockOutService.checkInDetails;
    forClockOut = ClockInClockOutService.checkInDetails != null;
    if(!Helper.isValueNullOrEmpty(timeLogDetails?.jobModel)){
      selectedJob = timeLogDetails?.jobModel;
    }
    if(forClockOut) {
      createTimeStream();
    }
  }

  // disposeCheckIn() : remove variables for check-out entry
  Future<void> disposeCheckIn() async {

    if(isSwitchingJob) return;

    if(Get.currentRoute == Routes.clockInClockOut) {
      Get.back();
      // a delay to update changes when after navigating back on clock out to previous page
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }
    Helper.hideKeyboard();
    forClockOut = false;
    selectedJob = null;
    duration = null;
    notesController.text = '';
    clearClockInOut();
    resetTimer();
  }

  void resetTimer() {
    duration = null;
    timer.cancel();
  }

  void navigateToJobSummary(int jobId, int customerId) {

    if(isSwitchingJob) Get.back(); // closing checking-in loader
    Get.back();
    Get.toNamed(Routes.jobSummary, arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.customerId: customerId,
    });
  }


  // updateImagePath() : will update displayed image path
  void updateImagePath(String? path) {
    if(path == null) return;

    fileImage = path; // setting up image path
    update();
  }

  // selectOrSwitchJob() : helps in differentiating switching or selecting job
  void selectOrSwitchJob(bool doSwitchJob, JobModel? job) {
    if(doSwitchJob && job != null) {
      switchJob(job);
    } else {
      selectedJob = job; // setting up job
    }
  }

  void setAutoNote({bool forCheckOut = false}) {
    if(forCheckOut) {
      notesController.text = 'auto_clocked_out'.tr;
    } else {
      fileImage = null;
      notesController.text = 'auto_clocked_in'.tr;
    }
  }

  @override
  void dispose() {
    disposeCheckIn();
    super.dispose();
  }
}