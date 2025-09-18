import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// InsuranceDetailsFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
/// - Helps in comparing form data
class InsuranceDetailsFormData {
  InsuranceDetailsFormData({required this.insuranceModel});

  Map<String, dynamic> initialJson = {}; // holds initial json for comparison
  InsuranceModel? insuranceModel;

  // form fields controllers
  JPInputBoxController insuranceCompanyController = JPInputBoxController();
  JPInputBoxController claimController = JPInputBoxController();
  JPInputBoxController policyController = JPInputBoxController();
  JPInputBoxController phoneController = JPInputBoxController();
  JPInputBoxController faxController = JPInputBoxController();
  JPInputBoxController emailController = JPInputBoxController();
  JPInputBoxController adjusterNameController = JPInputBoxController();
  JPInputBoxController adjusterEmailController = JPInputBoxController();
  JPInputBoxController acvController = JPInputBoxController();
  JPInputBoxController deductibleAmountController = JPInputBoxController();
  JPInputBoxController netClaimAmountController = JPInputBoxController();
  JPInputBoxController depreciationController = JPInputBoxController();
  JPInputBoxController rcvController = JPInputBoxController();
  JPInputBoxController upgradesController = JPInputBoxController();
  JPInputBoxController supplementsController = JPInputBoxController();
  JPInputBoxController totalController = JPInputBoxController();
  JPInputBoxController contingencyContractSignedController = JPInputBoxController();
  JPInputBoxController dateOfLossController = JPInputBoxController();
  JPInputBoxController claimFiledController = JPInputBoxController();

  // phone form controller
  List<PhoneModel> adjusterPhoneField = [];
  final adjusterPhoneFormKey = GlobalKey<PhoneFormState>();

  // date fields
  DateTime? contingencyContractSignedDate;
  DateTime? dateOfLoss;
  DateTime? claimFiledDate;

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = insuranceDetailsFormJson();
    return initialJson.toString() != currentJson.toString();
  }

  Map<String, dynamic> insuranceDetailsFormJson() {
    return InsuranceModel(
      acv: acvController.text,
      adjusterEmail: adjusterEmailController.text,
      adjusterName: adjusterNameController.text,
      adjusterPhone: PhoneMasking.unmaskPhoneNumber(adjusterPhoneField.isNotEmpty ? (adjusterPhoneField[0].number ?? "") : ''),
      adjusterPhoneExt: adjusterPhoneField.isNotEmpty ? adjusterPhoneField[0].ext : '',
      deductibleAmount: deductibleAmountController.text,
      depreciation: depreciationController.text,
      email: emailController.text,
      fax: PhoneMasking.unmaskPhoneNumber(faxController.text),
      id: insuranceModel?.id,
      insuranceCompany: insuranceCompanyController.text,
      insuranceNumber: claimController.text,
      netClaim: netClaimAmountController.text,
      phone: PhoneMasking.unmaskPhoneNumber(phoneController.text),
      policyNumber: policyController.text,
      rcv: rcvController.text,
      supplement: supplementsController.text,
      total: totalController.text,
      upgrade: upgradesController.text,
      claimFiledDate: DateTimeHelper.convertSlashIntoHyphen(claimFiledController.text),
      contingencyContractSignedDate: DateTimeHelper.convertSlashIntoHyphen(contingencyContractSignedController.text),
      dateOfLoss: DateTimeHelper.convertSlashIntoHyphen(dateOfLossController.text),
    ).toJson();
  }

  void setFormData() {
    acvController.text = insuranceModel?.acv ?? '';
    adjusterEmailController.text = insuranceModel?.adjusterEmail ?? '';
    adjusterNameController.text = insuranceModel?.adjusterName ?? '';
    deductibleAmountController.text = insuranceModel?.deductibleAmount ?? '';
    depreciationController.text = insuranceModel?.depreciation ?? '';
    insuranceCompanyController.text = insuranceModel?.insuranceCompany ?? '';
    emailController.text = insuranceModel?.email ?? '';
    faxController.text = PhoneMasking.maskPhoneNumber(insuranceModel?.fax ?? '');
    netClaimAmountController.text = insuranceModel?.netClaim ?? '';
    phoneController.text = PhoneMasking.maskPhoneNumber(insuranceModel?.phone ?? '');
    policyController.text = insuranceModel?.policyNumber ?? '';
    rcvController.text = insuranceModel?.rcv ?? '';
    supplementsController.text = insuranceModel?.supplement ?? '';
    upgradesController.text = insuranceModel?.upgrade ?? '';
    totalController.text = insuranceModel?.total ?? '';
    claimController.text = insuranceModel?.insuranceNumber ?? '';

    // Setting up Contingency Contract Signed Date only if it is not zero
    if (!DateTimeHelper.isZeroDate(insuranceModel?.contingencyContractSignedDate)) {
      contingencyContractSignedController.text = DateTimeHelper.convertHyphenIntoSlash(insuranceModel?.contingencyContractSignedDate ?? '');
      contingencyContractSignedDate = DateTimeHelper.stringToDateTime(insuranceModel?.contingencyContractSignedDate);
    }

    // Setting up Date of Loss only if it is not zero
    if (!DateTimeHelper.isZeroDate(insuranceModel?.dateOfLoss)) {
      dateOfLossController.text = DateTimeHelper.convertHyphenIntoSlash(insuranceModel?.dateOfLoss ?? '');
      dateOfLoss = DateTimeHelper.stringToDateTime(insuranceModel?.dateOfLoss);
    }

    // Setting up Claim Filed Date only if it is not zero
    if (!DateTimeHelper.isZeroDate(insuranceModel?.claimFiledDate)) {
      claimFiledController.text = DateTimeHelper.convertHyphenIntoSlash(insuranceModel?.claimFiledDate ?? '');
      claimFiledDate = DateTimeHelper.stringToDateTime(insuranceModel?.claimFiledDate);
    }

    adjusterPhoneField = [
      PhoneModel(
        number: PhoneMasking.maskPhoneNumber(insuranceModel?.adjusterPhone ?? ''),
        ext: insuranceModel?.adjusterPhoneExt ?? '',
        label: 'phone',
      )
    ];

    initialJson = insuranceModel?.toJson() ?? insuranceDetailsFormJson();
  }

}
