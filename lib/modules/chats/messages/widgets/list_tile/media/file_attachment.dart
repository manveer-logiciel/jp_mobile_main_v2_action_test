import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_thumb.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FileAttachmentMessage extends StatelessWidget {
  const FileAttachmentMessage({
    super.key,
    required this.attachments,
    this.isMyMessage = false,
    this.onTapFile
  });

  final List<MessageMediaModel>? attachments;

  final bool isMyMessage;

  final Function(MessageMediaModel)? onTapFile;

  @override
  Widget build(BuildContext context) {
    if (attachments == null) return const SizedBox();

    return Material(
      color: JPColor.transparent,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final mediaData = attachments![index];

          return InkWell(
            onTap: () {
              if(onTapFile != null) onTapFile!(mediaData);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [

                  if(mediaData.thumbIconType != null) ...{
                    JPThumbIcon(
                      iconType: mediaData.thumbIconType!,
                      size: ThumbSize.small,
                      isSelect: isMyMessage,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  },

                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: JPText(
                            text: mediaData.fileName ?? "",
                            textColor: urlColor,
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),

                        if(mediaData.fileExtension?.isNotEmpty ?? false)
                          JPText(
                          text: mediaData.fileExtension ?? "",
                          textColor: urlColor,
                          maxLine: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  JPIcon(
                    Icons.file_download_outlined,
                    color: downloadButtonColor,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, index) {
          return Divider(
            thickness: 1,
            indent: 40,
            color: JPAppTheme.themeColors.dimGray,
          );
        },
        itemCount: attachments?.length ?? 0,
      ),
    );
  }

  Color get downloadButtonColor => isMyMessage
      ? JPAppTheme.themeColors.inverse
      : JPAppTheme.themeColors.primary;

  Color get urlColor => isMyMessage
      ? JPAppTheme.themeColors.base
      : JPAppTheme.themeColors.tertiary;
}
