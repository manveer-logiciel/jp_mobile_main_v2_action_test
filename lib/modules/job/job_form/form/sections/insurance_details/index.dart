import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetailsFormView extends StatelessWidget {
  const InsuranceDetailsFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InsuranceDetailsFormController>(
      init: InsuranceDetailsFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: controller.pageTitle,
            backgroundColor: JPColor.transparent,
            titleColor: JPAppTheme.themeColors.text,
            backIconColor: JPAppTheme.themeColors.text,
            titleTextOverflow: TextOverflow.ellipsis,
            onBackPressed: controller.onWillPop,
            actions: [
              Center(
                child: JPButton(
                  key: const Key(WidgetKeys.appBarSaveButtonKey),
                  disabled: controller.isSavingForm,
                  type: JPButtonType.outline,
                  size: JPButtonSize.extraSmall,
                  text: controller.isSavingForm ? "" : controller.saveButtonText,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                    size: 10,
                  ),
                  onPressed: controller.createInsurance,
                ),
              ),
              const SizedBox(width: 16)
            ],
          ),
          body: InsuranceDetailsForm(
            controller: controller,
          ),
        );
      },
    );
  }
}
