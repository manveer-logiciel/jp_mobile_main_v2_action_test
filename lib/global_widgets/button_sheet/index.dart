import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class JPButtonSheetMenuButton extends StatelessWidget {
  const JPButtonSheetMenuButton({
    super.key,
    required this.child,
    required this.onTapOption,
    this.initialAlignment = Alignment.bottomCenter,
  });

  /// child can be any widget, on click of which options to be opened
  final Widget child;

  /// onTapOption helps in handling various quick actions
  final Function(String) onTapOption;

  /// initialAlignment decides the animation behaviour of action
  final Alignment initialAlignment;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPButtonSheetController>(
      global: false,
      init: JPButtonSheetController(
          onTapOption,
          initialAlignment
      ),
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.rotationController,
          builder: (_, child) {
            return Transform.rotate(
              angle: controller.rotationController.value,
              child: child,
            );
          },
          child: InkWell(
              onTap: () => controller.onTapChild(context),
              borderRadius: BorderRadius.circular(50),
              child: child,
          ),
        );
      }
    );
  }

}
