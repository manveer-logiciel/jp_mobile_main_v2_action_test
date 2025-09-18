import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class ImagePickerTestCase extends TestBase {

  Future<void> imagePickerTestCase(WidgetTester widgetTester) async {
    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final clockInFinder = find.byKey(testConfig.getKey(WidgetKeys.clockIn));
    expect(clockInFinder, findsOneWidget);

    await widgetTester.ensureVisible(clockInFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(clockInFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    final clockInClockOutController = Get.find<ClockInClockOutController>();
    await clockInClockOutController.takePhoto();
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(4);
  }

  Future<void> runImagePickerTestCase(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);

    testConfig.initializeDioAdapter(true);

    testConfig.setTestDescription(TestDescription.imagePickerGroupDesc, TestDescription.imagePickerTestDesc);

    await imagePickerTestCase(widgetTester);
  }

  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.imagePickerTestDesc,(widgetTester) async {
      testConfig.setTestDescription(TestDescription.imagePickerGroupDesc, TestDescription.imagePickerTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await imagePickerTestCase(widgetTester);
    },isMock);
  }
}