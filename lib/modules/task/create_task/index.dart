import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/task/create_task/form/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/models/forms/create_task/create_task_form_param.dart';
import '../../../global_widgets/loader/index.dart';
import 'controller.dart';

class CreateTaskFormView extends StatelessWidget {
  const CreateTaskFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTaskFormController>(
      init: CreateTaskFormController(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: controller.pageTitle,
            backgroundColor: JPColor.transparent,
            titleColor: JPAppTheme.themeColors.text,
            backIconColor: JPAppTheme.themeColors.text,
            onBackPressed: controller.onWillPop,
            actions: [
              Visibility(
                visible: controller.pageType == TaskFormType.createForm || 
                  controller.pageType == TaskFormType.progressBoardCreate,
                child: Center(
                    child: JPButton(
                      disabled: controller.isSavingForm,
                      type: JPButtonType.outline,
                      size: JPButtonSize.size24,
                    text: 'templates'.tr.toUpperCase(),
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm,
                        size: 10,
                      ),
                      onPressed: controller.navigateToTaskTemplateList,
                    ),
                  ),
              ),
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: JPButton(
                    disabled: controller.isSavingForm,
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    text: controller.isSavingForm ? "" : controller.saveButtonText,
                    suffixIconWidget: showJPConfirmationLoader(
                      show: controller.isSavingForm,
                      size: 10,
                    ),
                    onPressed: controller.createTask,
                  ),
                ),
                const SizedBox(
                  width: 16,
                )
              ],
          ),
          body: CreateTaskForm(
            createTaskFormParam: CreateTaskFormParam(controller: controller),
          ),
        );
      },
    );
  }
}
