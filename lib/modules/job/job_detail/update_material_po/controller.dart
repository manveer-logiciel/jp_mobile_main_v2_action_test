import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';

class UpdateMaterialPOController extends GetxController {
  final String currentMaterialPO;

  late TextEditingController materialPOController;

  bool isUpdatingMaterialPOStatus = false;


  UpdateMaterialPOController(this.currentMaterialPO) {
    materialPOController = TextEditingController(text:currentMaterialPO);
  }

  Future<void> updateMaterialPO(int jobId,Function(String?)? updateMaterialPOCallback) async{
    toggleMaterialPO();

    Map<String,dynamic> params = {
      'jobId' : jobId,
      'purchase_order_number' : materialPOController.text.toString()
    };

    JobModel jobModel = await MaterialListsRepository.updateMaterialPO(params).trackUpdateEvent(MixPanelEventTitle.jobMaterialPoUpdate);

    updateMaterialPOCallback?.call(jobModel.purchaseOrderNumber);

    Get.back();
  }

  void toggleMaterialPO() {
    isUpdatingMaterialPOStatus = !isUpdatingMaterialPOStatus;
    update();
  }
}