

import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/services/chip_with_avtar/index.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

void main() {
  group('JPChipWithAvatarService@evaluateBackgroundColor should return correct color', () {
    test('Should return darkGray, when param is null ', () {
      final result = JPChipWithAvatarService.evaluateBackgroundColor(null);
      expect(result, equals(ColorHelper.getHexColor(JPAppTheme.themeColors.darkGray.toHex())));
    });

    test('Should return inverseHexColor, when param contains inverseHexColor', () {
      final result = JPChipWithAvatarService.evaluateBackgroundColor(JPAppTheme.themeColors.inverse.toHex());
      expect(result, equals(ColorHelper.getHexColor(JPAppTheme.themeColors.darkGray.toHex())));
    });

    test('should return hexColor, when param does not contain inverseHexColor', () {
      const hexColor = 'FF0000'; // Replace with the desired hex color
      final result = JPChipWithAvatarService.evaluateBackgroundColor(hexColor);
      expect(result, equals(ColorHelper.getHexColor(hexColor)));
    });
  });
}