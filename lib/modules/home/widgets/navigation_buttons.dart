import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/widget_keys.dart';

class HomePageNavigationButtons extends StatelessWidget {
  const HomePageNavigationButtons({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {

    final JPButtonSize btnSize = Get.width <= 375 ? JPButtonSize.medium : JPButtonSize.large;

    return Container(
      margin: const EdgeInsets.only(left: 38, right: 38),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: JPButton(
              key: const ValueKey(WidgetKeys.customerManager),
              size: btnSize,
              width: double.maxFinite,
              text: "customer_manager".tr.toUpperCase(),
              colorType: JPButtonColorType.secondary,
              onPressed: () => Get.toNamed(Routes.customerListing),
            ),
          ),
          HasPermission(
            permissions: const [PermissionConstants.viewProgressBoard,PermissionConstants.manageProgressBoard],
            child: Visibility(
              visible: !AuthService.isPrimeSubUser(),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: JPButton(
                  size: btnSize,
                  width: double.maxFinite,
                  text: "progress_board".tr.toUpperCase(),
                  colorType: JPButtonColorType.secondary,
                  onPressed: () => Get.toNamed(Routes.progressBoard, preventDuplicates: false),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: JPButton(
              size: btnSize,
              width: double.maxFinite,
              text: "daily_plan".tr.toUpperCase(),
              colorType: JPButtonColorType.secondary,
              onPressed: () => Get.toNamed(Routes.dailyPlan),
            ),
          ),
          JPButton(
            size: btnSize,
            width: double.maxFinite,
            text: "my_calendar".tr.toUpperCase(),
            colorType: JPButtonColorType.secondary,
            onPressed: () => Get.toNamed(Routes.calendar),
          ),
        ],
      ),
    );
  }
}