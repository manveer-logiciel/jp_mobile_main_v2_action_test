import 'package:flutter/material.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/tabs/messages.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/tabs/texts.dart';

class GroupsListing extends StatelessWidget {
  const GroupsListing({
    super.key,
    required this.controller,
  });

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return controller.hasUserManagementFeature ? 
    Column(
      children: [
        /// header, includes tabs
        GroupsListingSecondaryHeader(
            controller: controller,
        ),
        Expanded(
          child: TabBarView(
            controller: controller.tabController,
            children: [
              MessagesTab(controller: controller,),
              TextsTab(controller: controller,),
            ],
          ),
        ),
      ],
    ): 
    TextsTab(controller: controller);
  }
}
