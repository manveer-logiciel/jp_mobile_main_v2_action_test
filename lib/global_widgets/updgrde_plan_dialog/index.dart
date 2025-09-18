import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';

class UpgradePlanDialog extends StatelessWidget {
  final String billingCode;
  final JPBottomSheetController controller;
  final String? title;
  final String subTitle;
  final IconData? dialogIcon;

  const UpgradePlanDialog({
    super.key,
    required this.billingCode,
    required this.controller,
    this.title,
    required this.subTitle, 
    this.dialogIcon,

  });

  @override
  Widget build(BuildContext context) {
    return JPConfirmationDialog(
      icon: dialogIcon ?? Icons.schedule_outlined ,
      title: title ?? '',
      subTitle: subTitle.tr,
      suffixBtnText: controller.isLoading ? null : 'upgrade'.tr,
      disableButtons: controller.isLoading,
      suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
      onTapSuffix: () async {
        controller.toggleIsLoading();
        await Helper.launchUrl(Urls.upgradeUrl(billingCode));
        Get.back();
      },
    );
  }
}