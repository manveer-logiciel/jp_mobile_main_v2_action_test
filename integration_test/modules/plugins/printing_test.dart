import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class PrintingTestCase extends TestBase {

  Future<void> redirectRecentJobs(WidgetTester widgetTester) async {
    await testConfig.successLoginCase(widgetTester);

    Finder menuFinder = find.byIcon(Icons.menu);
    await widgetTester.ensureVisible(menuFinder);
    await widgetTester.pumpAndSettle();

    expect(menuFinder, findsOneWidget);

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

  Future<void> printingFileTestCase(WidgetTester widgetTester) async {
    Finder jpThumbViewMoreFinder = find.byIcon(Icons.more_horiz).first;
    expect(jpThumbViewMoreFinder, findsWidgets);

    await widgetTester.ensureVisible(jpThumbViewMoreFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(jpThumbViewMoreFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(2);

    Finder printFinder = find.text('print'.tr);
    expect(printFinder, findsOneWidget);

    await widgetTester.tap(printFinder);

    await testConfig.fakeDelay(3);
  }

  Future<void> runPrintingTestCase(WidgetTester widgetTester) async {
    testConfig.initializeDioAdapter(false);

    testConfig.setTestDescription(TestDescription.printingFileGroupDesc, TestDescription.printingFileTestDesc);

    await printingFileTestCase(widgetTester);
  }

  @override
   void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.printingFileTestDesc,(widgetTester) async {
     testConfig.setTestDescription(TestDescription.printingFileGroupDesc, TestDescription.printingFileTestDesc);

     await redirectRecentJobs(widgetTester);

     await printingFileTestCase(widgetTester);
    },isMock);
  }
}