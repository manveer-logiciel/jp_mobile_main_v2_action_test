
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/form/sections/regular.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'sections/capture_request.dart';

class HoverOrderForm extends StatelessWidget {
  const HoverOrderForm({
    super.key,
    this.controller,
    required this.params
  });

  final HoverOrderFormController? controller;
  final HoverOrderFormParams? params;

  // parent controller will be null when opened from bottom sheet
  bool get isBottomSheet => controller == null;

  Widget get inputFieldSeparator => SizedBox(
    height: controller?.formUiHelper.inputVerticalSeparator,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Helper.hideKeyboard,
      child: GetBuilder<HoverOrderFormController>(
          init: controller ?? HoverOrderFormController(params),
          global: false,
          builder: (controller) {
            return JPWillPopScope(
              onWillPop: controller.onWillPop,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isBottomSheet ? 10 : 0
                ),
                child: JPFormBuilder(
                  title: controller.pageTitle,
                  backgroundColor: isBottomSheet ? JPAppTheme.themeColors.base : null,
                  onClose: controller.onWillPop,
                  form: Padding(
                    padding: EdgeInsets.only(
                      bottom: controller.formUiHelper.sectionSeparator
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Material(
                        color: JPAppTheme.themeColors.base,
                        borderRadius: BorderRadius.circular(controller.formUiHelper.sectionBorderRadius),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isBottomSheet ? controller.formUiHelper.verticalPadding : controller.formUiHelper.horizontalPadding,
                            vertical: !isBottomSheet ? controller.formUiHelper.verticalPadding : 0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// regular section
                              HoverOrderFormRegular(
                                controller: controller,
                              ),

                              /// capture request section
                              Visibility(
                                visible: controller.service.withCaptureRequest,
                                child: HoverOrderFormCaptureRequest(
                                  controller: controller
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isBottomSheet) ...{
                          Expanded(
                            flex: 1,
                            child: JPButton(
                              type: JPButtonType.solid,
                              text: "cancel".tr.toUpperCase(),
                              colorType: JPButtonColorType.lightGray,
                              size: JPButtonSize.small,
                              disabled: controller.isSavingForm,
                              onPressed: controller.onWillPop,
                            ),
                          ),
                          const SizedBox(width: 16)
                        },
                        Expanded(
                          flex: isBottomSheet ? 1 : 0,
                          child: JPButton(
                            type: JPButtonType.solid,
                            text: controller.isSavingForm ? "" : "save".tr.toUpperCase(),
                            size: JPButtonSize.small,
                            disabled: controller.isSavingForm,
                            suffixIconWidget: showJPConfirmationLoader(
                              show: controller.isSavingForm,
                            ),
                            onPressed: controller.synchHover,
                          ),
                        ),
                      ],
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
