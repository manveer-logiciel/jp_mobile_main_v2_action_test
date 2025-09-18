import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/forgot_password/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/utils/form/validators.dart';
import '../../../../global_widgets/loader/index.dart';

class ForgotPasswordForm extends StatelessWidget {
  final ForgotPasswordController controller;

  const ForgotPasswordForm({
    super.key,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 25),
          child: Form(
            key: controller.forgotPasswordKey,
            child: JPInputBox(
              fillColor: JPAppTheme.themeColors.base,
              onChanged: controller.onChangeEmail,
              onPressed: controller.scrollRecoverPasswordBtnAboveKeyboard,
              hintText: "email".tr,
              readOnly: controller.isLoading,
              textCapitalization: TextCapitalization.none,
              controller: controller.emailController,
              validator: (value) => FormValidator.validateEmail(
                  value,
                  errorMsg: 'please_enter_email'.tr,
                  isRequired: true
              ),
            )),
        ),
        JPButton(
          width: double.maxFinite,
          key: controller.forgotPasswordButtonKey,
          text: controller.isLoading ? null : 'recover_password'.tr.toUpperCase(),
          iconWidget: showJPConfirmationLoader(show: controller.isLoading),
          disabled: controller.isLoading,
          size: JPButtonSize.medium,
          onPressed: controller.recoverPassword,
        ),

        const SizedBox(
          height: 18,
        ),

        JPTextButton(
          onPressed: Get.back<void>,
          text: 'back_to_login'.tr,
          color: JPAppTheme.themeColors.primary,
          fontWeight: JPFontWeight.medium,
          isExpanded: false,
          textSize: JPTextSize.heading4,
        ),
      ],
    );
  }
}