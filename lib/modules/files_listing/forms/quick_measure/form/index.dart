import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../common/models/forms/quick_measure/quick_measure_param.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/form_builder/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../controller.dart';
import 'section/other_section.dart';
import 'section/product_section.dart';

class QuickMeasureForm extends StatelessWidget {
  const QuickMeasureForm({
    super.key,
    required this.quickMeasureParams});

  final QuickMeasureParams? quickMeasureParams;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => quickMeasureParams?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<QuickMeasureFormController> (
      init: quickMeasureParams?.controller ?? QuickMeasureFormController(quickMeasureParams: quickMeasureParams),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPFormBuilder(
            title: 'quick_measure'.tr.toUpperCase(),
            controller: controller.formBuilderController,
            onClose: controller.onWillPop,
            isWithMap : true,
            initialAddress : controller.selectedAddress,
            onAddressUpdate: controller.onAddressUpdate,
            form: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: QuickMeasureProductSection(
                      controller: controller
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: controller.formUiHelper.sectionSeparator),
                    child: QuickMeasureOtherSection(
                        controller: controller
                    ),
                  ),

                  SizedBox(
                    height: controller.formUiHelper.sectionSeparator
                  ),
                ],
              ),
            ),
            footer: JPButton(
              type: JPButtonType.solid,
              text: controller.isSavingForm
                  ? ""
                  : 'place_order'.tr.toUpperCase(),
              size: JPButtonSize.small,
              disabled: controller.isSavingForm,
              suffixIconWidget: showJPConfirmationLoader(
                show: controller.isSavingForm,
              ),
              onPressed: controller.createQuickMeasure,
            ),
            inBottomSheet: isBottomSheet,
          )
        );
      })
    );
  }
}
