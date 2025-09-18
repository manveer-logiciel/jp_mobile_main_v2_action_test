import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class CityField extends StatelessWidget {
  const CityField({
    super.key, 
    required this.controller, 
    required this.data, 
    required this.isDisabled, 
    required this.isRequired
  });

  final AddressFormController controller;
  final AddressFormData data;
  final bool isDisabled;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      key: const Key(WidgetKeys.cityKey),
      inputBoxController: data.cityController,
      type: JPInputBoxType.withLabel,
      label: 'city'.tr.capitalizeFirst,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      isRequired: isRequired,
      validator:(val) => isRequired ? data.validateCity() : null,
      onChanged: (val) {
        controller.onValueChanged(data);
      },
    );
  }
}