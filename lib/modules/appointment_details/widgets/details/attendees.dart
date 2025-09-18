import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/global_widgets/attendee_item_for_pop_up_menu/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentAttendees extends StatelessWidget {

  const AppointmentAttendees({
    super.key,
    required this.attendees,
  });

  final List<UserLimitedModel> attendees;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPText(
          text: 'additional_attendees'.tr,
          textColor: JPAppTheme.themeColors.tertiary,
          textSize: JPTextSize.heading5,
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          runSpacing: 6,
          spacing: 5,
          children: List.generate(attendees.length > 6 ? 6 : attendees.length,
              (index) {
            final attendee = attendees[index];

            if (index < 5) {
              return JPChip(
                text: attendee.fullName,
                child: JPProfileImage(
                  src: attendee.profilePic,
                  initial: attendee.intial,
                  color: attendee.color,
                ),
              );
            } else {
              return JPPopUpMenuButton<UserLimitedModel>(
                itemList: attendees.sublist(5, attendees.length),
                popUpMenuChild: (UserLimitedModel val) {
                  return AttendeeListItemForPopMenuItem(
                    attendee: val,
                  );
                },
                popUpMenuButtonChild: JPTextButton(
                  text: '+${attendees.length - 5} ${'more'.tr}',
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
        )
      ],
    );
  }
}
