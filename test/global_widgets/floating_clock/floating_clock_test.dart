
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/global_widgets/floating_clock/controller.dart';

void main() {

  FloatingClockController controller = FloatingClockController();

  test('FloatingClockController should be initialized with default values', () {
    expect(controller.animationDuration, 0);
    expect(controller.widgetWidth, 105);
    expect(controller.widgetHeight, 50);
    expect(controller.floatingClockOffsets, const Offset(0, 70));
  });

  test('FloatingClockController@onPanStart should set animation duration to 0', () {
    controller.onPanStart(DragStartDetails());
    expect(controller.animationDuration, 0);
  });

  test('FloatingClockController@onPanUpdate should updated floating clock offset', () {
    controller.onPanUpdate(DragUpdateDetails(globalPosition: const Offset(10, 10), delta: const Offset(10, 10)));
    expect(controller.floatingClockOffsets, const Offset(10, 80));
  });

}