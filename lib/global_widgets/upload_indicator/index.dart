
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/upload_indicator/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'indicator.dart';

class UploadIndicator extends StatelessWidget {
  const UploadIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadIndicatorController>(
      init: UploadIndicatorController(),
      builder: (controller) {
        return Stack(
          children: [

            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: controller.doShowTarget ? controller.targetOffset.dy : controller.targetHiddenOffset.dy,
              left: controller.targetOffset.dx,
              curve: Curves.fastOutSlowIn,
              child: ValueListenableBuilder(
                valueListenable: controller.isInTargetArea,
                builder: (_, bool val, child) {
                  return Card(
                    color: val
                        ? JPAppTheme.themeColors.secondary.withValues(alpha: 0.9)
                        : JPAppTheme.themeColors.darkGray.withValues(alpha: 0.7),
                    elevation: 3,
                    shape: const CircleBorder(),
                    child: child,
                  );
                },
                child: SizedBox(
                  height: 70,
                  width: 70,
                  child: Center(
                    child: JPIcon(
                      Icons.close,
                      color: JPAppTheme.themeColors.base,
                    ),
                  ),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: Duration(milliseconds: controller.animationDuration),
              left: controller.offset.dx,
              top: controller.offset.dy,
              curve: Curves.fastOutSlowIn,
              child: Hero(
                tag: 'floating_upload_indicator',
                child: GestureDetector(
                  onPanStart: (_) => controller.onPanStart(),
                  onPanUpdate: controller.onPanUpdate,
                  onPanEnd: (_) => controller.onPanEnd(),
                  child: Opacity(
                    opacity: !controller.isInTargetArea.value ? 1 : 0.9,
                    child: FloatingUploadIndicator(
                      onTap: () {
                        Get.toNamed(Routes.uploadsListing);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
