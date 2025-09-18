import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/modules/chats/messages/controller.dart';
import 'package:jobprogress/modules/chats/messages/widgets/group_details/header_details/responsive/desktop.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../job_details.dart';
import 'responsive/mobile.dart';

class GroupDetailsHeader extends StatelessWidget {
  const GroupDetailsHeader({
    super.key,
    required this.data,
    required this.profileWidget,
    required this.controller,
  });

  final ChatGroupModel? data;

  final Widget profileWidget;

  final MessagesPageController controller;

  @override
  Widget build(BuildContext context) {
    return JPResponsiveBuilder(
      mobile: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          JPHeader(
            titleWidget: GroupDetailsHeaderMobile(
              title: groupTitle,
              profileWidget: profileWidget,
              job: data?.job,
            ),
            actions: [
              Center(
                child: JPTextButton(
                  icon: Icons.people_alt_outlined,
                  color: JPAppTheme.themeColors.base,
                  iconSize: 22,
                  onPressed: controller.showGroupParticipants,
                ),
              ),

              const SizedBox(
                width: 12,
              )
            ],
            onBackPressed: Get.splitPop,
          ),
          GroupJobDetails(
            job: controller.service.groupData?.job,
            onTapDetails: controller.onTapJob,
          ),
        ],
      ),
      desktop: GroupDetailsHeaderDesktop(
        title: groupTitle,
        profileWidget: profileWidget,
        job: data?.job,
        actions: [
          Center(
            child: JPTextButton(
              icon: Icons.people_alt_outlined,
              color: JPAppTheme.themeColors.text,
              iconSize: 22,
              onPressed: controller.showGroupParticipants,
            ),
          ),
        ],
      ),
    );
  }

  String get groupTitle => (data?.isGroup ?? false)
      ? "${data?.activeParticipants?.length ?? 0} ${'members'.tr.capitalizeFirst!}"
      : data?.groupTitle ?? 'messages'.tr;
}
