import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class FlutterWidgetFromHtmlCoreTestCase extends TestBase {

  Future<void> runHtmlWidget(WidgetTester widgetTester) async {
    Finder notificationIconFinder = find.byIcon(Icons.notifications_outlined);
    expect(notificationIconFinder, findsOneWidget);

    await widgetTester.ensureVisible(notificationIconFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(notificationIconFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(6);

    Finder jpListViewItemFinder = find.byType(JPListView).at(1);
    expect(jpListViewItemFinder, findsOneWidget);

    await widgetTester.tap(jpListViewItemFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(4);
  }

  Future<void> runFlutterWidgetFromHtmlCoreTestCase(WidgetTester widgetTester) async {

    testConfig.setTestDescription(TestDescription.flutterWidgetFromHtmlCoreGroupDesc, TestDescription.flutterWidgetFromHtmlCoreTestDesc);

    await testConfig.fakeDelay(3);

    await runHtmlWidget(widgetTester);

    Get.back();

    await testConfig.fakeDelay(2);

    Get.back();

    await testConfig.fakeDelay(2);
  }
  
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.flutterWidgetFromHtmlCoreTestDesc, (widgetTester) async {

      testConfig.setTestDescription(TestDescription.flutterWidgetFromHtmlCoreGroupDesc, TestDescription.flutterWidgetFromHtmlCoreTestDesc);

      await testConfig.successLoginCase(widgetTester);

      await runHtmlWidget(widgetTester);
    }, isMock);
  }
}