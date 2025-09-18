import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/email_button_type.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/email_button/index.dart';
import 'package:jobprogress/global_widgets/message/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/my_profile/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

const maxBackBordSize = 206.0;
const minBackBordSize = 151.0;
const maxBackBordTop = 117.0;
const minBackBordTop = 46.0;

const maxHeaderExtent = 317.0;
const minHeaderExtent = 197.0;
const maxAvatarSize = 128.0;
const minAvatarSize = 62.0;
const maxAvatarTop = 53.0;
const minAvatarTop = 18.0;

const maxTextBoxHeight = 30.0;
const minTextBoxHeight = 22.0;
const maxFontSize = 42.0;
const minFontSize = 24.0;
const maxNameFontSize = 24.0;
const minNameFontSize = 20.0;
const maxNameFontTop = 175.0;
const minNameFontTop = 88.0;
const maxRowIconTop = 261.0;
const minRowIconTop = 130.0;

class MyProfileHeader extends SliverPersistentHeaderDelegate {
  MyProfileHeader({ required this.controller, Key? key });
  final MyProfileController controller;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    double avatarSize = maxAvatarSize - minAvatarSize;
    double avatarTop = maxAvatarTop - minAvatarTop;
    double fontSize = maxFontSize - minFontSize;
    double nameFontSize = maxNameFontSize - minNameFontSize;
    double backBordSize = maxBackBordSize - minBackBordSize;
    double backBordTop = maxBackBordTop - minBackBordTop;
    double nameFontTop = maxNameFontTop - minNameFontTop;
    double rowIconTop = maxRowIconTop - minRowIconTop;

      
    double scaleFactor(double shrinkOffset) {
      final ratio = (maxExtent - minExtent) / 100;
      double percentageHeight = shrinkOffset / ratio;
      double limitedPercentageHeight =
        percentageHeight >= 100 ? 100 : percentageHeight;
      return 1 - (limitedPercentageHeight / 100);
    }

    double currentAvatarSize(double shrinkOffset) {
      return avatarSize * scaleFactor(shrinkOffset)+minAvatarSize;
    }

    double currentAvatarTop(double shrinkOffset) {
      return avatarTop * scaleFactor(shrinkOffset)+minAvatarTop;
    }

    double currentFontSize(double shrinkOffset) {
      return fontSize * scaleFactor(shrinkOffset)+minFontSize;
    }
    
    double currentNameFontSize(double shrinkOffset) {
      return nameFontSize * scaleFactor(shrinkOffset) + minNameFontSize;
    }

    double currentBackBordSize(double shrinkOffset) {
      return backBordSize * scaleFactor(shrinkOffset)+minBackBordSize;
    }

    double currentBackBordTop(double shrinkOffset) {
      return backBordTop * scaleFactor(shrinkOffset)+minBackBordTop;
    }

    double currentTextBoxHeight(double shrinkOffset) {
      return backBordSize * scaleFactor(shrinkOffset)+minTextBoxHeight;
    }

    double currentNameFontTop(double shrinkOffset) {
      return nameFontTop * scaleFactor(shrinkOffset)+minNameFontTop;
    }

    double currentRowIconTop(double shrinkOffset) {
      return rowIconTop * scaleFactor(shrinkOffset) + minRowIconTop;
    }

    return Container(
      height: 323,
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.inverse,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 5,
            child: Material(
              color: JPAppTheme.themeColors.inverse,
              child: IconButton(
                splashRadius: 20,
                onPressed: () {
                  Get.back();
                },
                icon: JPIcon(
                  Icons.arrow_back,
                  color: JPAppTheme.themeColors.text,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 5,
            child: Material(
              color: JPAppTheme.themeColors.inverse,
              child: IconButton(
                splashRadius: 20,
                onPressed: () {
                  controller.scaffoldKey.currentState!.openEndDrawer();
                },
                icon: JPIcon(
                  Icons.menu,
                  color: JPAppTheme.themeColors.text,
                ),
              ),
            ),
          ),
          Positioned(
            top: currentBackBordTop(shrinkOffset),
            bottom: 0,
            child: Container(
              height: currentBackBordSize(shrinkOffset),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: JPAppTheme.themeColors.base,
              ),
            )
          ),
          Positioned(
            top: currentAvatarTop(shrinkOffset),
            left: (MediaQuery.of(context).size.width * 0.5) -
                (currentAvatarSize(shrinkOffset) / 2),
            right: (MediaQuery.of(context).size.width * 0.5) -
                (currentAvatarSize(shrinkOffset) / 2),
            child: JPProfileImage(
              radius: 200,
              height: currentAvatarSize(shrinkOffset),
              width: currentAvatarSize(shrinkOffset),
              color: controller.userDetails!.color!,
              src: controller.userDetails?.profilePic ,
              initial: controller.userDetails?.intial,
              dynamicFontSize: currentFontSize(shrinkOffset) ,
            ) 
          ),
          Positioned(
            left: 44,
            right: 43,
            top: currentNameFontTop(shrinkOffset),
            child: SizedBox(
              height: currentTextBoxHeight(shrinkOffset) + 10,
              width: 288,
              child: Center(
                child: JPText(
                  text: controller.userDetails!.fullName.capitalize ?? '',
                  dynamicFontSize: currentNameFontSize(shrinkOffset),
                  fontWeight: JPFontWeight.bold,
                ),
              ),
            )
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.255,
            right: MediaQuery.of(context).size.width * 0.26,
            top: currentRowIconTop(shrinkOffset),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Helper.launchCall(controller.userDetails!.phones![0].number!.trim());
                  },
                  child: Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: JPAppTheme.themeColors.primary),
                    child: JPIcon(
                      Icons.local_phone,
                      color: JPAppTheme.themeColors.base,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                if(controller.userDetails != null && controller.userDetails!.phones != null && controller.userDetails!.phones!.isNotEmpty)
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: JPAppTheme.themeColors.primary),
                      child: JPSaveMessageLog(
                        phone: controller.userDetails!.phones![0].number!.trim(),
                        isLargeIcon: true,
                      )
                ),
                const SizedBox(
                  width: 15,
                ),
                JPEmailButton(
                  email:controller.userDetails!.email,
                  fullName: controller.userDetails!.fullName, 
                  type: EmailButtonType.iconInAvtar
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderExtent;

  @override
  double get minExtent => minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
