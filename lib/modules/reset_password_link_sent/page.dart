import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/constants/assets_files.dart';

class ResetPasswordLinkSentView extends StatelessWidget {
  const ResetPasswordLinkSentView({super.key});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
        child: JPScaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AssetsFiles.emailSent,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 10),
                  JPText(
                    text: 'reset_password_link_sent'.tr,
                    textSize: JPTextSize.heading2,
                    fontWeight: JPFontWeight.medium,
                  ),
                  const SizedBox(height: 10),
                  JPText(
                    text: 'please_check_your_email_and_click_on_the_provided_link_to_reset_your_password'.tr,
                    textSize: JPTextSize.heading4,
                  ),
                  const SizedBox(height: 20),
                  JPButton(
                    text: 'back'.tr.toUpperCase(),
                    size: JPButtonSize.small,
                    onPressed: Get.back<void>,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}