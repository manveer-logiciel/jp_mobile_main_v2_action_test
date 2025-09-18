import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/form/detail.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyPaymentForm extends StatelessWidget {
  const ApplyPaymentForm({
    super.key, 
    required this.controller,
  });
  
  final ApplyPaymentFormController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: JPWillPopScope(
        onWillPop: controller.onWillPop,
        child: Material(
              color: JPColor.transparent,
              child: JPFormBuilder(
                title:'apply_payment'.tr,
                form: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ApplyPaymentDetailsection(controller: controller),
                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),
                    ],
                  ),
                ),
                footer: JPButton(
                  type: JPButtonType.solid,
                  text: controller.isSavingForm ? '' : 'apply'.tr.toUpperCase(),
                  size: JPButtonSize.small,
                  disabled: controller.isSavingForm,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                  ),
                  onPressed: (){
                    controller.onSave();
                  },
                ),
              ),
            ),
      ));
        }
}

