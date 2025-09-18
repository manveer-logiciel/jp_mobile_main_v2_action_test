
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_switcher.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/secondary_header.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/repositories/job.dart';

class JobSwitcherController extends GetxController {
  final int? customerId;
  final JobModel? currentJob;
  final JobSwitcherType type;
  JobSwitcherController({required this.currentJob, required this.customerId, required this.type});
  
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<JobModel> jobListing = [];
  List<JobModel> jobMutliProjectListing = [];
  List<JobModel> mainList = [];

  int jobListToatlLength = 0;
  int jobProjectToatlLength = 0;

  bool isLoading = true; 
  bool isLoadingProject = true; 
  bool isLoadMore = false;
  bool canShowLoadMore = false;
  bool isLoadMoreProject = false;
  bool canShowLoadMoreProject = false;

  JobSwitcherParamModel paramKey = JobSwitcherParamModel();

  Future<void> fetchJobListing() async {
    try {    
      paramKey.customerId = currentJob!.customerId;
      paramKey.optimized = 1;
      final jobListingParams = <String, dynamic>{
        'includes[0]': ['division'],
        'includes[1]': ['flags.color'],
        ...paramKey.toJson()
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
  
  Future<void> fetchProjectListing() async {
    try {
      paramKey.customerId = currentJob!.customerId;
      paramKey.parentId = currentJob!.isMultiJob ? currentJob!.id : currentJob!.parentId;
      paramKey.sortBy = 'display_order';
      paramKey.sortOrder = 'asc';
      
      final jobListingProjectParams = <String, dynamic>{
        'includes[0]': ['division'],
        'includes[1]': ['flags.color'],
        ...paramKey.toJson()
      };
      Map<String, dynamic> response = await JobRepository.fetchJobList(params: jobListingProjectParams);
      setJobListingProject(response);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadMoreProject = false;
      update();
    }
  }

  void setJobListing(Map<String, dynamic> response) {
    List<JobModel> list = response['list'];
    PaginationModel pagination = PaginationModel.fromJson(response['pagination']);
    jobListToatlLength = pagination.total!;
    
    if (!isLoadMore) {
      jobListing = [];
    }
    jobListing.addAll(list);

    if(currentJob!.parentId != null && currentJob!.parent != null) {
      int indexValue = jobListing.indexWhere((element) => element.id == currentJob!.parentId);

      if(indexValue != -1) {
        jobListing.removeAt(indexValue);
        int ind = jobListing.indexWhere((element) => element.id == currentJob!.id);
        if(ind != -1) jobListing.removeAt(ind);
      }

      jobListing.insert(0, currentJob!.parent!);
    } else {
      int indexValue = jobListing.indexWhere((element) => element.id == currentJob!.id);

      if(indexValue != -1) {
        jobListing.removeAt(indexValue);
        int ind = jobListing.indexWhere((element) => element.id == currentJob!.id);
        if(ind != -1) jobListing.removeAt(ind);
      }
      jobListing.insert(0, currentJob!);
    }

    mainList = jobListing;

    canShowLoadMore = jobListing.length < jobListToatlLength;
  }

  void setJobListingProject(Map<String, dynamic> response) {
    List<JobModel> list = response['list'];

    jobProjectToatlLength = response['pagination']?['total'] ?? 0;
 
    if(!isLoadMoreProject) {
      jobMutliProjectListing = [];
    }

    jobMutliProjectListing.addAll(list);

    if(currentJob!.parentId != null && currentJob!.parent != null) {
       int indexValue = jobMutliProjectListing.indexWhere((element) => element.id == currentJob!.parentId);

      if(indexValue != -1) {
        jobMutliProjectListing.removeAt(indexValue);
      }

       jobMutliProjectListing.insert(0, currentJob!.parent!);

      int currentSelectedIndex = jobMutliProjectListing.indexWhere((element) => element.id == currentJob!.id);

      if(currentSelectedIndex != -1) {
        jobMutliProjectListing.removeAt(currentSelectedIndex);
        int ind = jobMutliProjectListing.indexWhere((element) => element.id == currentJob!.id);
        if(ind != -1) jobMutliProjectListing.removeAt(ind);
      }

       jobMutliProjectListing.insert(1, currentJob!);
    } else {
      int indexValue = jobMutliProjectListing.indexWhere((element) => element.id == currentJob!.id);

      if(indexValue != -1) {
        jobMutliProjectListing.removeAt(indexValue);
        int ind = jobMutliProjectListing.indexWhere((element) => element.id == currentJob!.id);
        if(ind != -1) jobMutliProjectListing.removeAt(ind);
      }
      jobMutliProjectListing.insert(0, currentJob!);
    }

    mainList = jobMutliProjectListing;
    
    canShowLoadMoreProject = jobMutliProjectListing.length < jobProjectToatlLength;
    update();
  }

  Future<void> loadMore() async {
    paramKey.page += 1;
    if(type ==JobSwitcherType.project) {
      isLoadMoreProject = true;
      await fetchProjectListing();
    } else {
      isLoadMore = true;
      await fetchJobListing();
    }
  }

  void setType(){
    if(type ==JobSwitcherType.job){
      if(jobListing.isNotEmpty){
        mainList = jobListing;
      } else {
        fetchJobListing();
      }
    }
    if(type == JobSwitcherType.project){
      if(jobMutliProjectListing.isNotEmpty){
        mainList = jobMutliProjectListing;
      } else {
        fetchProjectListing();
      }
    }    
  }

 @override
  void onInit() {
    super.onInit(); 
    setType();   
  }
}