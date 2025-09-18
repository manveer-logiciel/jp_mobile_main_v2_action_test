import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../controller.dart';
import '../widgets/labeled_toggle.dart';
import '../widgets/section.dart';

class WorksheetSettingAmountSection extends StatelessWidget {
  const WorksheetSettingAmountSection({
    super.key,
    required this.controller,
  });

  final WorksheetSettingsController controller;

  WorksheetSettingModel get settings => controller.settings;

  @override
  Widget build(BuildContext context) {
    return WorksheetSettingSection(
      settings: [
        WorksheetSettingLabeledToggle(
          title: "show_pricing".tr,
          onToggle: controller.toggleHidePricing,
          value: !(settings.hidePricing ?? true),
          isDisabled: !controller.hasEditPermission,
        ),

        if (settings.hidePricing ?? false) ...{

          if (!(settings.showCalculationSummary ?? false)) ...{
            if (controller.isNotWorkOrderAndMaterial)
              WorksheetSettingLabeledToggle(
                title: "show_total".tr,
                onToggle: controller.toggleHideTotal,
                value: !(settings.hideTotal ?? true),
                isDisabled: !controller.hasEditPermission,
              ),

              WorksheetSettingLabeledToggle(
                title: "show_taxes".tr,
                onToggle: controller.toggleShowTaxes,
                value: (settings.showTaxes ?? false),
                isDisabled: !controller.hasEditPermission,
              ),
              if (controller.isNotWorkOrderAndMaterial)
              FromLaunchDarkly(
                flagKey: LDFlagKeyConstants.metroBathFeature,
                child: (_)=> Column(
                  children: [
                    WorksheetSettingLabeledToggle(
                      title: "show_discount".tr,
                      onToggle: controller.toggleShowDiscount,
                      value: (settings.showDiscount ?? false),
                      isDisabled: !controller.hasEditPermission,
                    ),
                     Divider(
                      color: JPAppTheme.themeColors.dimGray,
                      thickness: 1,
                      height: 26,
                    )
                  ],
                ),
              )
              
          },
          if (settings.hasTier) ...{
            WorksheetSettingLabeledToggle(
              title: "show_tier_total".tr,
              onToggle: controller.toggleShowTierTotal,
              value: settings.showTierTotal ?? false,
              isDisabled: !controller.hasEditPermission,
            ),
          },

          if (!settings.applyProfit! && !settings.isOverAllTaxSelected)
            WorksheetSettingLabeledToggle(
            title: "show_line_total".tr,
            onToggle: controller.toggleShowLineTotal,
            value: settings.showLineTotal ?? false,
            isDisabled: !controller.hasEditPermission,
          ),

          WorksheetSettingLabeledToggle(
            title: "show_summary".tr,
            onToggle: controller.toggleShowCalculationSummary,
            value: settings.showCalculationSummary ?? false,
            isDisabled: !controller.hasEditPermission,
          ),
        },

        if (settings.isWorkOrderSheet)
          WorksheetSettingLabeledToggle(
            title: "hide_customer_info".tr,
            onToggle: controller.toggleHideCustomerInfo,
            value: settings.hideCustomerInfo ?? false,
            isDisabled: !controller.hasEditPermission,
          ),

        if (controller.settings.hasTier) ...{
          WorksheetSettingLabeledToggle(
            title: "show_tier_color".tr,
            onToggle: controller.toggleShowTierColor,
            value: settings.showTierColor ?? false,
          ),

          /// Show Tier Sub Totals Toggle
          /// (displayed only if Metro Bath feature is enabled and any line item amount is applied)
          if (settings.canShowTierSubTotals)
            FromLaunchDarkly(
              flagKey: LDFlagKeyConstants.metroBathFeature,
              showHideOnly: true,
              child: (_) => Column(
                children: [
                  WorksheetSettingLabeledToggle(
                    key: const Key(WidgetKeys.showTierSubtotals),
                    title: "show_tier_sub_totals".tr,
                    onToggle: controller.toggleShowTierSubTotals,
                    value: settings.showTierSubTotals ?? false,
                    isDisabled: !controller.hasEditPermission,
                  ),
                ],
              ),
            ),
        }
      ],
    );
  }

}
