import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/date_tile.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/message.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/updates_tile.dart';

class GroupMessage extends StatelessWidget {
  const GroupMessage({
    super.key,
    this.isGroup = false,
    this.isReply = false,
    required this.data,
    this.isLastMsg = false,
    this.onTapFile,
    this.onTapTryAgain,
    this.onTapCancel,
    this.isAutomated = false,
  });

  final bool isGroup;
  final bool isReply;
  final bool isLastMsg;
  final bool isAutomated;

  final GroupMessageModel data;

  final Function(MessageMediaModel)? onTapFile;

  final VoidCallback? onTapTryAgain;
  final VoidCallback? onTapCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(data.doShowDate || isLastMsg || data.unreadMessageSeparatorText != null) ...{
          MessageDateTile(
            date: data.updatedAt,
            unreadMessageSeparatorText: data.unreadMessageSeparatorText,
          ),
        },

        if(data.action != null)...{
          MessageUpdatesTile(
            actionBy: data.actionBy,
            action: data.action,
            actionOn: data.actionOn,
          ),
        } else ...{
          MessageTile(
            isAutomated: isAutomated,
            data: data,
            isGroup: isGroup,
            isReply: isReply,
            onTapFile: onTapFile,
            onTapCancel: onTapCancel,
            onTapTryAgain: onTapTryAgain,
          ),
        }

      ],
    );
  }
}
