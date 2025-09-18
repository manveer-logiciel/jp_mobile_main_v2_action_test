import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/insurance_details/index.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class InsuranceDetailsFormService extends InsuranceDetailsFormData {
  InsuranceDetailsFormService({required this.validateForm, required super.insuranceModel});

  final VoidCallback validateForm; // helps in validating form when form data updates

  // initForm(): initializes form data
  void initForm() {
    try {
      setFormData();
    } catch (e) {
      rethrow;
    }
  }

  void selectContingencyContractSignedDate() {
    FormValueSelectorService.selectDate(
        date: contingencyContractSignedDate,
        isPreviousDateSelectionAllowed: true,
        controller: contingencyContractSignedController,
        initialDate: contingencyContractSignedDate?.toString(),
        onDateSelected: (date) {
          contingencyContractSignedDate = date;
          validateForm();
        });
  }

  void selectDateOfLoss() {
    FormValueSelectorService.selectDate(
        date: dateOfLoss,
        isPreviousDateSelectionAllowed: true,
        controller: dateOfLossController,
        initialDate: dateOfLoss?.toString(),
        onDateSelected: (date) {
          dateOfLoss = date;
          validateForm();
        });
  }

  void selectClaimFieldDate() {
    FormValueSelectorService.selectDate(
        date: claimFiledDate,
        isPreviousDateSelectionAllowed: true,
        controller: claimFiledController,
        initialDate: claimFiledDate?.toString(),
        onDateSelected: (date) {
          claimFiledDate = date;
          validateForm();
        });
  }

  double? get acvAmt => double.tryParse(acvController.text);
  double get deductibleAmt => double.tryParse(deductibleAmountController.text) ?? 0.0;
  double get depreciationAmt => double.tryParse(depreciationController.text) ?? 0.0;
  double get supplementsAmt => double.tryParse(supplementsController.text) ?? 0.0;
  double get upgradesAmt => double.tryParse(upgradesController.text) ?? 0.0;
  bool get isCalculatable => acvAmt != null;

  void calculateAmount() {
    netClaimAmountController.text = calculateNetClaimAmount();
    rcvController.text = calculateRcvAmount();
    totalController.text = calculateTotalAmount();
  }

  String calculateNetClaimAmount () {
    if (!isCalculatable) return '';
    return JobFinancialHelper.getRoundOff(acvAmt! - deductibleAmt);
  }

  String calculateRcvAmount() {
    if (!isCalculatable) return '';
    return JobFinancialHelper.getRoundOff(acvAmt! + depreciationAmt);
  }

  String calculateTotalAmount() {
    if (!isCalculatable) return '';
    double rcvAmt = double.tryParse(calculateRcvAmount()) ?? 0;
    return JobFinancialHelper.getRoundOff(rcvAmt + supplementsAmt + upgradesAmt);
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    bool isPhoneNumberError = FormValidator.validatePhoneNumber(phoneController.text, isRequired: false) != null;
    bool isFaxError = FormValidator.validatePhoneNumber(faxController.text, isRequired: false) != null;
    bool isEmailError = FormValidator.validateEmail(emailController.text, isRequired: false) != null;
    bool isAdjusterEmailError = FormValidator.validateEmail(adjusterEmailController.text, isRequired: false) != null;
    bool isAdjusterPhoneNumberError = FormValidator.validatePhoneNumber(adjusterPhoneField[0].number ?? '', isRequired: false) != null;

    if (isPhoneNumberError) {
      phoneController.scrollAndFocus();
    } else if (isFaxError) {
      faxController.scrollAndFocus();
    } else if (isEmailError) {
      emailController.scrollAndFocus();
    } else if (isAdjusterEmailError) {
      adjusterEmailController.scrollAndFocus();
    } else if (isAdjusterPhoneNumberError) {
      validatePhoneFormWithExt(scrollOnValidate: true);
    }
  }

  bool validatePhoneFormWithExt({bool scrollOnValidate = false}) {
    bool isEmpty = adjusterPhoneField[0].number?.isEmpty ?? false;
    if (isEmpty) return true;
    return adjusterPhoneFormKey.currentState?.validate(scrollOnValidate: scrollOnValidate) ?? false;
  }

  void saveForm() {
    InsuranceModel insuranceModel = InsuranceModel.fromJson(insuranceDetailsFormJson());
    Get.back(result: insuranceModel);
  }
}
