import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/pagination_model.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/task_template.dart';
import 'package:jobprogress/common/services/task/quick_actions.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';

class TaskTemplateListingController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'task_template_listing_controller_scaffold_key');

  int page = 1;
  String searchKeyword = '';
  List<TaskListModel> templateList = [];
  bool isLoadingMore = false;
  bool isLoading = true;
  bool canShowMore = false;
  bool favoriteOnly = false;
  TextEditingController searchController = TextEditingController();

  Map<String, dynamic> getTaskParams() {
    Map<String, dynamic> params = {
      'includes[0]': 'participants',
      'includes[1]': 'notify_users',
      'limit': PaginationConstants.pageLimit,
      'page': page,
      'title': searchKeyword
    };
    return params;
  }


  Future<void> getTaskTemplateList() async {
    Map<String, dynamic> tasksParams = getTaskParams();

    try {
      Map<String, dynamic> response = await TaskTemplatelListingRepository.fetchTemplateList(tasksParams);
      
      List<TaskListModel> list = response['list'];
      PaginationModel pagination = response['pagination'];

      if (!isLoadingMore) {
        templateList = [];
      }

      templateList.addAll(list);

      canShowMore = templateList.length < pagination.total!;
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> loadMore() async {
    page += 1;
    isLoadingMore = true;
    update();
    await getTaskTemplateList();
  }

  Future<void> refreshList({bool? showLoading}) async {
    page = 1;
    isLoading = showLoading ?? false;
    update();
    await getTaskTemplateList();
  }

  onSearchTextChanged(String text) {
    page = 1;
    searchKeyword = text;
    isLoading = true;
    update();
    getTaskTemplateList();
  }

  void openTemplateInDialog( TaskListModel task) {
    TaskService.openTaskdetail(task: task, isUserHaveEditPermission: false, isTaskTemplate: true);
  }

  void cancelOnGoingRequest() {
    cancelToken?.cancel();
  }

  @override
  void dispose() {
    cancelOnGoingRequest();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    getTaskTemplateList();
  }
}