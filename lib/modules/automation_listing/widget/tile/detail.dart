import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class AutomationTileDetail extends StatelessWidget {
  final String ? movedToStage;
  final bool isBlocked;
  const AutomationTileDetail({
    super.key, 
    this.movedToStage, 
    this.isBlocked = false
  });

  @override

  Widget build(BuildContext context) {
    return Visibility(
      visible: !isBlocked,
      child: Column(
        children:  [
          Row(
            children: [
              JPText(
                text: '${'moved_to'.tr} ',
                textSize: JPTextSize.heading4,
              ),
              
              JPText(
                text: movedToStage ?? "",
                textSize: JPTextSize.heading4,
                fontWeight: JPFontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}