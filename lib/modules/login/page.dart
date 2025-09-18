import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/login/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginScreen(controller, context),
    );
  }
}

Widget loginScreen(LoginController controller, BuildContext context) {
  return GetBuilder<LoginController>(builder: (_) {
    return JPSafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: controller.scrollController,
        child: AbsorbPointer(
          absorbing: controller.isLoading,
          child: Container(
            height: JPScreen.height,
            color: JPAppTheme.themeColors.base,
            child: Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: JPResponsiveDesign.maxButtonWidth
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: !JPScreen.isMobile ? 30 : 20,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: JPScreen.isSmallHeightMobile ? 40 : 100,
                                ),
                                Image.asset(
                                  'assets/images/login-logo.png',
                                  width: 200,
                                  height: 82,
                                ),
                                JPText(
                                  text: 'welcome_to_leap'.tr,
                                  textSize: JPTextSize.heading1,
                                  fontWeight: JPFontWeight.medium,
                                  textColor: JPAppTheme.themeColors.text,
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Form(
                                  key: controller.loginFormKey,
                                  child: (Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                                        child: JPInputBox(
                                          fillColor: JPAppTheme.themeColors.base,
                                          key: const ValueKey(WidgetKeys.emailKey),
                                          onChanged: (value) {
                                            if (controller.isValidate) {
                                              controller
                                                  .validateLoginForm(controller.loginFormKey);
                                            }
                                          },
                                          onPressed: () {
                                            controller.scrollSignInButtonAboveKeyboard();
                                          },
                                          hintText: "email".tr,
                                          readOnly: controller.isLoading,
                                          textCapitalization: TextCapitalization.none,
                                          controller: controller.emailController,
                                          onSaved: (value) {
                                            controller.loginData.username =
                                                value!.toString().trim();
                                          },
                                          validator: (value) {
                                            return controller
                                                .validateEmail(value!.toString().trim());
                                          },
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.only(bottom: 15),
                                          child: JPInputBox(
                                            fillColor: JPAppTheme.themeColors.base,
                                            key: const ValueKey(WidgetKeys.passwordKey),
                                            onChanged: (value) {
                                              if (controller.isValidate) {
                                                controller
                                                    .validateLoginForm(controller.loginFormKey);
                                              }
                                              controller.enableVisibilityIcon(value);
                                            },
                                            onPressed: () {
                                              controller.scrollSignInButtonAboveKeyboard();
                                            },
                                            obscureText: !controller.isPasswordVisbile,
                                            hintText: 'passsword'.tr,
                                            readOnly: controller.isLoading,
                                            textCapitalization: TextCapitalization.none,
                                            suffixChild: IconButton(
                                              icon: JPIcon(
                                                controller.isPasswordVisbile
                                                    ? Icons.visibility_off_outlined
                                                    : Icons.visibility_outlined,
                                                color:
                                                controller.isPasswordVisbilityButtonEnable
                                                    ? JPAppTheme.themeColors.tertiary
                                                    : JPAppTheme.themeColors.tertiary
                                                    .withValues(alpha: 0.5),
                                              ),
                                              splashRadius: controller.isPasswordVisbilityButtonEnable ? 20 : 1,
                                              onPressed: () {
                                                if(controller.isPasswordVisbilityButtonEnable) controller.togglePasswordVisibilty();
                                              },
                                            ),
                                            controller: controller.passwordController,
                                            onSaved: (value) {
                                              controller.loginData.password = value!;
                                            },
                                            validator: (value) {
                                              return controller.validatePassword(value!);
                                            },
                                          )),
                                    ],
                                  )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 25),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      JPTextButton(
                                        onPressed: () => Get.toNamed(Routes.forgotPassword),
                                        text: 'forgot_password'.tr,
                                        color: JPAppTheme.themeColors.primary,
                                        fontWeight: JPFontWeight.medium,
                                        textSize: JPTextSize.heading4,
                                      )
                                    ],
                                  ),
                                ),
                                JPButton(
                                  width: double.maxFinite,
                                  key: controller.signInButtonKey,
                                  text: controller.isLoading ? null : 'signin'.tr,
                                  iconWidget: showJPConfirmationLoader(show: controller.isLoading),
                                  disabled: controller.isLoading,
                                  size: JPButtonSize.medium,
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    controller.loginInWithEmailPass();
                                  },
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                JPTextButton(
                                  onPressed: () {
                                    controller.showQuickDemoDialog();
                                  },
                                  text: 'try_quick_demo'.tr,
                                  color: JPAppTheme.themeColors.primary,
                                  fontWeight: JPFontWeight.medium,
                                  isExpanded: false,
                                  textSize: JPTextSize.heading4,
                                ),
                          
                                //const Spacer(),
                          
                              ],
                            ),
                          ),
                        ),
                      ),

                      JPRichText(
                          textAlign: TextAlign.center,
                          text: JPTextSpan.getSpan(
                              'by_continuing_you_agree_to_leap'.tr,
                              textColor: JPAppTheme.themeColors.secondaryText,
                              children: [
                                WidgetSpan(
                                  child: JPTextButton(
                                    key: const ValueKey(WidgetKeys.privacyPolicyKey),
                                    text: 'privacy_policy'.tr,
                                    fontWeight: JPFontWeight.medium,
                                    textSize: JPTextSize.heading4,
                                    color: JPAppTheme.themeColors.primary,
                                    onPressed: () {
                                      Helper.launchUrl(Urls.termAndConditionUrl);
                                    },
                                    isExpanded: false,
                                    padding: 0,
                                  ),
                                ),
                                JPTextSpan.getSpan(
                                  ' ${'and'.tr} ',
                                  textColor:
                                  JPAppTheme.themeColors.secondaryText,
                                ),
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: JPTextButton(
                                      key: const ValueKey(WidgetKeys.termsOfUseKey),
                                      text: 'terms_of_use'.tr,
                                      fontWeight: JPFontWeight.medium,
                                      textSize: JPTextSize.heading4,
                                      color: JPAppTheme.themeColors.primary,
                                      onPressed: () {
                                        Helper.launchUrl(Urls.termsOfUseUrl);
                                      },
                                      isExpanded: false,
                                      padding: 0,
                                    ),
                                  ),
                                ),
                              ]),
                        ),

                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });
}
