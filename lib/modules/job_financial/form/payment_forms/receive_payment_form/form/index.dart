import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/payment/payment_form.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/controller.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/receive_payment_form/form/section/process_payment/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'section/linked_invoice_detail.dart';
import 'section/payment_type.dart';
import 'section/record_payment/index.dart';

class ReceivePaymentForm extends StatelessWidget {
  const ReceivePaymentForm({
    super.key,
    required this.controller,
  });

  final ReceivePaymentFormController controller;

  PaymentFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: service.hideKeyboard,
        child: JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: Material(
            color: JPColor.transparent,
            child: JPFormBuilder(
              title: 'record_payment'.tr,
              form: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Process Payment & Record Payment Form Switcher
                    Visibility(
                      visible: service.showFormSelection,
                      child: PaymentFormTypeSection(
                        controller: controller,
                      ),
                    ),
                    /// Process Payment Form
                    Visibility(
                      visible: !service.isRecordPaymentForm,
                      child: PaymentFormProcessPaymentSection(
                        controller: controller,
                      ),
                    ),
                    /// Record Payment Form
                    Visibility(
                      visible: service.isRecordPaymentForm,
                      child: RecordPaymentDetailsection(
                        controller: controller,
                      ),
                    ),
                    SizedBox(height: controller.formUiHelper.sectionSeparator),
                    if (service.invoiceList.isNotEmpty) ...{
                      LinkedInvoiceDetail(controller: controller),
                      SizedBox(height: controller.formUiHelper.sectionSeparator),
                    },
                  ],
                ),
              ),
              footer: Column(
                children: [
                  JPButton(
                    type: JPButtonType.solid,
                    text: controller.isSavingForm ? '' : 'next'.tr.toUpperCase(),
                    size: JPButtonSize.small,
                    disabled: controller.isSavingForm || service.isLoadingJustifiForm,
                    suffixIconWidget: showJPConfirmationLoader(
                      show: controller.isSavingForm,
                    ),
                    onPressed: () {
                      controller.saveForm();
                    },
                  ),
                  if (!controller.service.isRecordPaymentForm)
                    Padding(
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      AssetsFiles.poweredByLeapPay,
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
