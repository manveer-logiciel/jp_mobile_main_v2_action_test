
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentResultPlaceholder extends StatelessWidget {

  const AppointmentResultPlaceholder({
    super.key,
    this.onTapBtn
  });

  final VoidCallback? onTapBtn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Text.rich(
            JPTextSpan.getSpan(
              'tap_here'.tr,
              recognizer: TapGestureRecognizer()..onTap = onTapBtn ?? () {},
              textColor: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading4,
              children: [
                JPTextSpan.getSpan(
                  ' ${'to_add_appointment_results'.tr}',
                  textColor: JPAppTheme.themeColors.darkGray,
                  textSize: JPTextSize.heading4,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          ),
        ),
      ],
    );
  }
}
