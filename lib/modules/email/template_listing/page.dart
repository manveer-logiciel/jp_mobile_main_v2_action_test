import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/email/template_listing/controller.dart';
import 'package:jobprogress/modules/email/template_listing/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailTemplateListingView extends GetView<EmailTemplateListingController> {
  const EmailTemplateListingView({ Key? key }) : super(key: key);
@override
  Widget build(BuildContext context) {
    return GetBuilder<EmailTemplateListingController>(
      builder: (_) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: 'email_template'.tr,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  JPText(text: 'my_favorites'.tr,
                      fontWeight: JPFontWeight.regular,
                      textSize: JPTextSize.heading4,
                      textColor: JPAppTheme.themeColors.base,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    child: JPToggle(
                      value: controller.favoriteOnly,
                      onToggle: controller.toggleFavoriteOnly,
                      toggleHeight: 20,
                      innerToggleHeight: 16,
                      innerToggleWidth: 16,
                    )
                  )  
                ],
              )
            ],  
            onBackPressed: () {
              controller.cancelOnGoingRequest();
              Get.back();
            },
          ),
          body: body()
        ),
      ),
    );
  }

  Widget body() => JPSafeArea(
    child: EmailTemplateList(
      controller: controller
    ),
  );
}