import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFormTypeSection extends StatelessWidget {
  const JobFormTypeSection({super.key, required this.controller});

  final JobFormController controller;
  JobFormService get service => controller.service;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.verticalPadding,
        width: controller.formUiHelper.horizontalPadding,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: controller.formUiHelper.horizontalPadding,
          right: controller.formUiHelper.horizontalPadding,
          bottom: controller.formUiHelper.verticalPadding,
        ),
      child: Row(
        children: [
          ///   Add Job
          JPRadioBox(
            groupValue: service.isMultiProject,
            onChanged: service.changeFormType,
            isTextClickable: true,
            radioData: [
              JPRadioData(
                  value: false,
                  label: 'job'.tr,
                  disabled: controller.isSavingForm),
            ],
          ),
          inputFieldSeparator,

          ///   Add Multi Project Job
          JPRadioBox(
            groupValue: service.isMultiProject,
            onChanged: service.changeFormType,
            isTextClickable: true,
            radioData: [
              JPRadioData(
                  value: true,
                  label: 'multi_project_job'.tr,
                  disabled: controller.isSavingForm)
            ],
          )
        ],
      ),
    );
  }
}
