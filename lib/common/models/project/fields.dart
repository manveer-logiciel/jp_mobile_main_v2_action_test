import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';

class ProjectFormFieldsData {
  static List<InputFieldParams> fields = [
    InputFieldParams(key: ProjectFormConstant.syncWith, name: 'sync_with'.tr),
    InputFieldParams(key: ProjectFormConstant.projectAltId, name: 'project_alt_id'.tr),
    InputFieldParams(key: ProjectFormConstant.projectRepEstimator, name: 'project_rep_estimator'.tr),
    InputFieldParams(key: ProjectFormConstant.projectTradeWorkType, name: 'trade_workType'.tr),
    InputFieldParams(key: ProjectFormConstant.projectDescription, name: 'project_description'.tr),
    InputFieldParams(key: ProjectFormConstant.projectStatus, name: 'status'.tr),
    InputFieldParams(key: ProjectFormConstant.projectDuration, name: 'project_duration'.tr),
  ];
}
