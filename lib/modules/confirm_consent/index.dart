import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../core/constants/consent_status_constants.dart';
import '../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'widgets/confirm_consent_tile.dart';

class ConfirmConsentPage extends StatelessWidget {
  const ConfirmConsentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmConsentController>(
      global: false,
      init: ConfirmConsentController(),
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: "confirm_consent".tr,
            onBackPressed: () => Get.back(),
          ),
          body: JPSafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(!Helper.isValueNullOrEmpty(controller.customerName))...{
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: JPText(
                            text: "${"customer".tr}: ${controller.customerName}",
                            textSize: JPTextSize.heading4,
                            fontWeight: JPFontWeight.medium,
                          )
                        ),
                      },

                      JPText(
                        text: "confirm_consent_message".tr,
                        textSize: JPTextSize.heading4,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConfirmConsentTile(
                          title: "no_messaging".tr.capitalize,
                          description: "no_messaging_consent_message".tr,
                          isSelected: controller.previouslySelectedConsent == ConsentStatusConstants.noMessage,
                          isDisable: controller.previouslySelectedConsent == ConsentStatusConstants.noMessage,
                          onTap:() => controller.updateSelectedConsent(ConsentStatusConstants.noMessage),
                        ),

                        ConfirmConsentTile(
                          title: "transactional_messaging".tr.capitalize,
                          description: "transactional_messaging_consent_message".tr,
                          isSelected: controller.previouslySelectedConsent == ConsentStatusConstants.transactionalMessage,
                          isDisable: controller.previouslySelectedConsent == ConsentStatusConstants.transactionalMessage,
                          onTap:() => controller.updateSelectedConsent(ConsentStatusConstants.transactionalMessage),
                        ),

                        ConfirmConsentTile(
                          title: "promotional_messaging".tr,
                          description: "promotional_messaging_consent_message".tr,
                          isSelected: controller.previouslySelectedConsent == ConsentStatusConstants.promotionalMessage,
                          isDisable: controller.previouslySelectedConsent == ConsentStatusConstants.promotionalMessage,
                          onTap:() => controller.updateSelectedConsent(ConsentStatusConstants.promotionalMessage),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        );
      });
  }
}
