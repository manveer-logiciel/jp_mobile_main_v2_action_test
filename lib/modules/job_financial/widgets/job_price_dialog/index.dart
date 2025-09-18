import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/helpers.dart';
import '../../../../../global_widgets/safearea/safearea.dart';
import '../../../../common/models/job/job.dart';
import 'controller.dart';
import 'dialog_body.dart';
import 'dialog_footer.dart';
import 'dialog_header.dart';

class JobPriceDialog extends StatelessWidget {
  const JobPriceDialog({
    super.key,
    required this.onApply,
    this.jobModel,
  });

  final JobModel? jobModel;
  final void Function() onApply;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobPriceDialogController(jobModel: jobModel));
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<JobPriceDialogController>(
          builder: (_) => AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Builder(
              builder: (context) => Container(
                width: double.maxFinite,
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   header
                    JobPriceDialogHeader(controller: controller),
                    ///   body
                    JobPriceDialogBody(controller: controller),
                    ///   bottom buttons
                    JobPriceDialogFooter(controller: controller, onApply: onApply),
                  ]))))),
        ));
  }
}
