import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/index.dart';

class HandwrittenTemplatePage extends StatelessWidget {
  const HandwrittenTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HandwrittenTemplateController>(
      init: HandwrittenTemplateController(),
      global: false,
      dispose: (GetBuilderState<HandwrittenTemplateController> state) => state.controller?.dispose(),
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AbsorbPointer(
            absorbing: controller.isSavingForm,
            child: JPScaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: JPColor.dimBlack,
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
                actions: [
                  /// snippets button
                  Center(
                    child: JPTextButton(
                      icon: Icons.list_alt,
                      color: JPAppTheme.themeColors.inverse,
                      iconSize: 24,
                      isDisabled: controller.isSavingForm,
                      onPressed: controller.navigateToSnippets,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  /// save button
                  if (!controller.hasError)
                    Container(
                    padding: const EdgeInsets.only(
                      right: 16
                    ),
                    alignment: Alignment.center,
                    child: JPButton(
                      text: controller.isSavingForm ? '' : 'save'.tr.toUpperCase(),
                      iconWidget: showJPConfirmationLoader(
                          show: controller.isSavingForm,
                          size: 12
                      ),
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      colorType: JPButtonColorType.base,
                      disabled: controller.isSavingForm,
                      onPressed: controller.onTapSave,
                    ),
                  ),
                ],
                onBackPressed: controller.onWillPop,
              ),
              body: HandwrittenTemplateView(
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}
