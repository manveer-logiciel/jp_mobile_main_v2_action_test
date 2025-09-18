import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_header_detail/index.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../global_widgets/loader/index.dart';
import 'controller.dart';

class ApplyPaymentFormView extends StatelessWidget {
  const ApplyPaymentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApplyPaymentFormController>(
      init: ApplyPaymentFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            titleWidget:controller.isLoading ? 
              JobOverViewHeaderPlaceHolder(
                hightlightColor: JPAppTheme.themeColors.inverse,
                baseColor: JPAppTheme.themeColors.dimGray,
              ):
              JobHeaderDetail(job: controller.service.job, textColor: JPAppTheme.themeColors.text),
            backgroundColor: JPColor.transparent,
            titleColor: JPAppTheme.themeColors.text,
            backIconColor: JPAppTheme.themeColors.text,
            onBackPressed: controller.onWillPop,
            actions: [
                  const SizedBox(
                    width: 16,
                  ),
                  Center(
                    child: JPButton(
                      disabled: controller.isSavingForm,
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      text: controller.isSavingForm ? '' : 'apply'.tr.toUpperCase(),
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                        size: 10,
                      ),
                      onPressed: controller.onSave,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
          ),
          body:ApplyPaymentForm(controller: controller),
        );
      },
    );
  }
}
