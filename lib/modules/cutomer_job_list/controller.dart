import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/secondary_header.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/repositories/job.dart';

import '../../common/enums/page_type.dart';
import '../../core/constants/navigation_parms_constants.dart';
import '../../routes/pages.dart';

class CustomerJobListingController extends GetxController {

  final int? customerJobId;
  int? parentJobId;
  final List<JobModel>? jobs;
  final PageType? pageType;
  Function(JobModel jobModel)? callback;

  CustomerJobListingController({this.customerJobId, this.jobs, this.parentJobId, this.pageType = PageType.home, this.callback}) {
    jobListing = [];
    fetchCustomerJob();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  
  List<JobModel> jobListing = [];

  int customerJobListToatalLength = 0;
  
  JobSwitcherParamModel paramKey = JobSwitcherParamModel();


  Future<void> fetchCustomerJob() async {
    paramKey.customerId = customerJobId;
    paramKey.parentId = parentJobId;
    if(jobs != null) {
      jobListing = jobs!;
      isLoading = false;
      update();
      return;
    }

    try {
      if(customerJobId != null){
        paramKey.customerId = customerJobId;
      } else if (parentJobId != null) {
        paramKey.parentId = parentJobId;
      }
      final jobListingParams = <String, dynamic>{
        "includes[0]": "follow_up_status",
        "includes[1]": "projects.follow_up_status",
        "includes[2]": "customer",
        "includes[3]": "division",
        "includes[4]": "flags.color",
        ...paramKey.toJson()..removeWhere((dynamic key, dynamic value) => (key == null || value == null)),
      };

      Map<String, dynamic> response = await JobRepository.fetchJobList(params: jobListingParams);
      setJobListing(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMore = false;
      update();
    }
  }


  void setJobListing(Map<String, dynamic> response) {
    List<JobModel> list = response['list'];
    PaginationModel pagination;
    if(response['pagination'] is Map) {
      pagination = PaginationModel.fromJson(response['pagination']);
    } else {
      pagination = response['pagination'];
    }

    customerJobListToatalLength = pagination.total!; 

    if (!isLoadMore) {
      jobListing = [];
    }

    jobListing.addAll(list);

    canShowLoadMore = jobListing.length < customerJobListToatalLength;
    update();
  }

  Future<void> loadMore() async {
    paramKey.page += 1;
    isLoadMore = true;
    await fetchCustomerJob();
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  void navigateToJobDetailScreen({int? jobID, int? currentIndex}) {
    switch(pageType) {
      case PageType.home:
        Get.toNamed(
            Routes.jobSummary,
            arguments: {NavigationParams.jobId: jobListing[currentIndex!].id, NavigationParams.customerId : jobListing[currentIndex].customerId},
            preventDuplicates: false
        );
        break;
      case PageType.fileListing:
      case PageType.shareTo:
        if(jobListing[currentIndex!].isMultiJob) {
          parentJobId = jobListing[currentIndex].id;
          paramKey.parentId = jobListing[currentIndex].id;
          paramKey.customerId = null;
          isLoading = true;
          update();
          fetchCustomerJob();
        } else {
          callback!(jobListing[currentIndex]);
        }
        break;
      default:
        Get.toNamed(Routes.jobSummary, arguments: {
          NavigationParams.jobId: jobID,
          NavigationParams.customerId: jobListing[currentIndex!].customerId
        },preventDuplicates: false);
        break;
    }
  }

  void onBackPress() async {
    parentJobId = null;
    paramKey.parentId = null;
    paramKey.customerId = customerJobId;
    isLoading = true;
    update();
    fetchCustomerJob();
  }
}