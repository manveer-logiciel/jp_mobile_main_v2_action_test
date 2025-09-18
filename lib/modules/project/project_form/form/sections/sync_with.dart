
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/hover_details/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ProjectFormSyncWith extends StatelessWidget {

  const ProjectFormSyncWith({super.key, required this.controller});

  final ProjectFormController controller;

  ProjectFormService get service => controller.service;

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
            const SizedBox(
              height: 33,
            ),
            ///   Company Cam Toggle
            if (service.canShowCompanyCam)
              JPCheckbox(
              text: 'company_cam'.tr,
              separatorWidth: 2,
              padding: EdgeInsets.zero,
              selected: service.syncWithCompanyCam,
              onTap: service.toggleSyncWithCompanyCam,
            ),

            ///   Hover Toggle
            if (service.canShowHover) ...{
              const SizedBox(
                width: 10,
              ),
              JPCheckbox(
                text: 'hover'.tr.capitalizeFirst,
                separatorWidth: 2,
                padding: EdgeInsets.zero,
                selected: service.syncWithHover,
                disabled: service.disableHoverToggle,
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
            onTapEdit: service.selectHover,
            canEdit: !service.disableHoverToggle,
          )
        }
      ],
    );
  }
}
