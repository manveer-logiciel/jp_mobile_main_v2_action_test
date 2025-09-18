import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../tab.dart';

class GroupsListingSecondaryHeaderDesktop extends StatelessWidget {
  const GroupsListingSecondaryHeaderDesktop({super.key, required this.controller});

  final GroupsListingController controller;

  Widget get messages => ChatsListingSecondaryHeaderTab(
    flex: 0,
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
    isDesktop: true,
  );

  Widget get texts => ChatsListingSecondaryHeaderTab(
    flex: 0,
    title: 'texts'.tr.capitalizeFirst!,
    isSelected: controller.tabController.index == 1,
    doShowCount: controller.jobId == null,
    realTimeKeyType: RealTimeKeyType.textMessageUnread,
    onTap: () => controller.animateTabTo(1),
    isDesktop: true,
  );

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

                const SizedBox(
                  width: double.maxFinite,
                ),


                /// tab-bar for switch indicator and animation
                TabBar(
                  controller: controller.tabController,
                  indicatorPadding: const EdgeInsets.only(right: 35,left: -35),
                  tabs: [
                    Tab(
                      height: 50,
                      child: messages,
                    ),
                    Tab(
                      height: 50,
                      child: texts,
                    )
                  ],
                  indicatorWeight: 2,
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 2
                  ),
                  isScrollable: true,
                ),
                /// Message & texts tab
                Positioned.fill(
                  bottom: 1.5,
                  child: Material(
                    color: JPAppTheme.themeColors.base,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24
                      ),
                      child: Row(
                        children: [
                          messages,
                          texts
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  right: 8,
                  bottom: 4,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: JPFilterIcon(
                      type: JPFilterIconType.button,
                      onTap: controller.showFilterSheet,
                      isFilterActive: controller.filterUserIds.isNotEmpty,
                    ),
                  ),
                ),
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
