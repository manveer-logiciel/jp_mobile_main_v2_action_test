import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/list.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';

class SqfLiteTestCase extends TestBase {

  Future<void> divisionTestCase(WidgetTester widgetTester) async {
    Finder filterIconFinder = find.byIcon(Icons.filter_list);
    expect(filterIconFinder, findsOneWidget);

    await widgetTester.ensureVisible(filterIconFinder);
    await widgetTester.pumpAndSettle();

    await widgetTester.tap(filterIconFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(1);

    Finder divisionDropDownFinder = find.byKey(testConfig.getKey(WidgetKeys.division));
    expect(divisionDropDownFinder, findsOneWidget);

    await widgetTester.tap(divisionDropDownFinder);
    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(3);

    final divisionsList = find.descendant(of: find.byType(JPMultiSelectList), matching: find.byType(JPCheckbox));

    expect(divisionsList, findsNWidgets(2));

    await testConfig.fakeDelay(4);
  }

  Future<void> runSqfLiteTestCase(WidgetTester widgetTester) async {

    testConfig.setTestDescription(TestDescription.sqfLiteGroupDesc, TestDescription.sqfLiteTestDesc);

    await divisionTestCase(widgetTester);

    Get.back();

    await testConfig.fakeDelay(2);

    Get.back();
  }

  @override
  void runTest({bool isMock = true}) {
      testConfig.runTestWidget(TestDescription.sqfLiteTestDesc, (widgetTester) async {

        testConfig.setTestDescription(TestDescription.sqfLiteGroupDesc, TestDescription.sqfLiteTestDesc);

        await testConfig.successLoginCase(widgetTester);

        await divisionTestCase(widgetTester);
      }, isMock);
  }
}