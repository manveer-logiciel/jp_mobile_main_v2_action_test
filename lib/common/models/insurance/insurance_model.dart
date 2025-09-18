import 'package:jobprogress/common/services/phone_masking.dart';

class InsuranceModel {
  int? id;
  String? acv;
  String? adjusterEmail;
  String? adjusterName;
  String? adjusterPhoneExt;
  String? adjusterPhone;
  String? claimFiledDate;
  String? contingencyContractSignedDate;
  String? dateOfLoss;
  String? deductibleAmount;
  String? depreciation;
  String? email;
  String? fax;
  String? insuranceCompany;
  String? insuranceNumber;
  String? netClaim;
  String? phone;
  String? policyNumber;
  String? rcv;
  String? supplement;
  String? total;
  String? upgrade;

  InsuranceModel({
    this.id,
    this.acv,
    this.adjusterEmail,
    this.adjusterName,
    this.adjusterPhone,
    this.adjusterPhoneExt,
    this.claimFiledDate,
    this.contingencyContractSignedDate,
    this.dateOfLoss,
    this.deductibleAmount,
    this.insuranceNumber,
    this.depreciation,
    this.email,
    this.fax,
    this.insuranceCompany,
    this.netClaim,
    this.phone,
    this.policyNumber,
    this.rcv,
    this.supplement,
    this.total,
    this.upgrade,
  });

  @override

  InsuranceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acv = json['acv'];
    adjusterEmail = json['adjuster_email'];
    adjusterName = json['adjuster_name'];
    adjusterPhone = json['adjuster_phone'];
    adjusterPhoneExt = json['adjuster_phone_ext'];
    claimFiledDate = json['claim_filed_date'];
    contingencyContractSignedDate = json['contingency_contract_signed_date'];
    dateOfLoss = json['date_of_loss'];
    deductibleAmount = json['deductable_amount'];
    depreciation = json['depreciation'];
    rcv = json['rcv'];
    email = json['email'];
    fax = json['fax'];
    insuranceCompany = json['insurance_company'];
    insuranceNumber = json['insurance_number'];
    phone = json['phone'];
    upgrade = json['upgrade'];
    supplement = json['supplement'];
    netClaim = json['net_claim'];
    total = json['total'];
    policyNumber = json['policy_number'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['acv'] = acv;
    data['adjuster_email'] = adjusterEmail;
    data['adjuster_name'] = adjusterName;
    data['adjuster_phone'] = PhoneMasking.unmaskPhoneNumber(adjusterPhone ?? "");
    data['adjuster_phone_ext'] = adjusterPhoneExt;
    data['claim_filed_date'] = claimFiledDate ?? '';
    data['contingency_contract_signed_date'] = contingencyContractSignedDate ?? '';
    data['date_of_loss'] = dateOfLoss ?? '';
    data['deductable_amount'] = deductibleAmount;
    data['depreciation'] = depreciation;
    data['email'] = email;
    data['fax'] = PhoneMasking.unmaskPhoneNumber(fax ?? "");
    data['insurance_company'] = insuranceCompany;
    data['insurance_number'] = insuranceNumber;
    data['phone'] = PhoneMasking.unmaskPhoneNumber(phone ?? "");
    data['upgrade'] = upgrade; 
    data['rcv'] = rcv;
    data['supplement'] = supplement;
    data['net_claim'] = netClaim;
    data['total'] = total;
    data['policy_number'] = policyNumber;
    return data;
  }
}