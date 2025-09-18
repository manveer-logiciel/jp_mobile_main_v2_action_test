import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/fields.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PlaceSrsOrderFormSection extends StatelessWidget {
  const PlaceSrsOrderFormSection({
    super.key,
    required this.section,
    required this.controller,
    this.isFirstSection = false,
  });

  /// [section] holds the details about section (name, fields etc.)
  final FormSectionModel section;

  final PlaceSupplierOrderFormController controller;

  /// [isFirstSection] decides whether rendered section is first section
  final bool isFirstSection;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  @override
  Widget build(BuildContext context) {
    if (!section.wrapInExpansion) {
      return PlaceSrsOrderFormFields(
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
        header: JPText(
          text: section.name.toUpperCase(),
          textSize: JPTextSize.heading4,
          fontWeight: JPFontWeight.medium,
          textColor: JPAppTheme.themeColors.darkGray,
          textAlign: TextAlign.start,
        ),
        trailing: (_) => JPIcon(Icons.expand_more, color: JPAppTheme.themeColors.secondaryText),
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
              return PlaceSrsOrderFormFields(
                controller: controller,
                field: field,
              );
            }).toList(),
          )
        ]);
  }

}
