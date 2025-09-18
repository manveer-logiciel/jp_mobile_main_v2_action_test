import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/job_item_with_company_setting_constant.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/services/company_settings.dart';
import '../../core/constants/company_seetings.dart';

class JobItemWithCompanySetting extends StatelessWidget {
  const JobItemWithCompanySetting({
    super.key,
    required this.type,
    required this.job,
    this.value,
    this.labelTextColor,
    this.valueTextColor,
  });

  final String type;
  final String? value;
  final JobModel? job;
  final Color? labelTextColor;
  final Color? valueTextColor;

  String getJobIdReplaceWith() {
    final tempJobIdReplaceWith = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobIdReplaceWith);
    String jobIdReplaceWith = tempJobIdReplaceWith is String ? tempJobIdReplaceWith : "";
    if(jobIdReplaceWith.isNotEmpty && jobIdReplaceWith == JobItemWithCompanySettingConstant.none) {
      jobIdReplaceWith = JobItemWithCompanySettingConstant.number;
    }
    if((job?.name?.isEmpty ?? false) && jobIdReplaceWith == JobItemWithCompanySettingConstant.name) {
      jobIdReplaceWith = JobItemWithCompanySettingConstant.number;
    }
    if((job?.altId?.isEmpty ?? false )&& jobIdReplaceWith == JobItemWithCompanySettingConstant.altId) {
      jobIdReplaceWith = JobItemWithCompanySettingConstant.number;
    }

    return jobIdReplaceWith;
  }

  String getJobLabel() {
    String title = job?.isProject ?? false ? 'project'.tr.capitalize! :  'job'.tr.capitalize!;
    switch(type) { 
      case JobItemWithCompanySettingConstant.number: 
        return '$title ${'id'.tr.toUpperCase() }: ' ;

      case JobItemWithCompanySettingConstant.altId: 
        return '$title #: ';

      case JobItemWithCompanySettingConstant.name :
        return '$title ${'name'.tr.capitalize}: ';
     
      default: 
        return ''; 
      
    } 
  }

  @override
  Widget build(BuildContext context) {
    return type != getJobIdReplaceWith() && (value?.isNotEmpty ?? false) ?
      Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Row(
          children: [
            JPText(text: getJobLabel(), textColor: labelTextColor ?? JPAppTheme.themeColors.tertiary, overflow: TextOverflow.ellipsis,),
            Expanded(
              child: JPText(
                text: value ?? '',
                textColor: valueTextColor ?? JPAppTheme.themeColors.tertiary,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              )
            ),
          ],
        ),
      ) : const SizedBox.shrink();
  }
}