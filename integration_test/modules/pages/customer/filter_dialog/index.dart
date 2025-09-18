import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import '../../../../config/test_config.dart';
import '../../../../core/test_description.dart';
import '../../../../core/test_helper.dart';

class FilterDialogTestCase {

  final TestConfig testConfig = Get.find();

  Future<void> runFilterTestCase(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.applyFilterTestDesc);
    /// Fill values in filter dialog
    await fillValuesInFilterDialog(widgetTester);
    /// Tap apply
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.applyKey);

    await testConfig.fakeDelay(1);

    /// Tap filter icon
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byIcon(Icons.filter_list));

    await testConfig.fakeDelay(1);

    testConfig.setTestDescription(TestDescription.customerListingGroupDesc, TestDescription.resetFilterTestDesc);
    /// Tap reset
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.resetKey);

    await testConfig.fakeDelay(1);

    /// Tap apply
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.applyKey);

    await testConfig.fakeDelay(1);
  }

  Future<void> selectAndTypeNameType(WidgetTester widgetTester) async {
    Finder customerNameField = find.byKey(testConfig.getKey(WidgetKeys.customerFilterNameKey));

    Finder nameTypeFinder = find.descendant(of: customerNameField, matching: find.byType(InkWell));
    expect(nameTypeFinder, findsOneWidget);

    await TestHelper.selectDropDown(widgetTester, testConfig, nameTypeFinder);

    await TestHelper.enterText(widgetTester, testConfig, finder: customerNameField, text: 'Test Customer Name');

    await testConfig.fakeDelay(1);
  }

  Future<void> fillValuesInFilterDialog(WidgetTester widgetTester) async {
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byIcon(Icons.filter_list));

    await testConfig.fakeDelay(1);

    /// Select Assigned to
    await TestHelper.selectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.assignedToKey)));

    /// Select and Enter Customer Type Name
    await selectAndTypeNameType(widgetTester);

    /// Enter Phone Number
    await TestHelper.enterText(widgetTester, testConfig, text: '1234567890', finder: find.byKey(testConfig.getKey(WidgetKeys.phoneKey)));
    await testConfig.fakeDelay(1);

    /// Enter Email
    await TestHelper.enterText(widgetTester, testConfig, text: testConfig.correctEmail, finder: find.byKey(testConfig.getKey(WidgetKeys.emailKey)));
    await testConfig.fakeDelay(1);

    /// Enter Address
    await TestHelper.enterText(widgetTester, testConfig, text: 'Demo 123 Address', finder: find.byKey(testConfig.getKey(WidgetKeys.addressKey)));
    await testConfig.fakeDelay(1);

    /// Select States
    await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.stateKey)));

    /// Enter Zip
    await TestHelper.enterText(widgetTester, testConfig, text: '3022', finder: find.byKey(testConfig.getKey(WidgetKeys.zipKey)));
    await testConfig.fakeDelay(1);

    /// Enter Customer Note
    await TestHelper.enterText(widgetTester, testConfig, text: 'Demo Note', finder: find.byKey(testConfig.getKey(WidgetKeys.customerNoteKey)));

    await testConfig.fakeDelay(1);

    /// Select Flags
    await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, find.byKey(testConfig.getKey(WidgetKeys.flagKey)));
  }
}