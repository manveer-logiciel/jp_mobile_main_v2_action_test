
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomFieldUserDropdown extends StatelessWidget {

  const CustomFieldUserDropdown({
    super.key,
    required this.field,
    required this.onDataChange,
    required this.controller,
    required this.userlist,
    this.isDisabled = false, 
  });

  final CustomFieldFormController controller;

  /// [field] contains the list of field to be displayed
  final CustomFormFieldsModel field;

  /// [isDisabled] helps in disabling fields
  final bool isDisabled;

  /// [onDataChange] used to listen changes on the go
  final Function(String)? onDataChange;

  /// [userlist] contains the list of users
  final List<JPMultiSelectModel> userlist ;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.uiHelper.verticalPadding,
    width: controller.uiHelper.horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {
    List<JPMultiSelectModel> selectedUsers = FormValueSelectorService.getSelectedMultiSelectValues(field.usersList ?? []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPChipsInputBox(
          controller: controller,
          selectedItems: selectedUsers,
          inputBoxController: field.controller,
          label: field.name,
          disabled: isDisabled || !field.active,
          disableEditing: isDisabled || !field.active,
          isRequired: field.isRequired,
          readOnly: true,
          onRemove:(val) => controller.onRemoveUser(field),
          onTap:()=> controller.selectUsers(field.usersList ?? [], field.controller),
          validator: (val) {
          if(field.isRequired ?? false) {
            return FormValidator.requiredFieldValidator(field.controller.text);
          }
            return null;
          },
          onDataChanged: onDataChange,
          suffixChild: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: controller.uiHelper.horizontalPadding
            ),
            child: JPText(
              text: 'select'.tr.toUpperCase(),
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
            ),
          ),
        ),
      ],
    );
  }
}
