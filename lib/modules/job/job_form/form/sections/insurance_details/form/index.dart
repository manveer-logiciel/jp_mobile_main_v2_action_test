import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/insurance_form/add_insurance.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/form/insurance_amount.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/form/insurance_details.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetailsForm extends StatelessWidget {
  const InsuranceDetailsForm({super.key, required this.controller});

  final InsuranceDetailsFormController? controller;

  InsuranceDetailsFormService get service => controller!.service;

  Widget get inputFieldSeparator => SizedBox(height: controller?.formUiHelper.inputVerticalSeparator);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<InsuranceDetailsFormController>(
        init: controller ?? InsuranceDetailsFormController(),
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: Material(
              color: JPColor.transparent,
              child: JPFormBuilder(
                title: controller.pageTitle,
                onClose: controller.onWillPop,
                form: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InsuranceDetailsFormSection(controller: controller),
                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator,
                      ),
                     InsuranceAmountFormSection(controller: controller),
                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator,
                      ),
                    ],
                  ),
                ),
                footer: JPButton(
                  type: JPButtonType.solid,
                  text: controller.isSavingForm
                      ? ""
                      : controller.saveButtonText.toUpperCase(),
                  size: JPButtonSize.small,
                  disabled: controller.isSavingForm,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                  ),
                  onPressed: controller.createInsurance,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
