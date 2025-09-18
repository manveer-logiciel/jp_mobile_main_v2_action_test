import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/models/forms/quick_measure/quick_measure_param.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'form/index.dart';

class QuickMeasureFormView extends StatelessWidget {
  const QuickMeasureFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuickMeasureFormController>(
      init: QuickMeasureFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title:'quick_measure'.tr.toUpperCase(),
            backgroundColor: JPColor.transparent,
            titleColor: JPAppTheme.themeColors.text,
            backIconColor: JPAppTheme.themeColors.text,
            onBackPressed: controller.onWillPop,
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: JPButton(
                    key: const ValueKey(WidgetKeys.placeOrder),
                    text: controller.isSavingForm ? "" : "place_order".tr.toUpperCase(),
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    disabled: controller.isSavingForm,
                    suffixIconWidget: showJPConfirmationLoader(show: controller.isSavingForm,),
                    onPressed: controller.createQuickMeasure,
                  ),
                ),
              )
            ],
          ),
          body: QuickMeasureForm(
            quickMeasureParams: QuickMeasureParams(controller: controller),
          ),
        );
      }
    );
  }
}
