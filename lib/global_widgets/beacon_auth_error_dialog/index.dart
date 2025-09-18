import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/beacon_support_constants.dart';
import '../../core/utils/helpers.dart';

class BeaconAuthErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const BeaconAuthErrorDialog({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: JPColor.transparent,
        child: JPConfirmationDialog(
            icon: Icons.error_outline_outlined,
            title: 'beacon_authentication_issue'.tr,
            type: JPConfirmationDialogType.alert,
            prefixBtnColorType: JPButtonColorType.tertiary,
            prefixBtnText: 'ok'.tr.toUpperCase(),
            onTapPrefix: Get.back<void>,
            content: JPRichText(
              text: TextSpan(
                children: [
                  JPTextSpan.getSpan(
                      getErrorMessage(),
                      textColor: JPAppTheme.themeColors.tertiary,
                      height: 1.8
                  ),
                  JPTextSpan.getSpan(
                      'beacon_auth_error_msg'.tr,
                      textColor: JPAppTheme.themeColors.tertiary,
                      height: 1.8
                  ),
                  JPTextSpan.getSpan(
                      BeaconSupportConstants.phoneNumber,
                      textColor: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      height: 1.8,
                      recognizer: TapGestureRecognizer()..onTap =
                          () => Helper.launchCall(BeaconSupportConstants.phoneNumber)
                  ),
                  JPTextSpan.getSpan(
                     ' ${'or'.tr} ',
                     textColor: JPAppTheme.themeColors.tertiary,
                     height: 1.8,
                  ),
                  JPTextSpan.getSpan(
                     BeaconSupportConstants.email,
                     textColor: JPAppTheme.themeColors.primary,
                     textDecoration: TextDecoration.underline,
                     height: 1.8,
                     recognizer: TapGestureRecognizer()..onTap =
                         () => Helper.launchEmail(BeaconSupportConstants.email)
                  ),
                  JPTextSpan.getSpan(
                     'for_assistance'.tr,
                     textColor: JPAppTheme.themeColors.tertiary,
                     height: 1.8,
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  String getErrorMessage() {
    return errorMessage == null ? '' : errorMessage!.endsWith(".") ? errorMessage! : "$errorMessage.";
  }
}
