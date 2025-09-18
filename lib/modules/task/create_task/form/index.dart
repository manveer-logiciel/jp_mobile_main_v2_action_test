import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/task/create_task/controller.dart';
import 'package:jobprogress/modules/task/create_task/form/sections/attachments.dart';
import 'package:jobprogress/modules/task/create_task/form/sections/lock_job_stage/index.dart';
import 'package:jobprogress/modules/task/create_task/form/sections/task_details.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../common/models/forms/create_task/create_task_form_param.dart';
import 'sections/additional_options/index.dart';

class CreateTaskForm extends StatelessWidget {
  const CreateTaskForm({
    super.key,
    this.createTaskFormParam,
  });


  final CreateTaskFormParam? createTaskFormParam;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => createTaskFormParam?.controller == null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<CreateTaskFormController>(
        init: createTaskFormParam?.controller
            ?? CreateTaskFormController(createTaskFormParam: createTaskFormParam),
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
                      TaskDetailsSection(
                        controller: controller
                      ),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),

                      AdditionalOptionsSection(
                        controller: controller
                      ),

                      /// reminder notification
                      Visibility(
                        visible: controller.service.isLockStageVisible,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: controller.formUiHelper.sectionSeparator,
                          ),
                          child: CreateTaskLockJobSection(controller: controller),
                        ),
                      ),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),

                      CreateTaskAttachmentSection(controller: controller,),

                      SizedBox(
                        height: controller.formUiHelper.sectionSeparator
                      ),
                    ],
                  ),
                ),
                footer: JPButton(
                  type: JPButtonType.solid,
                  text: controller.isSavingForm
                      ? ""
                      : controller.saveButtonText,
                  size: JPButtonSize.small,
                  disabled: controller.isSavingForm,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                  ),
                  onPressed: controller.createTask,
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
