import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/chats.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/chats/messages/controller.dart';
import 'package:jobprogress/modules/chats/messages/widgets/group_details/header_details/index.dart';
import 'package:jobprogress/modules/chats/messages/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/utils/color_helper.dart';
import '../../../global_widgets/network_image/index.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({
    super.key,
    this.group,
    this.type = GroupsListingType.fireStoreMessages,
    this.profileWidget,
    this.onMessageSent,
  });

  final ChatGroupModel? group;

  final Widget? profileWidget;

  final GroupsListingType type;

  final Function(String message)? onMessageSent;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<MessagesPageController>(
        init: MessagesPageController(group, type, onMessageSent),
        global: false,
        dispose: (controllerState) async {
          await controllerState.controller?.closeStreams();
        },
        didUpdateWidget: (controller, controllerState) {
          controllerState.controller?.onGroupUpdated(group);
        },
        builder: (controller) {
          return JPScaffold(
            backgroundColor: JPAppTheme.themeColors.base,
            body: Column(
              children: [
                GroupDetailsHeader(
                    data: group ?? controller.service.groupData,
                    profileWidget: profileWidget == null
                        ? getProfileAvatar(controller.service.groupData)
                        : profileWidget!,
                    controller: controller,
                ),
                Expanded(
                  child: MessagesView(
                    controller: controller,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget getProfileAvatar(ChatGroupModel? data) {
    String  placeHolderText = data?.groupProfileText ?? ("${data?.groupTitle ?? ""}  ").substring(0, 2).toUpperCase();
    return JPAvatar(
      size: JPAvatarSize.small,
      backgroundColor: data?.isGroup ?? false
          ? JPAppTheme.themeColors.dimGray
          : data?.profileImage != null ? JPColor.transparent:  ColorHelper.companyContactAvatarColors[(0 % 8)],
      child: Center(
        child: JPNetworkImage(
          src: data?.profileImage,
          height: double.maxFinite,
          width: double.maxFinite,
          placeHolder: Center(
            child: JPText(
              text: placeHolderText,
              textColor: JPAppTheme.themeColors.base,
              textSize: JPTextSize.heading5,
            ),
          ),
        ),
      ),
    );
  }
}
