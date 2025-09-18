import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class EasyMaskTestCase extends TestBase {

  Future<void> showEasyMaskNumber(WidgetTester widgetTester) async {
    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final recentJobsFinder = find.byKey(testConfig.getKey(WidgetKeys.recentJobs));
    expect(recentJobsFinder, findsOneWidget);

    await widgetTester.ensureVisible(recentJobsFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(recentJobsFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    Finder recentJobListViewFinder = find.byKey(testConfig.getKey(WidgetKeys.recentJobs));
    expect(recentJobListViewFinder, findsOneWidget);

    await widgetTester.tap(recentJobListViewFinder.first);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(3);

    Finder contactPersonsFinder = find.byKey(testConfig.getKey(WidgetKeys.contactPersons));
    expect(contactPersonsFinder, findsOneWidget);

    await widgetTester.ensureVisible(contactPersonsFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(contactPersonsFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);
  }

  Future<void> runEasyMaskTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.easyMaskGroupDesc, TestDescription.easyMaskTestDesc);

    await showEasyMaskNumber(widgetTester);

  }

  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.easyMaskTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.easyMaskGroupDesc, TestDescription.easyMaskTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await showEasyMaskNumber(widgetTester);
    }, isMock);
  }

}