
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FloatingClockController extends GetxController{

  Offset floatingClockOffsets = const Offset(0, 70);

  double widgetWidth = 105; // helps in managing boundary constraints
  double widgetHeight = 50; // helps in managing boundary constraints

  int animationDuration = 0; // animation duration for auto-animation

  void onPanStart(DragStartDetails details) {
    animationDuration = 0;
  }

  // onPanUpdate() : helps in moving floating clock on finger gesture
  void onPanUpdate(DragUpdateDetails details) {
    floatingClockOffsets += details.delta;
    if(animationDuration == 0) {
      update();
    }
  }

  // onPanEnd() : helps in auto animation of floating widget to nearby boundry
  void onPanEnd() {
    animationDuration = 200;
    double xOffset = getXOffset();
    double yOffset = getYOffset();

    floatingClockOffsets = Offset(xOffset, yOffset);

    update();
  }

  double getXOffset() =>
      floatingClockOffsets.dx < (JPScreen.width - widgetWidth) / 2 ? 0 : JPScreen.width - widgetWidth;

  double getYOffset() {
    double maxVerticalExtent = JPScreen.height -
        (Get.mediaQuery.viewPadding.bottom + Get.mediaQuery.viewPadding.top) -
        widgetHeight;

    if (floatingClockOffsets.dy < 0) {
      return 0;
    } else if (floatingClockOffsets.dy > maxVerticalExtent) {
      return maxVerticalExtent;
    } else {
      return floatingClockOffsets.dy;
    }
  }

  void onTapClock() {
    if(Get.previousRoute == Routes.clockInClockOut && Get.currentRoute == Routes.customerJobSearch) {
      Get.back();
    } else {
      Get.toNamed(Routes.clockInClockOut);
    }
  }
}