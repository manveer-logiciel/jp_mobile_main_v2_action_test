import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DrawingToolEditorIcon extends StatelessWidget {
  const DrawingToolEditorIcon({
    super.key,
    this.isActive = false,
    this.showBlueBackground = false,
    required this.title,
    this.icon,
    this.onTap,
    this.value
  });

  final bool isActive;

  final bool showBlueBackground;

  final String title;

  final IconData? icon;

  final VoidCallback? onTap;

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 3
      ),
      child: InkWell(
        onTap: onTap == null ? null : () {
          HapticFeedback.mediumImpact();
          onTap!();
        },
        splashColor: JPColor.transparent,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: showBlueBackground ? JPAppTheme.themeColors.primary : JPColor.transparent,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6
          ),
          child: Column(
            children: [
              if(value != null)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 3
                  ),
                  child: JPText(
                    text: value.toString(),
                    textColor: isActive ? JPColor.white : JPAppTheme.themeColors.dimGray,
                  ),
                ),
    
              if(icon != null)
              JPIcon(
                icon!,
                size: 20,
                color: isActive ? JPColor.white : JPAppTheme.themeColors.dimGray,
              ),
              const SizedBox(
                height: 3,
              ),
              JPText(
                text: title,
                textColor: isActive ? JPColor.white : JPAppTheme.themeColors.dimGray,
                dynamicFontSize: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
