import 'package:flutter/material.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/utils/helpers.dart';

class NoDataFound extends StatelessWidget {
  final String? title;
  final String? descriptions;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? textColor;
  final JPTextSize? textSize;

  const NoDataFound({
    this.title,
    this.descriptions,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.textColor,
    this.textSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon != null)...{
              JPIcon(icon!,
                color: (iconColor ?? JPAppTheme.themeColors.primary).withValues(alpha: 0.6),
                size: iconSize ?? 90,
              )
            },

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: JPText(
                text: title ?? '',
                textSize: textSize ?? JPTextSize.heading3,
                textAlign: TextAlign.center,
                fontFamily: JPFontFamily.montserrat,
                fontWeight: JPFontWeight.medium,
                textColor: textColor,
              ),
            ),
            if(!Helper.isValueNullOrEmpty(descriptions))...{
              JPText(
                text: descriptions ?? '',
                textColor: JPAppTheme.themeColors.darkGray,
              ),
            }
          ],
        ),
      ),
    );
  }
}
