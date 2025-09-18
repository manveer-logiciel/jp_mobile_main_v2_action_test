import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/automation_listing/controller.dart';
import 'package:jobprogress/modules/automation_listing/shimmer.dart';
import 'package:jobprogress/modules/automation_listing/widget/header.dart';
import 'package:jobprogress/modules/automation_listing/widget/tile/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/no_data_found/index.dart';

class AutomationListingView extends StatelessWidget {
  const AutomationListingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AutomationListingController>(
      global: false,
      init: AutomationListingController(),
      builder: (controller) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: JPAppTheme.themeColors.inverse,
            borderRadius: JPResponsiveDesign.bottomSheetRadius,
          ),
          child: JPSafeArea(
            child: ClipRRect(
              borderRadius: JPResponsiveDesign.bottomSheetRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutomationListingHeader(controller: controller),
                  Flexible(
                    child: AnimatedContainer(
                      width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        maxHeight: controller.isLoading
                            ? JPScreen.height * 0.30
                            : JPScreen.height * 0.80,
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: controller.isLoading
                          ? const AutomationListingTileShimmer()
                          : controller.automationList.isNotEmpty
                              ? Padding(
                                  padding: JPScreen.isTablet || JPScreen.isDesktop
                                      ? const EdgeInsets.only(bottom: 17)
                                      : EdgeInsets.zero,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      JPListView(
                                        key: const Key(WidgetKeys.automationListing),
                                        shrinkWrap: true,
                                        onLoadMore: controller.canShowLoadMore
                                            ? controller.loadMore
                                            : null,
                                        listCount: controller.automationList.length,
                                        itemBuilder: (_, index) {
                                          if (index < controller.automationList.length) {
                                            return AutomationTile(
                                              index: index,
                                              controller: controller,
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
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: NoDataFound(
                                    icon: Icons.task,
                                    title: "no_automation_found".tr.capitalize,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
