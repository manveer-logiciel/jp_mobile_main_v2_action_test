import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class EagleViewOrderDialogueHeader extends StatelessWidget {
  const EagleViewOrderDialogueHeader({
    super.key,
    required this.controller
  });

  final EagleViewOrderVerificationDialogueController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              JPText(
                text: "verify_order_details".tr.toUpperCase(),
                textSize: JPTextSize.heading3,
                fontWeight: JPFontWeight.medium,
              ),
              JPTextButton(
                onPressed: () => Get.back(),
                color: JPAppTheme.themeColors.text,
                icon: Icons.clear,
                iconSize: 24,
                isDisabled: controller.isSavingForm,
              )
            ]
        ),
      );
  }
}
