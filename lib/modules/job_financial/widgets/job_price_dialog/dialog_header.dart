import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'controller.dart';

class JobPriceDialogHeader extends StatelessWidget {
  const JobPriceDialogHeader({
    super.key,
    required this.controller});

  final JobPriceDialogController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            JPText(
              text: controller.jobModel?.parentId != null ? "project_price".tr.toUpperCase() : "job_price".tr.toUpperCase(),
              textSize: JPTextSize.heading3,
              fontWeight: JPFontWeight.medium,
            ),
            Container(
              transform: Matrix4.translationValues(8, 0, 0),
              child: JPTextButton(
                isDisabled: controller.isLoading,
                onPressed: Get.back<void>,
                color: JPAppTheme.themeColors.text,
                icon: Icons.clear,
                iconSize: 24,
              ),
            )
          ]),
    );
  }
}
