
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/messages/page.dart';

class GroupsListingContent extends StatelessWidget {
  const GroupsListingContent({
    super.key,
    required this.controller
  });

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupsListingController>(
      init: controller,
      global: false,
      builder: (internalController) {
        return  MessagesPage(
          group: controller.groupsService.selectedGroupData,
          profileWidget: controller.selectedProfile,
          type: controller.selectedMessagesListType,
          onMessageSent: controller.handleOnMessageSent,
        );
      },
    );
  }
}
