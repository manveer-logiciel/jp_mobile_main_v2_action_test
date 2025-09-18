import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/utils/helpers.dart';
import 'controller.dart';
import 'widgets/consent_conformation_body.dart';

class ConsentConformationDialogue extends StatelessWidget {
  const ConsentConformationDialogue({
    super.key,
    this.consentStatusConstants,
    this.phone,
    this.isRemoveConsentDialogue = false,
    this.previouslySelectedConsent,
  });

  final String? consentStatusConstants;
  final PhoneModel? phone;
  final bool isRemoveConsentDialogue;
  final String? previouslySelectedConsent;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsentConformationDialogueController>(
      init: ConsentConformationDialogueController(
          consentStatusConstants: consentStatusConstants,
          phone: phone,
          isRemoveConsentDialogue: isRemoveConsentDialogue,
          previouslySelectedConsent: previouslySelectedConsent
      ),
      builder: (controller) => GestureDetector(
        onTap: Helper.hideKeyboard,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: JPAppTheme.themeColors.base,
                borderRadius: JPResponsiveDesign.bottomSheetRadius,
              ),
              child: JPSafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 4,
                      width: 30,
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          ConsentConformationBody(
                            controller: controller,
                            isCancelButtonDisable:  controller.isLoading,
                            isRemoveConsentDialogue: isRemoveConsentDialogue
                          ),

                          const SizedBox(height: 30,),
                          if(controller.isSkipVisible)...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    onPressed: controller.save,
                                    text: 'skip'.tr.toUpperCase(),
                                    disabled: controller.isSkipDisable || controller.isLoading,
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.lightGray,
                                    textColor: JPAppTheme.themeColors.tertiary,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  flex: JPResponsiveDesign.popOverButtonFlex,
                                  child: JPButton(
                                    onPressed: controller.save,
                                    text: 'save'.tr.toUpperCase(),
                                    disabled: controller.isSaveDisable || controller.isLoading,
                                    fontWeight: JPFontWeight.medium,
                                    size: JPButtonSize.small,
                                    colorType: JPButtonColorType.primary,
                                    textColor: JPAppTheme.themeColors.base,
                                  ),
                                )
                              ]
                            ),
                          } else...{
                            JPButton(
                              onPressed: controller.save,
                              text: controller.saveButtonText,
                              disabled: controller.isSaveDisable || controller.isLoading,
                              fontWeight: JPFontWeight.medium,
                              size: JPButtonSize.small,
                              colorType: JPButtonColorType.primary,
                              textColor: JPAppTheme.themeColors.base,
                            )
                          }
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}