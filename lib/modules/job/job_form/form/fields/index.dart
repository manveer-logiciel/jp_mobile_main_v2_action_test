import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/address_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/constants/forms/job_form.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/index.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/multi_select.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/single_select.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/contact_person/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/duration.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/flags.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/sync_with.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/index.dart';
import 'package:jobprogress/modules/project/project_form_tab/index.dart';
import 'text_input.dart';

/// [JobFormFields] renders form fields according to there type
class JobFormFields extends StatelessWidget {
  const JobFormFields({
    super.key,
    required this.controller,
    required this.field,
    this.avoidBottomPadding = false
  });

  final JobFormController controller;

  JobFormService get service => controller.service;

  final InputFieldParams field;

  final bool avoidBottomPadding;

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
      case JobFormConstants.jobDivision:
        return JobFormSingleSelect(
          key: UniqueKey(),
          field: field,
          textController: service.jobDivisionController,
          isDisabled: controller.isSavingForm,
          selectionId: service.selectedJobDivisionId,
          onTap: () => service.selectJobDivision(field.name),
        );

      case JobFormConstants.jobRepEstimator:
        return JobFormMultiSelect(
          field: field,
          textController: service.jobRepEstimatorController,
          selectedItems: service.selectedJobRepEstimators,
          controller: controller,
          isDisabled: controller.isSavingForm,
          onTap: () => service.selectJobRepEstimator(field.name),
        );

      case JobFormConstants.jobName:
        return JobFormTextInput(
          key: UniqueKey(),
          field: field,
          textController: service.jobNameController,
          isDisabled: controller.isSavingForm,
          maxLength: 30,
        );

      case JobFormConstants.jobAltId:
        return JobFormTextInput(
          key: UniqueKey(),
          field: field,
          jobDivisionCode: service.selectedJobDivisionCode,
          textController: service.jobAltIdController,
          isDisabled: controller.isSavingForm || !service.canEditJobNumber(),
        );

      case JobFormConstants.leadNumber:
        return JobFormTextInput(
          key: UniqueKey(),
          field: field,
          textController: service.leadNumberController,
          isDisabled: controller.isSavingForm || !service.canEditLeadNumber(),
        );

      case JobFormConstants.companyCrew:
        return JobFormMultiSelect(
          key: UniqueKey(),
          field: field,
          textController: service.companyCrewController,
          selectedItems: service.selectedCompanyCrews,
          controller: controller,
          isDisabled: controller.isSavingForm,
          onTap: () => service.selectCompanyCrew(field.name),
        );

      case JobFormConstants.laborSub:
        return JobFormMultiSelect(
          key: UniqueKey(),
          field: field,
          textController: service.laborSubController,
          selectedItems: service.selectedLaborSubs,
          controller: controller,
          isDisabled: controller.isSavingForm,
          onTap: () => service.selectLaborSub(field.name),
        );

      case JobFormConstants.jobDescription:
        return JobFormTextInput(
          key: UniqueKey(),
          field: field,
          isMultiline: true,
          showTradeScript: true,
          onTapTradeScript: service.selectTradeScript,
          textController: service.jobDescriptionController,
          isDisabled: controller.isSavingForm,
        );

      case JobFormConstants.jobAddress:
        return AddressForm(
          title: 'job_address'.tr,
          onDataChange: service.onDataChange,
          address: service.address,
          type: AddressFormType.job,
          isDisabled: controller.isSavingForm,
        );

      case JobFormConstants.customFields:
        return CustomFieldsForm(
          key: service.customFieldsFormKey,
          fields: service.customFormFields,
          onDataChange: field.onDataChange,
          isDisabled: controller.isSavingForm,
        );

      case JobFormConstants.jobDuration:
        return JobFormDuration(
          controller: controller,
        );

      case JobFormConstants.category:
        return JobFormSingleSelect(
          key: const Key(WidgetKeys.jobCategorySingleSelectKey),
          field: field,
          textController: service.categoryController,
          isDisabled: controller.isSavingForm,
          selectionId: service.selectedCategoryId,
          showInsuranceClaim: service.showInsuranceClaim,
          onTap: () => service.selectCategory(field.name),
          onTapInsuranceClaim: service.selectInsuranceClaim,
        );

      case JobFormConstants.tradeWorkType:
        return JobTradeWorkTypeInputs(
          key: service.tradeWorkTypeFormKey,
          isDisabled: controller.isSavingForm,
          tradesList: service.tradesList,
          workTypesList: service.workTypesList,
          hideAddButton: (service.job?.isOldTrade ?? false),
          otherTradeDescriptionController: service.otherTradeDescriptionController,
        );

      case JobFormConstants.contactPerson:
        return JobFormContactPerson(
          controller: controller,
        );

      case JobFormConstants.syncWith:
        return JobFormSyncWith(controller: controller);

      case JobFormConstants.flags:
        return JobFormFlags(controller: controller);

      case JobFormConstants.project:
        return ProjectFormTab(
          key: service.projectFormKey,
          fields: service.projectFields,
          job: service.job,
          formData: service.projectsFormData,
          isSaving: controller.isSavingForm,
          formType: service.formType,
          divisionCode: service.selectedJobDivisionCode,
          showCompanyCam: service.canShowCompanyCam,
          showHover: service.canShowHover,
          parentFormType: controller.parentFormType,
        );
      case JobFormConstants.canvasser:
        return FromLaunchDarkly(
          flagKey: LDFlagKeyConstants.jobCanvaser,
          child:(_)=> JobFormSingleSelect(
            key: const Key(JobFormConstants.canvasser),
            field: field,
            textController: service.canvasserController,
            otherController: service.otherCanvasserController,
            isDisabled: controller.isSavingForm,
            onTap: () => service.selectCanvasser(field.name),
            selectionId: service.canvasserId,
          ),
        );
    }

    return null;
  }
}
