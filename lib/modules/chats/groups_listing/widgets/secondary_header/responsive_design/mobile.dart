import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../tab.dart';

class GroupsListingSecondaryHeaderMobile extends StatelessWidget {
  const GroupsListingSecondaryHeaderMobile({super.key, required this.controller});

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupsListingController>(
        init: controller,
        global: false,
        builder: (controller) {
          return Material(
            color: JPAppTheme.themeColors.dimGray,
            child: Stack(
              children: [
                /// tab-bar for switch indicator and animation
                TabBar(
                  controller: controller.tabController,
                  tabs: const [
                    Tab(
                      text: '',
                    ),
                    Tab(
                      text: '',
                    )
                  ],
                  indicatorWeight: 2,
                  padding: EdgeInsets.zero,
                ),
                /// Message & texts tab
                Positioned.fill(
                  bottom: 2,
                  child: Material(
                    color: JPAppTheme.themeColors.secondary,
                    child: Row(
                      children: [
                        ChatsListingSecondaryHeaderTab(
                          title: 'messages'.tr,
                          doShowCount: controller.groupsService.doShowCount && controller.filterUserIds.isEmpty,
                          isSelected: controller.tabController.index == 0,
                          onTap: () => controller.animateTabTo(0),
                          keyType: fireStoreMessageKeyType,
                          realTimeKeyType: apiMessageKeyType,
                          filterList: controller.sortBy,
                          canShowFilterIcon: controller.groupsService.doShowSortByIcon,
                          onTapFilter: controller.groupsService.doShowSortByIcon && controller.groupsService.canShowFilterIcon
                              ? controller.onApplyingSortFilter
                              : null,
                        ),
                        ChatsListingSecondaryHeaderTab(
                          title: 'texts'.tr.capitalizeFirst!,
                          isSelected: controller.tabController.index == 1,
                          doShowCount: controller.jobId == null,
                          realTimeKeyType: RealTimeKeyType.textMessageUnread,
                          onTap: () => controller.animateTabTo(1),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }

  FireStoreKeyType? get fireStoreMessageKeyType =>
      controller.messageListType == GroupsListingType.fireStoreMessages
          ? FireStoreKeyType.unreadMessageCount
          : null;

  RealTimeKeyType? get apiMessageKeyType =>
      controller.messageListType == GroupsListingType.apiMessages
          ? RealTimeKeyType.messageUnread
          : null;

}
