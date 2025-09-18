import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/custom_material_card/index.dart';
import '../controller.dart';

class AppsSettings extends StatelessWidget {
  const AppsSettings({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text: "enable_dark_theme".tr,
                      textSize: JPTextSize.heading4,
                      fontWeight: JPFontWeight.medium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: JPText(
                        text: "enable_dark_theme_description".tr,
                        textSize: JPTextSize.heading5,
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            JPToggle(
                value: controller.darkModeToggle,
                onToggle: (val) => controller.updateDarkModeToggle(val))
          ],
        ),
      ),
    );
  }
}
