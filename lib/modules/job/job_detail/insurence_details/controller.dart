import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/label_value.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';

class InsuranceDetailController extends GetxController {

  InsuranceDetailController({this.jobModel});
  
  JobModel? jobModel;
 
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<LabelValueModel> insuranceDetailList =[];

  @override
  void onInit() {
    jobModel =  Get.arguments['data'];
    setInsuranceDetailList();
    super.onInit();
  }

  void setInsuranceDetailList(){
   
    InsuranceModel? insuranceData = jobModel?.insuranceDetails; 
    
    if(!Helper.isValueNullOrEmpty(insuranceData?.insuranceCompany)) {
      insuranceDetailList.add(
        LabelValueModel(
          label: 'insurance_company'.tr , 
          value: insuranceData!.insuranceCompany!
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.insuranceNumber)) {
      insuranceDetailList.add(
        LabelValueModel(
          label: 'claim'.tr, 
          value: insuranceData!.insuranceNumber!, 

        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.policyNumber)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: insuranceData!.policyNumber!, 
          label: 'policy'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.phone)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: PhoneMasking.maskPhoneNumber(insuranceData!.phone!), 
          label: 'phone_number'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.fax)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: PhoneMasking.maskPhoneNumber(insuranceData!.fax!), 
          label: 'fax'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.email)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: insuranceData!.email!, 
          label: 'email'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.adjusterName)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: insuranceData!.adjusterName!, 
          label: 'adjuster_name'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.adjusterPhone)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: PhoneMasking.maskPhoneNumber(insuranceData!.adjusterPhone!), 
          label: 'adjuster_phone'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.adjusterPhoneExt)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: insuranceData!.adjusterPhoneExt!, 
          label: 'adjuster_phone_ext'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.adjusterEmail)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: insuranceData!.adjusterEmail!, 
          label: 'adjuster_email'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.contingencyContractSignedDate)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: DateTimeHelper.convertHyphenIntoSlash(insuranceData!.contingencyContractSignedDate!), 
          label: 'contingency_contract_signed_date'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.dateOfLoss)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: DateTimeHelper.convertHyphenIntoSlash(insuranceData!.dateOfLoss!), 
          label: 'date_of_loss'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.claimFiledDate)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: DateTimeHelper.convertHyphenIntoSlash(insuranceData!.claimFiledDate!), 
          label: 'claim_filed_date'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.acv)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.acv!), 
          label: 'acv'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.deductibleAmount)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.deductibleAmount!), 
          label: 'deductible_amount'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.netClaim)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.netClaim!), 
          label: 'net_claim_amount'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.depreciation)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.depreciation!), 
          label: 'depreciation'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.rcv)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.rcv!),
          label: 'rcv'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.upgrade)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.upgrade!), 
          label: 'upgrades'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.supplement)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.supplement!), 
          label: 'supplements_amount'.tr
        )
      );
    }
    if(!Helper.isValueNullOrEmpty(insuranceData?.total)) {
      insuranceDetailList.add(
        LabelValueModel(
          value: JobFinancialHelper.getCurrencyFormattedValue(value: insuranceData!.total!), 
          label: 'total'.tr,
        )
      );
    }
  }
}
