import 'package:flutter/material.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/action_button.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/automation_block_detail.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/detail.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/email_task_count.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/header.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/incomplete_tasks_detail.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/trigger.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AutomationTile extends StatelessWidget {
  final AutomationListingController controller;
  final int index;
  const AutomationTile({
    super.key, 
    required this.controller, 
    required this.index,
    
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.base,
        borderRadius: BorderRadius.circular(8),
      ),
      child:Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutomationTileHeader(job: controller.automationList[index].job),
          AutomationTileDetail(
            movedToStage: controller.automationList[index].displayData?.toStage?.name,
            isBlocked: controller.isAutomationBlocked(index),
          ),
          AutomationBlockTileDetail(
            isBlocked: controller.isAutomationBlocked(index),
            isTaskCompleted: !controller.hadIncompleteTasks(index),
            movedToStage: controller.automationList[index].displayData?.toStage?.name,
          ),
          AutomationTileTriggerBy(
            eventName: controller.automationList[index].event, 
            isBlocked: controller.isAutomationBlocked(index),
          ),
          AutomationTileEmailTaskCounts(controller: controller, index: index),
          AutomationTileActionButtons(controller: controller, index: index),
          IncompleteTasksDetail(
            visible: controller.isAutomationBlocked(index) && 
              !Helper.isValueNullOrEmpty(controller.automationList[index].incompleteTaskLockCount),
            controller: controller, 
            automationIndex: index
          ),
        ],
      ),
    );
  }
}



