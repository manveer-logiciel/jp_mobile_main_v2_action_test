import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class AddItemTaxableToggleField extends StatelessWidget {
  const AddItemTaxableToggleField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JPText(text: 'taxable'.tr,
              fontWeight: JPFontWeight.regular,
              textSize: JPTextSize.heading4
          ),
          Flexible(
            child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: JPToggle(
                  value: controller.service.isTaxable,
                  onToggle: controller.service.toggleIsTaxable,
                )
            ),
          )
        ],),
    );
  }
}
