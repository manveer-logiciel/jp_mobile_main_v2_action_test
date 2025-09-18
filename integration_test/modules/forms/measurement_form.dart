import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/taplocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/bottom_sheet/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/index.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/index.dart';
import 'package:jobprogress/modules/job/job_summary/page.dart';
import 'package:jp_mobile_flutter_ui/Thumb/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../config/test_config.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

void main() {
  TestConfig.initialSetUpAll();
  MeasurementFormTestCase().runTest();
}

class MeasurementFormTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.measurementFormTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runMeasurementFormTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runMeasurementFormTestCase(WidgetTester widgetTester) async {
    if (PhasesVisibility.canShowSecondPhase) {      
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.measurementFormTestDesc);
      await testConfig.fakeDelay(2);
      await widgetTester.pumpAndSettle();

      await _goToAddMeasurementForm(widgetTester);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkPleaseEnterMeasurementValueCase);
      await _clickSaveButton(widgetTester);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingZeroInField);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '0');
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[2]', text: '0');
      await testConfig.fakeDelay(2);
    
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkPleaseEnterMeasurementValueCaseByZero);
      await _clickSaveButton(widgetTester);
      await  testConfig.fakeDelay(2);

      // Check invalid value validation
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.validationDesc);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '.');
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: MeasurementFormView, previousPage: JobSummaryView);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingValidInField);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '3.5');
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.navToAddMultipleTable);
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.tradeTypeKey}[0]');
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.navToUpdateMeasurement);
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.multipleMeasurementKey}[0]', tapLocation:TapAt.topLeft);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.validationDesc);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '.', isReplaceText: true);
      await  testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: EditMeasurementBottomSheet, previousPage: AddMultipleMeasurementView);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingValidInField);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '3.1', isReplaceText: true);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[0]', text: '5.9');
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[2]', text: '10', isReplaceText: true);
      await  testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.updateButtonDesc);
      await TestHelper.tapOnDescendantWidget(find.byType(EditMeasurementBottomSheet), find.byType(JPButton), testConfig, widgetTester);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.addNewMeasurementDesc);
      Finder? finder = find.text('+ ${'add_new_measurement'.tr.capitalizeFirst!}');
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: finder);
      await widgetTester.pumpAndSettle();
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.navToUpdateMeasurement);
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.multipleMeasurementKey}[2]', tapLocation:TapAt.topLeft);
      await testConfig.fakeDelay(2);
      
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingValidInField);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '3.4',);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[0]', text: '5.3');
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[2]', text: '10');
      await  testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.updateButtonDesc);
      await testConfig.fakeDelay(2);
      await TestHelper.tapOnDescendantWidget(find.byType(EditMeasurementBottomSheet), find.byType(JPButton), testConfig, widgetTester);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.tableLongPressActionDesc);
      Finder tableFirstItem = find.byKey(const ValueKey('${WidgetKeys.multipleMeasurementKey}[1]'));
      await  widgetTester.longPressAt(widgetTester.getTopLeft(tableFirstItem));
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.deleteActionDesc);
      Finder? deleteAction = find.text('delete'.tr.capitalizeFirst!);
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: deleteAction);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: AddMultipleMeasurementView, previousPage: MeasurementFormView);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.addButtonActionDesc);
      Finder? addButton = find.text('add'.tr.toUpperCase());
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addButton);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: MeasurementFormView, previousPage: JobSummaryView);
      await  testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.saveButtonDesc);
      await _clickSaveButton(widgetTester);
      await testConfig.fakeDelay(2);  

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.shouldShowValidateErrorInMeasurement);
      Finder? saveButton = find.descendant(of: find.byType(JPQuickEditDialog), matching: find.byType(JPButton));
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: saveButton);
      await  testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingValidInField);
      Finder? inputBox = find.descendant(of: find.byType(JPQuickEditDialog), matching: find.byType(JPInputBox));
      await TestHelper.enterText(widgetTester, testConfig, text: 'Testing', finder: inputBox);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.shouldSaveMeasurementWhenNameEnter);
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: saveButton);
      await testConfig.fakeDelay(2);

      await _goToEditMeasurementForm(widgetTester);
      await widgetTester.pumpAndSettle();

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.checkNoChangesMadeTestDesc);
      await _clickSaveButton(widgetTester);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.editButtonActionDesc);
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.tradeTypeKey}[0]');
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.navToUpdateMeasurement);
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.multipleMeasurementKey}[0]', tapLocation:TapAt.topLeft);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.fillingValidInField);
      await TestHelper.enterText(widgetTester, testConfig, key: '${WidgetKeys.attributeInputBoxKey}[1]', text: '10', isReplaceText: true);
      await  testConfig.fakeDelay(2);
      
      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.updateButtonDesc);
      await testConfig.fakeDelay(2);
      await TestHelper.tapOnDescendantWidget(find.byType(EditMeasurementBottomSheet), find.byType(JPButton), testConfig, widgetTester);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.addButtonActionDesc);
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addButton);
      await testConfig.fakeDelay(2);

      testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.updateButtonDesc);
      await _clickSaveButton(widgetTester);
      await testConfig.fakeDelay(2);
    }
  }
  
  Future<void> _clickSaveButton(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key:WidgetKeys.appBarSaveButtonKey);
    await testConfig.fakeDelay(2);
  }

  Future<void> _goToEditMeasurementForm(WidgetTester widgetTester) async {
    /// Tap on end drawer button in job summary page
    await  testConfig.fakeDelay(2);
    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.openSecondaryDrawerTestDesc);
    await TestHelper.openSecondaryDrawer(widgetTester, testConfig);
    await  testConfig.fakeDelay(2);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.clickToMeasurementItemTestDesc);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.measurementsKey);
    await testConfig.fakeDelay(2);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.longPressOfFileListingItem);
    await  widgetTester.longPress(find.byType(JPThumb).at(1));
    await testConfig.fakeDelay(2);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.editOptionClickDesc);
    Finder? editText = find.text('edit'.tr.capitalize!);
    TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: editText);
    await testConfig.fakeDelay(2);
  }

  Future<void> _goToAddMeasurementForm(WidgetTester widgetTester) async {
    Get.testMode = true;
    
    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.clickToRecentJobsDrawerItemTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.clickRecentJobsDrawerSection(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.selectFirstJobFromListTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.selectFirstJobFromRecentJobsSheet(widgetTester, testConfig);
    
    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.clickOnAddButton);
    await testConfig.fakeDelay(2);  
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addButtonKey);
  
    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.clickOnMeasurement);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.measurement);
    await testConfig.fakeDelay(2);

    testConfig.setTestDescription(TestDescription.measurementFormGroupDesc, TestDescription.clickOnMeasurementForm);
    Finder? finder = find.text('measurement_form'.tr);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: finder);
    await testConfig.fakeDelay(2);
  }
}