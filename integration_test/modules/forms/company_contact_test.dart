import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/email/fields/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/fields/tiles.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/form/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/index.dart';
import 'package:jobprogress/modules/company_contacts/listing/page.dart';
import 'package:jobprogress/modules/job/job_form/form/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/view.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../config/test_config.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';

void main() {
  TestConfig.initialSetUpAll();
  CompanyContactTestCase().runTest();
}

class CompanyContactTestCase extends TestBase {
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.companyContactTestDesc, (widgetTester) async {
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      await runCompanyContactTestCase(widgetTester);
    }, isMock);
  }

  Future<void> runCompanyContactTestCase(WidgetTester widgetTester) async {
    if (PhasesVisibility.canShowSecondPhase) {      
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.companyContactTestDesc);
      await testConfig.fakeDelay(2);

      await widgetTester.pumpAndSettle();

      await _goToCompanyContactForm(widgetTester);

      /// check no changes made in fields & back to company contact list
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.checkNoChangesMadeTestDesc);
      await _clickSaveButton(widgetTester);
      await TestHelper.noChangesMadeTestCase(widgetTester, testConfig, currentPage: CreateCompanyContactFormView, previousPage: CompanyContactListingView);

      /// check form data validation error & some changes made dialog on pop
      await _clickAddCompanyContactButton(widgetTester); 
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.checkFormValidationTestDesc);
      await _companyContactValidationFormTest(widgetTester);

      /// check unsaved dialog case
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.checkUnsavedDialogTestDesc);
      await _clickSaveButton(widgetTester);
      /// "cancel" button clicked & show current page
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: CreateCompanyContactFormView, previousPage: CompanyContactListingView);
      /// "don't save" button clicked & back to previous page
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: CreateCompanyContactFormView, previousPage: CompanyContactListingView, tapOnDontSave: true); 

      /// check form data filling properly
      await _clickAddCompanyContactButton(widgetTester);
      testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.checkDataFillingInFormTestDesc); 
      await _companyContactFormTest(widgetTester);

      await _goToJobContactPersonForm(widgetTester);

      await widgetTester.pumpAndSettle();
    }
  }
  
  Future<void> _companyContactValidationFormTest(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);

    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.firstNameKey, text: ' ');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.lastNameKey, text: ' ');

    await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '9876543');
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'ajaygmail.com');

    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: true);
    await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '567890', fieldIndex: 1);

    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: true);
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'amitchandra@gmailco', fieldIndex: 1);

    await _clickSaveButton(widgetTester);
    /// enter valid phone number on first field
    await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '9876543210', fieldIndex: 0, skipExt: true);
    /// enter valid email on first field
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'ajay@gmail.com', fieldIndex: 0);
    await testConfig.fakeDelay(2);
   
    /// delete invalid phone number on second field
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: false, deleteIndex: 0);
    await testConfig.fakeDelay(2);
    /// delete invalid email on second field
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: false, deleteIndex: 0);
    await testConfig.fakeDelay(2);
  }

  /// Find & Tap on save button
  Future<void> _clickSaveButton(WidgetTester widgetTester) async {
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.appBarSaveButtonKey)));
    await testConfig.fakeDelay(2);
  }
  
  Future<void> _companyContactFormTest(WidgetTester widgetTester) async {
    CreateCompanyContactForm createCompanyContactForm = widgetTester.firstWidget(find.byType(CreateCompanyContactForm));
    final controller = createCompanyContactForm.createCompanyContactFormParam?.controller;

    await testConfig.fakeDelay(2);

    /// Find & Enter Text on first name field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.firstNameKey, text: 'Veer');

    /// Find & Enter Text on last name field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.lastNameKey, text: 'Singh');

    /// Find & Enter Text on company name field
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.companyNameKey, text: 'Test');

    /// Find & Enter Text on phone fields
    await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '9876543210', fieldIndex: 0);

    /// Find & Enter Text on email fields
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'veer@gmail.com', fieldIndex: 0);

    /// Find & Tap on address expansion tile section
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addressSectionKey);

    /// Find & Enter Text on address fields
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.addressLineTwoKey, text: 'Virar west');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.cityKey, text: 'Mumbai');
    await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.zipKey, text: '401305');

    /// Find & Tap on state dropdown field
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.stateKey);
    /// Find & Enter Text on search field
    Finder? searchStateField = find.descendant(of: find.byType(JPSingleSelect), matching: find.byType(JPInputBox));
    await TestHelper.enterText(widgetTester, testConfig, finder: searchStateField, text: 'no');
    /// Find & Tap on first searched state
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: '0');

    // /// Find & Tap on Address field
    // await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addressKey);

    // /// Find & Enter Text on search address fields
    // await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.searchLocationKey, text: 'vira');

    // /// Find & Tap on first location result
    // await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.searchLocationResultListKey + '[0]');

    /// Find & address fields should not be empty
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.addressLineTwoKey, matcherValue: isNotEmpty);
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.cityKey, matcherValue: isNotEmpty);
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.stateKey, matcherValue: isNotEmpty);
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.zipKey, matcherValue: isNotEmpty);

    /// Find & Read only country field is filled from logged in user company details
    await TestHelper.checkJPInputFieldValue(widgetTester, testConfig, key: WidgetKeys.countryKey, checkReadOnly: true, matcherValue: isNotEmpty);
    
    if (controller?.service.isJobContactPersonForm ?? false) {
      /// Find job contact additional options view
      expect(find.byKey(testConfig.getKey(WidgetKeys.jobContactAdditionalOptionsSectionKey)), findsOneWidget);

      /// this section should not show additional options section in job contact form
      expect(find.byKey(testConfig.getKey(WidgetKeys.additionalOptionsSectionKey)), findsNothing);

      /// Find & Tap on set as primary toggle
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.setAsPrimaryKey);

      if (controller?.service.companyContactModel?.id == null) {
        /// Find & Tap on save as company contact toggle
        await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.saveAsCompanyContactKey);
      } else {
        /// this field should not show if contact model id is not null
        expect(find.byKey(testConfig.getKey(WidgetKeys.saveAsCompanyContactKey)), findsNothing);
      }
    } else {
      /// Find & Tap on additional options expansion tile section
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.additionalOptionsSectionKey);
      /// this section should not show job contact additional options in company contact form
      expect(find.byKey(testConfig.getKey(WidgetKeys.jobContactAdditionalOptionsSectionKey)), findsNothing);

      /// Find & Tap on assign group dropdown field
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.assignGroupsKey);
      /// Find & Tap on first group
      Finder? assignGroupSelectionTile = find.descendant(of: find.byType(JPMultiSelectView), matching: find.byType(InkWell));
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: assignGroupSelectionTile.at(1));
      /// Find & Tap on done button after group selection
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.widgetWithText(JPButton, 'DONE'));

      if (controller?.pageType == CompanyContactFormType.createForm) {
        /// Find & Enter Text on notes field
        await TestHelper.enterText(widgetTester, testConfig, key: WidgetKeys.notesKey, text: 'notes test');
      } else {
        /// this field should not show if page type is not create company contact form
        expect(find.byKey(testConfig.getKey(WidgetKeys.notesKey)), findsNothing);
      }
    }
    
    testConfig.binding?.testTextInput.onCleared?.call();
    
    testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.clickSaveTestDesc);
    await testConfig.fakeDelay(1);

    await _clickSaveButton(widgetTester);
  }

  /// Tap on add company contact floating button
  Future<void> _clickAddCompanyContactButton(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.goToContactPersonFormPageTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addCompanyContactKey);
  }

  Future<void> _goToCompanyContactForm(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(5);
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.companyContactGroupDesc, TestDescription.clickToCompanyContactDrawerItemTestDesc);
    await testConfig.fakeDelay(2);

    /// Tap on company contact item button in drawer 
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.companyContactsItemKey);

    await _clickAddCompanyContactButton(widgetTester);
  }

  Future<void> _goToJobContactPersonForm(WidgetTester widgetTester) async {
    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.jobContactPersonTestDesc); 
    await TestHelper.backToHomePage(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(5);
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.clickToRecentJobsDrawerItemTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.clickRecentJobsDrawerSection(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.selectFirstJobFromListTestDesc);
    await testConfig.fakeDelay(2);
    await TestHelper.selectFirstJobFromRecentJobsSheet(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.openEndDrawerTestDesc);
    await testConfig.fakeDelay(2);
    
    /// Tap on end drawer button in job summary page
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.clickToAddJobDrawerItemTestDesc);
    await testConfig.fakeDelay(2);

    /// Tap on add job item button in drawer 
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addJobItemKey);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.jobContactPersonTestDesc); 
    await testConfig.fakeDelay(5);

    JobForm jobForm = widgetTester.firstWidget(find.byType(JobForm));

    /// Find & Tap contact person section to expand
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.jobFormSectionsKey)).at(1));

    if (jobForm.service.contactPersons.isEmpty) {
      /// Find & Tap same as customer toggle
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.sameAsCustomerKey);
    } else {
      /// Find & Tap add job contact person button
      await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addJobContactPersonKey);
    }

    await _companyContactFormTest(widgetTester);

    /// Find added contact person in list
    expect(find.widgetWithText(JPText, 'Veer Singh'), findsOneWidget);

    /// Find only one primary tag in contact person list
    expect(find.byKey(testConfig.getKey(WidgetKeys.primaryKey)), findsOneWidget);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.selectContactPersonFromCompanyContactTestDesc);

    /// Find & Tap add job contact person button
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addJobContactPersonKey);
    await widgetTester.pumpAndSettle();

    /// Find & Tap select contact options button to open bottomsheet
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.selectContactOptionsKey);

    /// Find & Tap company contacts option to choose contact
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.text('company_contacts'.tr.capitalize!));

    /// Find & Tap second company contact person
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.contactPersons}[1]');

    /// Find & Tap on set as primary toggle
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.setAsPrimaryKey);

    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.clickSaveTestDesc);
    await testConfig.fakeDelay(2);

    await _clickSaveButton(widgetTester);
    testConfig.setTestDescription(TestDescription.jobContactPersonGroupDesc, TestDescription.showOnlyOnePrimaryContactTestDesc);
    
    /// Find added company contact person in list
    expect(find.widgetWithText(JPText, 'Amit Mallah'), findsOneWidget);

    /// Find only one primary tag in contact person list
    expect(find.byKey(testConfig.getKey(WidgetKeys.primaryKey)), findsOneWidget);

    await testConfig.fakeDelay(5);
  }
  
}