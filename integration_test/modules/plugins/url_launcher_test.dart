import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/login/page.dart';
import 'package:jobprogress/modules/my_profile/page.dart';
import 'package:jobprogress/modules/my_profile/widgets/user_phone_email.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

class UrlLauncherTestCase extends TestBase {

  Future<void> openTermConditionUrl(WidgetTester widgetTester) async {
    await widgetTester.pumpWidget(testConfig.createWidgetUnderTest());

    Finder termFinder = find.byKey(testConfig.getKey(WidgetKeys.termKey));
    expect(termFinder, findsOneWidget);

    await widgetTester.ensureVisible(termFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(termFinder);

    await widgetTester.pumpAndSettle();
    await widgetTester.idle();
    await testConfig.fakeDelay(2);
    expect(find.byType(LoginView), findsOneWidget);
  }

  Future<void> redirectToDialPad(WidgetTester widgetTester) async {
    Finder callFinder = find.byType(JPTextButton);
    expect(callFinder, findsWidgets);

    await widgetTester.tap(callFinder.at(3));
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);
  }

  Future<void> openMapLocationIcon(WidgetTester widgetTester) async {
    Finder msgFinder = find.byType(JPTextButton);
    expect(msgFinder, findsWidgets);

    await widgetTester.tap(msgFinder.at(2));
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    if (Platform.isIOS) {
      Finder appleLocation = find.text('google_map'.tr);
      expect(appleLocation, findsOneWidget);
      await widgetTester.tap(appleLocation);
      await widgetTester.pumpAndSettle();
      }
    }

  Future<void> runUrlLauncherTestCases(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.urlLauncherGroupDesc,
        TestDescription.launchNativeDialPadTestDesc);

    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await TestHelper.openEndDrawer(widgetTester, testConfig);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.myProfile)));

    await testConfig.fakeDelay(4);
    expect(find.byType(MyProfileView), findsOneWidget);

    expect(find.byType(MyProfileEmailPhone), findsOneWidget);

    await redirectToDialPad(widgetTester);

    await testConfig.fakeDelay(5);

    testConfig.setTestDescription(TestDescription.urlLauncherGroupDesc,
        TestDescription.openGoogleMapTestDesc);

    await openMapLocationIcon(widgetTester);

    await testConfig.fakeDelay(5);
  }

  @override
  void runTest({bool isMock = true}) {
    group(TestDescription.urlLauncherGroupDesc, () {
      testConfig.runTestWidget(TestDescription.openTermAndConditionTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.urlLauncherGroupDesc,
            TestDescription.openTermAndConditionTestDesc);

        await openTermConditionUrl(widgetTester);
      }, isMock);

      testConfig.runTestWidget(TestDescription.launchNativeDialPadTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.urlLauncherGroupDesc,
            TestDescription.launchNativeDialPadTestDesc);

        await testConfig.successLoginCase(widgetTester);

        await openMyProfilePage(widgetTester);

        await redirectToDialPad(widgetTester);
      }, isMock);

      testConfig.runTestWidget(TestDescription.openGoogleMapTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.urlLauncherGroupDesc,
            TestDescription.openGoogleMapTestDesc);

        await testConfig.successLoginCase(widgetTester);

        await openMyProfilePage(widgetTester);

        await openMapLocationIcon(widgetTester);
      }, isMock);
    });
  }

  Future<void> openMyProfilePage(WidgetTester widgetTester) async {
    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final myProfileFinder = find.text('my_profile'.tr);
    expect(myProfileFinder, findsOneWidget);

    await widgetTester.ensureVisible(myProfileFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(myProfileFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(4);
    expect(find.byType(MyProfileView), findsOneWidget);

    expect(find.byType(MyProfileEmailPhone), findsOneWidget);
  }
}