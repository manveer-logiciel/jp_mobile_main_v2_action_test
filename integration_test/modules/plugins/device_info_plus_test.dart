import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/my_profile/controller.dart';
import 'package:jobprogress/modules/my_profile/page.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class DeviceInfoPlusTestCase extends TestBase {

  Future<void> deviceInfoTestCase(WidgetTester widgetTester) async {
    await widgetTester.scrollUntilVisible(find.byKey(testConfig.getKey(WidgetKeys.appAndDeviceInfo)), 1.0);

    MyProfileController myProfileController = MyProfileController();

    await testConfig.fakeDelay(2);

    expect(myProfileController.deviceInfo, isNotNull);
    expect(myProfileController.deviceInfo?.manufacturer, isNotNull);

    await testConfig.fakeDelay(2);
  }

  Future<void> runDeviceInfoTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.deviceInfoGroupDesc, TestDescription.deviceInfoTestDesc);

    await deviceInfoTestCase(widgetTester);
  }

  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.deviceInfoTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.deviceInfoGroupDesc, TestDescription.deviceInfoTestDesc);

      await testConfig.successLoginCase(widgetTester);

      Finder menuFinder = find.byIcon(Icons.menu);
      await widgetTester.ensureVisible(menuFinder);
      await widgetTester.pumpAndSettle();

      expect(menuFinder, findsOneWidget);

      await widgetTester.tap(menuFinder);
      await widgetTester.pumpAndSettle();
      await testConfig.fakeDelay(2);

      final myProfileFinder = find.byKey(testConfig.getKey(WidgetKeys.myProfile));
      expect(myProfileFinder, findsOneWidget);

      await widgetTester.ensureVisible(myProfileFinder);
      await widgetTester.pumpAndSettle();

      await widgetTester.tap(myProfileFinder);
      await widgetTester.pumpAndSettle();
      await testConfig.fakeDelay(3);
      expect(find.byType(MyProfileView),findsOneWidget);

      await deviceInfoTestCase(widgetTester);
    }, isMock);
  }



}