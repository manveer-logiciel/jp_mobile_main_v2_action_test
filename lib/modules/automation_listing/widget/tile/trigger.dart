import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class AutomationTileTriggerBy extends StatelessWidget {
  final bool? isTriggered;
  final String? eventName;
  final bool isBlocked;
  
  const AutomationTileTriggerBy({
    super.key, 
    this.isTriggered, 
    this.eventName,
    this.isBlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !Helper.isValueNullOrEmpty( eventName) && (isTriggered ?? true) && (!isBlocked),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: JPText(
          text: '${'triggered_by'.tr}: ${Helper.formattedUnderscoreString(eventName!)}',
          textSize: JPTextSize.heading5,
          textColor: JPAppTheme.themeColors.tertiary,
        ),
      ),
    );
  }
}