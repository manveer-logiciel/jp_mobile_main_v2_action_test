
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/repositories/work_flow_stages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

import '../../../../../../common/services/workflow_stages/workflow_service.dart';
import '../../../../../../global_widgets/bottom_sheet/index.dart';

class JobOverViewProjectStatusDialogController extends GetxController {

  JobOverViewProjectStatusDialogController(
      this.users,
      this.parentId,
      this.stageId
  );

  List<JPMultiSelectModel> users;
  int parentId;
  String stageId;

  TextEditingController usersController = TextEditingController();

  bool byEmail = false;
  bool byText = false;
  bool isLoading = false;

  @override
  void onInit() {
    clearListValues();
    super.onInit();
  }

  void clearListValues() {
    for (var user in users) {
      user.isSelect = false;
    }
  }

  // showSelectionSheet() will display multiselect filter sheet
  void showSelectionSheet() {
    showJPBottomSheet(child: (_) =>
      JPMultiSelect(
        mainList: users,
        inputHintText: 'search_here'.tr,
        title: 'select_users'.tr.toUpperCase(),
        onDone: (list) {
          usersController.text = getInputFieldText(list);
          users = list;
          update();
          Get.back();
        },
      ),
      isScrollControlled: true,
      ignoreSafeArea: true,
      enableDrag: true,
    );
  }

  // getInputFieldText() will return string generated from selected options
  String getInputFieldText(List<JPMultiSelectModel> list) {

    final selectedValuesList = list.where((element) => element.isSelect).toList(); // filtering selected options

    return selectedValuesList.map((e) => e.label).toList().join(', ');
  }

  void toggleByEmail(bool val) {
    byEmail = !val;
    update();
  }

  void toggleByText(bool val) {
    byText = !val;
    update();
  }

  Future<void> updateProjectStatus(Function(bool doRefresh) onDone) async {
    try {

      toggleIsLoading();

      final selectedUsers = users.where((element) => element.isSelect);
      final notifyUsersList = selectedUsers.map((e) => e.id).toList();


      Map<String, dynamic> params = {
        'parent_id' : parentId,
        if(notifyUsersList.isNotEmpty)
          'notify_users[]' : notifyUsersList,
        'email_notification' : byEmail ? '1' : '0',
        'text_notification' : byText ? '1' : '0',
        'status' : stageId,
      };

      final response = await WorkflowStagesRepository.updateProjectStatus(params);

      onDone(response);

      WorkFlowService.get()?.fetchStages();

    } catch(e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

}