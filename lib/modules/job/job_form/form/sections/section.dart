import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormSection extends StatelessWidget {
  const JobFormSection({
    super.key,
    required this.section,
    required this.controller,
    this.isFirstSection = false,
  });

  /// [section] holds the details about section (name, fields etc.)
  final FormSectionModel section;

  final JobFormController controller;

  /// [isFirstSection] decides whether rendered section is first section
  final bool isFirstSection;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  bool get doShowAddIcon => section.fields.isNotEmpty
      && section.fields.first.key == JobFormConstants.contactPerson
      && !controller.service.isContactPersonSameAsCustomer;

  @override
  Widget build(BuildContext context) {
    if (!section.wrapInExpansion) {
      return JobFormFields(
        controller: controller,
        field: section.fields.first,
        avoidBottomPadding: true,
      );
    }

    return JPExpansionTile(
        key: const Key(WidgetKeys.jobFormSectionsKey),
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
                  icon: Icons.flag,
                  color: JPAppTheme.themeColors.primary,
                  isDisabled: controller.isSavingForm,
                  iconSize: 18,
                  onPressed: controller.service.selectFlags,
                ),
              ),
            },

            /// Displaying add icon on contact person section
            if (doShowAddIcon) ...{
              JPAddRemoveButton(
                key: const Key(WidgetKeys.addJobContactPersonKey),
                isDisabled: controller.isSavingForm,
                iconSize: 14,
                onTap: controller.service.onAddEditContactPerson,
              )
            },

            const SizedBox(
              width: 8,
            ),
          ],
        ),
        trailing: (_) => JPIcon(Icons.expand_more,
              color: JPAppTheme.themeColors.secondaryText,
            ),
        contentPadding: section.avoidContentPadding ? null : EdgeInsets.only(
          left: controller.formUiHelper.horizontalPadding,
          right: controller.formUiHelper.horizontalPadding,
          bottom: controller.formUiHelper.verticalPadding / 2,
        ),
        onExpansionChanged: (val) => controller.onSectionExpansionChanged(section, val),
        children: [
          /// Fields associated with section
          Column(
            children: section.fields.map((field) {
              
              return JobFormFields(
                controller: controller,
                field: field,
                avoidBottomPadding: avoidBottomPadding(field.key),
              );
            }).toList(),
          )
        ]);
  }

  bool avoidBottomPadding(String key) {

    bool isFlagsField = key == JobFormConstants.flags
        && controller.service.selectedFlags.isEmpty;

    bool isJobDescription = key == JobFormConstants.jobDescription;

    return isFlagsField || isJobDescription;
  }
}
