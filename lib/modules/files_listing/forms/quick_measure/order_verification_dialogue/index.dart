import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import '../../../../../common/models/forms/quick_measure/index.dart';
import '../../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';
import 'widgets/dialogue_body.dart';
import 'widgets/dialogue_footer.dart';
import 'widgets/dialogue_header.dart';

class QuickMeasureOrderVerificationDialogue extends StatelessWidget {
  const QuickMeasureOrderVerificationDialogue({
    super.key,
    required this.formData,
    required this.isDefaultLocation,
    required this.onFinish,
  });

  final QuickMeasureFormData formData;
  final bool isDefaultLocation;
  final Function(bool) onFinish;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: GetBuilder<QuickMeasureOrderVerificationDialogueController>(
        init: QuickMeasureOrderVerificationDialogueController(formData, isDefaultLocation),
        global: false,
        builder: (controller) => JPSafeArea(
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Builder(
              builder: (context) {
                return Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   header
                      QuickMeasureOrderDialogueHeader(controller: controller),
                      ///   body
                      QuickMeasureOrderDialogueBody(formData: formData, isDefaultLocation: isDefaultLocation, controller: controller),
                      ///   bottom buttons
                      QuickMeasureOrderDialogueFooter(controller: controller, onFinish: onFinish),
                    ],
                  ),
                );
              },
            ),
          ),
        )
      )
    );
  }
}
