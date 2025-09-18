import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [JobFormMultiSelect] is a common widget which can be used to render all the
/// multi select inputs of job form
class JobFormMultiSelect extends StatelessWidget {

  const JobFormMultiSelect({
    required this.field,
    this.isDisabled = false,
    required this.textController,
    required this.selectedItems,
    required this.controller,
    this.onTap,
    super.key,
  });

  FormUiHelper get uiHelper => FormUiHelper();

  /// [field] holds data of field coming from company settings
  final InputFieldParams field;

  /// [textController] holds controller for multi select selector
  final JPInputBoxController textController;

  /// [selectedItems] helps is displaying selected items
  final List<JPMultiSelectModel> selectedItems;

  /// [isDisabled] helps is disabling field
  final bool isDisabled;

  /// [onTap] handles tap on single select
  final VoidCallback? onTap;

  /// [controller] is used to sync widget state
  final JobFormController controller;

  @override
  Widget build(BuildContext context) {
    return JPChipsInputBox(
      key: Key(field.key),
      controller: controller,
      selectedItems: selectedItems,
      inputBoxController: textController,
      label: field.name,
      disabled: isDisabled,
      isRequired: field.isRequired,
      readOnly: true,
      onTap: onTap,
      validator: (val) {
        if(field.isRequired && selectedItems.isEmpty) {
          return FormValidator.requiredFieldValidator(val);
        }
        return null;
      },
      onDataChanged: field.onDataChange,
      suffixChild: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: uiHelper.horizontalPadding
        ),
        child: JPText(
          text: 'select'.tr.toUpperCase(),
          fontWeight: JPFontWeight.medium,
          textColor: JPAppTheme.themeColors.primary,
          textSize: JPTextSize.heading5,
        ),
      ),
    );
  }
}
