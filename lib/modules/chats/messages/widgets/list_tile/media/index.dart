
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/media/file_attachment.dart';

class MediaTypeToFile extends StatelessWidget {

  const MediaTypeToFile({
    super.key,
    this.media,
    this.isMyMessage = false,
    this.onTapFile,
  });

  final List<MessageMediaModel>? media;

  final bool isMyMessage;

  final Function(MessageMediaModel)? onTapFile;

  @override
  Widget build(BuildContext context) {
    return FileAttachmentMessage(
      attachments: media,
      isMyMessage: isMyMessage,
      onTapFile: onTapFile,
    );
  }
}
