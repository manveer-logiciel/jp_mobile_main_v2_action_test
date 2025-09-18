import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/schedule_details/status_icon.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_icon.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailWorkCrewChip extends StatelessWidget {
  const ScheduleDetailWorkCrewChip({
    super.key,
    required this.workCrew,
    this.onStatusTap
  });

  final UserLimitedModel workCrew;
  final Function(PopoverActionModel)? onStatusTap;

  @override
  Widget build(BuildContext context) {
    return JPChip(
      text: Helper.getWorkCrewName(workCrew),
      suffixWidget: onStatusTap == null || workCrew.status == null || workCrew.status!.isEmpty ? null : getSuffixWidget(),
      child: JPProfileImage(
        src: workCrew.profilePic,
        color:workCrew.color,
        initial: workCrew.intial ?? ''
      )
    );
  }

  Widget getSuffixWidget() {
    return (workCrew.id == AuthService.userDetails!.id ?  JPPopUpMenuButton(
        popUpMenuButtonChild: ScheduleDetailStatusIcon(status: workCrew.status.toString(),),
        childPadding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        itemList: ScheduleStatusActions.getActions(),
        onTap: (PopoverActionModel selected) {
          onStatusTap!(selected);
        },
        popUpMenuChild: (PopoverActionModel val) {
          return Row(
              children: [
                ScheduleDetailStatusIcon(status: val.value),
                const SizedBox(
                  width: 10,
                ),
                JPText(text: val.label)
              ],
            );
        }
      ) : workCrew.status != null && workCrew.status!.isNotEmpty ? ScheduleDetailStatusIcon(status: workCrew.status.toString()) : const SizedBox.shrink());
  }
}
