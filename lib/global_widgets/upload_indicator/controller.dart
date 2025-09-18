
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class UploadIndicatorController extends GetxController with GetTickerProviderStateMixin {

  Offset offsetVal = Offset(0, JPScreen.height * 0.65);

  Offset get offset => offsetVal;

  Offset get initialOffset => Offset(0, JPScreen.height * 0.7); // helps in re-initializing floating indicator

  double widgetWidth = 78; // helps in managing boundary constraints
  double widgetHeight = 70; // helps in managing boundary constraints

  double get trapTargetValue => JPScreen.width / 2.5;

  Offset get targetOffset => Offset(JPScreen.width / 2 - 40, JPScreen.height - 150); // view offset of target

  Offset get targetHiddenOffset => Offset(JPScreen.width - 40, JPScreen.height * 2); // hidden offset of target

  int animationDuration = 0; // animation duration for auto-animation

  bool doShowTarget = false; // helps in manage view state of target
  bool isIndicatorHidden = false; // helps in managing view state of indicator

  ValueNotifier<bool> isInTargetArea = ValueNotifier(false); // a notifier to update state of target

  set offset(Offset f) {
    offsetVal = f;
  }

  void onPanStart() {
    animationDuration = 0;
  }

  // onPanUpdate() : helps in moving floating clock on finger gesture
  void onPanUpdate(DragUpdateDetails details) {
    offset += details.delta;
    if(animationDuration == 0) {
      update();
    }

    // hide/show target
    isInTargetArea.value = (offset - targetOffset).translate(10, 0).distance <= trapTargetValue;

    // displaying target when user dragging near target
    animateDragTarget(offset.dy > JPScreen.height/2);

  }

  // onPanEnd() : helps in auto animation of floating widget to nearby boundry
  void onPanEnd() {

    if(isInTargetArea.value) {
      hideIndicator();
    } else {
      animationDuration = 200;

      double xOffset = getXOffset();
      double yOffset = getYOffset();

      offset = Offset(xOffset, yOffset);

      isInTargetArea.value = false;
      animateDragTarget(false);
    }
    update();
  }

  double getXOffset() =>
      offset.dx < (JPScreen.width - widgetWidth) / 2 ? 0 : JPScreen.width - widgetWidth;

  double getYOffset() {
    double maxVerticalExtent = JPScreen.height -
        (Get.mediaQuery.viewPadding.bottom + Get.mediaQuery.viewPadding.top) -
        widgetHeight;

    if (offset.dy < 0) {
      return 0;
    } else if (offset.dy > maxVerticalExtent) {
      return maxVerticalExtent;
    } else {
      return offset.dy;
    }
  }

  // animateDragTarget() : helps in hide/view target
  void animateDragTarget(bool val) {

    if(val == doShowTarget) return;

    doShowTarget = val;

  }

  Future<void> hideIndicator() async {
    HapticFeedback.mediumImpact();
    animationDuration = 100;
    offset = targetOffset.translate(0, 0);
    update();

    await Future<void>.delayed(const Duration(milliseconds: 300));

    animationDuration = 200;
    offset = targetHiddenOffset;
    doShowTarget = false;
    isInTargetArea.value = false;
    isIndicatorHidden = true;
    update();
  }

  void unHideIndicator() {

    if(!isIndicatorHidden) return;

    offset = initialOffset;
    animationDuration = 0;
    isIndicatorHidden = false;
    update();
  }

}