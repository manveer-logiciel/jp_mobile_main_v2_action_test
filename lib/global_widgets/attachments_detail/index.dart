import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/attachments_detail/controller.dart';
import 'package:jobprogress/global_widgets/circular_progress_with_icon/index.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_thumb.dart';
import 'package:jp_mobile_flutter_ui/Thumb/image_thumb.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:path/path.dart';

class JPAttachmentDetail extends StatelessWidget {

  const JPAttachmentDetail({
    super.key,
    required this.attachments,
    this.controller,
    this.titleTextColor,
    this.tileTextColor,
    this.iconColor,
    this.titleText,
    this.titleFontWeight,
    this.titleTextSize,
    this.tileTextSize,
    this.tileFontWeight,
    this.suffixIcon,
    this.headerActions,
    this.onTapSuffixIcon,
    this.paddingLeft = 20,
    this.removeTitle = false,
    this.isAttachmentCount = true,
    this.disabled = false,
    this.addCallback,
    this.tapHereText,
    this.onTapCancelIcon,
    this.isEdit = false,
    this.openImageInJPPreview = false
  });

  final AttachmentController? controller;
  final List<AttachmentResourceModel> attachments;
  final String? titleText;
  final Color? titleTextColor;
  final JPFontWeight? titleFontWeight;
  final JPTextSize? titleTextSize;
  final Color? tileTextColor;
  final JPTextSize? tileTextSize;
  final JPFontWeight? tileFontWeight;
  final Color? iconColor;
  final IconData? suffixIcon;
  final List<Widget>? headerActions;
  final Function(int index)? onTapSuffixIcon;
  final double paddingLeft;
  final bool removeTitle;
  final bool isAttachmentCount;
  final bool disabled;
  final VoidCallback? addCallback;
  final String? tapHereText;
  final Function(int index)? onTapCancelIcon;
  final bool isEdit;
  final bool openImageInJPPreview;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AttachmentController>(
        key: UniqueKey(),
        init: AttachmentController(attachments),
        global: false,
        builder: (controller) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if(!removeTitle)
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: paddingLeft),
                          child: JPText(
                            text: titleText ?? 'ATTACHMENTS ',
                            textColor: titleTextColor,
                            textSize: titleTextSize,
                            fontWeight: titleFontWeight ?? JPFontWeight.medium,
                          ),
                        ),
                        if(controller.attachments.isNotEmpty && isAttachmentCount)
                          JPText(
                            text: ' (${controller.attachments.length})',
                            textColor: titleTextColor,
                            textSize: titleTextSize,
                            fontWeight: titleFontWeight ?? JPFontWeight.medium,
                          ),
                      ],
                    ),
                  ),
                if(headerActions != null)
                  Row(children: headerActions!,),
                const SizedBox(width: 20,)
              ],
            ),
            const SizedBox(height: 5,),
            controller.attachments.isEmpty && isEdit
              ? Padding(
                  padding: EdgeInsets.only(left: paddingLeft),
                    child: JPRichText(
                    text: JPTextSpan.getSpan('tap_here'.tr,
                      recognizer: TapGestureRecognizer()..onTap = disabled 
                        ? null : (addCallback ?? () {}),
                      textColor: JPAppTheme.themeColors.primary,
                      children: [
                        JPTextSpan.getSpan(
                          tapHereText ?? 'to_add_an_attachment'.tr,
                          textColor: JPAppTheme.themeColors.darkGray)
                      ]
                    ),
                  ),
                )
              : getAttachmentList(controller),
          ],
        )
    );
  }

  Widget getAttachmentList(AttachmentController controller) =>
      Column(
        key: const ValueKey(WidgetKeys.attachmentListKey),
        children: [
        for (int i = 0; i < controller.attachments.length; i++)
          Material(
            color: JPColor.transparent,
            child: InkWell(
              onTap: disabled || controller.attachments[i].downloadProgress != 0.00 ? null : () {
                controller.onTapFile(i, openImageInJPPreview: openImageInJPPreview);
              },
              child: Container(
                padding: EdgeInsets.only(left: paddingLeft,),
                child: Row(
                  children: [
                    getThumbnailWidget(controller, i),
                    const SizedBox(width: 19,),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 13, top: 13),
                        decoration: i < controller.attachments.length - 1
                            ? BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: JPAppTheme.themeColors.inverse)))
                            : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getFileNameWidget(controller, i),
                            const SizedBox(width: 8,),
                            getActionWidget(controller, i),
                            const SizedBox(width: 18,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ]);

  Widget getThumbnailWidget(AttachmentController controller, int index) =>
      Row(
        children: [
          if(FileHelper.checkIfImage(controller.getAttachmentExtension(index)))
          SizedBox(
            width: 30,
            child: JPThumbImage(
              size: ThumbSize.small,
              thumbImage:
              JPNetworkImage(
                src: controller.attachments[index].url!,
                boxFit: BoxFit.cover,
                borderRadius: 8,
              ),
            ),
          ),
          if(!FileHelper.checkIfImage(controller.getAttachmentExtension(index)))
          JPThumbIcon(
            size: ThumbSize.small,
            iconType: Helper.getIconTypeAccordingToExtension(controller.getAttachmentExtension(index)),
          )
        ],
      );

  Widget getFileNameWidget(AttachmentController controller, int index) =>
      Flexible(
        child: Row(
          children: [
            Flexible(
              child: JPText(
                textAlign: TextAlign.start,
                text: basenameWithoutExtension(controller.attachments[index].name ?? ''),
                overflow: TextOverflow.ellipsis,
                textSize: tileTextSize,
                textColor: tileTextColor,
                fontWeight: tileFontWeight,
              ),
            ),
            if(controller.attachments[index].extensionName != null)
              JPText(
                text: '.${controller.attachments[index].extensionName!}',
                textSize: tileTextSize,
                textColor: tileTextColor,
                fontWeight: tileFontWeight,
              )
          ],
        ),
      );

  Widget getActionWidget(AttachmentController controller, int index) =>
      Row(
        children: [
          controller.attachments[index].downloadProgress > 0
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            child: SizedBox(
              height: 24, width: 24,
              child: Center(
                child: ProgressWithIcon(
                  progressValue:
                  controller.attachments[index].downloadProgress,
                ),
              ),
            ),
          )
              : Row(
            children: [
              JPTextButton(
                icon: suffixIcon ?? Icons.remove_red_eye_outlined,
                color: iconColor ?? JPAppTheme.themeColors.tertiary,
                iconSize: 24,
                padding: 2,
                isDisabled: disabled,
                onPressed: onTapSuffixIcon != null
                    ? () => onTapSuffixIcon!(index)
                    : null,
              ),
              Visibility(
                visible: isEdit,
                child: JPTextButton(
                  key: ValueKey('${WidgetKeys.attachmentListKey}[$index]'),
                  icon: Icons.clear,
                  color: JPAppTheme.themeColors.red,
                  iconSize: 24,
                  isDisabled: disabled, 
                  onPressed: onTapCancelIcon != null
                      ? () => onTapCancelIcon!(index)
                      : null,
                  padding: 2,
                ),
              ),
            ],
          ),
        ],
      );
}
