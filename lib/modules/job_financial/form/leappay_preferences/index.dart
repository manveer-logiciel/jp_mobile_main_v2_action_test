import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/job_financial/form/leappay_preferences/widgets/preference_toggles.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class LeapPayPreferencesPage extends StatelessWidget {
  const LeapPayPreferencesPage({
    super.key,
    this.controller,
    this.amount,
  });

  final LeapPayPreferencesController? controller;
  final double? amount;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeapPayPreferencesController>(
      global: false,
      init: controller ?? LeapPayPreferencesController(),
      builder: (controller) {
        return JPScaffold(
          appBar: JPHeader(
            title: 'payment_settings'.tr,
            onBackPressed: Get.back<void>,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LeapPayPreferences(
                    controller: controller,
                    amount: amount ?? controller.amount,
                  ),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: JPButton(
                            text: 'cancel'.tr.toUpperCase(),
                            colorType: JPButtonColorType.tertiary,
                            size: JPButtonSize.small,
                            onPressed: () => Get.back(),
                            disabled: controller.isSaving,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: JPButton(
                              text: controller.isSaving ? "" : 'save'.tr.toUpperCase(),
                              onPressed: controller.onSavePreferences,
                              size: JPButtonSize.small,
                              disabled: controller.isSaving,
                              suffixIconWidget: showJPConfirmationLoader(
                                show: controller.isSaving,
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
