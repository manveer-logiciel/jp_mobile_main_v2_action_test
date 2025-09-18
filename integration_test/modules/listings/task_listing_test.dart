
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/task/detail/index.dart';
import 'package:jobprogress/modules/task/list_tile/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../config/test_config.dart';
import '../../core/enum/url_matcher_mode.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

void main() {
  TestConfig.initialSetUpAll();
  TaskListingTestCase().runTest();
}

class TaskListingTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.taskListingGroupDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runTaskListingTestCase(widgetTester);
    }, isMock,);
  }

  Future<void> runTaskListingTestCase(WidgetTester widgetTester) async {
    testConfig.changeUrlMatcher(JPUrlMatcherMode.fullRequestMatch);
    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.taskListingTestDesc);
    await testConfig.fakeDelay(1);
    await widgetTester.pumpAndSettle();

    await _goToTaskListing(widgetTester);
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.taskListingDetailTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig,tapFinder: find.byType(TaskListTile).at(0));

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.closeTaskListingDetailTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnDescendantWidget(find.byType(TaskDetail), find.byIcon(Icons.close), testConfig, widgetTester);

    await testConfig.fakeDelay(2);

    await loadMoreTestCase(widgetTester);

    await widgetTester.pumpAndSettle();

    await noLoadMoreTestCase(widgetTester);

    await widgetTester.pumpAndSettle();

    await testConfig.fakeDelay(2);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.refreshTaskListingTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.clickRefreshDrawerSection(widgetTester, testConfig);
    await testConfig.fakeDelay(1);

    await runFilterCases(widgetTester);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.fillCustomFilterTestDesc);
    await testConfig.fakeDelay(2);

    await runCustomFilterTestCase(widgetTester);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.resetCustomFilterTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.resetKey)));
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.fillCustomFilterTestDesc);
    await testConfig.fakeDelay(2);

    await fillValuesInCustomFilterDialog(widgetTester);
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.applyCustomFilterTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.applyKey)));
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.pullToRefreshTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.pullToRefresh(widgetTester, testConfig, find.byType(TaskListTile));
  }

  Future<void> loadMoreTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.taskListingTestDesc, TestDescription.loadMoreTestCaseDesc);
    await TestHelper.scrollToLast(widgetTester, testConfig, testConfig.getKey('${WidgetKeys.taskListingKey}[9]'));

    expect(find.byType(FadingCircle), findsOneWidget);
  }

  Future<void> noLoadMoreTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.taskListingTestDesc, TestDescription.noLoadMoreTestCaseDesc);
    await TestHelper.scrollToLast(widgetTester, testConfig, testConfig.getKey('${WidgetKeys.taskListingKey}[19]'));

    expect(find.byType(FadingCircle), findsNothing);
  }

  Future<void> selectDropDown(WidgetTester widgetTester, Finder dropDownFinder, int index) async {
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: dropDownFinder);

    await testConfig.fakeDelay(1);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byType(AutoScrollTag).at(index));

    await testConfig.fakeDelay(1);
  }

  Future<void> runCustomFilterTestCase(WidgetTester widgetTester) async {
    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.taskListingFilterKey)),7);
    await testConfig.fakeDelay(1);
    await fillValuesInCustomFilterDialog(widgetTester);
  }

  Future<void> runFilterCases(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.taskFilterTestDesc);
    await testConfig.fakeDelay(2);

    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.taskListingFilterKey)),1);
    await testConfig.fakeDelay(1);

    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.taskListingFilterKey)),0);
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.taskSortOrderTestDesc);
    await testConfig.fakeDelay(2);

    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.taskListingSortOrderKey);
    await testConfig.fakeDelay(1);

    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.taskListingSortOrderKey);
    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.taskListingGroupDesc, TestDescription.taskSortByTestDesc);
    await testConfig.fakeDelay(2);

    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.taskListingSortFilterKey)),1);
    await testConfig.fakeDelay(1);
  }

  Future<void> fillValuesInCustomFilterDialog(WidgetTester widgetTester) async {
    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.statusKey)),2);
    await testConfig.fakeDelay(1);

    await selectDropDown(widgetTester, find.byKey(testConfig.getKey(WidgetKeys.dueOnKey)),3);
    await testConfig.fakeDelay(1);

    Finder checkBoxList = find.byType(JPCheckbox);
    expect(checkBoxList, findsWidgets);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: checkBoxList.at(0));
    await testConfig.fakeDelay(1);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: checkBoxList.at(1));
    await testConfig.fakeDelay(1);

    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: checkBoxList.at(2));
    await testConfig.fakeDelay(1);
  }

  Future<void> _goToTaskListing(WidgetTester widgetTester) async {
    Get.testMode = true;
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.taskButtonHomePage);
  }
}