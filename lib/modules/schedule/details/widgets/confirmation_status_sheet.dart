import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/schedule_details/status_icon.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_icon.dart';
import 'package:jobprogress/modules/schedule/details/widgets/status_icon_with_text.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleConfirmationStatusBottomSheet extends StatelessWidget {
  const ScheduleConfirmationStatusBottomSheet(
      {required this.controller,
      super.key});
  final ScheduleDetailController controller;

  Widget getHeader() {
    return Column(
      children: [
        Container(
          height: 3,
          width: 30,
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          color: JPAppTheme.themeColors.inverse,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, bottom: 5),
                child: JPText(
                    text: 'confirmation status'.toUpperCase(),
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading3)),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5),
              child: Material(
                color: JPAppTheme.themeColors.base,
                child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Get.back();
                    },
                    child: const SizedBox(
                        height: 35, width: 35, child: Icon(Icons.close))),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget getStatusIcon(UserLimitedModel workcrew, {bool currentUser = false}) {
    if (workcrew.status == 'accept') {
      return ScheduleStatusIconWithText(
        icon: Icons.check_circle,
        text: 'confirmed'.tr,
        textColor: JPAppTheme.themeColors.success,
        color: JPAppTheme.themeColors.success,
        canShowArrow: currentUser,
      );
    }
    if (workcrew.status == 'decline') {
      return ScheduleStatusIconWithText(
        icon: Icons.cancel,
        text: 'declined'.tr,
        textColor: JPAppTheme.themeColors.secondary,
        color: JPAppTheme.themeColors.secondary,
        canShowArrow: currentUser,
      );
    }
    return ScheduleStatusIconWithText(
      icon: Icons.pending,
      text: 'pending'.tr,
      textColor: JPAppTheme.themeColors.warning,
      color: JPAppTheme.themeColors.warning,
      canShowArrow: currentUser,
    );
  }

  Widget workCrewListItems(UserLimitedModel workcrew) => Container(
    height: 36,
    padding: const EdgeInsets.only(left: 20, right: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: JPProfileImage(
                        src: workcrew.profilePic,
                        initial: workcrew.intial ?? '',
                        color: workcrew.color,
                      )
                    ),
                    Flexible(
                      child: JPText(text: Helper.getWorkCrewName(workcrew), 
                      overflow: TextOverflow.ellipsis
                    )),
                  ],
                ),
              ),
              workcrew.id == AuthService.userDetails!.id ? 
               JPPopUpMenuButton(
                  popUpMenuButtonChild: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 3, right: 0),
                    child: getStatusIcon(workcrew, currentUser: true)
                  ),
                  childPadding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                  itemList: ScheduleStatusActions.getActions(),
                  onTap: (PopoverActionModel selected) {
                    controller.handleStatusActions(selected.value);
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
                  },
               ) :
              getStatusIcon(workcrew)
            ],
          ),
        ),
      ],
    ),
  );

  Widget getList() {
     return (controller.schedulesDetails!.workCrew!.isEmpty)
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: JPText(
            text: 'no_record_found'.capitalize! ,
            textSize: JPTextSize.heading4,
          ))
      : ListView.separated(
        padding: const EdgeInsets.only(bottom: 21),
        shrinkWrap: true,
          itemCount: controller.schedulesDetails!.workCrew!.length,
          separatorBuilder: (_, index) {
            return const SizedBox(height: 5,);
          },
          itemBuilder: (_, index) {
            return GetBuilder<ScheduleDetailController>(
              init: controller,
              builder: (context) {
                return Material(
                  color: JPAppTheme.themeColors.base,
                  child: workCrewListItems(controller.schedulesDetails!.workCrew![index]),
                );
              }
            );
          });
  }

  @override
  Widget build(BuildContext context) {

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: JPAppTheme.themeColors.base,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: JPScreen.isTablet ? const Radius.circular(20) : const Radius.circular(0),
                  bottomRight: JPScreen.isTablet ? const Radius.circular(20) : const Radius.circular(0),
              )),
          child: JPSafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getHeader(),
                Flexible(child: getList()),
              ],
            ),
          )),
    );

  }
}
