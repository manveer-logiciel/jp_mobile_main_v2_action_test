import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../global_widgets/loader/index.dart';
import '../controller.dart';

class QuickMeasureOrderDialogueFooter extends StatelessWidget {
  const QuickMeasureOrderDialogueFooter({
    super.key,
    required this.controller,
    required this.onFinish
  });

  final QuickMeasureOrderVerificationDialogueController controller;
  final Function(bool) onFinish;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: JPButton(
                text: 'cancel'.tr.toUpperCase(),
                onPressed: () => Get.back(),
                fontWeight: JPFontWeight.medium,
                size: JPButtonSize.small,
                disabled: controller.isSavingForm,
                colorType: JPButtonColorType.lightGray,
                textColor: JPAppTheme.themeColors.tertiary,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: JPButton(
                onPressed: () => controller.saveForm(onFinish),
                text: controller.isSavingForm ? "" : 'save'.tr.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                size: JPButtonSize.small,
                colorType: JPButtonColorType.primary,
                textColor: JPAppTheme.themeColors.base,
                disabled: controller.isSaveDisable,
                iconWidget: showJPConfirmationLoader(show: controller.isSavingForm),
              ),
            )
          ]
      ),
    );
  }
}
