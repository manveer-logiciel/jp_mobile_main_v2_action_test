import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/firebase/firestore/group_message.dart';
import 'package:jobprogress/common/models/firebase/firestore/message_media.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/chats/messages/widgets/error_popup/index.dart';
import 'package:jobprogress/modules/chats/messages/widgets/list_tile/media/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    this.isGroup = false,
    this.isReply = false,
    this.onTapFile,
    required this.data,
    this.onTapTryAgain,
    this.onTapCancel,
    this.isAutomated = false,
  });

  final bool isGroup;
  final bool isReply;
  final bool isAutomated;

  final GroupMessageModel data;

  final Function(MessageMediaModel)? onTapFile;

  final VoidCallback? onTapTryAgain;
  final VoidCallback? onTapCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: (isSystemMessage || data.isMyMessage) ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showUserDetails && !isSystemMessage) ...{
            JPAvatar(
              size: JPAvatarSize.small,
              child: profileWidget,
            ),
            const SizedBox(
              width: 10,
            ),
          },

          Flexible(
            child: Column(
              crossAxisAlignment: isSystemMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (showUserDetails && !isSystemMessage) ...{
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ChatsConstants.maxMessageWidth
                    ),
                    child: JPText(
                      text: FirestoreHelpers.getUserName(data.user,isAutomated: isAutomated),
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading5,
                      maxLine: 1,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                },
                if (showUserDetails && isSystemMessage) ...{
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ChatsConstants.maxMessageWidth
                        ),
                        child: JPText(
                          text: FirestoreHelpers.getUserName(data.user,isAutomated: isAutomated),
                          textColor: JPAppTheme.themeColors.tertiary,
                          textSize: JPTextSize.heading5,
                          maxLine: 1,
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: JPAppTheme.themeColors.themeGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AssetsFiles.automatedTextIcon,
                            width: 10,
                            height: 10,
                            colorFilter: ColorFilter.mode(
                              JPAppTheme.themeColors.base,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                },
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    if(data.error != null) ...{
                      errorIcon,
                      const SizedBox(
                        width: 5,
                      ),
                    },

                    Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: ChatsConstants.maxMessageWidth,
                        ),
                        decoration: messageDecoration,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                if (data.content?.isNotEmpty ?? false) ...{
                                  textMessage,
                                  if(data.media == null) SizedBox(
                                    height: data.isLastLineOfFullWidth &&
                                        data.isMultilineText ? 20 : 10,
                                  ),
                                },

                                if(data.media != null)...{
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  MediaTypeToFile(
                                    media: data.media,
                                    isMyMessage: data.isMyMessage,
                                    onTapFile: onTapFile,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                },
                              ],
                            ),

                            Positioned(
                              bottom: 5,
                              right: 10,
                              child: JPText(
                                text: DateTimeHelper.format(data.updatedAt, DateFormatConstants.timeOnlyFormat),
                                textSize: JPTextSize.heading5,
                                textColor: timeColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                /// message failure buttons
                if(data.error != null) ...{
                  const SizedBox(height: 3,),
                  errorButtons,
                }

              ],
            ),
          ),
        ],
      ),
    );
  }

  bool get showUserDetails => (isGroup || isAutomated) && !data.isMyMessage;

  bool get isSystemMessage => isAutomated && data.user?.groupId == UserGroupIdConstants.anonymous && !data.isMyMessage;

  Color get messageTextColor => data.isMyMessage
      ? JPAppTheme.themeColors.base
      : JPAppTheme.themeColors.tertiary;

  Color get timeColor => data.isMyMessage
      ? JPAppTheme.themeColors.inverse
      : JPAppTheme.themeColors.secondaryText;

  Color get messageColor => data.isMyMessage
      ? JPAppTheme.themeColors.primary
      : JPAppTheme.themeColors.inverse;

  Color get replyColor => data.isMyMessage
      ? JPAppTheme.themeColors.inverse
      : JPAppTheme.themeColors.secondaryText;

  BorderRadius get borderRadius {
    if (isSystemMessage) {
      return const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10));
    } else if (data.isMyMessage) {
      return const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10));
    } else {
      return const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10));
    }
  }

  /// profileWidget displays right profile widget as per data available
  Widget get profileWidget {
    return JPProfileImage(
      src: data.user?.profilePic,
      color: data.user?.color,
      initial: placeHolderText,
      size: JPAvatarSize.medium,
    );
  }

  String get placeHolderText => data.user == null
      ? ""
      : data.user!.firstName[0] + (data.user?.lastName?[0] ?? '');

  Widget get textMessage => Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: data.isMultilineText ? 10 : 90,
          bottom: JPScreen.isDesktop ? 5 : 0
        ),
        child: JPText(
          text: data.content ?? "",
          textAlign: TextAlign.start,
          textColor: messageTextColor,
          textSize: JPTextSize.heading4,
          height: data.isMultilineText ? 1.3 : null,
        ),
      );

  Decoration get messageDecoration {
    if (isSystemMessage) {
      // Green border for system messages
      return BoxDecoration(
        borderRadius: borderRadius,
        color: JPAppTheme.themeColors.inverse,
        border: Border.all(
          color: JPAppTheme.themeColors.themeGreen,
          width: 2.0,
        ),
      );
    } else if (data.isMyMessage) {
      return BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
            colors: [
              JPAppTheme.themeColors.primary,
              JPAppTheme.themeColors.gradientblue,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
        ),
      );
    } else {
      return BoxDecoration(
          borderRadius: borderRadius,
          color: JPAppTheme.themeColors.inverse
      );
    }
  }

  Widget get errorButtons => ValueListenableBuilder(
    valueListenable: data.isTryingAgain ?? ValueNotifier(false),
    builder: (_, bool val, Widget? child) {
      return IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 22,
            ),
            JPTextButton(
              text: 'try_again'.tr,
              padding: 2,
              color: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
              onPressed: onTapTryAgain,
              isDisabled: val,
            ),
            VerticalDivider(
              width: 5,
              indent: 4,
              thickness: 1,
              endIndent: 4,
              color: JPAppTheme.themeColors.tertiary,
            ),
            JPTextButton(
              text: 'cancel'.tr,
              padding: 2,
              color: JPAppTheme.themeColors.primary,
              textSize: JPTextSize.heading5,
              onPressed: onTapCancel,
              isDisabled: val,
            ),
          ],
        ),
      );
    },
  );

  Widget get errorIcon => ValueListenableBuilder(
      valueListenable: data.isTryingAgain ?? ValueNotifier(false),
      builder: (_, bool val, Widget? child) {
        if(val) {
          return loadingCircle;
        } else {
          return child ?? const SizedBox();
        }
      },
    child: JPPopUpMenuButton<Widget>(
      itemList: [
        MessageErrorPopUp(
          error: data.error!,
        )
      ],
      popUpMenuChild: (val) {
        return val;
      },
      offset: const Offset(100, 32),
      popUpMenuButtonChild: JPIcon(
        Icons.info,
        size: 18,
        color: JPAppTheme.themeColors.secondary,
      ),
    ),
  );

  Widget get loadingCircle => Center(
    child: FadingCircle(
      color: JPAppTheme.themeColors.primary,
      size: 18,
    ),
  );
}
