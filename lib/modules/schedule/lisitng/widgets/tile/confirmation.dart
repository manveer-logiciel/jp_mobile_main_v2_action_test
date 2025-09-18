import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleListingConfirmationButtons extends StatelessWidget {
  const ScheduleListingConfirmationButtons({
    required this.onAccept,
    required this.onDecline,
    super.key,
  });

  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        JPTextButton(
          onPressed: onAccept,
          text: 'accept'.tr,
          textSize: JPTextSize.heading5,
          color: JPAppTheme.themeColors.success,
          fontWeight: JPFontWeight.medium,
        ),
        JPText(
          text: '|',
          textColor: JPAppTheme.themeColors.darkGray,
          fontWeight: JPFontWeight.medium,
        ),
        JPTextButton(
          onPressed: onDecline,
          text: 'decline'.tr,
          textSize: JPTextSize.heading5,
          color: JPAppTheme.themeColors.secondary,
          fontWeight: JPFontWeight.medium,
        ),
      ],
    );
  }
}
