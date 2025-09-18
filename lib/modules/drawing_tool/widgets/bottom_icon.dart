
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolBottomIcon extends StatelessWidget {

  const DrawingToolBottomIcon({
    super.key,
    this.icon,
    this.onTap,
    this.iconColor,
    this.value,
    this.unit,
    this.isActive = false,
    this.iconWidget
  });

  /// icon used to display icon
  final IconData? icon;

  /// onTap handles tap action
  final VoidCallback? onTap;

  /// iconColor used to set icon color
  final Color? iconColor;

  /// value can be used to display text value
  final String? value;

  /// unit can be used to display value unit
  final String? unit;

  /// unit can be used to set change state of button
  final bool isActive;

  final Widget? iconWidget;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? iconColor ?? JPAppTheme.themeColors.primary : JPColor.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap == null ? null : () {
          HapticFeedback.mediumImpact();
          onTap!();
        },
        child: SizedBox(
          height: 36,
          width: 36,
          child: value != null
              ? Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                JPText(
                  text: value ?? "",
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.bold,
                  textColor: isActive ? JPAppTheme.themeColors.secondary : JPAppTheme.themeColors.darkGray,
                ),
                if(unit != null)
                  JPText(
                    text: unit ?? "",
                    textSize: JPTextSize.heading6,
                    fontWeight: JPFontWeight.bold,
                    textColor: isActive ? JPAppTheme.themeColors.secondary : JPAppTheme.themeColors.darkGray,
                  ),
              ],
            ),
          ): iconWidget ??
          Icon(
            icon,
            size: 24,
            color: iconColor ?? (isActive ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.dimGray),
          ),
        ),
      ),
    );
  }
}
