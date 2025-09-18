import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementFormSubAttributeView extends StatelessWidget {
  const MeasurementFormSubAttributeView({
    super.key, 
    this.subAttributes, 
    required this.attributeName, 
    required this.isSavingForm, 
    this.isBottomSheet = false, 
    this.controllerList, 
    required this.isDisable, 
    required this.valuesAttribute, 
    required this.isEdit,
    required this.isViewOnly, 
    this.validateInputBox, 
    this.validateForm,
  });

  
  final List<MeasurementAttributeModel>? subAttributes;
  final MeasurementAttributeModel valuesAttribute;
  final bool isEdit;
  final String attributeName;
  final bool isSavingForm;
  final bool isBottomSheet; 
  final bool isDisable;
  final bool isViewOnly;
  final String? Function(dynamic)? validateInputBox;
  final Function(String)? validateForm;

  final Map<String,JPInputBoxController>? controllerList;
  Widget get inputFieldSeparator => SizedBox(
    height: JPAppTheme.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: JPAppTheme.formUiHelper.suffixPadding, 
          vertical: JPAppTheme.formUiHelper.suffixPadding,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: JPAppTheme.themeColors.dimGray,
            width: 1
          ),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JPText(
              text: attributeName,
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
            if(!isBottomSheet)
            inputFieldSeparator,
            Wrap(
              spacing: 20,
              children: [
                for(int i = 0; i <  subAttributes!.length; i++)
                SizedBox(
                  width: (JPScreen.width / 2) - 40,
                  child:
                  JPInputBox(
                    inputBoxController: controllerList?['${subAttributes?[i].id}'] ?? JPInputBoxController(),
                    label: subAttributes![i].name,
                    validator: validateInputBox,
                    onChanged: validateForm,
                    hintText: '0.0',
                    maxLength: 9,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(RegexExpression.amount)),],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    type: JPInputBoxType.withLabel,
                    fillColor: JPAppTheme.themeColors.base,
                    disabled: isDisable,
                    showCursor: !isDisable,
                    readOnly: isViewOnly,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
