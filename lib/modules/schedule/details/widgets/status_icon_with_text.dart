import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleStatusIconWithText extends StatelessWidget {
  const ScheduleStatusIconWithText(
      {required this.icon,
       this.text,
      required this.color,
      this.textColor,
      this.canShowArrow = false,
      super.key});
  final IconData icon;
  final String? text;
  final Color color;
  final Color? textColor;
  final bool canShowArrow;
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        JPIcon(
          icon,
          color: color,
          size: 15,
        ),
        const SizedBox(
          width: 6.5,
        ),
        JPText(
          text: text ?? '',
          textSize: JPTextSize.heading5,
          textAlign: TextAlign.left,
          textColor: textColor ?? JPAppTheme.themeColors.text,
        ),
        canShowArrow
            ? JPIcon(
                Icons.expand_more,
                color: color,
                size: 15,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
