import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'sections/amount.dart';
import 'sections/item.dart';
import 'sections/other.dart';
import 'sections/tax.dart';

class WorksheetSettingsView extends StatelessWidget {
  const WorksheetSettingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorksheetSettingsController>(
        init: WorksheetSettingsController(),
        global: false,
        builder: (controller) => JPScaffold(
              backgroundColor: JPAppTheme.themeColors.lightestGray,
              appBar: JPHeader(
                title: 'worksheet_setting'.tr,
                onBackPressed: Get.back<void>,
                titleColor: JPAppTheme.themeColors.text,
                backIconColor: JPAppTheme.themeColors.text,
                backgroundColor: JPAppTheme.themeColors.lightestGray,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.showTaxAndOtherSection) ...{
                      if (controller.showTaxSection)
                        WorksheetSettingTaxSection(controller: controller),
                      if (controller.isNotWorkOrderAndMaterial)
                        WorksheetSettingOtherSection(controller: controller),
                    },
                    WorksheetSettingItemSection(controller: controller),
                    WorksheetSettingAmountSection(controller: controller),
                  ],
                ),
              ),
            ));
  }
}
