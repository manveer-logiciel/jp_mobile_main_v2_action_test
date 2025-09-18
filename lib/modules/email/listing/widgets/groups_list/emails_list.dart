import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/common/models/email/email_group.dart';
import 'package:jobprogress/core/utils/color_helper.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/modules/email/listing/widgets/groups_list/list_tile.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/Constants/screen.dart';

class EmailsList extends StatelessWidget {
  const EmailsList({
    super.key,
    required this.emails,
    required this.showFirstLetterOfEmail,
    required this.showEmailListWithThreeDots,
    required this.onTap,
    required this.onLongPress,
    this.selectedId
  });

  final GroupEmailListingModel emails;

  final String Function(EmailListingModel email) showFirstLetterOfEmail;

  final String Function(EmailListingModel email) showEmailListWithThreeDots;

  final Function(int i) onTap;

  final Function(int i) onLongPress;

  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        JPListView(
          listCount: emails.groupValues.length - 1,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (_, index) {
            return EmailListTile(
              email: emails.groupValues[index],
              avatarColor: ColorHelper.companyContactAvatarColors[index % 8],
              showFirstLetterOfEmail: showFirstLetterOfEmail,
              showEmailListWithThreeDots: showEmailListWithThreeDots,
              onTap: () => onTap(index),
              onLongPress: () => onLongPress(index),
              isFirst: index == 0,
              isLast: index == emails.groupValues.length - 1,
              isSelected: emails.groupValues[index].id == selectedId && JPScreen.isDesktop,
            );
          },
        ),
      ],
    );
  }
}
