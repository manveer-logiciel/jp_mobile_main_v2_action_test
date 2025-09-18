
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'hover_details/index.dart';

class JobFormSyncWith extends StatelessWidget {

  const JobFormSyncWith({
    super.key,
    required this.controller
  });

  final JobFormController controller;

  JobFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: JPText(
                text: 'synch_with'.tr,
                textSize: JPTextSize.heading5,
                textAlign: TextAlign.start,
              ),
            ),

            ///   Company Cam Toggle
            if (service.canShowCompanyCam)
              JPCheckbox(
              text: 'company_cam'.tr,
              separatorWidth: 2,
              padding: EdgeInsets.zero,
              selected: service.syncWithCompanyCam,
              disabled: controller.isSavingForm,
              onTap: service.toggleSyncWithCompanyCam,
            ),

            ///   Hover Toggle
            ///   Note: Hover toggle should not be displayed in case of multi-project job
            if (service.canShowHover && !service.isMultiProject) ...{
              const SizedBox(
                width: 10,
              ),
              JPCheckbox(
                text: 'hover'.tr.capitalizeFirst,
                separatorWidth: 2,
                padding: EdgeInsets.zero,
                selected: service.syncWithHover,
                disabled: controller.isSavingForm || service.disableHoverToggle,
                onTap: service.toggleSyncWithHover,
              ),
            }
          ],
        ),

        if (service.canShowHover && service.hoverJob != null) ...{
          const SizedBox(
            height: 10,
          ),

          JobFormHoverDetails(
            hoverJob: service.hoverJob!,
            isDisable: controller.isSavingForm,
            onTapEdit: service.selectHover,
            canEdit: !service.disableHoverToggle,
          )
        }
      ],
    );
  }
}
