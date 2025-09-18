
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/options.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/chips_input_box/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomFieldDropdown extends StatelessWidget {

  const CustomFieldDropdown({
    super.key,
    required this.field,
    required this.onDataChange,
    required this.controller,
    this.isDisabled = false,
  });

  final CustomFieldFormController controller;

  /// [field] contains the list of field to be displayed
  final CustomFormFieldsModel field;

  /// [isDisabled] helps in disabling fields
  final bool isDisabled;

  /// [onDataChange] used to listen changes on the go
  final Function(String)? onDataChange;

  Widget get inputFieldSeparator => SizedBox(
    height: controller.uiHelper.verticalPadding,
    width: controller.uiHelper.horizontalPadding,
  );

  @override
  Widget build(BuildContext context) {

    if (field.options!.length == 1) {
      return selectionField(field.options!.first);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: JPAppTheme.themeColors.dimGray,
          width: 1
        )
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ///   Group Name
          JPText(
            text: (field.name ?? 'group'.tr).toUpperCase(),
            textSize: JPTextSize.heading5,
            fontWeight: JPFontWeight.medium,
            textColor: JPAppTheme.themeColors.darkGray,
          ),

          if(field.options != null) ...{

            const SizedBox(
              height: 10,
            ),

            ///   Fields
            ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (_, index) {
                final option = field.options![index];
                return selectionField(option, index: index);
              },
              separatorBuilder: (_, index) {
                return inputFieldSeparator;
              },
              itemCount: field.dropDownOptionsLength,
            ),

            const SizedBox(
              height: 5,
            ),
          }
        ],
      ),
    );
  }

  Widget selectionField(CustomFormFieldOption option, {int index = 0}) {
    return JPChipsInputBox<CustomFieldFormController>(
      key: Key('${WidgetKeys.customFieldDropdown}_${option.id}_$index'),
      inputBoxController: option.controller,
      label: option.name?.capitalize ?? "option".tr.capitalizeFirst,
      isRequired: field.isRequired! && index == 0,
      controller: controller,
      selectedItems: option.selectedItems,
      onTap: () => controller.selectSubOptions(field, option, index),
      disabled: isDisabled || !field.active,
      validator: (val) {
        if(field.isRequired! && index == 0) {
          return FormValidator.requiredDropDownValidator(option.selectedItems);
        }
        return null;
      },
      onRemove: (val) => controller.onAllItemsRemoved(field, index),
      disableEditing: isDisabled || !field.active,
      onDataChanged: onDataChange,
      suffixChild: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16
        ),
        child: JPText(
          text: 'select'.tr.toUpperCase(),
          fontWeight: JPFontWeight.medium,
          textColor: JPAppTheme.themeColors.primary,
          textSize: JPTextSize.heading5,
        ),
      ),
    );
  }

}
