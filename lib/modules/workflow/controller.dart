import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/home/filter_model.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';

import '../../common/services/workflow_stages/workflow_service.dart';

class WorkflowListController extends GetxController {
  bool isLoading = true;
  late GlobalKey<ScaffoldState> scaffoldKey;
  List<WorkFlowStageModel> stages = [];
  HomeFilterModel filterKeys = HomeFilterModel();

  WorkFlowService? workFlowService;

  StreamSubscription<List<WorkFlowStageModel>>? stagesListener;

  WorkflowListController() {
    scaffoldKey = GlobalKey<ScaffoldState>();

    initPage();
  }

  void initPage() {
    isLoading = true;

    update();
    dynamic filterSetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.workFlowFilters, onlyValue: false);
    if(filterSetting is Map<String, dynamic>) {
      filterKeys = HomeFilterModel.fromJson(filterSetting);
    }

    workFlowService = WorkFlowService.get();
    workFlowStagesListener();

    loadStages();
  }

  Future<void> loadStages() async {
    try {
      Map<String, dynamic> filterParams  = filterKeys.toJsonForStateAPI()..removeWhere(
      (dynamic key, dynamic value) => (key == null || value == null));

      await workFlowService?.fetchStages(params: filterParams);
    } catch (e) {
      rethrow;
    }
  }

  void refreshWorkFlowStages(List<WorkFlowStageModel> stages) {
    this.stages = stages;
    isLoading = false;
    update();
  }

  void workFlowStagesListener() {
    stagesListener = workFlowService?.listen((stages) {
      if(stages.isNotEmpty) {
        refreshWorkFlowStages(stages);
      }
    });
  }

  Future<bool> onWillPopup() async {
    stagesListener?.cancel();
    Get.back();
    return false;
  }
}
