
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// [CustomerFormTextInput] is a common widget which can be used to render all the
/// text inputs in customer form
class CustomerFormTextInput extends StatelessWidget {

  const CustomerFormTextInput({
    super.key,
    required this.field,
    required this.textController,
    this.isDisabled = false,
    this.isMultiline = false
  });

  /// [field] holds data of field coming from company settings
  final InputFieldParams field;

  /// [textController] used to assign controller to field
  final JPInputBoxController textController;

  /// [isDisabled] helps is disabling field
  final bool isDisabled;

  /// [isMultiline] decides whether field s multiline or not
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      inputBoxController: textController,
      type: JPInputBoxType.withLabel,
      label: field.name,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      maxLines: isMultiline ? 4 : 1,
      isRequired: field.isRequired,
      validator: (val) {
        if(field.isRequired) {
          final message = field.name.capitalizeFirst! + " " + "is_required".tr;
          return FormValidator.requiredFieldValidator(val, errorMsg: message);
        }
        return null;
      },
      onChanged: field.onDataChange,
    );
  }

}
