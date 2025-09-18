import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/form/section/process_payment/shimmer/justifi_method.dart';

class ProcessPaymentJustifiSection extends StatelessWidget {
  const ProcessPaymentJustifiSection({
    required this.controller,
    super.key,
  });

  final ReceivePaymentFormController controller;

  PaymentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: service.justifySectionHeight,
      child: Stack(
        children: [
          ///   Justifi Form
          Opacity(
            opacity: service.isLoadingJustifiForm ? 0.1 : 1,
            child: justifiForm(),
          ),
          /// Justifi Form Shimmer
          if (service.isLoadingJustifiForm)
            ProcessPaymentJustifiShimmer(
              isDebitCardSelected: service.isCardForm,
            ),
        ],
      ),
    );
  }

  Widget justifiForm() {
    return Column(
      children: [
        Flexible(
          child: InAppWebView(
            initialFile: service.justifiFilePath,
            initialSettings: InAppWebViewSettings(
              horizontalScrollBarEnabled: false,
              verticalScrollBarEnabled: false,
              supportZoom: false,
            ),
            onWebViewCreated: (controller) {
              service.justifiFormController = controller;
            },
            onLoadStop: service.onJustifiViewLoaded,
            onConsoleMessage: (_, message) {},
          ),
        ),
      ],
    );
  }
}