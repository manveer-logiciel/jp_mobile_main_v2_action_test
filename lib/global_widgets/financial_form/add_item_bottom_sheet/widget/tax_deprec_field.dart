import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';

class AddItemTaxDepreciationField extends StatelessWidget {
  const AddItemTaxDepreciationField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: JPInputBox(
              inputBoxController: controller.service.taxController,
              label: 'tax'.tr,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: controller.onItemDataChanged,
              maxLength: 9,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: JPInputBox(
              inputBoxController: controller.service.depreciationController,
              label: 'depreciation'.tr.capitalize,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              keyboardType: TextInputType.number,
              maxLength: 9,
              inputFormatters:  [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount))],
              onChanged: controller.onItemDataChanged,
            ),
          ),
        ],
      )
    );
  }
}