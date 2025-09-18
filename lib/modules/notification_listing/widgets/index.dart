import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/notification_listing/controller.dart';
import 'package:jobprogress/modules/notification_listing/widgets/shimmer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:sticky_headers/sticky_headers.dart';

import 'notification_list.dart';

class NotificationTileList extends StatelessWidget {
  const NotificationTileList({super.key, required this.controller});

  final NotificationListingController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const NotificationShimmer();
    } else if (controller.notificationGroup.isEmpty && !controller.isLoading) {
      return NoDataFound(
        icon: Icons.contact_page,
        title: "no_notification_found".tr.capitalize,
        descriptions: "no_notification_description".tr,
      );
    } else {
      return Column(
        children: [
          JPListView(
            onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
            shrinkWrap: true,
            onRefresh: controller.refreshList,
            listCount: controller.notificationGroup.length,
            itemBuilder: (_, index) {
              if (index < controller.notificationGroup.length) {
                return Container(
                  margin: EdgeInsets.only(
                      bottom: (index == controller.notificationGroup.length)
                          ? 16
                          : 0),
                  child: StickyHeader(
                    header: Container(
                      color: JPAppTheme.themeColors.base,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 16,
                        bottom: 10,
                        left: 16,
                      ),
                      transform: Matrix4.translationValues(0.0, -1, 0.0),
                      child: JPText(
                          textColor: JPAppTheme.themeColors.text,
                          fontWeight: JPFontWeight.medium,
                          textAlign: TextAlign.left,
                          text: controller.notificationGroup[index].groupName),
                    ),
                    content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: JPAppTheme.themeColors.base),
                      child: NotificationsList(
                          controller: controller,
                          notifications: controller.notificationGroup[index]),
                    ),
                  ),
                );
              } else if (controller.canShowLoadMore) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FadingCircle(
                      color: JPAppTheme.themeColors.primary,
                      size: 25,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      );
    }
  }
}
