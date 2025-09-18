import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/body.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/controller.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/footer.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/header.dart';

class PayCommissionDialog extends StatelessWidget {
  const PayCommissionDialog({
    super.key,
    required this.onApply,
    this.model,
  });

  final FinancialListingModel? model;
  final void Function(FinancialListingModel model, String action) onApply;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayCommissionDialogController(model: model));
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: JPSafeArea(
        child: GetBuilder<PayCommissionDialogController>(
          builder: (_) => AbsorbPointer(
            absorbing: controller.isLoading,
            child: AlertDialog(
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
                      PayCommissionDialogHeader(controller: controller,),
                      ///   body
                      PayCommissionDialogBody(controller: controller, model: model!,),
                      ///   bottom buttons
                      PayCommissionDialogFooter(controller: controller, onApply: onApply),
                    ]
                  )
                )
              )
            ),
          )
        ),
      )
    );
  }
}
