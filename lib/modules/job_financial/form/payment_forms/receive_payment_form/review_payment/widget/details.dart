import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../controller.dart';
import 'detail_tile.dart';

class ProceedPaymentDetails extends StatelessWidget {
  const ProceedPaymentDetails({
    required this.controller,
    super.key,
  });

  final ReviewPaymentDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   Description
        JPText(
          text: 'proceed_payment_confirmation_desc'.tr,
          textAlign: TextAlign.start,
          height: 1.3,
          textColor: JPAppTheme.themeColors.tertiary,
        ),

        const SizedBox(
          height: 12,
        ),

        ///   Invoice Amount
        ProceedPaymentDetailTile(
          title: 'payment_amount'.tr,
          value: JobFinancialHelper.getCurrencyFormattedValue(
            value: controller.service?.getPayableAmount(isFeePassOverEnabled: controller.isFeePassOverEnabledForInvoice),
          ),
          subText: controller.isFeePassOverEnabledAndNotRecordPayment ? 'amount_includes_the_processing_fee'.tr : null,
          highlightValue: true,
        ),

        ///   Payment & Payment Method Details
        Column(
          children: controller.paymentToProcessDetails.keys.map((key) {
            return ProceedPaymentDetailTile(
              title: key.tr,
              value: controller.paymentToProcessDetails[key]!,
            );
          }).toList(),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: JPResponsiveDesign.popOverButtonFlex,
                child: JPButton(
                  onPressed: controller.proceedPayment,
                  text: controller.isLoading
                      ? ""
                      : 'pay'.tr.toUpperCase(),
                  fontWeight: JPFontWeight.medium,
                  size: JPButtonSize.small,
                  disabled: controller.isLoading,
                  colorType: JPButtonColorType.primary,
                  textColor: JPAppTheme.themeColors.base,
                  iconWidget: showJPConfirmationLoader(show: controller.isLoading),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: JPResponsiveDesign.popOverButtonFlex,
                child: JPButton(
                  text: 'back'.tr.toUpperCase(),
                  fontWeight: JPFontWeight.medium,
                  size: JPButtonSize.small,
                  disabled: controller.isLoading,
                  colorType: JPButtonColorType.tertiary,
                  textColor: JPAppTheme.themeColors.tertiary,
                  onPressed: Get.back<void>,
                ),
              ),
            ],
          ),
        ),

        ///   Powered By LeapPay
        if (!(controller.service?.isRecordPaymentForm ?? true))
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20
              ),
              child: SvgPicture.asset(
                AssetsFiles.poweredByLeapPay,
                height: 25,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
