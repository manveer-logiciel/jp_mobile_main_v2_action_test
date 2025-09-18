import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/form/section/detail.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApplyCreditForm extends StatelessWidget {
  const ApplyCreditForm({
    super.key, 
    required this.controller,
  });
  
  final ApplyCreditFormController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: Material(
            color: JPColor.transparent,
            child: JPFormBuilder(
              title:'apply_credit'.tr,
              onClose: Get.back<void>,
              form: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ApplyCreditDetailsection(controller: controller),
                    SizedBox(
                      height: controller.formUiHelper.sectionSeparator
                    ),
                  ],
                ),
              ),
              footer: JPButton(
                type: JPButtonType.solid,
                text: controller.service.isSavingForm ? '' : 'save'.tr.toUpperCase(),
                size: JPButtonSize.small,
                disabled: controller.service.isSavingForm,
                suffixIconWidget: showJPConfirmationLoader(
                  show: controller.service.isSavingForm,
                ),
                onPressed:controller.onSave,
              ),
            ),
          ));
        }
}

