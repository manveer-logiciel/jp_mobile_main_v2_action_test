import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class ProjectFormMultiSelect extends StatelessWidget {
  const ProjectFormMultiSelect({
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
  final ProjectFormController controller;

  @override
  Widget build(BuildContext context) {
    return JPChipsInputBox(
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