import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MeasurementFormView extends StatelessWidget {
  const MeasurementFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeasurementFormController>(
      init: MeasurementFormController(),
      global: false,
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isSavingForm,
          child: JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: JPHeader(
                title: controller.isEdit ?
                'update_measurement'.tr.toUpperCase() :
                controller.viewTitle.isNotEmpty ?
                controller.viewTitle :
                'add_measurement'.tr.toUpperCase(),
                backgroundColor: JPColor.transparent,
                titleColor: JPAppTheme.themeColors.text,
                backIconColor: JPAppTheme.themeColors.text,
                onBackPressed: controller.onWillPop,
                actions: [
                  Visibility(
                    visible: controller.viewTitle.isEmpty && controller.controllerList.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: JPButton(
                        key: const Key(WidgetKeys.appBarSaveButtonKey),
                        text: controller.isSavingForm ? '' : controller.isEdit ? 'update'.tr.toUpperCase() :  'save'.tr.toUpperCase(),
                        iconWidget:  showJPConfirmationLoader(
                          show: controller.isSavingForm
                        ),
                        onPressed: (){
                          controller.showSaveDialog();
                        },
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: MeasurementForm(controller: controller),
            ),
          ),
        );
      },
    );
  }
}
