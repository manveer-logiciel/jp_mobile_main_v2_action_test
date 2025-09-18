
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_model.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_thumb.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:path/path.dart';


class UploadsListTile extends StatefulWidget {

  const UploadsListTile({
    super.key,
    required this.data,
    this.onTapCancel,
    this.onTapFile,
    this.onChangeFileStatus,
  });

  /// will contain upload item data
  final FileUploaderModel data;

  /// will handle cancel on file item
  final VoidCallback? onTapCancel;

  /// will handle tap on file
  final VoidCallback? onTapFile;

  /// will helps in toggling file status
  final VoidCallback? onChangeFileStatus;

  @override
  State<UploadsListTile> createState() => _UploadsListTileState();
}

class _UploadsListTileState extends State<UploadsListTile> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        InkWell(
          onTap: widget.onTapFile,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    JPThumbIcon(
                      iconType: widget.data.thumb!,
                      size: ThumbSize.small,
                    ),

                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: JPText(
                                        textAlign: TextAlign.start,
                                        text: basenameWithoutExtension(widget.data.fileName.toString()),
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: JPFontWeight.medium,
                                      ),
                                    ),
                                    if(FileHelper.getFileExtension(widget.data.fileName.toString()) != null)
                                    JPText(
                                      text: '.${FileHelper.getFileExtension(
                                        widget.data.fileName.toString())!}',
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: JPFontWeight.medium,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text.rich(
                            TextSpan(
                              children: widget.data.displayPath.split('>')
                                .map<InlineSpan>((segment) {
                                  int index = widget.data.displayPath.split('>').indexOf(segment);
                                  return JPTextSpan.getSpan(
                                    segment.trim(),
                                    textSize: JPTextSize.heading6,
                                    textColor: JPAppTheme.themeColors.darkGray,
                                    children: [
                                      if (index != widget.data.displayPath.split('>').length - 1)
                                      JPTextSpan.getSpan(
                                        ' / ',
                                        textSize: JPTextSize.heading6,
                                        textColor: JPAppTheme.themeColors.darkGray,
                                      ),
                                    ],
                                  );
                                }).toList(),
                            ),
                            overflow: TextOverflow.ellipsis, // To handle overflow
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(widget.data.isUploaded && widget.data.error == null)...{
                          JPIcon(
                            Icons.done,
                            color: JPAppTheme.themeColors.success,
                            size: 22,
                          )
                        } else...{
                          if(!(widget.data.isLargeFile))
                            Transform.scale(
                            scaleX: widget.data.error?.isNotEmpty ?? false ? -1 : 1,
                            child: JPTextButton(
                              onPressed: widget.onChangeFileStatus,
                              icon: statusToIcon(),
                              iconSize: 22,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),

                          JPTextButton(
                            onPressed: widget.onTapCancel,
                            icon: Icons.close_outlined,
                            iconSize: 22,
                            color: JPAppTheme.themeColors.red,
                          )
                        }
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Padding(
                    padding: const EdgeInsets.only(
                        left: 46,
                        right: 6
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Obx(() => LinearProgressIndicator(
                        minHeight: 3,
                        value: progressToValue(widget.data.progress!.value),
                        valueColor: progressColor(),
                        backgroundColor: JPAppTheme.themeColors.dimGray,
                      )),
                    )
                ),

                const SizedBox(
                  height: 5,
                ),

                if(widget.data.error != null && widget.data.error!.isNotEmpty)...{
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 46,
                        right: 4
                    ),
                    child: JPText(
                      text: widget.data.error!,
                      textAlign: TextAlign.start,
                      maxLine: 2,
                      textSize: JPTextSize.heading6,
                      textColor: JPAppTheme.themeColors.red,
                    ),
                  )
                }

              ],
            ),
          ),
        ),
        Divider(
          color: JPAppTheme.themeColors.dimGray,
          height: 1,
          indent: 62,
        )
      ],
    );
  }

  IconData statusToIcon() {

    if(widget.data.error != null) {
      return Icons.refresh;
    }

    switch (widget.data.fileStatus) {
      case FileUploadStatus.paused:
        return Icons.play_circle_outline;
      default:
        return Icons.pause_circle_outline;
    }
  }

  double? progressToValue(double val) {
    if(widget.data.error != null) {
      return 1;
    } else if(widget.data.fileStatus == FileUploadStatus.pending) {
      return 0;
    } else {
      return widget.data.progress?.value ?? 0;
    }
  }

  AlwaysStoppedAnimation<Color> progressColor() {
    if(widget.data.error != null) {
      return AlwaysStoppedAnimation(
        JPAppTheme.themeColors.red,
      );
    } else {
      return AlwaysStoppedAnimation(
        widget.data.progress?.value == 0 ? JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.5) : JPAppTheme.themeColors.primary,
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  bool get isLargeSizeImage => FileHelper.checkIfLargeFile(widget.data.localPath);

}
