import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/job_header_detail/index.dart';
import '../../../../global_widgets/job_overview_placeholders/header_placeholder.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'form/index.dart';

class InvoiceForm extends StatelessWidget {
  const InvoiceForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Helper.hideKeyboard(),
      child: GetBuilder<InvoiceFormController>(
        init: InvoiceFormController(),
        global: false,
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: JPScaffold(
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: JPHeader(
                titleWidget: controller.service.jobModel == null
                    ? const JobOverViewHeaderPlaceHolder()
                    : JobHeaderDetail(job: controller.service.jobModel, textColor: JPAppTheme.themeColors.base),
                onBackPressed: controller.isSavingForm ? null : controller.onWillPop,
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: JPButton(
                        colorType: JPButtonColorType.base,
                        text: controller.isSavingForm ? "" : controller.saveButtonText,
                        type: JPButtonType.outline,
                        size: JPButtonSize.extraSmall,
                        disabled: controller.isSavingForm,
                        suffixIconWidget: showJPConfirmationLoader(show: controller.isSavingForm,),
                        onPressed: controller.saveOrderForm,
                      ),
                    ),
                  )
                ],
              ),
              floatingActionButton: JPButton(
                key: const ValueKey(WidgetKeys.addButtonKey),
                size: JPButtonSize.floatingButton,
                iconWidget: JPIcon(Icons.add, color: JPAppTheme.themeColors.base,),
                onPressed: controller.openAddItemBottomSheet,
                disabled: controller.isSavingForm,
              ),
              body: InvoiceViewForm(controller: controller),
            ),
          );
        },
      ),
    );
  }
}
