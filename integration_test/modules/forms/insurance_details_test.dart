import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/phone/fields/tiles.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jobprogress/modules/job/job_form/form/fields/single_select.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/form/index.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/index.dart';
import 'package:jobprogress/modules/job/job_form/index.dart';
import '../../config/test_config.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

void main() {
  TestConfig.initialSetUpAll();
  InsuranceDetailsTestCase().runTest(isMock: false);
}

class InsuranceDetailsTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.insuranceDetailsTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runInsuranceDetailsTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runInsuranceDetailsTestCase(WidgetTester widgetTester) async {
    if (PhasesVisibility.canShowSecondPhase) {      
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.insuranceDetailsTestDesc);
      await testConfig.fakeDelay(2);

      await widgetTester.pumpAndSettle();

      await _goToJobForm(widgetTester);

      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.clickToJobCategoryTestDesc);
      await testConfig.fakeDelay(5);

      /// check no changes made toast & back to job form
      await _goToInsuranceForm(widgetTester);
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkNoChangesMadeTestDesc);
      await _clickSaveButton(widgetTester);
      await TestHelper.noChangesMadeTestCase(widgetTester, testConfig, currentPage: InsuranceDetailsFormView, previousPage: JobFormView);

      /// check form data validation error & some changes made dialog on pop
      await _goToInsuranceForm(widgetTester); 
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkFormValidationTestDesc);
      await _insuranceValidationFormTest(widgetTester);
      await _clickSaveButton(widgetTester);

      /// check unsaved dialog case
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      /// cancel clicked & show current page
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: InsuranceDetailsFormView, previousPage: JobFormView);
      /// "dont save" clicked & back to previous page
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: InsuranceDetailsFormView, previousPage: JobFormView, tapOnDontSave: true); 

      /// check form data filling properly
      await _goToInsuranceForm(widgetTester);
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkDataFillingInFormTestDesc); 
      await _insuranceFormTest(widgetTester);
      
      /// check filed data showing on fields
      await _goToInsuranceForm(widgetTester); 
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkAllFiledDataShowingTestDesc);

      await testConfig.fakeDelay(5);
      await widgetTester.drag(find.byType(SingleChildScrollView), const Offset(0, -700));
      await testConfig.fakeDelay(5);

      /// check no changes made toast after all filled data
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkNoChangesMadeTestDesc);
      await _clickSaveButton(widgetTester);

      /// change some data
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.changeSomeFieldsOnEditTestDesc);
      await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.insuranceCompanyKey, text: 'test', isReplaceText: true);
      await testConfig.fakeDelay(2);
      await _clickSaveButton(widgetTester);

      /// check updated values
      await _goToInsuranceForm(widgetTester); 
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.checkSavedDataInFormTestDesc);
      await testConfig.fakeDelay(5);

      await widgetTester.pumpAndSettle();
    }
  }

  /// Find & Enter Text on adjuster phone field
  Future<void> _adjusterPhoneField(WidgetTester widgetTester, String number) async {
    Finder adjusterPhoneField = find.descendant(of: find.byType(PhoneForm), matching: find.byType(PhoneFormTile));
    PhoneFormTile phoneWidget = widgetTester.firstWidget(adjusterPhoneField);
    phoneWidget.controller.phoneFields[0].phoneController.text = PhoneMasking.maskPhoneNumber(number);
    await testConfig.fakeDelay(1);
    Finder phoneExtField = find.descendant(of: find.byType(PhoneForm), matching: find.bySemanticsLabel('Ext'));
    await widgetTester.enterText(phoneExtField, '12');
    await testConfig.fakeDelay(2);
  }

  Future<void> _insuranceValidationFormTest(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);

    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.phoneKey, text: '987654');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.faxKey, text: '567890');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.emailKey, text: 'amitchandra@gmailco');
    await _adjusterPhoneField(widgetTester, '9876543');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.adjusterEmailKey, text: 'ajaygmail.com');

    await testConfig.fakeDelay(2);
  }

  Future<void> _insuranceFormTest(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);
    InsuranceDetailsForm insuranceDetailsForm = widgetTester.firstWidget(find.byType(InsuranceDetailsForm));

    /// Find & Enter Text on insurance company field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.insuranceCompanyKey, text: 'lic company', isReplaceText: true);

    /// Find & Enter Text on claim field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.claimKey, text: 'test claim');

    /// Find & Enter Text on policy field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.policyKey, text: 'test policy');

    /// Find & Enter Text on phone field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.phoneKey, text: '9876543210');

    /// Find & Enter Text on fax field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.faxKey, text: '5678901234');

    /// Find & Enter Text on email field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.emailKey, text: 'amitchandra@gmail.com');

    /// Find & Enter Text on adjuster name field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.adjusterNameKey, text: 'ajay');
    
    testConfig.binding?.testTextInput.onCleared?.call();
    await testConfig.fakeDelay(1);
    await _adjusterPhoneField(widgetTester, '9876543210');

    /// Find & Enter Text on adjuster email field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.adjusterEmailKey, text: 'ajay@gmail.com');

    /// Find & Select date from dialog for contingency contract signed date field
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.contingencyContractSignedDateKey);
    await TestHelper.selectDateFromDialog(widgetTester, testConfig);
    await testConfig.fakeDelay(2);

    /// Find & Select date from dialog for date of loss field
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.dateOfLossKey);
    await TestHelper.selectDateFromDialog(widgetTester, testConfig);
    await testConfig.fakeDelay(2);

    /// Find & Select date from dialog for claim filed date field
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.claimFiledDateKey);
    await TestHelper.selectDateFromDialog(widgetTester, testConfig);
    await testConfig.fakeDelay(2);

    /// Find & Enter Text on acv field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.acvKey, text: '100.5');

    /// Find & Enter Text on deductible amount field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.deductibleAmountKey, text: '15.2');

    /// Find & Read only net claim amount field is calculated
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.netClaimAmountKey, checkReadOnly: true, matcherValue: insuranceDetailsForm.service.calculateNetClaimAmount());

    /// Find & Enter Text on depreciation field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.depreciationKey, text: '9.8');

    /// Find & Read only rcv field is calculated
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.rcvKey, checkReadOnly: true, matcherValue: insuranceDetailsForm.service.calculateRcvAmount());
    
    /// Find & Enter Text on upgrades field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.upgradesKey, text: '12');

    /// Find & Enter Text on supplements amount field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.supplementsAmountKey, text: '8');

    /// Find & Read only total field is calculated
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.totalKey, checkReadOnly: true, matcherValue: insuranceDetailsForm.service.calculateTotalAmount());

    testConfig.binding?.testTextInput.onCleared?.call();
    
    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.clickSaveTestDesc);
    await testConfig.fakeDelay(1);

    await _clickSaveButton(widgetTester);
  }

  /// Find & Tap on save button
  Future<void> _clickSaveButton(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.appBarSaveButtonKey)));
    await testConfig.fakeDelay(2);
  }

  /// Find & Visible category field in job form
  Future<void> _goToInsuranceForm(WidgetTester widgetTester) async {
    Finder? jobCategorySingleSelectField = find.byKey(testConfig.getKey(WidgetKeys.jobCategorySingleSelectKey));
    await widgetTester.ensureVisible(jobCategorySingleSelectField);
    expect(jobCategorySingleSelectField, findsOneWidget);
    JobFormSingleSelect jobCategorySingleSelect = widgetTester.firstWidget(jobCategorySingleSelectField);

    if (!jobCategorySingleSelect.showInsuranceClaim) {
      await testConfig.fakeDelay(2);
      testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.selectInsuranceClaimItemTestDesc);
      await testConfig.fakeDelay(2);

      /// Tap on jobCategorySingleSelectField to select category 
      jobCategorySingleSelect.onTap!();
      await testConfig.fakeDelay(2);

      /// Find & Tap on insurance claim item from bottomsheet
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: '3');
    }

    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.goToInsuranceClaimFormPageTestDesc);
    await testConfig.fakeDelay(2);

    /// Tap on insurance claim form button & it will go to insurance form
    jobCategorySingleSelect.onTapInsuranceClaim!();
  }

  Future<void> _goToJobForm(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.clickToRecentJobsDrawerItemTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.clickRecentJobsDrawerSection(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.selectFirstJobFromListTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.selectFirstJobFromRecentJobsSheet(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    
    /// Tap on end drawer button in job summary page
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.insuranceDetailsGroupDesc, TestDescription.clickToAddJobDrawerItemTestDesc);
    await testConfig.fakeDelay(2);

    /// Tap on add job item button in drawer 
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addJobItemKey);
  }
}