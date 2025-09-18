import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/chip_with_avtar/index.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/enums/jpchip_type.dart';
import '../../common/models/sql/flag/flag.dart';
import '../../common/models/sql/user/user_limited.dart';
import '../../core/constants/widget_keys.dart';
import '../attendee_item_for_pop_up_menu/index.dart';

class JPChipWithAvatar extends StatelessWidget {
  const JPChipWithAvatar({
    super.key,
    required this.jpChipType,
    this.flagList,
    this.userLimitedModelList,
    this.addCallback});

  final List<FlagModel?>? flagList;
  final List<UserLimitedModel>? userLimitedModelList;
  final JPChipType? jpChipType;
  final void Function()? addCallback;

  @override
  Widget build(BuildContext context) {
    switch(jpChipType) {
      case JPChipType.flags:
        return flagWidget();
      case JPChipType.flagsWithAddMoreButton:
        return flagWithAddMoreWidget();
      case JPChipType.users:
        return userWidget();
      case JPChipType.userWithMoreButton:
        return userWithMoreWidget();
      default :
        return const SizedBox.shrink();
    }
  }

  Widget flagWidget() {
    return Wrap(
      key: const Key(WidgetKeys.chipWithAvatarKey),
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate((
        flagList!.length),
        (index) => Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: JPChip(
                text: flagList![index]!.title,
                textSize: JPTextSize.heading5,
                avatarRadius: 10,
                avatarBorderColor: JPAppTheme.themeColors.inverse,
                backgroundColor: JPAppTheme.themeColors.inverse,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: JPAvatar(
                      key:ValueKey('${WidgetKeys.chipWithAvatarKey}[$index]'),
                      size: JPAvatarSize.small,
                      backgroundColor: JPChipWithAvatarService.evaluateBackgroundColor(flagList?[index]?.color),
                      child: JPIcon(Icons.flag, color: JPAppTheme.themeColors.base, size: 15,),
                    ),
                ),
              ),
            )
      ),
    );
  }

  Widget flagWithAddMoreWidget() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.start,
      children: List.generate(((flagList!.length) + 1),
        (index) => index < (flagList!.length)
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: JPChip(
                text: flagList![index]!.title,
                textSize: JPTextSize.heading5,
                avatarRadius: 10,
                avatarBorderColor: JPAppTheme.themeColors.inverse,
                backgroundColor: JPAppTheme.themeColors.inverse,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: JPAvatar(size: JPAvatarSize.small,
                      backgroundColor: JPChipWithAvatarService.evaluateBackgroundColor(flagList?[index]?.color),
                      child: JPIcon(Icons.flag, color: JPAppTheme.themeColors.base, size: 15,),
                    ),
                ),
              ),
            )
            : flagList!.isEmpty
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                child: JPRichText(
                  text: JPTextSpan.getSpan(
                    '${'tap_here'.tr} ',
                    recognizer: TapGestureRecognizer()..onTap = addCallback ?? () {},
                    textColor: JPAppTheme.themeColors.primary,
                    children: [
                      JPTextSpan.getSpan('to_add_flag'.tr, textSize: JPTextSize.heading4, textColor: JPAppTheme.themeColors.darkGray)
                    ]
                  ),
                ),
              )
            : Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
              child: JPTextButton(
                text: '+ ${"addMore".tr}',
                isExpanded: false,
                textSize: JPTextSize.heading4,
                fontWeight: JPFontWeight.medium,
                color: JPAppTheme.themeColors.primary,
                padding: 4,
                onPressed: addCallback ?? () {} ,
              ),
            ),
      ),
    );
  }

  Widget userWidget() {
    return Wrap(
      runSpacing: 6,
      spacing: 5,
      children: List.generate(
        userLimitedModelList!.length,
        (index) {
          return JPChip(
            text: userLimitedModelList![index].fullName,
            child: JPProfileImage(
              src: userLimitedModelList![index].profilePic,
              initial: userLimitedModelList![index].intial,
              color: userLimitedModelList![index].color,
            ),
          );
        }),
    );
  }

  Widget userWithMoreWidget() {
    return Wrap(
      runSpacing: 6,
      spacing: 5,
      children: List.generate(userLimitedModelList!.length > 6 ? 6 : userLimitedModelList!.length,
              (index) {
            final attendee = userLimitedModelList![index];
            if (index < 5) {
              return JPChip(
                text: Helper.getWorkCrewName(attendee, byRoleName: true),
                child: JPProfileImage(
                  src: attendee.profilePic,
                  initial: attendee.intial,
                  color: attendee.color,
                ),
              );
            } else {

              return JPPopUpMenuButton<UserLimitedModel>(
                itemList: userLimitedModelList!.sublist(5, userLimitedModelList!.length),
                popUpMenuChild: (UserLimitedModel val) {
                  return AttendeeListItemForPopMenuItem(
                    attendee: val,
                  );
                },
                popUpMenuButtonChild: JPTextButton(
                  text: '+${userLimitedModelList!.length - 5} ${'more'.tr}',
                  isExpanded: false,
                  textSize: JPTextSize.heading4,
                  fontWeight: JPFontWeight.medium,
                  color: JPAppTheme.themeColors.primary,
                  padding: 4,
                ),
                childPadding: const EdgeInsets.only(left: 16, right: 16, top: 9, bottom: 9),
              );
            }
          }),
    );
  }
}