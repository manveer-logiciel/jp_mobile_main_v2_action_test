import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jp_mobile_flutter_ui/animations/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPPopUpBuilder extends StatelessWidget {
  const JPPopUpBuilder(
      {super.key,
      required this.child,
      this.allowFullWidth = false,
      this.enableInsets = false});

  final bool allowFullWidth;
  final bool enableInsets;
  final Widget Function(JPBottomSheetController controller) child;

  Widget get popOverChild => GetBuilder<JPBottomSheetController>(
      init: JPBottomSheetController(),
      global: false,
      builder: (controller) {
        return child(controller);
      });

  @override
  Widget build(BuildContext context) {
    switch (JPScreen.type) {
      case DeviceType.mobile:
        return popOverChild;

      case DeviceType.desktop:
      case DeviceType.tablet:
        return Center(
          child: AnimatedPadding(
            padding: !enableInsets
                ? EdgeInsets.zero
                : MediaQuery.of(context).viewInsets +
                    const EdgeInsets.only(bottom: 20),
            duration: const Duration(milliseconds: 50),
            child: Container(
              constraints: allowFullWidth
                  ? null
                  : BoxConstraints(
                      maxWidth: JPResponsiveDesign.maxPopOverWidth,
                      minWidth: JPResponsiveDesign.maxPopOverWidth,
                      maxHeight: JPResponsiveDesign.maxPopOverHeight),
              child: Material(
                color: JPColor.transparent,
                child: popOverChild,
              ),
            ),
          ),
        );
    }
  }
}

/// showJPBottomSheet can be used when we have to perform loading
/// but we don't have controller for managing our loading state
/// a default controller will be provided with it and loading
/// state can be toggled easily by [controller.toggleIsLoading()]
Future<dynamic> showJPBottomSheet(
    {required Widget Function(JPBottomSheetController controller) child,
    bool isScrollControlled = false,
    bool ignoreSafeArea = true,
    bool isDismissible = true,
    bool enableDrag = false,
    bool allowFullWidth = false,
    bool enableInsets = false}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  if (!JPScreen.isMobile) {
    return await showJPDialog(
        child: child,
        allowFullWidth: allowFullWidth,
        enableInsets: enableInsets);
  } else {
    return await Get.bottomSheet(
      JPPopUpBuilder(
        child: child,
      ),
      isScrollControlled: isScrollControlled,
      ignoreSafeArea: ignoreSafeArea,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      enterBottomSheetDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
      exitBottomSheetDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
    );
  }
}

Future<dynamic> showJPDialog({
  required Widget Function(JPBottomSheetController controller) child,
  bool allowFullWidth = false,
  bool enableInsets = false,
}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  return await Get.dialog(
    JPPopUpBuilder(
      child: child,
      allowFullWidth: allowFullWidth,
      enableInsets: enableInsets,
    ),
    transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
  );
}

Future<dynamic> showJPGeneralDialog({
  required Widget Function(JPBottomSheetController controller) child,
  Widget? secondChild,
  bool? isDismissible = true,
  bool allowFullWidth = false,
}) async {

  // Avoiding dialog and bottom sheet opening in unit testing
  if (RunModeService.isUnitTestMode) return;

  Widget persistentChild = JPPopUpBuilder(child: child);

  if (!JPScreen.isMobile) {
    return await showJPDialog(child: child, allowFullWidth: allowFullWidth);
  } else {
    return await Get.generalDialog(
        barrierDismissible: isDismissible ?? false,
        barrierLabel: '',
        transitionDuration: const Duration(milliseconds: CommonConstants.transitionDuration),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return Animations.fromBottom(animation, secondaryAnimation, child);
        },
        pageBuilder: (animation, secondaryAnimation, child) {
          return persistentChild;
        });
  }
}
