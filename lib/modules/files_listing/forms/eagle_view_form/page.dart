import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/models/forms/eagleview_order/eagle_view_form_param.dart';
import '../../../../global_widgets/loader/index.dart';
import '../../../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'form/index.dart';

class EagleViewFormView extends StatelessWidget {
  const EagleViewFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EagleViewFormController>(
        init: EagleViewFormController(),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: JPButton(
                      text: controller.isSavingForm ? "" : controller.saveButtonText,
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      disabled: controller.isSavingForm,
                      suffixIconWidget: showJPConfirmationLoader(show: controller.isSavingForm,),
                      onPressed: controller.createEagleViewOrder,
                    ),
                  ),
                )
              ],
            ),
            body: EagleViewForm(
              eagleViewFormParam: EagleViewFormParam(controller: controller),
            ),
          );
        }
    );
  }
}
