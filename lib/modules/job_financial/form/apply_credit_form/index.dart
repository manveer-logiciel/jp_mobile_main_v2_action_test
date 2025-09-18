import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_header_detail/index.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class ApplyCreditFormView extends StatelessWidget {
  const ApplyCreditFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ApplyCreditFormController>(
      init: ApplyCreditFormController(),
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
            onBackPressed: Get.back<void>,
            actions: [
              Center(
                child: JPButton(
                  disabled: controller.service.isSavingForm,
                  type: JPButtonType.outline,
                  size: JPButtonSize.extraSmall,
                  text: controller.service.isSavingForm ? "" : 'save'.tr.toUpperCase(),
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.service.isSavingForm,
                    size: 10,
                  ),
                  onPressed: controller.onSave,
                ),
              ),
              const SizedBox(width: 16,)
            ],
          ),
          body: ApplyCreditForm(controller: controller),
        );
      },
    );
  }
}
