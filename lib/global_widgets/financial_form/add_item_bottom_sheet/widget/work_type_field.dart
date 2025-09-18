import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class AddItemWorkTypeField extends StatelessWidget {
  const AddItemWorkTypeField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.service.workTypeList.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
        child: JPInputBox(
            inputBoxController: controller.service.workTypeController,
            onPressed: controller.service.selectWorkType,
            type: JPInputBoxType.withLabel,
            label: "work_type".tr.capitalize,
            hintText: "select".tr,
            readOnly: true,
            fillColor: JPAppTheme.themeColors.base,
            suffixChild: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
            )
        ),
      ),
    );
  }
}
