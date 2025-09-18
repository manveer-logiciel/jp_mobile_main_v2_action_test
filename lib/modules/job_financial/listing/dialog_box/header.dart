import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class PayCommissionDialogHeader extends StatelessWidget {
  final PayCommissionDialogController controller;
  const PayCommissionDialogHeader({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JPText(
          text: '${"pay".tr.toUpperCase()} ${'commission'.tr.toUpperCase()}',
          textSize: JPTextSize.heading3,
          fontWeight: JPFontWeight.medium,
          ),
          Container(
            transform: Matrix4.translationValues(8, 0, 0),
            child: JPTextButton(
              isDisabled: controller.isLoading,
              onPressed: () => Get.back(),
              color: JPAppTheme.themeColors.text,
              icon: Icons.clear,
              iconSize: 24,
            ),
          )
        ]
      ),
    );
  }
}
