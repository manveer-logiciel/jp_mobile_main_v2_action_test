import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UserListItemForPopMenuItem extends StatelessWidget {
  final UserLimitedModel user;
  final Widget? suffixWidget;

  const UserListItemForPopMenuItem({
    super.key,
    required this.user,
    this.suffixWidget
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        JPProfileImage(
          src: user.profilePic,
          color: user.color,
          initial: user.intial ?? ''),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: JPText(
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          text: Helper.getWorkCrewName(user, byRoleName: true),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        suffixWidget != null ? suffixWidget! : const SizedBox.shrink()
      ],
    );
  }
}
