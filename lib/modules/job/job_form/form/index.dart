
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/services/job/job_form/add_job.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/job/job_form/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'sections/index.dart';
import 'shimmer.dart';

class JobForm extends StatelessWidget {
  const JobForm({
    super.key,
    required this.controller
  });

  final JobFormController? controller;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => controller == null;

  JobFormService get service => controller!.service;

  @override
  Widget build(BuildContext context) {

    if(service.isLoading) {
      // returning shimmer if data is loading
      return  JobFormShimmer(type: controller!.type,);
    }

    // returning actual widgets once loading done
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<JobFormController>(
        init: controller ?? JobFormController(),
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: Material(
              color: JPColor.transparent,
              child: JPFormBuilder(
                title: controller.pageTitle,
                onClose: controller.onWillPop,
                form: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(controller.type == JobFormType.add) JobFormTypeSection(controller: controller),
                      Flexible(
                        child: JobFormAllSections(
                          controller: controller,
                        ),
                      ),
                      SizedBox(
                        height: controller.formUiHelper.horizontalPadding,
                      ),
                    ],
                  ),
                ),
                footer: Visibility(
                  visible: controller.service.allFields.isNotEmpty,
                  child: JPButton(
                    type: JPButtonType.solid,
                    text: controller.isSavingForm
                        ? ""
                        : controller.saveButtonText.toUpperCase(),
                    size: JPButtonSize.small,
                    disabled: controller.isSavingForm,
                    suffixIconWidget: showJPConfirmationLoader(
                      show: controller.isSavingForm,
                    ),
                    onPressed: controller.createJob,
                  ),
                ),
                inBottomSheet: isBottomSheet,
              ),
            ),
          );
        }
      ),
    );
  }
}
