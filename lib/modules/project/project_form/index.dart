import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/parent_form_type.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/project/project_form/controller.dart';
import 'package:jobprogress/modules/project/project_form/form/index.dart';
import 'package:jobprogress/modules/project/project_form/form/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ProjectFormView extends StatelessWidget {
  const ProjectFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<ProjectFormController>(
          init: ProjectFormController([], '', null, null,ParentFormType.individual),
          global: false,
          builder: (controller) {
            return AbsorbPointer(
              absorbing: controller.isSavingForm,
              child: JPScaffold(
                backgroundColor: JPAppTheme.themeColors.inverse,
                appBar: JPHeader(
                  title: controller.pageTitle,
                  backgroundColor: JPColor.transparent,
                  titleColor: JPAppTheme.themeColors.text,
                  backIconColor: JPAppTheme.themeColors.text,
                  titleTextOverflow: TextOverflow.ellipsis,
                  onBackPressed: controller.onWillPop,
                  actions: [
                    const SizedBox(
                      width: 16,
                    ),
                    Visibility(
                      visible: controller.service.allFields.isNotEmpty,
                      child: Center(
                        child: JPButton(
                          disabled: controller.isSavingForm,
                          type: JPButtonType.outline,
                          size: JPButtonSize.extraSmall,
                          text: controller.isSavingForm ? "" : "save".tr.toUpperCase(),
                          suffixIconWidget: showJPConfirmationLoader(
                            show: controller.isSavingForm,
                            size: 10,
                          ),
                          onPressed: controller.createJob,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                body: controller.service.isLoading
                    ? const ProjectFormShimmer()
                    : JPFormBuilder(
                        form: Visibility(
                          visible: controller.service.allFields.isNotEmpty,
                          child: Material(
                              color: JPAppTheme.themeColors.base,
                              borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:controller.formUiHelper.horizontalPadding,
                                  vertical:controller.formUiHelper.verticalPadding,
                                ),
                                child: ProjectForm(
                                  controller: controller,
                                  showCompanyCam: null,
                                  showHover: null,
                                  divisionCode:controller.service.selectedJobDivisionCode,
                                  fields: controller.service.allFields,
                                  isSaving: controller.isSavingForm,
                                  job: controller.job, parentFormType: controller.parentFormType,
                                ),
                              )),
                        ),
                        title: '',
                        footer: Visibility(
                          visible: controller.service.allFields.isNotEmpty,
                          child: Container(
                            margin: EdgeInsets.only(top: controller.formUiHelper.sectionSeparator),
                            child: JPButton(
                              type: JPButtonType.solid,
                              text: controller.isSavingForm
                                  ? ""
                                  : 'save'.tr.toUpperCase(),
                              size: JPButtonSize.small,
                              disabled: controller.isSavingForm,
                              suffixIconWidget: showJPConfirmationLoader(
                                show: controller.isSavingForm,
                              ),
                              onPressed: controller.createJob,
                            ),
                          ),
                        ),
                      ),
              ),
            );
          }),
    );
  }
}
