
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';

class JobFormFieldsData {

  static List<InputFieldParams> fields = [
    InputFieldParams(key: JobFormConstants.syncWith, name: 'sync_with'.tr),
    InputFieldParams(key: JobFormConstants.flags, name: 'flags'.tr),
    InputFieldParams(key: JobFormConstants.jobRepEstimator, name: 'job_rep_estimator'.tr),
    InputFieldParams(key: JobFormConstants.jobDivision, name: 'job_division'.tr),
    InputFieldParams(key: JobFormConstants.jobName, name: 'job_name'.tr),
    InputFieldParams(key: JobFormConstants.jobAltId, name: 'job_number'.tr),
    InputFieldParams(key: JobFormConstants.leadNumber, name: 'lead_number'.tr),
    InputFieldParams(key: JobFormConstants.tradeWorkType, name: 'trade_work_type'.tr, isRequired: true),
    InputFieldParams(key: JobFormConstants.companyCrew, name: 'company_crew'.tr),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
      InputFieldParams(key: JobFormConstants.laborSub, name: 'labor_sub'.tr),
    InputFieldParams(key: JobFormConstants.jobDuration, name: 'job_duration'.tr),
    InputFieldParams(key: JobFormConstants.jobDescription, name: 'job_description'.tr, isRequired: true),
    InputFieldParams(key: JobFormConstants.category, name: 'category'.tr),
    InputFieldParams(key: JobFormConstants.jobAddress, name: 'job_address'.tr),
    InputFieldParams(key: JobFormConstants.contactPerson, name: 'contact_person'.tr),
    InputFieldParams(key: JobFormConstants.otherInformation, name: 'other_information'.tr),
    InputFieldParams(key: JobFormConstants.customFields, name: 'custom_fields'.tr),
    InputFieldParams(key: JobFormConstants.canvasser, name: 'canvasser'.tr),
  ];

}