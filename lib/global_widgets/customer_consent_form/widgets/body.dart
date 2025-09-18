import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/controller.dart';
import 'package:jobprogress/global_widgets/link_with_text/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ConsentFormBody extends StatelessWidget {
  const ConsentFormBody({
    super.key,
    required this.controller,
  });

  final ConsentFormDialogController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isTwilioTextingEnabled) {
      if (controller.canActiveUserSendConsent) {
        return Padding(
          padding: EdgeInsets.only(bottom: controller.showSuccessMessage ? 0 : 16),
          child: Column(
            children: [
              JPText(
                height: 1.6,
                textAlign: TextAlign.left,
                text: controller.consentMessage,
                textSize: JPTextSize.heading4,
              ),
              SizedBox(
                height: controller.showSuccessMessage ? 0 : 16,
              ),
              Visibility(
                visible: controller.showEmailField,
                child: Form(
                  key: controller.formKey,
                  child: JPInputBox(
                    hintText: 'type_email_address'.tr,
                    isRequired: true,
                    controller: controller.emailController,
                    suffixChild: Visibility(
                      visible: !Helper.isValueNullOrEmpty(controller.emailList),
                      child: InkWell(
                        onTap: controller.getEmailList,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: JPAppTheme.themeColors.lightestGray,
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    fillColor: JPAppTheme.themeColors.base,
                    type: JPInputBoxType.withLabel,
                    onChanged: controller.updateSelectedValue,
                    textCapitalization: TextCapitalization.none,
                    onSaved: (value) {},
                    validator: (value) {
                      return controller.validateEmail(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (!controller.isSoleProprietorMissing) {
        return JPRichText(
          text: TextSpan(
            children: [
              JPTextSpan.getSpan(
                  'you_can_only_obtain_consent_through'.tr,
                  textColor: JPAppTheme.themeColors.tertiary,
                  height: 1.8
              ),
              JPTextSpan.getSpan(
                ' ${ConsentHelper.lastSoleProprietorUser?.fullName} ',
                textColor: JPAppTheme.themeColors.tertiary,
                fontWeight: JPFontWeight.medium,
                height: 1.8,
              ),
              JPTextSpan.getSpan(
                '${'account'.tr}.',
                textColor: JPAppTheme.themeColors.tertiary,
                height: 1.8,
              ),
            ],
          ),
        );
      } else {
        return JPText(
          text: 'no_user_is_set_up_to_text_consumers'.tr,
        );
      }
    } else {
      return JPTextWithLink(
        linkText: 'click_here'.tr,
        helperText: 'to_find_out_about_restoring_texting_service'.tr,
        startWithLink: true,
        onTapLink: () => Helper.launchUrl(Urls.textServiceRestorationURL),
      );
    }
  }
}
