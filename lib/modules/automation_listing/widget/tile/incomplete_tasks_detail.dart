import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/task_tile/index.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class IncompleteTasksDetail extends StatelessWidget {
  final bool visible;
  final int automationIndex;
  final AutomationListingController controller;
  const IncompleteTasksDetail({
    super.key, 
    required this.visible, 
    required this.controller, 
    required this.automationIndex, 
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: JPExpansionTile(
        enableHeaderClick: true,
        isExpanded: (controller.automationList[automationIndex].isExpanded ?? false),
        headerPadding: const EdgeInsets.only(top:5, bottom: 5,left: 2,right: 2),
        contentPadding: const EdgeInsets.all(0),
        header: Row(
          children: [
            JPText(
              text: 'incomplete_tasks'.tr,
            ),
            JPText(
              text: ' (${controller.automationList[automationIndex].incompleteTaskLockCount})',
              fontWeight: JPFontWeight.bold,
            )
          ],
        ),
        trailing: (_) => const JPIcon(
          Icons.expand_more,
          size: 25,
        ),
        onExpansionChanged: (val) => controller.onExpansionChanged(val, 
          stages: controller.automationList[automationIndex].transitionStages ?? [], 
          jobId: controller.automationList[automationIndex].job?.id ?? 0, 
          index: automationIndex,
        ),
        children: [
         Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JPListView(
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Helper.isValueNullOrEmpty(controller.automationList[automationIndex].taskList)? const SizedBox.shrink() : 
                  DailyPlanTasksListTile(
                    showTaskAlertIcon: false,
                    padding: const EdgeInsets.only(top: 12,left: 0),
                    showCheckBox: controller.showTaskCheckBox(automationIndex, index),
                    disabled: controller.automationList[automationIndex].taskList![index].completed != null,
                    taskItem: controller.automationList[automationIndex].taskList![index],
                    checkValue: controller.automationList[automationIndex].taskList![index].completed != null,
                    showBorder: (index != controller.automationList[automationIndex].taskList!.length - 1),
                    onTapCheckBox: (val) {
                      controller.updateAutomationAfterTaskComplete(index: automationIndex, taskIndex: index);
                    },
                  );
                },
                listCount:(controller.automationList[automationIndex].taskList?.length ?? 0) - 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
