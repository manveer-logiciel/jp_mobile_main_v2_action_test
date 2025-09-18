import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/forms/project_form.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jobprogress/modules/project/project_form/form/fields/index.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm(
      {super.key,
      required this.controller,
      required this.fields,
      required this.job,
      required this.isSaving,
      required this.divisionCode,
      required this.showCompanyCam,
      required this.showHover, required this.parentFormType});

  /// [fields] contains the list of fields to be displayed
  final List<InputFieldParams> fields;
  final JobModel? job;
  final bool isSaving;
  final bool? showHover;
  final bool? showCompanyCam;
  final String divisionCode;
  final ProjectFormController? controller;
  final ParentFormType parentFormType;

  @override
  State<ProjectForm> createState() => ProjectFormState();
}

class ProjectFormState extends State<ProjectForm> {
  late ProjectFormController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectFormController>(
        init: widget.controller ??
            ProjectFormController(
                widget.fields,
                widget.divisionCode,
                widget.showCompanyCam,
                widget.showHover,
                widget.parentFormType,
                customer: widget.job?.customer
            ),
        didChangeDependencies: (state) {
          controller = state.controller!;
        },
        dispose: (state){
          state.controller?.removeFieldsListener();
        },
        didUpdateWidget: (oldWidget, state) {
          state.controller?.service.selectedJobDivisionCode = widget.divisionCode;
        },
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: Form(
              key: controller.form,
              child: Column(
                children: widget.fields.map((field){
                  if(controller.service.formType == JobFormType.edit && field.key == ProjectFormConstant.projectStatus){
                    return Container();
                  }
                  return ProjectFormFields(
                        controller: controller,
                        field: field,
                        savingForm: widget.isSaving,
                        avoidBottomPadding: avoidBottomPadding(field.key),
                      );
                }).toList(),
              ),
            ),
          );
        });
  }

  bool avoidBottomPadding(String key) {
    bool isProjectDescription = key == ProjectFormConstant.projectDescription;
    return isProjectDescription;
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidate: scrollOnValidate);
  }

  Map<String, dynamic> data() {
    return controller.projectData();
  }
}

