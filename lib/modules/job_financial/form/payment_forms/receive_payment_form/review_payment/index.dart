import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_status.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widget/details.dart';
import 'widget/processing.dart';

class ReviewPaymentDetails extends StatelessWidget {
  const ReviewPaymentDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GetBuilder<ReviewPaymentDetailsController>(
        init: ReviewPaymentDetailsController(),
        global: false,
        dispose: (state) {
          state.controller?.onDispose();
        },
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: JPScaffold(
              appBar: JPHeader(
                title: 'payment'.tr.capitalize!,
                backIconColor: controller.isSyncingStatus
                    ? JPAppTheme.themeColors.base.withValues(alpha: 0.5)
                    : null,
                onBackPressed: controller.isLoading
                    || controller.isSyncingStatus ? null : controller.stopProcessingPayment,
              ),
              backgroundColor: JPAppTheme.themeColors.inverse,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: SizedBox(width: double.infinity, child: body(controller))
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget body(ReviewPaymentDetailsController controller) {
    switch(controller.paymentStatus){
      case PaymentStatus.fail:
      case PaymentStatus.success:
      case PaymentStatus.pending:
      case PaymentStatus.inProgress:
        return ProceedPaymentProcessing(
          controller: controller,
        );
      default:
        return ProceedPaymentDetails(
          controller: controller,
        );
    }
  }
}
