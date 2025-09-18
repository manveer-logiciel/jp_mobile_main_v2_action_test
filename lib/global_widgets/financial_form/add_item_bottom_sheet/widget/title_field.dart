import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/utils/form/validators.dart';
import '../controller.dart';

class AddItemTitleField extends StatelessWidget {
  const AddItemTitleField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: JPInputBox(
        inputBoxController: controller.service.activityController,
        label: controller.pageType == AddLineItemFormType.insuranceForm ? 'description'.tr : 'activity'.tr,
        type: JPInputBoxType.withLabel,
        fillColor: JPAppTheme.themeColors.base,
        isRequired: true,
        readOnly: true,
        maxLines: 6,
        onPressed: controller.selectActivity,
        onChanged: controller.onItemDataChanged,
        validator: (val) => FormValidator.requiredFieldValidator(val.trim()),
      ),
    );
  }
}
