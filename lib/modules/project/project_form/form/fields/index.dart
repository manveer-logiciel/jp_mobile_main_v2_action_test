import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/project/project_form/add_project.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/single_select.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/text_input.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jobprogress/modules/project/project_form/form/fields/multi_select.dart';
import 'package:jobprogress/modules/project/project_form/form/sections/duration.dart';
import 'package:jobprogress/modules/project/project_form/form/sections/sync_with.dart';

/// [ProjectFormFields] renders form fields according to there type
class ProjectFormFields extends StatelessWidget {
  const ProjectFormFields({
    super.key,
    required this.controller,
    required this.field,
    required this.savingForm,
    this.avoidBottomPadding = false
  });

  final ProjectFormController controller;

  final bool savingForm;
  final bool avoidBottomPadding;

  final InputFieldParams field;

  ProjectFormService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    final child = keyToField(field);

    return child != null
        ? Padding(
            padding: EdgeInsets.only(bottom: avoidBottomPadding ? 0 : 16),
            child: child,
          )
        : const SizedBox();
  }

  // keyToField(): returns the field to be displayed acc. to field key
  Widget? keyToField(InputFieldParams field) {
    String key = field.key;

    switch (key) {
      case ProjectFormConstant.projectRepEstimator:
        return ProjectFormMultiSelect(
          field: field,
          isDisabled: savingForm,
          textController: service.projectRepEstimatorController,
          selectedItems: service.selectedProjectRepEstimators,
          controller: controller,
          onTap: () => service.selectProjectRepEstimator(field.name),
        );

      case ProjectFormConstant.projectAltId:
        return JobFormTextInput(
          key: UniqueKey(),
          field: field,
          isDisabled: savingForm,
          jobDivisionCode: service.selectedJobDivisionCode,
          textController: service.projectAltIdController,
        );

      case ProjectFormConstant.projectDescription:
        return JobFormTextInput(
          field: field,
          isMultiline: true,
          showTradeScript: true,
          onTapTradeScript: service.selectTradeScript,
          textController: service.projectDescriptionController,
          isDisabled: savingForm,
        );

      case ProjectFormConstant.projectTradeWorkType:
        return JobTradeWorkTypeInputs(
          key: service.tradeWorkTypeFormKey,
          tradesList: service.tradesList,
          isDisabled: savingForm,
          workTypesList: service.workTypesList,
          hideAddButton: true,
          otherTradeDescriptionController: service.otherTradeDescriptionController,
        );

      case ProjectFormConstant.projectDuration:
        return ProjectFormDuration(
          controller: controller,
          isSaving: savingForm
        );
      case ProjectFormConstant.syncWith:
        return ProjectFormSyncWith(controller:  controller);

      case ProjectFormConstant.projectStatus:
        return JobFormSingleSelect(
          key: UniqueKey(),
          field: field,
          isDisabled: savingForm,
          textController: service.projectStatusController,
          selectionId: service.selectedProjectStatus,
          onTap: () => service.selectProjectStatus(field.name),
        );
    }

    return null;
  }
}
