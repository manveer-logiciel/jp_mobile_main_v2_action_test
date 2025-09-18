import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/support/controller.dart';
import 'package:jobprogress/modules/support/form/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SupportFormView extends StatelessWidget {
  const SupportFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SupportFormController>(
      init: SupportFormController(),
      global: false,
      builder: (controller){
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            title: "support".tr.toUpperCase(),
            backgroundColor: JPAppTheme.themeColors.secondary,
            titleTextOverflow: TextOverflow.ellipsis,
            onBackPressed: controller.onWillPop,
            actions: [
              const SizedBox(
                width: 16,
              ),
              JPIconButton(
                icon: Icons.attach_file_sharp,
                backgroundColor: Colors.transparent,
                iconSize: 20,
                iconColor: JPAppTheme.themeColors.base,
                onTap: controller.showFileAttachmentSheet,
              ),
              const SizedBox(
                width: 10,
              ),
              Center(
                child: JPButton(
                  disabled: controller.isSavingForm,
                  type: JPButtonType.outline,
                  size: JPButtonSize.extraSmall,
                  text: controller.isSavingForm ? '':'create'.tr.toUpperCase(),
                
                  colorType: JPButtonColorType.base,
                  suffixIconWidget: showJPConfirmationLoader(
                    show: controller.isSavingForm,
                    size: 10,
                  ),
                  onPressed: controller.onSave,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          body: SupportForm(
            controller: controller,
          ),
        );
      },
    );
  }
}