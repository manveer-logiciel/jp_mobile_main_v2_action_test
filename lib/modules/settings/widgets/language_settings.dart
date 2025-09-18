import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/custom_material_card/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../controller.dart';

class LanguageSettings extends StatelessWidget {
  const LanguageSettings({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                JPText(
                  text: "language".tr,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                ),
                controller.isLanguageUpdating
                    ? showLoader()
                    : JPTextButton(
                  text: controller.selectedLanguage?.label ?? "use_device_language".tr,
                  isExpanded: false,
                  textSize: JPTextSize.heading5,
                  fontWeight: JPFontWeight.medium,
                  color: JPAppTheme.themeColors.primary,
                  padding: 4,
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () => controller.showLanguagePicker(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: JPText(
                text: 'language_description'.tr,
                textSize: JPTextSize.heading5,
                textColor: JPAppTheme.themeColors.tertiary,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showLoader() => Container(
      height: 22,
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.dimGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: showJPConfirmationLoader(show: true) ?? const SizedBox.shrink());
}
