import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/Button/color_type.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class AutomationTileActionButtons extends StatelessWidget {
  final AutomationListingController controller;
  final int index;
  const AutomationTileActionButtons({
    super.key, 
    required this.controller, 
    required this.index});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.showActionButtons(index),
      child: Column(
        children: [
          Visibility(
            visible: controller.showActionButtonDivider(index),
            child: const Divider(thickness: 1)
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                Visibility(
                  visible: controller.undoButtonEnable(index),
                  child: JPButton(
                    key: ValueKey('${WidgetKeys.automationUndoButton}[$index]'),
                    size: JPButtonSize.extraSmall,
                    text: 'undo'.toUpperCase(),
                    colorType: JPButtonColorType.lightGray,
                    onPressed: () {
                      controller.undoConfirmationDialog(
                        index: index,
                        id: controller.automationList[index].id.toString(),
                        customerJobName: '${controller.automationList[index].job?.customer?.fullNameMobile ?? ''} ${Helper.getJobName(controller.automationList[index].job!)}',
                        stageName: controller.automationList[index].displayData?.fromStage?.name ?? '',
                      );
                    }
                  ),
                ),
                Visibility(
                  visible: controller.canProceedAutomation(index),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: JPButton(
                      size: JPButtonSize.extraSmall,
                      text: 'initiate_stage_change'.tr.toUpperCase(),
                      colorType: JPButtonColorType.primary,
                      onPressed: () {
                        controller.unblockAutomationConfirmationDialog(index: index);
                      }
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.automationList[index].showReverted ?? false,
                  child: JPText(
                    text: 'reverted'.tr,
                    textColor: JPAppTheme.themeColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Visibility(
                  visible: controller.showSkipSendButton(index),
                  child: Row(
                    children: [
                      JPButton(
                        key: ValueKey('${WidgetKeys.automationSkipButton}[$index]'),
                        size: JPButtonSize.extraSmall,
                        text: 'skip_all'.tr.toUpperCase(),
                        colorType: JPButtonColorType.tertiary,
                        onPressed: () => controller.showSkippedConfirmation(index),
                      ),
                      const SizedBox(width: 8),
                      JPButton(
                        key: ValueKey('${WidgetKeys.automationSendButton}[$index]'),
                        size: JPButtonSize.extraSmall,
                        text: 'send'.tr.toUpperCase(),
                        colorType: JPButtonColorType.primary,
                        onPressed: () => controller.navigateToAutomationDetails(index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
