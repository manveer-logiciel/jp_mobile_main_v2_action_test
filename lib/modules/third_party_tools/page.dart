import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/third_party_tools/controller.dart';
import 'package:jobprogress/modules/third_party_tools/widgets/shimmer.dart';
import 'package:jobprogress/modules/third_party_tools/widgets/third_party_tools_tiles.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ThirdPartyTools extends StatelessWidget {
  const ThirdPartyTools({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThirdPartyToolsController>(
      global: false,
      init: ThirdPartyToolsController(),
      builder: (controller) {
      return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: JPAppTheme.themeColors.base,
        endDrawer: JPMainDrawer(
          selectedRoute: 'third_party_tools',
          onRefreshTap: () {
            controller.refreshList(showLoading: true);
          },
        ),
        appBar: JPHeader(
          onBackPressed: () {
            Get.back();
          },
          title: 'third_party_tools'.tr,
          actions: [
            IconButton(
                splashRadius: 20,
                onPressed: () {
                  controller.scaffoldKey.currentState!.openEndDrawer();
                },
                icon:  JPIcon(
                  color: JPAppTheme.themeColors.base,
                  Icons.menu
                )
            )
          ],
        ),
        body: JPSafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: controller.isLoading
              ? const ThirdPartyToolsShimmer()
              : Column(
                  children: [
                    Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Material(
                              color: JPAppTheme.themeColors.base,
                              child: JPTextButton(
                                  color: JPAppTheme.themeColors.tertiary,
                                  onPressed: () {
                                    controller.selectTrade();
                                  },
                                  fontWeight: JPFontWeight.medium,
                                  textSize: JPTextSize.heading5,
                                  text: controller.trade,
                                  icon: Icons.keyboard_arrow_down_outlined),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 14,),
                    JPListView(
                      listCount: controller.allTools.length,
                      onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
                      onRefresh: controller.refreshList,
                      itemBuilder: (_, index) {
                        if (index < controller.allTools.length) {
                          return ThirdPartyToolsTiles(
                            thirdPartyTools: controller.allTools,
                            index: index,
                            onTap: controller.navigateToDetailScreen
                          );
                        } else if (controller.canShowLoadMore) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: FadingCircle(
                                size: 25,
                                color: JPAppTheme.themeColors.primary,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    )
                  ],
                ),
          ),
        ),
      );
    });
  }
}
