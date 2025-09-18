import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/type.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class CountryField extends StatelessWidget {
  const CountryField({super.key, required this.controller, required this.data, required this.isDisabled, required this.isRequired});

  final AddressFormController controller;
  final AddressFormData data;
  final bool isDisabled;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return JPInputBox(
      key: const Key(WidgetKeys.countryKey),
      inputBoxController: data.countryController,
      type: JPInputBoxType.withLabel,
      label: 'country'.tr,
      fillColor: JPAppTheme.themeColors.base,
      disabled: isDisabled,
      readOnly: true,
      isRequired: isRequired,
      onPressed: () {
        if (data.doShowCountrySelect) {
          return controller.selectCountry(data: data);
        }
        return;
      },
      suffixChild: data.doShowCountrySelect ? Padding(
        padding: EdgeInsets.symmetric(horizontal: controller.formUiHelper.horizontalPadding),
        child: JPIcon(
          Icons.keyboard_arrow_down_outlined,
          color: JPAppTheme.themeColors.text,
        ),
      ) : null,
    );
  }
}