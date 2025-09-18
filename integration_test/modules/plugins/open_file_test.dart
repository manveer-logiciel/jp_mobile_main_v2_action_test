import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/Thumb/index.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class OpenFileTestCase extends TestBase {

  Future<void> openFileTestCase(WidgetTester widgetTester) async {
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

    Finder jpThumbFinder = find.byType(JPThumb).first;
    expect(jpThumbFinder, findsOneWidget);

    await widgetTester.ensureVisible(jpThumbFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(jpThumbFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);
  }

  @override
   void runTest({bool isMock = true}){
    testConfig.runTestWidget(TestDescription.openFileTestDesc,(widgetTester) async {

      testConfig.setTestDescription(TestDescription.openFileGroupDesc, TestDescription.openFileTestDesc);

      await openFileTestCase(widgetTester);
    },isMock);
  }
}