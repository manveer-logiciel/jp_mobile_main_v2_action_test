import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../../core/constants/regex_expression.dart';

class ZipField extends StatelessWidget {
  const ZipField({
    super.key, 
    required this.controller, 
    required this.data,
    required this.isRequired, 
    required this.isDisabled});

  final AddressFormController controller;
  final AddressFormData data;
  final bool isDisabled;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      key: const Key(WidgetKeys.zipKey),
      inputBoxController: data.zipController,
      type: JPInputBoxType.withLabel,
      label: 'zip'.tr,
      maxLength: 20,
      keyboardType: TextInputType.text,
      fillColor: JPAppTheme.themeColors.base,
      isRequired: isRequired,
      disabled: isDisabled,
      validator: (value) => isRequired ? data.validateZip() : null,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(RegexExpression.alphaNumeric)),
      ],
      onChanged: (val) {
        controller.onValueChanged(data);
      },
    );
  }
}