import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/animated_sync_button/controller.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AnimatedSyncButton extends StatelessWidget {

  const AnimatedSyncButton({
    super.key,
    this.iconData,
    this.onPressed,
    this.isLoading,
  });

  final VoidCallback? onPressed;
  final IconData? iconData;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AnimatedSyncButtonController>(
      global: false,
      init: AnimatedSyncButtonController(),
      builder: (AnimatedSyncButtonController controller) {
          controller.handleLoading(isLoading!);
          return RotationTransition(
            turns: Tween(begin: 1.0, end: 0.0).animate(controller.animationController),
            child: JPIconButton(
              onTap: onPressed,
              backgroundColor: JPColor.transparent,
              icon: iconData ?? Icons.sync,
              iconColor: controller.animationController.isAnimating ? JPAppTheme.themeColors.dimGray : JPAppTheme.themeColors.primary,
              iconSize: 24,
            ),
          );
        }
    );
  }
}