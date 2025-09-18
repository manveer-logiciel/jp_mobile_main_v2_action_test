import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/notification_listing/controller.dart';
import 'package:jobprogress/modules/notification_listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import 'widgets/sync_banner.dart';

class NotificationListingView extends StatelessWidget {
  const NotificationListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationListingController>(
      init: NotificationListingController(),
      dispose: (state) => state.controller?.dispose(),
      global: false,
      builder: (controller) {
        return JPScaffold(
          scaffoldKey: controller.scaffoldKey,
          appBar: JPHeader(
            onBackPressed: () {
              Get.back();
            },
            title: "notifications".tr,
            actions: [
              controller.notificationGroup.isNotEmpty ?
                FromFirebase(
                  realTimeKeys: controller.realTimeKeys,
                  child: (val) {
                    return int.parse(val) > 0 && !controller.paramkeys.readOnly
                      ? Center(
                          child: JPTextButton(
                            icon: Icons.playlist_add_check,
                            onPressed: controller.markAllAsRead,
                            color: JPAppTheme.themeColors.base,
                            iconSize: 24,
                          ),
                        ) : const SizedBox.shrink();
                  }
                ) : const SizedBox.shrink(),
              Center(
                child: JPTextButton(
                  icon: Icons.filter_list,
                  onPressed: controller.openFilters,
                  color: JPAppTheme.themeColors.base,
                  iconSize: 24,
                ),
              ),
              Center(
                child: JPTextButton(
                  icon: Icons.menu,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                  color: JPAppTheme.themeColors.base,
                  iconSize: 24,
                ),
              ),
              const SizedBox(
                width: 12,
              ),  
            ],
          ),
          endDrawer: JPMainDrawer(
            selectedRoute: 'notifications',
            onRefreshTap: () {
              controller.refreshList(showLoading: true);
            },
          ),
          body: JPSafeArea(
            top: false,
            child: Column(
              children: [
                NotificationListingSyncBanner(
                  isVisible: controller.isDataNotSynced,
                  onTapSync: () => controller.refreshList(showLoading: true)
                ),
                Expanded(
                    child: NotificationTileList(
                        controller: controller,
                    ),
                ),
              ],
            )
          ),
        );
      }
    );
  }
}