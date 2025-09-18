import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import '../controller.dart';
import '../widgets/labeled_toggle.dart';
import '../widgets/section.dart';

class WorksheetSettingOtherSection extends StatelessWidget {
  const WorksheetSettingOtherSection({
    super.key,
    required this.controller
  });

  final WorksheetSettingsController controller;

  WorksheetSettingModel get settings => controller.settings;

  @override
  Widget build(BuildContext context) {
    return WorksheetSettingSection(
      title: 'other_option'.tr,
      settings: [
        WorksheetSettingLabeledToggle(
          title: "overhead".tr,
          onToggle: controller.toggleOverhead,
          value: settings.applyOverhead ?? false,
          isDisabled: !controller.hasEditPermission,
        ),
        if(!(settings.applyLineAndWorksheetProfit ?? false))...{
          WorksheetSettingLabeledToggle(
            title: "profit".tr,
            onToggle: controller.toggleProfit,
            value: settings.applyProfit ?? false,
            forceOff: settings.isFixedPrice,
            isDisabled: !controller.hasEditPermission || settings.isFixedPrice,
          ),
          WorksheetSettingLabeledToggle(
            title: "add_profit_to_individual_item".tr,
            onToggle: controller.toggleApplyLineItemProfit,
            value: settings.applyLineItemProfit ?? false,
            onTapEdit: controller.editLineItemProfit,
            forceOff: settings.isFixedPrice,
            isDisabled: !controller.hasEditPermission || settings.isFixedPrice,
          ),
        },

        /// Apply Card Fee toggle
        /// (displayed only if Metro Bath feature is enabled)
        FromLaunchDarkly(
          flagKey: LDFlagKeyConstants.metroBathFeature,
          showHideOnly: true,
          child: (_) => Column(
            children: [
              WorksheetSettingLabeledToggle(
                title: "apply_line_and_worksheet_profit".tr,
                onToggle: controller.toggleApplyLineAndWorksheetProfit,
                value: settings.applyLineAndWorksheetProfit ?? false,
                onTapEdit: controller.editLineItemProfit,
                forceOff: settings.isFixedPrice,
                isDisabled: !controller.hasEditPermission || settings.isFixedPrice,
              ),

              Divider(color: JPAppTheme.themeColors.dimGray, thickness: 1, height: 26,),

              WorksheetSettingLabeledToggle(
                title: "apply_processing_fee".tr,
                onToggle: controller.toggleCardFee,
                value: settings.applyProcessingFee ?? false,
                isDisabled: !controller.hasEditPermission,
              ),
              Divider(
                color: JPAppTheme.themeColors.dimGray,
                thickness: 1,
                height: 26,
              )
            ],
          ),
        ),
        WorksheetSettingLabeledToggle(
          title: "commission".tr,
          onToggle: controller.toggleCommission,
          value: settings.applyCommission ?? false,
          isDisabled: !controller.hasEditPermission,
        ),
        FromLaunchDarkly(
          flagKey: LDFlagKeyConstants.metroBathFeature,
           child: (_)=> WorksheetSettingLabeledToggle(
            title: "discount".tr,
            onToggle: controller.toggleDiscount,
            value: settings.applyDiscount ?? false,
            isDisabled: !controller.hasEditPermission,
          ) ,
        ),
      ],
    );
  }
}
