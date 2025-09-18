import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ForgotPasswordHeaderTile extends StatelessWidget {
  const ForgotPasswordHeaderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AssetsFiles.loginLogo,
          width: 200,
          height: 82,
        ),
        const SizedBox(height: 20),
        JPText(
          text: '${'forgot_password'.tr.capitalize}?',
          textSize: JPTextSize.heading1,
          fontWeight: JPFontWeight.medium,
          textColor: JPAppTheme.themeColors.text,
        ),
        const SizedBox(height: 10),
        JPText(
          text: 'no_worries_just_enter_your_email_and_you_will_receive_a_reset_password_link'.tr,
          textSize: JPTextSize.heading4,
          textColor: JPAppTheme.themeColors.tertiary,
          height: 1.5,
        ),
      ],
    );
  }
}