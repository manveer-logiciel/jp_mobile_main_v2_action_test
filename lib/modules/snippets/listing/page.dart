import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/snippets/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class SnippetsListingView extends GetView<SnippetsListingController> {
  const SnippetsListingView( {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SnippetsListingController>(
      init: SnippetsListingController(),
      builder: (_) => JPWillPopScope(
        onWillPop: () async {
          controller.cancelOnGoingRequest();
          return true;
        },
        child: JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: controller.type == STArg.snippet
                ? 'snippets'.tr
                : 'trade_scripts'.tr,
            onBackPressed: () {
              controller.cancelOnGoingRequest();
              Get.back(result: controller.copiedDescription);
            },
            actions: [
              if (controller.type == STArg.tradeScript)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: JPFilterIcon(
                        type: JPFilterIconType.headerAction,
                        isFilterActive: controller.selectedFilterByOptions?.isNotEmpty ?? false,
                        onTap: controller.type == STArg.tradeScript
                            ? controller.openFilters
                            : null,
                    ),
                  ),
                ),
            ],
          ),
          body: body()
        ),
      ),
    );
  }

  Widget body() => JPSafeArea(
        child: SnippetTradeList(
          controller: controller
        ),
      );
}
