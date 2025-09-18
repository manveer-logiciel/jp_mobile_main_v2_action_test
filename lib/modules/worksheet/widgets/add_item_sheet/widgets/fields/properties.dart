import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item_conditions.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemPropertiesField extends StatelessWidget {
  const WorksheetAddItemPropertiesField({
    super.key,
    required this.controller,
    this.onlyUnit = true,
  });

  final WorksheetAddItemController controller;
  final bool onlyUnit;

  WorksheetAddItemService get service => controller.service;
  WorksheetAddItemConditionsService get conditions => service.conditionsService;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (conditions.showVariants) ...{
          getSupplierProperties(),
          if(conditions.isConfirmedVariationRequired)
            Row(
              children: [
                JPCheckbox(
                  onTap: (_) => service.toggleConfirmedVariation(),
                  selected: service.isConfirmedVariation ?? false,
                  checkColor: JPAppTheme.themeColors.base,
                  color: JPAppTheme.themeColors.themeGreen,
                  borderColor: JPAppTheme.themeColors.themeGreen,
                  padding: EdgeInsets.zero,
                  separatorWidth: 0,
                  text: 'confirmed_variation'.tr,
                ),
                const SizedBox(width: 10),
                JPToolTip(
                  message: 'confirmed_variation_tooltip'.tr,
                  decoration: BoxDecoration(
                      color: JPAppTheme.themeColors.dimBlack,
                      borderRadius: BorderRadius.circular(8)
                  ),
                  preferBelow: true,
                  child:  JPIcon(Icons.info_outline_rounded,
                    size: 18,
                    color: JPAppTheme.themeColors.primary,
                  ),
                )
              ],
            )
        } else ...{
          getMaterialProperties(),
        },

        /// Unit
        Padding(
          key: const Key('unit'),
          padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
          child: JPInputBox(
            inputBoxController: service.unitController,
            label: 'unit'.tr,
            type: JPInputBoxType.withLabel,
            disabled: conditions.disableUnit,
            fillColor: JPAppTheme.themeColors.base,
            isRequired: conditions.hasMultipleUOM,
            readOnly: conditions.isUnitSingleSelect,
            onPressed: conditions.isUnitSingleSelect ? () => service.selectMaterialProp(WorksheetMaterialPropType.unit, 'select_unit'.tr) : null,
            suffixChild: getSuffixIcon(
              condition: conditions.isUnitSingleSelect,
              onTap: () => service.selectMaterialProp(WorksheetMaterialPropType.unit, 'select_unit'.tr),
            ),
            onChanged: (val) => controller.onDataChanged(val),
            validator: (val) => FormValidator.requiredFieldValidator(val, errorMsg: 'unit_is_required'.tr),
          ),
        ),
      ],
    );
  }

  Widget getMaterialProperties() {
    return Column(
      children: [
        /// Type & Style
        if (conditions.showTypeStyle)
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPInputBox(
              key: UniqueKey(),
              inputBoxController: service.typeStyleController,
              label: 'type_and_style'.tr,
              type: JPInputBoxType.withLabel,
              disabled: conditions.disableTypeStyle,
              fillColor: JPAppTheme.themeColors.base,
              suffixChild: getSuffixIcon(
                  condition: conditions.isStyleSingleSelect,
                  onTap: () => service.selectMaterialProp(WorksheetMaterialPropType.style, 'select_type_style'.tr)
              ),
            ),
          ),

        /// Size
        if (conditions.showSize)
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPInputBox(
              inputBoxController: service.sizeController,
              label: 'size'.tr,
              type: JPInputBoxType.withLabel,
              disabled: conditions.disableSize,
              fillColor: JPAppTheme.themeColors.base,
              suffixChild: getSuffixIcon(
                  condition: conditions.isSizeSingleSelect,
                  onTap: () => service.selectMaterialProp(WorksheetMaterialPropType.size, 'select_size'.tr)
              ),
            ),
          ),

        /// Color
        if (conditions.showColor)
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPInputBox(
              key: UniqueKey(),
              inputBoxController: service.colorController,
              label: 'color'.tr,
              readOnly: true,
              type: JPInputBoxType.withLabel,
              disabled: conditions.isColorDisabled && !conditions.isColorRequired,
              fillColor: JPAppTheme.themeColors.base,
              isRequired: conditions.isColorRequired,
              suffixChild: getSuffixIcon(
                condition: conditions.isColorSingleSelect,
                onTap: () => service.selectMaterialProp(WorksheetMaterialPropType.color, 'select_color'.tr),
              ),
              validator: (val) {
                if (!conditions.isColorRequired) return null;
                return FormValidator.requiredFieldValidator(val);
              },
              onPressed: () => service.selectMaterialProp(WorksheetMaterialPropType.color, 'select_color'.tr),
            ),
          ),
      ],
    );
  }

  Widget getSupplierProperties() {
    return Column(
      children: [
          Padding(
            padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
            child: JPInputBox(
              key: UniqueKey(),
              inputBoxController: service.variantController,
              label: 'variation'.tr,
              readOnly: true,
              type: JPInputBoxType.withLabel,
              fillColor: JPAppTheme.themeColors.base,
              isRequired: conditions.isVariantsSingleSelect,
              suffixChild: getSuffixIcon(
                condition: conditions.isVariantsSingleSelect,
                onTap: () => service.selectMaterialProp(WorksheetMaterialPropType.variant, 'select_variation'.tr),
              ),
              validator: (val) {
                return FormValidator.requiredFieldValidator(val);
              },
              onPressed: () => service.selectMaterialProp(WorksheetMaterialPropType.variant, 'select_variation'.tr),
            ),
          ),

      ],
    );
  }

  /// [getSuffixIcon] returns the suffix icon if property field has options
  /// to select from
  Widget? getSuffixIcon({
    required bool condition,
    VoidCallback? onTap
  }) {

    if (!condition) return null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.keyboard_arrow_down, color: JPAppTheme.themeColors.text,),
      ),
    );
  }
}
