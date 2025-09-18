import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'detail_tile/index.dart';

class MacroListDetail extends GetView<MacroProductController> {
  const MacroListDetail( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MacroProductController>(
      init: MacroProductController(),
      builder: (_) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: 'macro_preview'.tr,
            actions: [
              Visibility(
                visible: controller.macroDetail.isNotEmpty,
                child: HasPermission(
                  permissions: const [PermissionConstants.viewUnitCost],
                  child: Center(
                    child: JPTextButton(
                      onPressed:controller.showPriceSelectionSheet,
                      color: JPAppTheme.themeColors.base,
                      icon: Icons.attach_money_outlined,
                      iconSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
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
        child: MacroDetailList(
          controller: controller
        ),
      );
}
