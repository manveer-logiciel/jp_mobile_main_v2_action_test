import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/job_header_detail/index.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/index.dart';

class WorksheetFormView extends StatelessWidget {

  const WorksheetFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorksheetFormController>(
      init: WorksheetFormController(),
      global: false,
      dispose: (GetBuilderState<WorksheetFormController> state) => state.controller?.dispose(),
      builder: (controller) => AbsorbPointer(
        absorbing: controller.service.isSavingForm,
        child: JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: GestureDetector(
            onTap: Helper.hideKeyboard,
            child: JPScaffold(
              scaffoldKey: controller.scaffoldKey,
              backgroundColor: JPAppTheme.themeColors.lightestGray.withValues(alpha: 0.6),
              appBar: JPHeader(
                onBackPressed: controller.onWillPop,
                titleWidget: controller.service.isLoading
                    ? const JobOverViewHeaderPlaceHolder()
                    : JobHeaderDetail(
                        job: controller.service.job,
                        textColor: JPAppTheme.themeColors.base,
                      ),
                backgroundColor: JPAppTheme.themeColors.secondary,
                titleColor: JPAppTheme.themeColors.base,
                backIconColor: JPAppTheme.themeColors.base,
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 16),
                    alignment: Alignment.center,
                    child: JPButton(
                      key: const ValueKey(WidgetKeys.appBarSaveButtonKey),
                      text: controller.service.isSavingForm ? "" : controller.saveButtonTitle,
                      onPressed: controller.service.onTapSave,
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      colorType: JPButtonColorType.base,
                      disabled: controller.service.isSavingForm,
                      suffixIconWidget: showJPConfirmationLoader(
                        show: controller.service.isSavingForm,
                        size: 14
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: !controller.service.hasTiers ? JPButton(
                key: const ValueKey(WidgetKeys.addButtonKey),
                size: JPButtonSize.floatingButton,
                iconWidget: JPIcon(
                  Icons.add,
                  color: JPAppTheme.themeColors.base,
                ),
                onPressed: controller.service.showAddEditSheet,
                disabled: controller.service.isSavingForm || controller.service.isLoading,
              ) : null,
              body: WorksheetView(
                controller: controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
