import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class PayCommissionDialogBody extends StatelessWidget {
  const PayCommissionDialogBody({
    super.key,
    required this.controller, required this.model});

  final PayCommissionDialogController controller;
  final FinancialListingModel model;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///   amount
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: JPInputBox(
                      controller:controller.amountController,
                      fillColor: JPColor.white,
                      type: JPInputBoxType.withLabel,
                      label: "${"amount".tr.capitalize} (${JobFinancialHelper.getCurrencySymbol()})",
                      hintText: "0.00",
                      maxLength: 9,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      readOnly: false,
                      validator:(val)=> controller.validateAmount(val, double.parse(model.dueAmount!)),
                      onSaved: (val) => controller.amount = val,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: JPInputBox(
                      label: 'date'.tr,
                      maxLength: 50,
                      type: JPInputBoxType.withLabel,
                      fillColor: JPAppTheme.themeColors.base,
                      readOnly: true,
                      controller: controller.dateController,
                      validator: (val)=>(val?.isEmpty ?? true) ? "enter_valid_date".tr : "", 
                      onPressed: () {
                        controller.pickDate(); 
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
