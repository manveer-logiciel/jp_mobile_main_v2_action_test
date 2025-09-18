import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/settings/settings.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/controller.dart';
import '../widgets/labeled_toggle.dart';
import '../widgets/section.dart';

class WorksheetSettingItemSection extends StatelessWidget {

  const WorksheetSettingItemSection({
    super.key,
    required this.controller
  });

  final WorksheetSettingsController controller;

  WorksheetSheetSetting get settings => controller.settings;

  @override
  Widget build(BuildContext context) {
    return WorksheetSettingSection(
      settings: [
        WorksheetSettingLabeledToggle(
          title: "description_only".tr,
          onToggle: controller.toggleDescriptionOnly,
          value: settings.descriptionOnly ?? false,
          isDisabled: !controller.hasEditPermission,
        ),

        if ((settings.descriptionOnly ?? false)) ...{

          WorksheetSettingLabeledToggle(
            title: "show_unit".tr,
            onToggle: controller.toggleShowUnit,
            value: settings.showUnit ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
          WorksheetSettingLabeledToggle(
            title: "show_quantity".tr,
            onToggle: controller.toggleShowQuantity,
            value: settings.showQuantity ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
          if(!controller.settings.isWorkOrderSheet) ...{
            WorksheetSettingLabeledToggle(
              title: "show_style".tr,
              onToggle: controller.toggleShowStyle,
              value: settings.showStyle ?? false,
              isDisabled: !controller.hasEditPermission,
            ),
            if(controller.showSize) ...{
              WorksheetSettingLabeledToggle(
                title: "show_size".tr,
                onToggle: controller.toggleShowSize,
                value: settings.showSize ?? false,
                isDisabled: !controller.hasEditPermission,
              ),
            },
            if(controller.showColor) ...{
              WorksheetSettingLabeledToggle(
                title: "show_color".tr,
                onToggle: controller.toggleShowColor,
                value: settings.showColor ?? false,
                isDisabled: !controller.hasEditPermission,
              ),
            },
            if(controller.showVariationControls)
              WorksheetSettingLabeledToggle(
                title: "show_variation".tr,
                onToggle: controller.toggleShowVariation,
                value: settings.showVariation ?? false,
                isDisabled: !controller.hasEditPermission,
              ),
          },
          WorksheetSettingLabeledToggle(
            title: "show_supplier".tr,
            onToggle: controller.toggleShowSupplier,
            value: settings.showSupplier ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
          WorksheetSettingLabeledToggle(
            title: "show_trade_type".tr,
            onToggle: controller.toggleShowTradeType,
            value: settings.showTradeType ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
          WorksheetSettingLabeledToggle(
            title: "show_work_type".tr,
            onToggle: controller.toggleShowWorkType,
            value: settings.showWorkType ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
        }
      ],
    );
  }

}
