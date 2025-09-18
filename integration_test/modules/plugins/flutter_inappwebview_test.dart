import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class FlutterInAppWebViewTestCase extends TestBase {

  Future<void> runInAppWebView(WidgetTester widgetTester) async {
    Finder customerManagerFinder = find.byKey(testConfig.getKey(WidgetKeys.customerManager));
    expect(customerManagerFinder, findsOneWidget);

    await widgetTester.ensureVisible(customerManagerFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(customerManagerFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);

    Finder emailFinder = find.text('email'.tr.toUpperCase()).first;
    expect(emailFinder, findsOneWidget);

    await widgetTester.ensureVisible(emailFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(emailFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);

    Finder moreIconFinder = find.byIcon(Icons.more_vert);
    expect(moreIconFinder, findsOneWidget);

    await widgetTester.tap(moreIconFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(1);

    Finder emailTemplateFinder = find.text('${'email'.tr.capitalize!} ${'templates'.tr.capitalize!}');
    expect(emailTemplateFinder, findsOneWidget);

    await widgetTester.tap(emailTemplateFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);

    Finder eyeIconFinder = find.byIcon(Icons.remove_red_eye_outlined);
    expect(eyeIconFinder, findsOneWidget);

    await widgetTester.tap(eyeIconFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);
  }

  Future<void> runFlutterInAppWebViewTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.inAppWebViewGroupDesc, TestDescription.inAppWebViewTestDesc);

    await runInAppWebView(widgetTester);
  }

  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.inAppWebViewTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.inAppWebViewGroupDesc, TestDescription.inAppWebViewTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await runInAppWebView(widgetTester);
    }, isMock);
  }
}