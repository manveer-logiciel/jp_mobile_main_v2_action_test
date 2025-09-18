import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../controller.dart';

class AddItemTradeField extends StatelessWidget {
  const AddItemTradeField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: JPInputBox(
          inputBoxController: controller.service.tradeController,
          onPressed: controller.service.selectTrade,
          type: JPInputBoxType.withLabel,
          label: "trades".tr.capitalize,
          hintText: "select".tr,
          readOnly: true,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
          )
      ),
    );
  }
}
