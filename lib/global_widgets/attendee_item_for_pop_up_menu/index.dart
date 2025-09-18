
import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

// AttendeeListItemForPopMenuItem can be used to display attendee data in popup menu item
class AttendeeListItemForPopMenuItem extends StatelessWidget {

  const AttendeeListItemForPopMenuItem({
    super.key,
    required this.attendee,
  });

  final UserLimitedModel attendee;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        JPProfileImage(src: attendee.profilePic,color: attendee.color, initial: attendee.intial,),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: JPText(
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              text: Helper.getWorkCrewName(attendee, byRoleName: true)
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

