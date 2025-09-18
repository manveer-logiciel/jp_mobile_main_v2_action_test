import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';

class TaskParticipantList extends StatelessWidget {
  final UserLimitedModel user;
  const TaskParticipantList(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: 0.8,
      child: JPProfileImage(src: user.profilePic, initial: user.intial, color:user.color,)
    );
  }
}
