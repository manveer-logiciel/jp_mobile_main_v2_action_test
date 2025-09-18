import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_listing_filter.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SelectJobOfCustomerController extends GetxController {
  List<JobModel> customerJobList = [];
  bool isLoading = true;
  late int? customerID;
  JobListingFilterModel filterKeys = JobListingFilterModel();
  late List<JobModel> selectedJobs;
  List<JobModel> tempSelectedJobs = [];

  SelectJobOfCustomerController(this.customerID,this.selectedJobs) {
    tempSelectedJobs.addAll(selectedJobs);
    fetchJobs();
  }

  Map<String, dynamic> getQueryParams() {
    Map<String, dynamic> queryParams = {
      'customer_id': customerID,
      ...filterKeys.toJson()
    };
    return queryParams;
  }

  Future<void> fetchJobs() async {
    try {
      Map<String, dynamic> queryParams = getQueryParams();
      Map<String, dynamic> response = await JobRepository.fetchJobList(params: queryParams);
      customerJobList = response["list"];
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  // select selected jobs color
  Color getSelectedColor(JobModel job){
    if(tempSelectedJobs.isNotEmpty){
        if(tempSelectedJobs.where((element) => element.id == job.id).isNotEmpty){
        return JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8);
      }}
    return JPAppTheme.themeColors.base;
  }

  // select selected jobs or remove jobs
  void getSelectedJobs(JobModel job){
    if(tempSelectedJobs.isNotEmpty){
      if(tempSelectedJobs.where((element) => element.id == job.id).isNotEmpty) {
        tempSelectedJobs.removeWhere((element) => element.id == job.id);
      } else {
        if(tempSelectedJobs.first.addressString == job.addressString) {
          tempSelectedJobs.add(job);
        } else {
          Helper.showToastMessage('job_address_must_be_same'.tr.capitalize!);
        }
      }
    } else {
      tempSelectedJobs.add(job);
    }
    update();
  }

  void setSelectedJobData(){
    selectedJobs.clear();
    selectedJobs.addAll(tempSelectedJobs);
    Get.back(result: selectedJobs);
  }
}