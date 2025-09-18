import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/modules/company_contacts/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CompanyContactSelectedContactItem extends StatelessWidget {
  final CompanyContactListingController controller;
  const CompanyContactSelectedContactItem({
    required this.controller,
    required this.item,
    required this.animation,
    super.key
  });

  final CompanyContactListingModel item;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    controller.deviceWidth = MediaQuery.of(context).size.width;

    return  Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(
          horizontal: 6
      ),
      child: ScaleTransition(
          scale: animation,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                JPBubble(
                  bubbleType: JPBubbleType.avatar,
                  avatarSize: JPAvatarSize.large,
                  onTapIconButton: () {
                    controller.removeSelectedContact(item);
                  },
                  child: JPAvatar(
                    size: JPAvatarSize.large,
                    backgroundColor: item.color,
                    child: JPText(
                      text: '${item.firstName![0].toString().toUpperCase()}'
                          '${item.lastName![0].toString().toUpperCase()}',
                      textSize: JPTextSize.heading3,
                      textColor: JPAppTheme.themeColors.base,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  constraints: const BoxConstraints(maxWidth: 80),
                  child: JPText(
                    text: item.fullName!..toString(),
                    textColor: JPAppTheme.themeColors.tertiary,
                    overflow: TextOverflow.ellipsis
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}