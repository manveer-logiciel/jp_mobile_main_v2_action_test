import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/widgets/detail.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/widgets/header.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/widgets/total.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class AddMultipleMeasurementView extends StatelessWidget {
  const AddMultipleMeasurementView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddMultipleMeasurementController>(
      init: AddMultipleMeasurementController(),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.base,
            appBar: JPHeader(
              title: controller.measurement.name!,
              onBackPressed: controller.onWillPop,
              actions: [
                Container(
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  child: JPButton(
                    text: 'add'.tr.toUpperCase(),
                    onPressed: controller.onAddButtonTap,
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    colorType: JPButtonColorType.base,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MeasurementTableHeader(attributes: controller.measurement.values![0],),
                    MeasurementTableContent(controller: controller),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: JPTextButton(
                        onPressed: (){
                         controller.addNewMeasurement();
                        },
                        text: '+ ${'add_new_measurement'.tr.capitalizeFirst!}',
                        color: JPAppTheme.themeColors.primary,
                      ),
                    ),
                    MeasurementTotal(controller: controller)
                  ],
                ),
              ),
            )
          ),
        );
      },
    );
  }
}