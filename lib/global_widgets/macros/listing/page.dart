import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../list_tile/index.dart';
import 'controller.dart';

class MacroListingView extends StatelessWidget {
  const MacroListingView( {super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MacroListingController>(
      init: MacroListingController(),
      global: false,
      builder: (controller) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: 'select_macros'.tr,
            actions: [
                Visibility(
                  visible: controller.canShowApplyBtn,
                  child: Container(
                    padding: const EdgeInsets.only(right: 16),
                    alignment: Alignment.center,
                    child: JPButton(
                      text: 'apply'.tr.toUpperCase(),
                      onPressed:() {
                        Get.back(result: controller.macroIdList);
                      },
                      type: JPButtonType.outline,
                      size: JPButtonSize.extraSmall,
                      colorType: JPButtonColorType.base,
                    ),
                  ),
                )
              ],
            onBackPressed: () {
              controller.cancelOnGoingRequest();
              Get.back();
            },
          ),
          body: JPSafeArea(
            child: MacroList(
                controller: controller
            ),
          )
        ),
      ),
    );
  }
}
