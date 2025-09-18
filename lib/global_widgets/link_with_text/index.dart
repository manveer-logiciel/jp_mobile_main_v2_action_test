import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPTextWithLink extends StatelessWidget {
  const JPTextWithLink({
    super.key,
    required this.linkText,
    required this.helperText,
    this.startWithLink = false,
    this.bannerStyle = false,
    this.onTapLink,
  });

  /// The text to be displayed for the link
  final String linkText;

  /// The helper text to provide additional information about the link
  final String helperText;

  /// Decides whether the link should be displayed at the start of the text
  final bool startWithLink;

  /// Whether the link should be styled as a banner
  final bool bannerStyle;

  /// Callback function to be executed when the link is tapped
  final VoidCallback? onTapLink;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: bannerStyle ? BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: JPAppTheme.themeColors.red.withValues(alpha: 0.1),
      ) : null,
      padding: bannerStyle
          ? const EdgeInsets.fromLTRB(12, 8, 12, 12)
          : EdgeInsets.zero,
      child: JPRichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            children: [
              /// helper text
              if (!startWithLink)
                JPTextSpan.getSpan(
                  '$helperText ' ,
                  textColor: JPAppTheme.themeColors.red,
                  height: 1.8
              ),
              /// link
              WidgetSpan(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JPTextButton(
                      text: linkText.trim(),
                      color: JPAppTheme.themeColors.themeBlue,
                      textSize: JPTextSize.heading4,
                      padding: 1,
                      textDecoration: TextDecoration.underline,
                      onPressed: onTapLink,
                    ),
                  ],
                ),
              ),
              /// helper text
              if (startWithLink)
                JPTextSpan.getSpan(
                    ' $helperText' ,
                    textColor: JPAppTheme.themeColors.red,
                    height: 1.8
                ),
            ]
        ),
      ),
    );
  }
}
