
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomFieldTextInput extends StatelessWidget {

  const CustomFieldTextInput({
    super.key,
    required this.field,
    this.onDataChange,
    this.isDisabled = false,
  });

  /// [field] contains the list of field to be displayed
  final CustomFormFieldsModel field;

  /// [isDisabled] helps in disabling fields
  final bool isDisabled;

  /// [onDataChange] used to listen changes on the go
  final Function(String)? onDataChange;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: field.controller,
      type: JPInputBoxType.withLabel,
      label: field.name,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled || !field.active,
      isRequired: field.isRequired,
      maxLength: 250,
      validator: (val) {
        if(field.isRequired ?? false) {
          return FormValidator.requiredFieldValidator(val);
        }
        return null;
      },
      onChanged: onDataChange,
    );
  }

}
