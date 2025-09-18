import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemTypeField extends StatelessWidget {

  const WorksheetAddItemTypeField({
    super.key,
    required this.controller
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: JPInputBox(
          inputBoxController: service.typeController,
          onPressed: service.selectType,
          type: JPInputBoxType.withLabel,
          label: "type".tr.capitalize,
          hintText: "select".tr,
          readOnly: true,
          isRequired: true,
          disabled: service.conditionsService.disableCategory,
          fillColor: JPAppTheme.themeColors.base,
          suffixChild: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_down,
              color: JPAppTheme.themeColors.text,
            ),
          ),
          onChanged: (val) => controller.onDataChanged(val),
          validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: 'type_is_required'.tr),
      ),
    );
  }
}
