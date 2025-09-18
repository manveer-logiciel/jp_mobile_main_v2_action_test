import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/forgot_password/widget/form/forgot_password.dart';
import 'package:jobprogress/modules/forgot_password/widget/forgot_password_header_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
        init: ForgotPasswordController(),
        builder: (controller) => JPSafeArea(
          top: false,
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              title: 'forgot_password'.tr.toUpperCase(),
              backgroundColor: JPAppTheme.themeColors.base,
              titleColor: JPAppTheme.themeColors.text,
              backIconColor: JPAppTheme.themeColors.text,
              titleTextOverflow: TextOverflow.ellipsis,
              onBackPressed: Get.back<void>,
            ),
            body: SingleChildScrollView(
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
                                        height: JPScreen.isSmallHeightMobile ? 20 : 60,
                                      ),
                                      const ForgotPasswordHeaderTile(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ForgotPasswordForm(controller: controller),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}