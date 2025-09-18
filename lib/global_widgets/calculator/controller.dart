
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FloatingCalculatorController extends GetxController{
  Offset floatingClockOffsets =  Offset(0, JPScreen.height- 390 - Get.mediaQuery.viewPadding.bottom);
  double floatingClockWidth =  JPScreen.width;
  
  // helps in managing boundary constraints
  double floatingClockHeight = 390; // helps in managing boundary constraints
  int animationDuration = 0; // animation duration for auto-animation

  void onPanStart(DragStartDetails details) {
    animationDuration = 0;
  }

  // onPanUpdate() : helps in moving floating calculator on finger gesture
  void onPanUpdate(DragUpdateDetails details) {
    floatingClockOffsets += details.delta;
    if(animationDuration == 0) {
      update();
    }
  }

  // onPanEnd() : helps in auto animation of floating widget to nearby boundary
  void onPanEnd() {
    animationDuration = 200;
    double xOffset = getXOffset();
    double yOffset = getYOffset();

    floatingClockOffsets = Offset(xOffset, yOffset);

    update();
  }

  double getXOffset() =>
      floatingClockOffsets.dx < (JPScreen.width - floatingClockWidth) / 2 ? 0 : JPScreen.width - floatingClockWidth;

  double getYOffset() {
    double maxVerticalExtent = JPScreen.height -
        (Get.mediaQuery.viewPadding.bottom) -
        floatingClockHeight;
    if (floatingClockOffsets.dy < 0) {
      return 0;
    } else if (floatingClockOffsets.dy > maxVerticalExtent) {
      return maxVerticalExtent;
    } else {
      return floatingClockOffsets.dy;
    }
  }
}