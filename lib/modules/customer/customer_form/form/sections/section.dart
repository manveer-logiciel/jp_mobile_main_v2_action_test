import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jobprogress/modules/customer/customer_form/form/fields/index.dart';
import 'package:jobprogress/modules/customer/customer_form/form/sections/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'flags.dart';

class CustomerFormSection extends StatelessWidget {
  const CustomerFormSection({
    super.key,
    required this.section,
    required this.controller,
    this.isFirstSection = false,
  });

  /// [section] holds the details about section (name, fields etc.)
  final FormSectionModel section;

  final CustomerFormController controller;

  /// [isFirstSection] decides whether rendered section is first section
  final bool isFirstSection;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  @override
  Widget build(BuildContext context) {
    if (!section.wrapInExpansion) {
      return CustomerFormFields(
        controller: controller,
        field: section.fields.first,
        avoidBottomPadding: true,
      );
    }

    return JPExpansionTile(
        enableHeaderClick: true,
        preserveWidgetOnCollapsed: true,
        initialCollapsed: section.initialCollapsed,
        borderRadius: controller.formUiHelper.sectionBorderRadius,
        isExpanded: section.isExpanded,
        headerPadding: EdgeInsets.symmetric(
          horizontal: controller.formUiHelper.horizontalPadding,
          vertical: controller.formUiHelper.verticalPadding,
        ),
        header: Row(
          children: [
            ///   Section name
            Expanded(
              child: JPText(
                text: section.name.toUpperCase(),
                textSize: JPTextSize.heading4,
                fontWeight: JPFontWeight.medium,
                textColor: JPAppTheme.themeColors.darkGray,
                textAlign: TextAlign.start,
              ),
            ),

            ///   Flags selection
            if (isFirstSection) ...{
              Material(
                borderRadius: BorderRadius.circular(8),
                color: JPAppTheme.themeColors.lightBlue,
                child: JPTextButton(
                  key: const Key(WidgetKeys.customerFormFlagButtonKey),
                  icon: Icons.flag,
                  color: JPAppTheme.themeColors.primary,
                  isDisabled: controller.isSavingForm,
                  iconSize: 18,
                  onPressed: controller.service.selectFlags,
                ),
              ),

              const SizedBox(
                width: 8,
              ),
            },
          ],
        ),
        trailing: (_) => JPIcon(Icons.expand_more,
              color: JPAppTheme.themeColors.secondaryText,
            ),
        contentPadding: EdgeInsets.only(
          left: controller.formUiHelper.horizontalPadding,
          right: controller.formUiHelper.horizontalPadding,
          bottom: controller.formUiHelper.verticalPadding / 2,
        ),
        onExpansionChanged: (val) => controller.onSectionExpansionChanged(section, val),
        children: [
          /// Displaying flags & form type isn first section only
          if (isFirstSection) ... {
            CustomerFormTypeSection(controller: controller),
            CustomerFlagsSection(controller: controller),
          },

          /// Fields associated with section
          Column(
            children: section.fields.map((field) {
              return CustomerFormFields(
                controller: controller,
                field: field,
              );
            }).toList(),
          )
        ]);
  }
}
