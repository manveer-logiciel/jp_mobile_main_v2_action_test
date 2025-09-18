import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/template_editor/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widget/page_switcher.dart';

class FormProposalMergeTemplateView extends StatelessWidget {
  const FormProposalMergeTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormProposalMergeTemplateController>(
      init: FormProposalMergeTemplateController(),
      dispose: (GetBuilderState<FormProposalMergeTemplateController> state) => state.controller?.dispose(),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onBackPressed,
          child: AbsorbPointer(
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
                            textAlign: TextAlign.start,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
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
                onBackPressed: controller.onBackPressed,
                actions: !controller.hasError
                    ? [
                        MergeTemplatePageSwitcher(
                          controller: controller,
                        ),
                        Center(
                          child: JPTextButton(
                            isDisabled: controller.isSavingForm,
                            onPressed: controller.handleMoreActions,
                            color: JPAppTheme.themeColors.base,
                            iconSize: 24,
                            icon: Icons.more_vert,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ]
                    : [],
              ),
              body: controller.hasError ? NoDataFound(
                icon: Icons.description_outlined,
                title: 'proposal_not_found'.tr.capitalize,
              ) : JPTemplateEditor(
                controller: controller,
                isDisabled: controller.isSavingForm,
              ),
            ),
          ),
        );
      },
    );
  }
}
