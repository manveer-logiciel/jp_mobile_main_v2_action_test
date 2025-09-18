import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemSupplierField extends StatelessWidget {
  const WorksheetAddItemSupplierField({
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
        inputBoxController: service.supplierController,
        label: 'supplier'.tr,
        hintText: 'select'.tr,
        type: JPInputBoxType.withLabel,
        fillColor: JPAppTheme.themeColors.base,
        readOnly: true,
        onPressed: service.selectSupplier,
        disabled: service.conditionsService.disableSupplier,
        suffixChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
        ),
      ),
    );
  }
}
