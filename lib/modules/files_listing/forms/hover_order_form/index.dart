import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'form/index.dart';

class HoverOrderFormView extends StatelessWidget {
  const HoverOrderFormView({
    super.key,
    this.params
  });

  final HoverOrderFormParams? params;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HoverOrderFormController>(
        init: HoverOrderFormController(params),
        builder: (controller) {
          return AbsorbPointer(
            absorbing: controller.isSavingForm,
            child: Scaffold(
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: JPHeader(
                title: controller.pageTitle,
                backgroundColor: JPColor.transparent,
                titleColor: JPAppTheme.themeColors.text,
                backIconColor: JPAppTheme.themeColors.text,
                onBackPressed: controller.onWillPop,
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16
                      ),
                      child: JPButton(
                        type: JPButtonType.outline,
                        colorType: JPButtonColorType.primary,
                        size: JPButtonSize.extraSmall,
                        text: controller.isSavingForm ? "" : 'save'.tr.toUpperCase(),
                        disabled: controller.isSavingForm,
                        suffixIconWidget: showJPConfirmationLoader(
                          show: controller.isSavingForm,
                          size: 14
                        ),
                        onPressed: controller.synchHover,
                      ),
                    ),
                  )
                ],
              ),
              body: HoverOrderForm(
                params: params,
                controller: controller,
              ),
            ),
          );
        },
    );
  }
}
