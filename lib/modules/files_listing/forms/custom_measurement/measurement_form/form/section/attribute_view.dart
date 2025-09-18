import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/measurement/measurement_attribute.dart';

class MeasurementFormAttributeView extends StatelessWidget {
  const MeasurementFormAttributeView({
    super.key, 
     required this.measurement, 
     required this.isSavingForm, 
     this.isBottomSheet = false, 
     this.controllerList, 
     required this.isEdit,
     required this.isViewOnly,  
     this.validateInputBox, 
     this.validateForm,
     required this.index,
     this.isHoverWasteFactorSuggestionApplied = false,
     this.isHoverWasteFactorExist = false,
     this.isSystemEdit = false,
     this.onTapSuggestWasteFactor,
     this.onTapAttributeEdit
  });

  final MeasurementDataModel measurement;
  final bool isSavingForm;
  final bool isEdit;
  final bool isBottomSheet;
  final bool isViewOnly;
  final int index;
  final String? Function(dynamic)? validateInputBox;
  final Function(String)? validateForm;
  final Map<String,JPInputBoxController>? controllerList;
  final bool isHoverWasteFactorSuggestionApplied;
  final bool isHoverWasteFactorExist;
  final bool isSystemEdit;
  final VoidCallback? onTapSuggestWasteFactor;
  final Function(MeasurementAttributeModel)? onTapAttributeEdit;

  Widget get inputFieldSeparator => SizedBox(
    height: JPAppTheme.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (JPScreen.width / 2) - 30,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            JPInputBox(
              key: ValueKey('${WidgetKeys.attributeInputBoxKey}[$index]'),
              inputBoxController: controllerList?['${measurement.attributes?[index].id}'] ?? JPInputBoxController(),
              label: measurement.attributes![index].unit != null ?
                '${measurement.attributes![index].name} (${
                  measurement.attributes![index].unit!.name
                })' :
              measurement.attributes![index].name,
              hintText: MeasurementHelper.getAttributeHintText(measurement: measurement, index: index),
              maxLength: 9,
              inputFormatters: MeasurementHelper.getAttributeInputFormatters(measurement: measurement, index: index),
              keyboardType: MeasurementHelper.getAttributeKeyBoardType(measurement: measurement, index: index),
              type: JPInputBoxType.withLabel,
              onChanged: validateForm,
              validator: validateInputBox,
              fillColor: JPAppTheme.themeColors.base,
              disabled: isSavingForm || measurement.isDisable && !isBottomSheet,
              readOnly: isViewOnly,
              suffixChild: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(isHoverWasteFactorSuggestionApplied)
                     JPToolTip(
                      message: 'recommended_waste_factor_from_hover'.tr,
                      decoration: BoxDecoration(
                          color: JPAppTheme.themeColors.dimBlack,
                          borderRadius: BorderRadius.circular(8)
                      ),
                      preferBelow: true,
                      child:  Padding(
                        padding:  const EdgeInsets.all(3.0),
                        child: JPIcon(Icons.info_outline_rounded,
                            size: 18,
                          color: JPAppTheme.themeColors.primary,
                        ),
                      ),
                    ),
                  if(isSystemEdit)
                    Padding(
                      padding:  const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () => onTapAttributeEdit?.call(measurement.attributes![index]),
                        child: JPIcon(Icons.edit_outlined,
                          size: 18,
                          color: JPAppTheme.themeColors.primary,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if(isHoverWasteFactorExist)
              Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.topRight,
                child: JPButton(
                  text: 'suggest'.tr.toUpperCase(),
                  onPressed: onTapSuggestWasteFactor,
                  type: JPButtonType.outline,
                  size: JPButtonSize.extraSmall,
                ),
              )
          ],
        ),
      ),
    );
  }
}
