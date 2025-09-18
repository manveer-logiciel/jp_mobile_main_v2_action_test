import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FileUrlMessage extends StatelessWidget {
  const FileUrlMessage({
    super.key,
    required this.urls,
    this.isMyMessage = false,
    this.onTapFile
  });

  final List<MessageMediaModel>? urls;

  final bool isMyMessage;

  final Function(MessageMediaModel)? onTapFile;

  @override
  Widget build(BuildContext context) {
    if (urls == null) return const SizedBox();

    return Material(
      color: JPColor.transparent,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final urlData = urls![index];

          return InkWell(
            onTap: () {
              if(onTapFile != null) onTapFile!(urlData);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                children: [
                  JPIcon(
                    Icons.file_download_outlined,
                    color: downloadButtonColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: JPText(
                      text: urlData.mediaUrl ?? "",
                      textColor: urlColor,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                    ),
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
        itemCount: urls?.length ?? 0,
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
