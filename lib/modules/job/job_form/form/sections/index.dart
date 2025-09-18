import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'section.dart';

class JobFormAllSections extends StatelessWidget {
  const JobFormAllSections({
    super.key,
    required this.controller,
  });

  final JobFormController controller;

  Widget get inputFieldSeparator => SizedBox(
        height: controller.formUiHelper.inputVerticalSeparator,
      );

  JobFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (_, index) {
        final section = service.allSections[index];

        return JobFormSection(
          controller: controller,
          section: section,
          isFirstSection: index == 0,
        );
      },
      separatorBuilder: (_, index) => inputFieldSeparator,
      itemCount: service.allSections.length,
    );
  }

}
