
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/list_tile/footer.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/list_tile/header.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class GroupThreadTile extends StatelessWidget {
  const GroupThreadTile({
    super.key,
    required this.index,
    required this.data,
    required this.onTapGroup,
    required this.onLongPressGroup,
    this.isSelected = false,
    this.showAutomatedPill = true,
  });

  /// index to display color on profile placeholder
  final int index;

  /// data contains threads data
  final ChatGroupModel data;

  final Function(String, Widget) onTapGroup;

  final Function(int) onLongPressGroup;

  final bool isSelected;

  final bool showAutomatedPill;

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isSelected
              ? JPAppTheme.themeColors.lightBlue
              : JPAppTheme.themeColors.base,
          child: InkWell(
            onTap: () {
              onTapGroup(
                data.groupId!, getProfileAvatar(
                  size: JPAvatarSize.small
              ),
              );
            },
            onLongPress: () {
              onLongPressGroup(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getProfileAvatar(),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatsMessageTileHeader(
                          title: data.groupTitle ?? "-",
                          time: data.updatedAt,
                        ),
                        ChatsMessageTileFooter(
                          lastMessage: data.recentMessage,
                          job: data.job,
                          messageCount: data.unreadMessageCount ?? 0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: JPAppTheme.themeColors.dimGray,
          indent: 75,
        )
      ],
    );

  }

  /// profileWidget displays right profile widget as per data available
  Widget getProfileWidget({JPTextSize? textSize}) {
    // Check if this is an automated conversation
    if (data.isAutomated ?? false) {
      // Return robot icon for automated conversations
      return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: JPAppTheme.themeColors.themeGreen,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: SvgPicture.asset(
            AssetsFiles.automatedTextIcon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              JPAppTheme.themeColors.base,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }
    
    // Return normal profile widget for regular conversations
    return data.isGroup ?? false
        ? Image.asset('assets/images/group-profile.jpg')
        : JPNetworkImage(
            src: data.profileImage,
            height: double.maxFinite,
            width: double.maxFinite,
            placeHolder: Center(
              child: JPText(
                text: placeHolderText,
                textColor: JPAppTheme.themeColors.base,
                textSize: textSize ?? JPTextSize.heading3,
              ),
            ),
          );
  }

  String get placeHolderText =>
      data.groupProfileText ??
      ("${data.groupTitle ?? ""}  ").substring(0, 2).toUpperCase();

  Widget getProfileAvatar({JPAvatarSize? size}) {
  return JPAvatar(
    size: size ?? JPAvatarSize.large,
    backgroundColor: data.isGroup ?? false
        ? JPAppTheme.themeColors.dimGray
        : data.profileImage != null ? JPColor.transparent:  ColorHelper.companyContactAvatarColors[(index % 8)],
    child: Center(
      child: getProfileWidget(
        textSize: size == null ? JPTextSize.heading3 : JPTextSize.heading5
      ),
    ),
  );
  }

}
