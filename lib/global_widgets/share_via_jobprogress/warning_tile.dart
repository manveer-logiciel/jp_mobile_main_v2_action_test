import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WarningTile extends StatelessWidget {
  const WarningTile({
    super.key, 
    required this.text, 
    this.buttonText, 
    this.suffixText, 
    required this.onTap,
  });

  final String text;
  final String? buttonText;
  final String? suffixText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Material(
          color: JPAppTheme.themeColors.red.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12, left: 8, right: 8),
            child: JPRichText(
              text: TextSpan(
                children: [
                  JPTextSpan.getSpan(
                    text,
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.red,
                    height: 1.5,
                  ),
                  JPTextSpan.getSpan(
                    buttonText ?? '',
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.red,
                    height: 1.5,
                    fontWeight: JPFontWeight.medium,
                  ),
                  JPTextSpan.getSpan(
                    suffixText ?? '',
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    textColor: JPAppTheme.themeColors.red,
                    height: 1.5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}