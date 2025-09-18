import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/split_view/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/routes/pages.dart';

import 'splits/content.dart';
import 'splits/list.dart';

class GroupsResponsiveView extends StatelessWidget {
  const GroupsResponsiveView({
    super.key,
    required this.controller,
    required this.header,
  });

  final GroupsListingController controller;
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return JPResponsiveSplitView(
      header: header,
      list: GroupsListing(
        controller: controller,
      ),
      content: GroupsListingContent(
        controller: controller,
      ),
      contentPlaceholder: NoDataFound(
        title: 'no_conversation_selected'.tr.capitalize,
        icon: Icons.textsms,
        descriptions: 'there_is_no_conversation_selected_in_inbox'.tr,
      ),
      contentRouteName: Routes.messages,
    );
  }
}
