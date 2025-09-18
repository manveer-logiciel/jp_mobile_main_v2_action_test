import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/day_count_down/controller.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';

class JPDayCountDown extends StatelessWidget {
  const JPDayCountDown({
    super.key,
    this.color,
    this.topPadding,
    this.horizontalPadding,
    this.bottomPadding,
    this.alignment,
    this.showupgradeButton = false,
    this.textSize,
    this.remainingDays,
    this.visibility = true,
  });

  final Color? color;
  final double? topPadding;
  final double? bottomPadding;
  final double? horizontalPadding;
  final MainAxisAlignment? alignment;
  final bool showupgradeButton;
  final bool visibility;
  final int ? remainingDays;
  final JPTextSize? textSize;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPDayCountDownController>(
      init: JPDayCountDownController(),
      builder: (controller) {
         return Visibility(
           visible: controller.shouldWidgetBeVisible(remainingDays, visibility),
           child: Container(
            padding: EdgeInsets.only(
              top: topPadding ?? 0,
              bottom: bottomPadding ?? 0,
              left: horizontalPadding ?? 0,
              right: horizontalPadding ?? 0
            ),
            child: Row(
              mainAxisAlignment: showupgradeButton
                ? MainAxisAlignment.spaceBetween
                : alignment ?? MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: alignment ?? MainAxisAlignment.start,
                  children: [
                    JPIcon(
                      Icons.schedule_outlined,
                      color: color,
                    ),
                    const SizedBox(width: 10),
                    
                    JPText(
                    text: controller.calculateDaysLeft(remainingDays),
                    textColor: color,
                    fontWeight: JPFontWeight.medium,
                    textSize: textSize,
                  ),
                  
                  ],
                ),
                Visibility(
                  visible: showupgradeButton,
                  child: JPButton(
                    text: 'upgrade'.tr,
                    size: JPButtonSize.extraSmall,
                    onPressed: controller.upgradePlan,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
