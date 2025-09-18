import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/global_widgets/consent_status_button/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class DefaultConsentStatus extends StatelessWidget {
  const DefaultConsentStatus({
    super.key,
    required this.params
  });

  final ConsentStatusParams? params;

  @override
  Widget build(BuildContext context) {
    switch (params?.phoneConsentDetail?.consentStatus) {
      case ConsentStatusConstants.optedIn:
        return JPIcon(
          Icons.check_circle,
          color: JPAppTheme.themeColors.tealGreen,
          size: 19,
        );
      case ConsentStatusConstants.optedOut:
        return JPIcon(
          Icons.cancel,
          color: JPAppTheme.themeColors.red,
          size: 19,
        );
      case ConsentStatusConstants.pending:
        return const JPIcon(
          Icons.schedule,
          size: 15,
        );
      case ConsentStatusConstants.resend:
        return ConsentStatusButton(
          suffixIcon: Icons.keyboard_double_arrow_right_outlined,
          onPressed: () {
            ConsentHelper.openConsentFormDialog(
                email: params?.email,
                additionalEmails: params?.additionalEmails,
                previousEmail: params?.phoneConsentDetail?.consentEmail,
                phoneNumber: params?.phoneConsentDetail?.number,
                customerId: params?.customerId,
                contactPersonId: params?.contactPersonId,
                updateScreen: params?.updateScreen
            );
          }, suffixText: 'resend_consent_form'.tr.capitalize!,
        );
      case ConsentStatusConstants.byPass:
        return JPIcon(
          Icons.sms,
          color: JPAppTheme.themeColors.success,
          size: 19,
        );
      default:
        return ConsentStatusButton(
          suffixText: 'send_consent_form'.tr,
          color: JPAppTheme.themeColors.tealGreen,
          suffixIcon: Icons.chevron_right_outlined,
          onPressed: () {
            ConsentHelper.openConsentFormDialog(
                email: params?.email,
                additionalEmails: params?.additionalEmails,
                phoneNumber: params?.phoneConsentDetail?.number,
                customerId: params?.customerId,
                contactPersonId: params?.contactPersonId,
                updateScreen: params?.updateScreen
            );
          },
        );
    }
  }
}
