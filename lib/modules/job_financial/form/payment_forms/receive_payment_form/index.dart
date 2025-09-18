import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/job_header_detail/index.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../global_widgets/loader/index.dart';
import 'controller.dart';
import 'widget/preferences_status.dart';

class ReceivePaymentFormView extends StatelessWidget {
  const ReceivePaymentFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReceivePaymentFormController>(
      init: ReceivePaymentFormController(),
      global: false,
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isSavingForm,
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              titleWidget: controller.isLoading
                  ? JobOverViewHeaderPlaceHolder(
                      hightlightColor: JPAppTheme.themeColors.inverse,
                      baseColor: JPAppTheme.themeColors.dimGray,
                    )
                  : JobHeaderDetail(
                      job: controller.service.job,
                      textColor: JPAppTheme.themeColors.text),
              backgroundColor: JPColor.transparent,
              titleColor: JPAppTheme.themeColors.text,
              backIconColor: JPAppTheme.themeColors.text,
              onBackPressed: controller.onWillPop,
              actions: [
                if(!Helper.isValueNullOrEmpty(controller.financialDetails) && controller.service.isLeapPayEnabled)...{
                  JPTextButton(
                    icon: Icons.settings_outlined,
                    iconSize: 22,
                    onPressed: controller.navigateToLeapPayPrefs,
                  ),
                },
                  if (!controller.service.showLeapPreferenceStatus) ...{
                    const SizedBox(
                      width: 16,
                    ),
                    Center(
                      child: JPButton(
                        disabled: controller.isSavingForm ||
                            controller.service.isLoadingJustifiForm,
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                        text: controller.isSavingForm ? '' : 'next'.tr
                            .toUpperCase(),
                        suffixIconWidget: showJPConfirmationLoader(
                          show: controller.isSavingForm,
                        ),
                        onPressed: controller.saveForm,
                      ),
                    ),
                  },
                  const SizedBox(
                    width: 16,
                  )
                ],
            ),
            body: controller.service.showLeapPreferenceStatus
                ? LeapPayPreferencesStatus(controller: controller,)
                : ReceivePaymentForm(controller: controller),
          ),
        );
      },
    );
  }
}
