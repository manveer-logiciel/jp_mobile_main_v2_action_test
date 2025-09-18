import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/clock_summary/clock_summary_time_log_details.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/clock_summary.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class TimeLogDetailsController extends GetxController {

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;

  int timeLogId = Get.arguments['id']; // used as api request param
  String title = Get.arguments['title']; // used to display page title
  JobModel? job = Get.arguments['job']; // used to job details

  ClockSummaryTimeLogDetails? timeLogDetails;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      Map<String, dynamic> params = {
        'id': '$timeLogId',
        'includes[0]': 'trades',
        'includes[1]': 'job_address',
        'includes[2]': 'customer',
      };

      final response = await ClockSummaryRepository.fetchTimLogEntryDetails(params);
      timeLogDetails = response['data'];
      timeLogDetails?.jobModel = job;

    } catch (e) {
      Helper.handleError(e);
    } finally {
      isLoading = false;
      update();
    }
  }

  void cancelOnGoingApiRequest() {
    Helper.cancelApiRequest();
  }

  @override
  void dispose() {
    cancelOnGoingApiRequest();
    super.dispose();
  }

}