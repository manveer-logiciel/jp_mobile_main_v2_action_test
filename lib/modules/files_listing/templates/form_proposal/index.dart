import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/template_editor/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class FormProposalTemplateView extends StatelessWidget {
  const FormProposalTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormProposalTemplateController>(
      init: FormProposalTemplateController(),
      global: false,
      dispose: (GetBuilderState<FormProposalTemplateController> state) => state.controller?.dispose(),
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isSavingForm,
          child: JPScaffold(
            appBar: JPHeader(
              titleWidget: controller.isLoading
                  ? const JobOverViewHeaderPlaceHolder()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JPText(
                          text: controller.customerName,
                          textColor: JPAppTheme.themeColors.base,
                          fontWeight: JPFontWeight.medium,
                        ),
                        if (!controller.hasError) ...{
                          const SizedBox(
                            height: 3,
                          ),
                          JPText(
                            text: controller.jobName,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.base,
                          ),
                        }
                      ],
                    ),
              onBackPressed: controller.onWillPop,
              actions: !controller.hasError ? [
                Container(
                  padding: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  child: JPButton(
                    text: controller.isSavingForm && controller.isEditForm ? '' : 'save'.tr.toUpperCase(),
                    iconWidget: showJPConfirmationLoader(
                        show: controller.isSavingForm && controller.isEditForm,
                        size: 12
                    ),
                    onPressed: controller.onTapSave,
                    type: JPButtonType.outline,
                    size: JPButtonSize.extraSmall,
                    colorType: JPButtonColorType.base,
                    disabled: controller.isSavingForm,
                  ),
                ),

                Center(
                  child: JPTextButton(
                    isDisabled: controller.isSavingForm,
                    onPressed: controller.reloadTemplate,
                    color: JPAppTheme.themeColors.base,
                    iconSize: 24,
                    icon: Icons.refresh_outlined,
                  ),
                ),

                Center(
                  child: JPTextButton(
                    isDisabled: controller.isSavingForm,
                    onPressed: controller.html == null ? null : controller.service?.showMoreActions,
                    color: JPAppTheme.themeColors.base,
                    iconSize: 24,
                    icon: Icons.more_vert,
                  ),
                ),
                const SizedBox(width: 10),
              ] : [],
            ),
            body: controller.hasError ? NoDataFound(
              icon: Icons.description_outlined,
              title: 'proposal_not_found'.tr.capitalize,
            ) : JPTemplateEditor(
                controller: controller,
                isDisabled: controller.isSavingForm,
            ),
            floatingActionButton: controller.canShowAttachmentIcon ? JPButton(
              onPressed: controller.showAttachmentSheet,
              size: JPButtonSize.floatingButton,
              disabled: controller.isSavingForm,
              iconWidget: JPIcon(Icons.photo_outlined,
                color: JPAppTheme.themeColors.base,
              ),
            ) : null,
          ),
        );
      },
    );
  }
}
