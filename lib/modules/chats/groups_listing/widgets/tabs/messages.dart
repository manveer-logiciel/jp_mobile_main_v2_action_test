
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({
    super.key,
    required this.controller,
  });

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (controller.isLoadingMessage && controller.groupsService.groups.isEmpty) ...{
          const GroupListingShimmer(),
        }
        else if (controller.groupsService.groups.isEmpty)...{
          /// placeholder
          Expanded(
            child: Center(
              child: NoDataFound(
                title: 'no_message_found'.tr.capitalize,
                icon: JPScreen.isDesktop ? null : Icons.sms,
                descriptions: 'you_currently_havent_got_any_messages'.tr,
              ),
            ),
          )
        }
        else...{
            GroupsThreadList(
              key: controller.messageThreadsKey,
              onLongPressGroup: controller.onLongPressGroup,
              onTapGroup: controller.onTapGroup,
              onLoadMore: controller.loadMoreMessages,
              canShowLoadMore: controller.canShowMessageLoadMore,
              groups: controller.groupsService.groups,
              selectedGroupId: controller.groupsService.selectedGroupData?.groupId,
              controller: controller,
            )
          }
      ],
    );
  }
}
