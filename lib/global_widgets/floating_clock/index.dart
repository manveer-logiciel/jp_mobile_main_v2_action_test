import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/global_widgets/floating_clock/controller.dart';
import 'package:jobprogress/global_widgets/floating_clock/clock_animation.dart';
import 'package:jobprogress/global_widgets/global_value_listener/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FloatingClock extends StatelessWidget {
  const FloatingClock({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<FloatingClockController>(
      init: FloatingClockController(),
      builder: (floatingClockController) {
        return Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: floatingClockController.animationDuration),
              left: floatingClockController.floatingClockOffsets.dx,
              top: floatingClockController.floatingClockOffsets.dy,
              curve: Curves.fastOutSlowIn,
              child: JPSafeArea(
                child: GlobalValueListener<ClockInClockOutController>(
                  init: ClockInClockOutService.controller,
                  child: (clockInClockOutController) {
                    /// displays nothing
                    if (clockInClockOutController.duration == null) {
                      return const SizedBox();
                    } else {
                      /// displays floating clock
                      return GestureDetector(
                        onPanStart: floatingClockController.onPanStart,
                        onPanUpdate: floatingClockController.onPanUpdate,
                        onPanEnd: (_) => floatingClockController.onPanEnd(),
                        child: Hero(
                          tag: 'floating_clock',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Material(
                              elevation: 3,
                              shadowColor: JPAppTheme.themeColors.dimGray,
                              color: JPAppTheme.themeColors.lightBlue,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: floatingClockController.onTapClock,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const JPAnimatedClock(
                                          size: 24,
                                          handHeight: 6,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Container(
                                          alignment:  Alignment.center,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              JPText(
                                                text: clockInClockOutController.duration!.substring(0, 2),
                                                textSize: JPTextSize.heading5,
                                                fontWeight: JPFontWeight.medium,
                                                textColor: JPAppTheme.themeColors.primary,
                                                fontFamily: JPFontFamily.montserrat,
                                              ),
                                              JPText(
                                                text: 'h',
                                                dynamicFontSize: 10,
                                                fontWeight: JPFontWeight.medium,
                                                textColor: JPAppTheme.themeColors.primary,
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              JPText(
                                                text: clockInClockOutController.duration!.substring(3),
                                                textSize: JPTextSize.heading5,
                                                fontWeight: JPFontWeight.medium,
                                                textColor: JPAppTheme.themeColors.primary,
                                                fontFamily: JPFontFamily.montserrat,
                                              ),
                                              JPText(
                                                text: 'm',
                                                dynamicFontSize: 10,
                                                fontWeight: JPFontWeight.medium,
                                                textColor: JPAppTheme.themeColors.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



