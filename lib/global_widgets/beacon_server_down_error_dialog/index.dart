import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/beacon_support_constants.dart';
import '../../core/utils/helpers.dart';

class BeaconServerDownErrorDialog extends StatelessWidget {
  const BeaconServerDownErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: JPColor.transparent,
        child: JPConfirmationDialog(
            icon: Icons.error_outline_outlined,
            title: 'beacon_server_down'.tr.capitalize,
            type: JPConfirmationDialogType.alert,
            prefixBtnColorType: JPButtonColorType.tertiary,
            prefixBtnText: 'close'.tr.toUpperCase(),
            onTapPrefix: Get.back<void>,
            content: JPRichText(
              text: TextSpan(
                children: [
                  JPTextSpan.getSpan(
                      'beacon_server_down_error_msg'.tr+' \n',
                      textColor: JPAppTheme.themeColors.tertiary,
                      height: 1.8,
                      letterSpacing: 0.1
                  ),
                  JPTextSpan.getSpan(
                      ' \u2022 ',
                      textSize: JPTextSize.heading3,
                      textColor: JPAppTheme.themeColors.tertiary
                  ),
                  JPTextSpan.getSpan(
                      BeaconSupportConstants.phoneNumber+' \n',
                      textColor: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      height: 1.8,
                      recognizer: TapGestureRecognizer()..onTap =
                          () => Helper.launchCall(BeaconSupportConstants.phoneNumber)
                  ),
                  JPTextSpan.getSpan(
                      ' \u2022 ',
                      textSize: JPTextSize.heading3,
                      textColor: JPAppTheme.themeColors.tertiary
                  ),
                  JPTextSpan.getSpan(
                      BeaconSupportConstants.email,
                      textColor: JPAppTheme.themeColors.primary,
                      textDecoration: TextDecoration.underline,
                      height: 1.8,
                      recognizer: TapGestureRecognizer()..onTap =
                          () => Helper.launchEmail(BeaconSupportConstants.email)
                  )
                ],
              ),
            ),
      )),
    );
  }
}
