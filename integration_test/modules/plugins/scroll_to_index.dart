import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class ScrollToIndexTestCase extends TestBase {

  Future<void> runScrollToIndexTestCase(WidgetTester widgetTester) async {
    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

    await testConfig.fakeDelay(1);

    await widgetTester.tap(menuFinder);
    await widgetTester.pumpAndSettle();
    await testConfig.fakeDelay(2);

    final recentJobsFinder = find.text('recent_jobs'.tr);
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
  }

  @override
  void runTest({bool isMock = true}) {

    testConfig.runTestWidget(TestDescription.scrollToIndexTestDesc, (widgetTester) async {

      testConfig.setTestDescription(TestDescription.scrollToIndexGroupDesc, TestDescription.scrollToIndexTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await runScrollToIndexTestCase(widgetTester);
    }, isMock);
  }
}