
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/task/create_task_form.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../common/enums/form_toggles.dart';
import '../../../../../../core/constants/work_flow_stage_color.dart';
import '../../../../../../global_widgets/expansion_tile/index.dart';
import 'lock_job_stage.dart';

class CreateTaskLockJobSection extends StatelessWidget {
  const CreateTaskLockJobSection({
    super.key,
    required this.controller
  });

  final CreateTaskFormController controller;

  CreateTaskFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: controller.formUiHelper.verticalPadding,
            horizontal: controller.formUiHelper.horizontalPadding
        ),
        child: JPExpansionTile(
          header: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: JPIcon(
                  Icons.lock_outline,
                  color: JPAppTheme.themeColors.tertiary,
                  size: 16,
                ),
              ),
              Expanded(
                child: JPRichText(
                  text: JPTextSpan.getSpan(
                      "lock".tr,
                      children: [
                        JPTextSpan.getSpan(
                          " ${controller.service.task?.stage?.name ?? controller.jobModel?.currentStage?.name ?? ""} ",
                          textDecoration: TextDecoration.none,
                          fontWeight: JPFontWeight.regular,
                          textAlign: TextAlign.start,
                          textColor: WorkFlowStageConstants.colors[controller.service.task?.stage?.color ?? controller.jobModel!.currentStage!.color],
                          textSize: JPTextSize.heading4,
                        ),
                        JPTextSpan.getSpan(
                          'stage'.tr,
                          fontWeight: JPFontWeight.regular,
                          textAlign: TextAlign.start,
                          textSize: JPTextSize.heading4,
                          textColor: JPAppTheme.themeColors.text,
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
          disableRotation: true,
          trailing: (val) => JPToggle(
            value: controller.service.isLockStageSelected,
            disabled: !controller.service.isFieldEditable(FormToggles.stageLock),
            onToggle: controller.onLockStageExpansionChanged,
          ),
          headerPadding: EdgeInsets.zero,
          initialCollapsed: true,
          isExpanded: controller.service.isLockStageSelected,
          children: [
            TaskLockJobSection(controller: controller),
          ],
        ),
      ),
    );
  }
}
