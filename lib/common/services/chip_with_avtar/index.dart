import 'package:flutter/material.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class JPChipWithAvatarService {

  static Color evaluateBackgroundColor(String? color) {
      final defaultColor = JPAppTheme.themeColors.darkGray.toHex();
      final hexColor = color ?? defaultColor;
      final inverseHexColor = JPAppTheme.themeColors.inverse.toHex();

      return ColorHelper.getHexColor(
          hexColor.contains(inverseHexColor) ? defaultColor : hexColor,
      );
  }
}
