import 'dart:async';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/home/filter_model.dart';

import '../../models/workflow_stage.dart';
import '../../repositories/stage_resources.dart';

class WorkFlowService extends GetxService {

  RxList<WorkFlowStageModel> stages = <WorkFlowStageModel>[].obs;

  Map<String, dynamic>? filterParams;

  List<StreamSubscription<List<WorkFlowStageModel>>> streamSubscriptionList = [];

  static WorkFlowService setUp() => Get.put(WorkFlowService());

  Future<List<WorkFlowStageModel>> fetchStages({Map<String, dynamic>? params}) async {
    try {
      if (params != null) {
        filterParams = params;
      }

      filterParams ??= HomeFilterModel().toJsonForStateAPI();
      stages.assignAll( await StageResourcesRepository.fetchStages(params: filterParams));
    } catch(e) {
      rethrow;
    }
    return stages;
  }

  static WorkFlowService? get() {
    if(Get.isRegistered<WorkFlowService>()) {
      final WorkFlowService workFlowService = Get.find<WorkFlowService>();
      return workFlowService;
    }
    return null;
  }

  StreamSubscription<List<WorkFlowStageModel>> listen(void Function(List<WorkFlowStageModel>) onData) {
    StreamSubscription<List<WorkFlowStageModel>> listener = stages.listen(onData);
    streamSubscriptionList.add(listener);
    return listener;
  }

  Future<void> destroyAllListeners() async {
    for(StreamSubscription<List<WorkFlowStageModel>>
     streamSubscription in streamSubscriptionList) {
      await streamSubscription.cancel();
    }
  }
}