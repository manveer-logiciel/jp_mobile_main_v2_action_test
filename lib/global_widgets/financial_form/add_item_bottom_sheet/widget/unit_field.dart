import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class AddItemUnitField extends StatelessWidget {
  const AddItemUnitField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: controller.formUiHelper.inputVerticalSeparator
      ),
      child: JPInputBox(
        inputBoxController: controller.service.unitController,
        type: JPInputBoxType.withLabel,
        isRequired: true,
        label: "unit".tr.capitalize,
        fillColor: JPAppTheme.themeColors.base,
        validator: FormValidator.validateUnit,
        onChanged: controller.onItemDataChanged,
      ),
    );
  }
}

