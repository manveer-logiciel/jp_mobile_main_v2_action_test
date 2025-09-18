import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:jobprogress/core/constants/worksheet.dart';

/// A widget that allows users to toggle default settings for different types of worksheets.
///
/// This widget displays a checkbox with a title and description that changes based on the
/// worksheet type. It's commonly used at the top of worksheet forms to let users opt-in
/// to using predefined default settings.
class WorksheetDefaultSettingSelector extends StatelessWidget {
  const WorksheetDefaultSettingSelector({
    required this.onToggle,
    this.isSelected = false,
    this.worksheetType,
    super.key
  });

  /// Whether the default settings are currently selected
  final bool isSelected;

  /// Callback function called when the checkbox is toggled
  final Function(bool) onToggle;

  /// The type of worksheet this selector is being used for.
  /// This affects the displayed title and description.
  final String? worksheetType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: JPAppTheme.themeColors.lightestGray.withValues(
          alpha: 0.5
        ),
      ),
      child: InkWell(
        onTap: () => onToggle(isSelected),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 14
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(2, -7),
                child: JPCheckbox(
                  selected: isSelected,
                  onTap: onToggle,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    JPText(
                      text: getTitle(),
                      textSize: JPTextSize.heading5,
                      fontWeight: JPFontWeight.medium,
                      textColor: JPAppTheme.themeColors.text,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 4),
                    JPText(
                      text: getDescription(),
                      textSize: JPTextSize.heading6,
                      textColor: JPAppTheme.themeColors.tertiary,
                      textAlign: TextAlign.start,
                      height: 1.3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the appropriate title based on the worksheet type
  String getTitle() {
    if (worksheetType == WorksheetConstants.materialList) {
      return 'use_material_list_default_settings'.tr;
    } else if (worksheetType == WorksheetConstants.workOrder) {
      return 'use_work_order_default_settings'.tr;
    } else if (worksheetType == WorksheetConstants.proposal) {
      return 'use_document_default_settings'.tr;
    } else {
      return 'use_default_settings'.tr;
    }
  }

  /// Returns the appropriate description based on the worksheet type
  String getDescription() {
    if (worksheetType == WorksheetConstants.materialList) {
      return 'use_material_list_default_settings_desc'.tr;
    } else if (worksheetType == WorksheetConstants.workOrder) {
      return 'use_work_order_default_settings_desc'.tr;
    } else if (worksheetType == WorksheetConstants.proposal) {
      return 'use_document_default_settings_desc'.tr;
    } else {
      return 'use_default_settings_desc'.tr;
    }
  }
}
