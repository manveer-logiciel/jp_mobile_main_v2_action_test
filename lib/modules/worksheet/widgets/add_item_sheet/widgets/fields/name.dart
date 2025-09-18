import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemNameField extends StatelessWidget {
  const WorksheetAddItemNameField({
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
        inputBoxController: service.nameController,
        label: 'name'.tr,
        type: JPInputBoxType.withLabel,
        fillColor: JPAppTheme.themeColors.base,
        readOnly: true,
        isRequired: true,
        disabled: service.conditionsService.disableNameField,
        onPressed: service.selectProduct,
        onChanged: (val) => controller.onDataChanged(val),
        validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: 'name_is_required'.tr),
      ),
    );
  }
}
