import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class StateField extends StatelessWidget {
  const StateField({super.key, required this.controller, required this.data, required this.isDisabled, required this.isRequired});

  final AddressFormController controller;
  final AddressFormData data;
  final bool isDisabled;
  final bool isRequired;


  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      key: const Key(WidgetKeys.stateKey),
      inputBoxController: data.stateController,
      type: JPInputBoxType.withLabel,
      label: 'state'.tr,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      isRequired: isRequired,
      readOnly: true,
      validator: (value) => isRequired ? data.validateState() : null,
      onPressed: () {
        if (data.doShowStateSelect) {
          controller.selectState(data: data);
        }
        return;
      },
      suffixChild: data.doShowStateSelect ? Padding(
        padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
        child: JPIcon(
          Icons.keyboard_arrow_down_outlined,
          color: JPAppTheme.themeColors.text,
        ),
      ) : null,
    );
  }
}