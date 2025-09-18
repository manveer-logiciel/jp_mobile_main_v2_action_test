import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/global_widgets/main_drawer/user_tracking.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPMainDrawerHeader extends StatelessWidget {
  final UserModel loggedInUser;

  const JPMainDrawerHeader({super.key, required this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: JPAppTheme.themeColors.inverse,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
              )),
          padding: const EdgeInsets.only(top: 15, bottom: 15, left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    JPProfileImage(src: loggedInUser.profilePic, color: loggedInUser.color,initial: loggedInUser.intial,size: JPAvatarSize.medium),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          JPText(
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            textSize: JPTextSize.heading3,
                            fontWeight: JPFontWeight.medium,
                            text: loggedInUser.fullName,
                          ),
                          const SizedBox(height: 5),
                          JPText(
                            text: loggedInUser.email!,
                            textAlign: TextAlign.left,
                            textSize: JPTextSize.heading5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Material(
                    shape: const CircleBorder(),
                    color: JPAppTheme.themeColors.inverse,
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minHeight: 30, minWidth: 30),
                      icon: const JPIcon(
                        Icons.search,
                      ),
                      onPressed: () {
                        Get.back();
                        Get.offCurrentToNamed(Routes.customerJobSearch, arguments: {NavigationParams.pageType: PageType.home});
                      },
                    ),
                  ),
                  Material(
                    shape: const CircleBorder(),
                    color: JPAppTheme.themeColors.inverse,
                    clipBehavior: Clip.hardEdge,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minHeight: 30, minWidth: 30),
                      icon: const JPIcon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if(!Get.testMode )
        const UserTrackingDrawerLabel(),
      ],
    );
  }
}
