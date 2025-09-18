
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_toggles.dart';
import '../../../../../../common/services/forms/value_selector.dart';

class TaskLockJobSection extends StatelessWidget {
  const TaskLockJobSection({
    super.key,
    required this.controller
  });

  final CreateTaskFormController controller;

  CreateTaskFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            JPText(
              text: 'stage'.tr,
              fontWeight: JPFontWeight.regular,
              textSize: JPTextSize.heading4,
              textColor: JPAppTheme.themeColors.text,
            ),
            JPButton(
              disabled: !service.isFieldEditable(FormToggles.stageLock),
              colorType: JPButtonColorType.lightGray,
              size: JPButtonSize.datePickerButton,
              text: service.selectedStage?.label ?? "",
              suffixIconWidget: JPIcon(
                Icons.expand_more,
                color: JPAppTheme.themeColors.secondaryText,
                size: 14,
              ),
              onPressed: () {
                FormValueSelectorService.openSingleSelect(
                  list: service.stageList,
                  controller: service.stageSelectionController,
                  selectedItemId: service.selectedStage?.id ?? "",
                  onValueSelected: service.selectStage,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
