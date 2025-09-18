import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/payment_status.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';

class ProceedPaymentProcessing extends StatelessWidget {
  const ProceedPaymentProcessing({
    required this.controller,
    super.key,
  });

  final ReviewPaymentDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(controller.paymentStatus == PaymentStatus.inProgress) ...{
          JPText(
            text: 'proceed_payment_processing_desc'.tr,
            textAlign: TextAlign.start,
            height: 1.3,
            textColor: JPAppTheme.themeColors.tertiary,
          ),

          ///Loader
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: FadingCircle(color: JPAppTheme.themeColors.primary, size: 40),
          ),
        },
          
        if(controller.paymentStatus == PaymentStatus.success) ...{
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, top: 5),
              child: SvgPicture.asset(
                AssetsFiles.success,
              )
            ),
          ),
          JPText(
            text: 'payment_successful'.tr,
            textSize: JPTextSize.heading1,
            textAlign: TextAlign.start,
            height: 1.3,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        },
          
        if(controller.paymentStatus == PaymentStatus.fail) ...{
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10, top: 5),
              child: SvgPicture.asset(
                AssetsFiles.error,
              )
            ),
          ),
          JPText(
            text: 'something_went_wrong'.tr,
            textSize: JPTextSize.heading1,
            textAlign: TextAlign.start,
            height: 1.3,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        },

        if(controller.paymentStatus == PaymentStatus.pending)...{
          JPText(
            text: 'payment_process_pending_message'.tr,
            textAlign: TextAlign.center,
            height: 1.3,
            textColor: JPAppTheme.themeColors.tertiary,
          ),
        },              

        if(controller.paymentStatus != PaymentStatus.inProgress && !controller.service!.isCardForm) ...{
          if(controller.paymentStatus != PaymentStatus.pending)
            const SizedBox(height: 10),

          ///   Description
          if(controller.paymentStatus != PaymentStatus.pending)
            JPText(
              text: controller.paymentStatusDesc ?? "",
              textAlign: TextAlign.center,
              height: 1.3,
              textColor: JPAppTheme.themeColors.tertiary,
            ),
        },       
      ],
    );
  }
}
