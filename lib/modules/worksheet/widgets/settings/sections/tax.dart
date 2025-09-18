import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import '../controller.dart';
import '../widgets/labeled_toggle.dart';
import '../widgets/section.dart';

class WorksheetSettingTaxSection extends StatelessWidget {
  const WorksheetSettingTaxSection({
    super.key,
    required this.controller
  });

  final WorksheetSettingsController controller;

  WorksheetSettingModel get settings => controller.settings;

  @override
  Widget build(BuildContext context) {
    return WorksheetSettingSection(
      title: 'tax'.tr,
      settings: [
        if (settings.hasMaterialItem)
          WorksheetSettingLabeledToggle(
            title: "${'tax'.tr} (${'material'.tr})",
            onToggle: controller.toggleApplyTaxMaterial,
            value: settings.applyTaxMaterial ?? false,
            isDisabled: !controller.hasEditPermission,
          ),

        if (settings.hasLaborItem)
          WorksheetSettingLabeledToggle(
            title: "${'tax'.tr} (${'labor'.tr})",
            onToggle: controller.toggleApplyTaxLabor,
            value: settings.applyTaxLabor ?? false,
            isDisabled: !controller.hasEditPermission,
          ),

        if (!settings.isMaterialWorkSheet && !settings.isWorkOrderSheet) ...{
          WorksheetSettingLabeledToggle(
            title: "${'tax'.tr} (${'all'.tr})",
            onToggle: controller.toggleApplyTaxAll,
            value: settings.applyTaxAll ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
          WorksheetSettingLabeledToggle(
            title: "add_tax_to_individual_item".tr,
            onToggle: controller.toggleAddLineItemTax,
            value: settings.addLineItemTax ?? false,
            onTapEdit: controller.editLineItemTax,
            isDisabled: !controller.hasEditPermission,
          ),
        },

      ],
    );
  }

}
