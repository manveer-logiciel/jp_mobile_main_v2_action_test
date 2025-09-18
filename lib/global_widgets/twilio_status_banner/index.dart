
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/twilio_text_status.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/link_with_text/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPTwilioStatusBanner extends StatelessWidget {
  const JPTwilioStatusBanner({
    super.key,
    this.status,
  });

  final TwilioTextStatus? status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case TwilioTextStatus.disabled:
      case TwilioTextStatus.inProgress:
        return JPTextWithLink(
          bannerStyle: true,
          linkText: getLinkText(),
          helperText: getHelperText(),
          onTapLink: handleLinkTap,
        );
      case TwilioTextStatus.notPermitted:
        return textingNotPermittedBanner();
      default:
        return const SizedBox();
    }
  }

  Widget textingNotPermittedBanner() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: JPAppTheme.themeColors.red.withValues(alpha: 0.1),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: JPRichText(
        text: TextSpan(
          children: [
            if (Helper.isValueNullOrEmpty(ConsentHelper.lastSoleProprietorUser)) ...{
              JPTextSpan.getSpan(
                  'no_user_is_set_up_to_text_consumers'.tr,
                  textColor: JPAppTheme.themeColors.red,
                  height: 1.8
              ),
            } else ...{
              JPTextSpan.getSpan(
                  'you_can_only_send_texts_from'.tr,
                  textColor: JPAppTheme.themeColors.red,
                  height: 1.8
              ),
              JPTextSpan.getSpan(
                ' ${ConsentHelper.lastSoleProprietorUser?.fullName} ',
                textColor: JPAppTheme.themeColors.red,
                fontWeight: JPFontWeight.medium,
                height: 1.8,
              ),
              JPTextSpan.getSpan(
                '${'account'.tr}.',
                textColor: JPAppTheme.themeColors.red,
                height: 1.8,
              ),
            }
          ],
        ),
      ),
    );
  }

  String getLinkText() {
    switch (status) {
      case TwilioTextStatus.disabled:
        return ConsentStatusConstants.supportEmail;
      case TwilioTextStatus.inProgress:
        return 'learn_more'.tr;
      default:
        return '';
    }
  }

  String getHelperText() {
    switch (status) {
      case TwilioTextStatus.disabled:
        return 'to_enable_texting_please_reach_out_to'.tr;
      case TwilioTextStatus.inProgress:
        return 'you_cant_start_texting_until_you_finish_setup_process'.tr;

        default:
        return '';
    }
  }

  void handleLinkTap() {
    switch (status) {
      case TwilioTextStatus.disabled:
        ConsentHelper.sendSupportEmail();
        break;
      case TwilioTextStatus.inProgress:
        Helper.launchUrl(Urls.setUpTextingURL);
        break;
      default:
        break;
    }
  }
}
