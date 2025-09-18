import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../controller.dart';

class WorksheetAddItemDescriptionField extends StatelessWidget {
  const WorksheetAddItemDescriptionField({
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
        inputBoxController: service.descriptionController,
        label: 'description'.tr,
        disabled: service.conditionsService.disableDescription,
        type: JPInputBoxType.withLabel,
        fillColor: JPAppTheme.themeColors.base,
        maxLines: 6,
      ),
    );
  }
}
