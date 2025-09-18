import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/count.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';

class AutomationTileEmailTaskCounts extends StatelessWidget {
  final AutomationListingController controller;
  final int index;
  const AutomationTileEmailTaskCounts({
    super.key, 
    required this.controller, 
    required this.index});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.hasTasksOrEmail(index),
      child: Column(
        children: [
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(top: 8,bottom: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutomationTileCounts(
                          visible: controller.automationList[index].displayData?.toStage?.sendCustomerEmail ?? false,
                          label: '${'email_automations'.tr}: ',
                          count: controller.automationList[index].displayData?.toStage?.emailCount.toString() ?? '0',
                        ),
                        const SizedBox(height: 8),
                        AutomationTileCounts(
                          visible: controller.automationList[index].displayData?.toStage?.createTasks ?? false,
                          label: '${'task_automations'.tr}: ',
                          count: controller.automationList[index].displayData?.toStage?.taskCount.toString() ?? '0',
                        ),
                      ],
                    ),
                    JPTextButton(
                      key: ValueKey('${WidgetKeys.automationViewButton}[$index]'),
                      text: 'view'.tr.capitalizeFirst,
                      icon: Icons.chevron_right,
                      textSize: JPTextSize.heading4,
                      onPressed: () {
                        controller.navigateToAutomationDetails(index);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}