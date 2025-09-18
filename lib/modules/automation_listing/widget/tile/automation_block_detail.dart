import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/TextSpan/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class AutomationBlockTileDetail extends StatelessWidget {
  final String ? movedToStage;
  final bool isBlocked;
  final bool isTaskCompleted;
  const AutomationBlockTileDetail({
    super.key, 
    this.movedToStage, 
    this.isBlocked = false,
    this.isTaskCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isBlocked,
      child: Column(
        children:  [
          Text.rich(
            JPTextSpan.getSpan(
            '', 
            height: 1.5,
            textSize: JPTextSize.heading4,
            children: [
              JPTextSpan.getSpan(
                '${'automation_to'.tr} ',
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              JPTextSpan.getSpan(
                movedToStage ?? "",
                fontWeight: JPFontWeight.bold,
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              JPTextSpan.getSpan(
                ' ${'was'.tr} ',
                textColor: JPAppTheme.themeColors.tertiary,
              ),
              JPTextSpan.getSpan(
                'blocked'.tr,
                fontWeight: JPFontWeight.bold,
                textColor: JPAppTheme.themeColors.red,
              ),
              if(isTaskCompleted)...{
                JPTextSpan.getSpan(
                  '. ''${'please_click_on_initiate_stage_change_to_unblock_the_automation'.tr}',
                  textColor: JPAppTheme.themeColors.tertiary,
                ),  
              } else ...{
                JPTextSpan.getSpan(
                  ' ${'due_to_incomplete_tasks'.tr}',
                  textColor: JPAppTheme.themeColors.tertiary,
                ),
              }
            ],
          ),
        ), 
        const SizedBox(height: 4),
        ],
      ),
    );
  }
}