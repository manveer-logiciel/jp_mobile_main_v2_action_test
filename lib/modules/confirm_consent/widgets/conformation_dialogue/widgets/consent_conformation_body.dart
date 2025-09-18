import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/modules/confirm_consent/widgets/conformation_dialogue/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ConsentConformationBody extends StatelessWidget {
  const ConsentConformationBody({
    super.key,
    required this.controller,
    this.isCancelButtonDisable = false,
    this.isRemoveConsentDialogue = false,
  });

  final ConsentConformationDialogueController controller;
  final bool isCancelButtonDisable;
  final bool isRemoveConsentDialogue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: 20,),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JPText(
                  text: controller.title,
                  textSize: JPTextSize.heading3,
                  fontWeight: JPFontWeight.medium,
                ),
                JPTextButton(
                  isDisabled: isCancelButtonDisable,
                  onPressed: () => Get.back(),
                  color: JPAppTheme.themeColors.text,
                  icon: Icons.clear,
                  iconSize: 24,
                )
              ]
          ),
        ),
        JPText(
          text: controller.description,
          textSize: JPTextSize.heading4,
          height: 1.25,
          textColor: JPAppTheme.themeColors.text,
          textAlign: TextAlign.start,
        ),
        if(!Helper.isTrue(controller.isRemoveConsentDialogue))... {
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Column(
              children: [
                JPBulletList(
                    isBulletedList: true,
                    textSize: JPTextSize.heading4,
                    textHeight: 1.5,
                    textColor: JPAppTheme.themeColors.text,
                    textAlign: TextAlign.start,
                    spaceBetweenTextAndBullet: 10,
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    stringList: [
                      "express_consent_conformation_message_statement_1".tr,
                      "express_consent_conformation_message_statement_2".tr,
                      "express_consent_conformation_message_statement_3".tr
                    ]
                ),
              ],
            ),
          ),
        },

        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: JPCheckbox(
            selected: controller.isExpressConsentCheckBoxSelected,
            onTap: controller.onExpressConsentCheckBoxToggle,
            padding: EdgeInsets.zero,
            borderColor: JPAppTheme.themeColors.themeGreen,
            text: controller.checkBoxText,
            textColor: JPAppTheme.themeColors.text,
            textSize: JPTextSize.heading4,
            fontWeight: JPFontWeight.medium,
            separatorWidth: 4,
          ),
        )
      ],
    );
  }
}
