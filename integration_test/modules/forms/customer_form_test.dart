import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/expansion_tile/index.dart';
import 'package:jobprogress/modules/customer/customer_form/form/fields/index.dart';
import 'package:jobprogress/modules/customer/customer_form/form/index.dart';
import 'package:jobprogress/modules/customer/customer_form/form/sections/section.dart';
import 'package:jobprogress/modules/customer/customer_form/index.dart';
import 'package:jobprogress/modules/customer/details/page.dart';
import 'package:jobprogress/modules/home/page.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'common/common_form_test.dart';
import '../../config/test_config.dart';
import '../../core/test_base.dart';
import '../../core/test_description.dart';
import '../../core/test_helper.dart';
import '../../mock_responses/customer_form_mock_response.dart';


void main() {
  TestConfig.initialSetUpAll();
  CustomerFormTestCase().runTest();
}

class CustomerFormTestCase extends TestBase {

  /// [widgetTester] helps in accessing widget tester anywhere with in file
  late WidgetTester widgetTester;

  /// [commonForm] helps in testing common forms e.g. address, custom fields etc.
  late TestCommonForm commonForm;

  /// [runTest] Runs a test with the given configuration.
  ///
  /// Parameters:
  ///   - isMock: Whether to use mock data for the test. Defaults to true.
  @override
  void runTest({bool isMock = true}) {
    testConfig.runTestWidget(TestDescription.customerFormGroupDesc, (tester) async {
      // Performing user login to execute customer form test cases
      await setDescription(TestDescription.correctCredentialLoginTestDesc);
      await testConfig.successLoginCase(widgetTester);
      // Executing customer for test cases
      await runCustomerFormTestCase(tester);
    }, isMock);
  }

  Future<void> init(WidgetTester tester) async {
    // Setting up tester to be accessed globally
    widgetTester = tester;
    // Initializing common forms
    commonForm = TestCommonForm(widgetTester, testConfig, TestDescription.customerFormGroupDesc);
    // Updating company settings to display default form fields
    CompanySettingsService.addOrReplaceCompanySetting(CompanySettingConstants.prospectCustomize, <String, dynamic>{});
  }

  Future<void> runCustomerFormTestCase(WidgetTester tester) async {
    await init(tester);
    if (PhasesVisibility.canShowSecondPhase) {
      await widgetTester.pumpAndSettle();
      await _handleBackPress();
      await _goToCustomerForm();
      await _expandCollapseAllSections();
      await _selectAndUpdateFlags();
      await _fillAndValidateFields(validateBeforeFilling: true);
      await _clickSaveButton(testSuccess: true);
      await _goToCustomerForm();
      await _switchFormType(isCommercial: false);
      await _fillAndValidateFields(isCommercial: true, onlyRequired: true);
      await _clickSaveButton(testSuccess: true);
      await _goToCustomerForm();
      await _testFormFieldsShuffling();
    }
  }

  /// [_handleBackPress] Handles the back press events
  Future<void> _handleBackPress() async {
      // Go to the customer form
      await _goToCustomerForm();
  
      // Closes form without showing changes made dialog, when no changes were made
      await setDescription(TestDescription.closeFormWithoutConfirmation);
      await TestHelper.clickSystemBackButton(widgetTester);
      await widgetTester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(CustomerFormView), findsNothing);

      // Go to the customer form
      await testConfig.fakeDelay(2);
      await _goToCustomerForm();
  
      // Updating form data to have different data than initial
      await setDescription(TestDescription.updateFormDataForConfirmation);
      await TestHelper.enterText(widgetTester, testConfig, text: 'Man', finder: find.byType(JPInputBox).first.at(0));

      // Displaying unsaved changes dialog and tap on cancel to close it
      await setDescription(TestDescription.unsavedChangesCancelTap);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: CustomerFormView, previousPage: HomeView);
      await widgetTester.pumpAndSettle();

      expect(find.byType(CustomerFormView), findsOneWidget);
      expect(find.byType(JPConfirmationDialog), findsNothing);
  
      // Displaying unsaved changes dialog and tapping on don't save to close both form and dialog
      await setDescription(TestDescription.unsavedChangesDoNotSaveTap);
      await TestHelper.unsavedChangesMadeTestCase(widgetTester, testConfig, currentPage: CustomerFormView, previousPage: HomeView, tapOnDontSave: true);
      await widgetTester.pumpAndSettle();

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.byType(CustomerFormView), findsNothing);
  }

  /// [_goToCustomerForm] helps in navigating to the customer form
  Future<void> _goToCustomerForm() async {
    // Set the description for the action
    await setDescription(TestDescription.openSideMenuForOption);

    // Open the end drawer
    await TestHelper.openEndDrawer(widgetTester, testConfig);

    // Tap on the "Add Lead/Prospect/Customer" option
    await setDescription(TestDescription.addLeadProspectCustomerTap);
    await TestHelper.tapOnWidget(widgetTester, testConfig, key: WidgetKeys.addLeadProspectCustomer);

    // Display the form with the first section expanded
    await setDescription(TestDescription.displayFormWithFirstSectionExpanded);

    // Ensure that the CustomerFormView widget is displayed
    expect(find.byType(CustomerFormView), findsOneWidget);
  }

  /// Find & Tap on save button
  Future<void> _clickSaveButton({bool testSuccess = false}) async {
    Helper.hideKeyboard();
    await testConfig.fakeDelay(2);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: find.byKey(testConfig.getKey(WidgetKeys.appBarSaveButtonKey)));
    await testConfig.fakeDelay(2);
    if (testSuccess) {
      await setDescription(TestDescription.openCustomerDetailsFromForm);
      await widgetTester.pumpAndSettle();
      expect(find.byType(CustomerDetailView), findsOneWidget);
      await setDescription(TestDescription.goBackToHomePage);
      await TestHelper.backToHomePage(widgetTester, testConfig);
      await widgetTester.pumpAndSettle();
      expect(find.byType(HomeView), findsOneWidget);
      await testConfig.fakeDelay(5);
    }
  }

  Future<void> _switchFormType({bool isCommercial = true}) async {
    /// finding available radio widgets
    await testConfig.fakeDelay(2);
    Finder? radioFinder = find.byType(JPRadioBox);
    expect(radioFinder, findsNWidgets(2));

    /// tapping of form type switcher radio
    final tapFinder = isCommercial ? radioFinder.at(0) : radioFinder.at(1);
    await TestHelper.ensureVisible(tapFinder, widgetTester);

    /// initially form type should not be selected
    bool radioValue = (tapFinder.evaluate().first.widget as JPRadioBox).radioData![0].value;
    bool groupValue = (tapFinder.evaluate().first.widget as JPRadioBox).groupValue;
    expect(radioValue, !groupValue);

    /// tapping on form type and updating
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: tapFinder);

    /// tapped form type should be selected
    bool updatedGroup = (tapFinder.evaluate().first.widget as JPRadioBox).groupValue;
    expect(radioValue, updatedGroup);
  }

  /// [_expandCollapseAllSections] Expands or collapses all sections in the widget.
  /// This function sets the description, waits for the widget to settle,
  /// finds all expandable sections, expands or collapses them,
  /// and then toggles the first section.
  Future<void> _expandCollapseAllSections({bool doUpdateDescription = true}) async {
      // Set the description
      if (doUpdateDescription) await setDescription(TestDescription.expandCollapseAllSections);
      // Wait for the widget to settle
      await widgetTester.pumpAndSettle();
      // Find all expandable sections
      Finder? expandableSectionsFinder = find.byType(JPExpansionTile);
      // Toggle the first section
      await TestHelper.expandCollapseSection(widgetTester, testConfig, finder: expandableSectionsFinder.at(0), toggleOnly: true);
      // Loop through the remaining sections and expand or collapse them
      for (int i = 1; i <= expandableSectionsFinder.evaluate().skip(1).length; i++) {
        await TestHelper.expandCollapseSection(widgetTester, testConfig, finder: expandableSectionsFinder.at(i));
      }
      // Toggle the first section again
      await TestHelper.expandCollapseSection(widgetTester, testConfig, finder: expandableSectionsFinder.at(0), toggleOnly: true);
  }

  /// [_selectAndUpdateFlags] Selects and updates flags.
  ///
  /// This method performs the following steps:
  /// 1. Expects that the flags chip is not displayed when no flags are selected.
  /// 2. Selects the flags and expects that they are displayed in the form.
  /// 3. Removes the selected flag and expects that it is not displayed in the form.
  /// 4. Updates the flags and expects that they are displayed in the form.
  Future<void> _selectAndUpdateFlags() async {
      // Expects that the flags chip is not displayed when no flags are selected.
      expect(find.byType(JPChip), findsNothing);

      // Selecting flags and displaying in form
      await setDescription(TestDescription.selectFlagsAndDisplay);
      final flagIconFinder = find.byKey(testConfig.getKey(WidgetKeys.customerFormFlagButtonKey));
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, flagIconFinder);
      await widgetTester.pumpAndSettle();
      expect(find.byType(JPChip), findsWidgets);

      // Removing selected flags
      await setDescription(TestDescription.removeFlagsAndNotDisplay);
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, flagIconFinder);
      await widgetTester.pumpAndSettle();
      expect(find.byType(JPChip), findsNothing);
  
      // Updating flags selection
      await setDescription(TestDescription.updateFlagsAndDisplay);
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, flagIconFinder, selectOnlyOne: true);
      await widgetTester.pumpAndSettle();
      expect(find.byType(JPChip), findsWidgets);
  }

  Future<void> _switchBetweenFormTypes({bool avoidDescUpdate = false}) async {
    /// selecting commercial form type
    if (!avoidDescUpdate) await setDescription(TestDescription.switchFormToCommercial);
    await _switchFormType(isCommercial: false);

    /// selecting residential form type
    if (!avoidDescUpdate) await setDescription(TestDescription.switchFormToResidential);
    await _switchFormType();
    await testConfig.fakeDelay(2);
  }

  /// [_fillAndValidateFields] Fills and validates the fields.
  ///
  /// [onlyRequired] specifies if only the required fields should be filled.
  /// [validateBeforeFilling] specifies if validation should be done before filling the fields.
  /// [isCommercial] helps in differentiating between form types
  Future<void> _fillAndValidateFields({
    bool onlyRequired = false,
    bool validateBeforeFilling = false,
    bool isCommercial = false,
  }) async {
    if (validateBeforeFilling) {
      // Validate required fields and focus on first required field
      await setDescription(TestDescription.validateRequiredFieldsAndFocus);
      await _clickSaveButton();
  
      // Show validation based on form type
      await setDescription(TestDescription.showValidationBasedOnFormType);
      await _switchBetweenFormTypes(avoidDescUpdate: true);
    }
  
    await TestHelper.iterateDynamicForm(widgetTester, testConfig, CustomerFormSection, CustomerFormFields,
        groupDesc: TestDescription.customerFormGroupDesc,
        onlyRequired: onlyRequired,
        // Callback function to handle each field
        onFindField: (fieldFinder, key) async {
          switch (key) {
            case CustomerFormConstants.customFields:
              await commonForm.testCustomFields(fieldFinder, deepTesting: !onlyRequired);
              break;
  
            case CustomerFormConstants.salesManCustomerRep:
              await _testSalesManCustomerRep(fieldFinder);
              break;
  
            case CustomerFormConstants.referredBy:
              await _testReferredBy(fieldFinder);
              break;
  
            case CustomerFormConstants.canvasser:
              await _testCanvasser(fieldFinder);
              break;
  
            case CustomerFormConstants.callCenterRep:
              await _testCallCenterRep(fieldFinder);
              break;
  
            case CustomerFormConstants.customerNote:
              await commonForm.testNormalTextInput(fieldFinder, text: 'Customer note goes here...', description: TestDescription.fillCustomerNote);
              break;
  
            case CustomerFormConstants.email:
              await commonForm.testEmailField(fieldFinder, deepTesting: !onlyRequired);
              break;
  
            case CustomerFormConstants.phone:
              await commonForm.testPhoneField(fieldFinder, deepTesting: !onlyRequired);
              break;
  
            case CustomerFormConstants.customerName:
              isCommercial
                  ? await _testFieldVisibility(fieldFinder, isVisible: false)
                  : await _testNameFields(fieldFinder, deepTesting: !onlyRequired);
              break;
  
            case CustomerFormConstants.commercialCustomerName:
              isCommercial
                  ? await _testNameFields(fieldFinder, deepTesting: false)
                  : await _testFieldVisibility(fieldFinder, isVisible: false);
              break;
  
            case CustomerFormConstants.companyName:
              await commonForm.testNormalTextInput(fieldFinder, description: TestDescription.fillCompanyName, text: 'Logiciel Solutions');
              break;
  
            case CustomerFormConstants.managementCompany:
              await commonForm.testNormalTextInput(fieldFinder, description: TestDescription.fillManagementCompany, text: 'Logiciel Management');
              break;
  
            case CustomerFormConstants.propertyName:
              await commonForm.testNormalTextInput(fieldFinder, description: TestDescription.fillPropertyName, text: 'Test Property');
              break;
  
            case CustomerFormConstants.customerAddress:
              await commonForm.testAddressForm(fieldFinder);
              break;
  
            default:
              break;
          }
        }
    );
  }

  /// [_testNameFields] tests customer name fields including primary and
  /// secondary name. This function tries to find the fields of a section and
  /// fills in the data and also performs necessary toggles
  /// Test the name fields.
  /// [fieldFinder] - The finder for the field.
  /// [deepTesting] - Whether to perform deep testing or not. Defaults to true.
  Future<void> _testNameFields(Finder fieldFinder, {bool deepTesting = true}) async {
    // Find the child input boxes
    final childMatcher = find.byType(JPInputBox);

    Finder inputBoxFinder = find.descendant(of: fieldFinder, matching: childMatcher);
    Finder? addRemoveButton = find.descendant(of: fieldFinder, matching: find.byType(SvgPicture));

    // Ensure there are exactly 2 input boxes
    expect(inputBoxFinder, findsNWidgets(2));

    await setDescription(TestDescription.fillFirstAndLastName);
    await TestHelper.enterText(widgetTester, testConfig, text: 'Manveer', finder: inputBoxFinder.at(0));
    await TestHelper.enterText(widgetTester, testConfig, text: 'Singh', finder: inputBoxFinder.at(1));

    if (!deepTesting) return;

    await setDescription(TestDescription.displaySecondaryName);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addRemoveButton);

    // Ensure there are exactly 4 input boxes
    expect(inputBoxFinder, findsNWidgets(4));

    await setDescription(TestDescription.fillSecondaryNameAndLastName);
    await TestHelper.enterText(widgetTester, testConfig, text: 'Manveer', finder: inputBoxFinder.at(2));
    await TestHelper.enterText(widgetTester, testConfig, text: 'Bansal', finder: inputBoxFinder.at(3));
    await setDescription(TestDescription.hideSecondaryNameAndLastName);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addRemoveButton);

    // Ensure there are exactly 2 input boxes
    expect(inputBoxFinder, findsNWidgets(2));

    await setDescription(TestDescription.preserveSecondaryNameAndLastName);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addRemoveButton);

    // Ensure there are exactly 4 input boxes
    expect(inputBoxFinder, findsNWidgets(4));
  }

  /// [_testFieldVisibility] Tests the visibility of a field.
  ///
  /// This function takes a [fieldFinder] to locate the field in the widget tree
  /// and checks if the field is visible or not based on the [isVisible] flag.
  /// It uses [JPInputBox] as the child matcher to find the input box within the field.
  /// Finally, it asserts that the [inputBoxFinder] either finds one widget (if isVisible is true)
  /// or finds nothing (if isVisible is false).
  Future<void> _testFieldVisibility(Finder fieldFinder, {bool isVisible = true}) async {
      // Find the input box within the field
      final childMatcher = find.byType(JPInputBox);
      Finder inputBoxFinder = find.descendant(of: fieldFinder, matching: childMatcher);
      // Assert the visibility of the input box
      expect(inputBoxFinder, isVisible ? findsOneWidget : findsNothing);
  }

  /// [toggleSecondaryName] Toggles the secondary name.
  ///
  /// This method finds the secondary name add button using the provided key and taps on it.
  /// It then waits for a delay of 2 seconds.
  Future<void> toggleSecondaryName() async {
      // Find the secondary name add button using the provided key
      Finder? secNameAddButtonFinder = find.byKey(testConfig.getKey(WidgetKeys.customerFormSecNameButtonKey));
      // Tap on the secondary name add button
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: secNameAddButtonFinder);
      // Wait for a delay of 2 seconds
      await testConfig.fakeDelay(2);
  }

  /// [_testSalesManCustomerRep] Test the functionality of selecting and filling in Salesman/Customer Rep
  Future<void> _testSalesManCustomerRep(Finder fieldFinder) async {
      // Set the description of the test
      await setDescription(TestDescription.fillSalesManCustomerRep);

      // Find the input boxes within the given field
      Finder inputBoxFinders = find.descendant(of: fieldFinder, matching: find.byType(JPInputBox));
      String previousText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      expect(inputBoxFinders, findsOneWidget);

      // Select a dropdown option at index 1
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 1);
      await widgetTester.pumpAndSettle();

      // Get the updated text after selecting the dropdown option
      String updatedText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";

      // Assert that the previous text is not equal to the updated text
      expect(previousText, isNot(updatedText));
  
      // Assert that the updated text is not empty
      expect(updatedText, isNotEmpty);
  }

  /// [_testReferredBy] is Test method for testing the behavior of the referredBy feature.
  /// [fieldFinder] is the finder for the field being tested.
  Future<void> _testReferredBy(Finder fieldFinder) async {
      await setDescription(TestDescription.fillReferredBy);
  
      // Find the input box inside the fieldFinder
      Finder inputBoxFinders = find.descendant(of: fieldFinder, matching: find.byType(JPInputBox));
      // Get the previous text in the input box
      String previousText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      // Ensure that there is only one input box widget
      expect(inputBoxFinders, findsOneWidget);
      // Ensure that the previous text is empty
      expect(previousText, isEmpty);
  
      // Select an option from the drop-down
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 2);
      await widgetTester.pumpAndSettle();
  
      // Get the updated text in the input box
      String updatedText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      // Ensure that the previous text is not equal to the updated text
      expect(previousText, isNot(updatedText));
      // Ensure that the updated text is not empty
      expect(updatedText, isNotEmpty);

      // Select another option from the drop-down
      await setDescription(TestDescription.showReferredByAllFields);
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 1);
      await widgetTester.pumpAndSettle();
  
      // Ensure that there are three input box widgets
      expect(inputBoxFinders, findsNWidgets(3));

      // Select another option from the drop-down
      await setDescription(TestDescription.showReferredByLimitedFields);
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 0);
      await widgetTester.pumpAndSettle();
  
      // Ensure that there are two input box widgets
      expect(inputBoxFinders, findsNWidgets(2));
  
      await setDescription(TestDescription.fillReferredByNote);
  
      // Get the previous note text in the input box
      String previousNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
      // Ensure that the previous note text is empty
      expect(previousNoteText, isEmpty);
  
      // Enter text in the input box
      await TestHelper.enterText(widgetTester, testConfig, text: 'Dummy note', finder: inputBoxFinders.at(1));
  
      // Get the updated note text in the input box
      String updatedNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
      // Ensure that the updated note text is not equal to the previous note text
      expect(updatedNoteText, isNot(previousNoteText));
  }

  /// [_testCanvasser] Test the functionality of selecting and filling in the Canvasser field.
  Future<void> _testCanvasser(Finder fieldFinder) async {
      // Set the description for this test case
      await setDescription(TestDescription.fillCanvasser);
  
      // Find the input boxes within the given field finder
      Finder inputBoxFinders = find.descendant(of: fieldFinder, matching: find.byType(JPInputBox));
  
      // Get the previous text in the first input box
      String previousText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      expect(inputBoxFinders, findsOneWidget);
      expect(previousText, isNotEmpty);
  
      // Select the second item in the dropdown and wait for the UI to settle
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 2);
      await widgetTester.pumpAndSettle();
  
      // Get the updated text in the first input box
      String updatedText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      expect(inputBoxFinders, findsOneWidget);
      expect(previousText, isNot(updatedText));
      expect(updatedText, isNotEmpty);
  
      // Set the description for this test case
      await setDescription(TestDescription.showCanvasserAllFields);
  
      // Select the first item in the dropdown and wait for the UI to settle
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 1);
      await widgetTester.pumpAndSettle();
      expect(inputBoxFinders, findsNWidgets(2));
  
      // Set the description for this test case
      await setDescription(TestDescription.fillCanvasserNote);
  
      // Get the previous note text in the second input box
      String previousNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
      expect(previousNoteText, isEmpty);
  
      // Enter the text 'Canvasser note' in the second input box
      await TestHelper.enterText(widgetTester, testConfig, text: 'Canvasser note', finder: inputBoxFinders.at(1));
  
      // Get the updated note text in the second input box
      String updatedNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
      expect(updatedNoteText, isNot(previousNoteText));
  }

  /// [_testCallCenterRep] Test the call center representative functionality.
  ///
  /// This function selects and fills in the call center representative field.
  /// It also tests that the field updates correctly when different options are selected.
  /// Additionally, it tests the call center representative note field.
  Future<void> _testCallCenterRep(Finder fieldFinder) async {
      // Set the description for the test case
      await setDescription(TestDescription.fillCallCenterRep);
  
      // Find the input box within the given field finder
      Finder inputBoxFinders = find.descendant(of: fieldFinder, matching: find.byType(JPInputBox));
  
      // Get the previous text in the input box
      String previousText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
      
      // Assert that the input box is found and the previous text is not empty
      expect(inputBoxFinders, findsOneWidget);
      expect(previousText, isNotEmpty);
  
      // Select an option from the drop-down
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 2);
      await widgetTester.pumpAndSettle();
  
      // Get the updated text in the input box
      String updatedText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(0)).inputBoxController?.text ?? "";
  
      // Assert that the input box is still found, the previous text is not equal to the updated text, and the updated text is not empty
      expect(inputBoxFinders, findsOneWidget);
      expect(previousText, isNot(updatedText));
      expect(updatedText, isNotEmpty);
  
      // Set the description for the test case
      await setDescription(TestDescription.showCallCenterRepAllFields);
  
      // Select a different option from the drop-down
      await TestHelper.selectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), index: 1);
      await widgetTester.pumpAndSettle();
  
      // Assert that there are two input boxes found
      expect(inputBoxFinders, findsNWidgets(2));
  
      // Set the description for the test case
      await setDescription(TestDescription.fillCallCenterRepNote);
  
      // Get the previous note text in the input box
      String previousNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
  
      // Assert that the previous note text is empty
      expect(previousNoteText, isEmpty);
  
      // Enter text in the note input box
      await TestHelper.enterText(widgetTester, testConfig, text: 'Call center rep note', finder: inputBoxFinders.at(1));
  
      // Get the updated note text in the input box
      String updatedNoteText = widgetTester.widget<JPInputBox>(inputBoxFinders.at(1)).inputBoxController?.text ?? "";
  
      // Assert that the updated note text is not equal to the previous note text
      expect(updatedNoteText, isNot(previousNoteText));
  }

  /// [_updateFields] Updates the fields in the customer form.
  ///
  /// The [updatedFields] parameter is a map containing the updated field values.
  /// The [description] parameter is a description of the test scenario.
  /// The [doCancel] parameter indicates whether to cancel the update or not.
  Future<void> _updateFields(Map<String, dynamic> updatedFields, String description, {bool doCancel = false}) async {
      // Find the customer form widget
      Finder formFinder = find.byType(CustomerForm);
      expect(formFinder, findsOneWidget);
      // Set the description for the test
      await setDescription(description);

      // Add or replace the company setting
      CompanySettingsService.addOrReplaceCompanySetting(CompanySettingConstants.prospectCustomize, updatedFields);
      
      // Show the update field confirmation dialog
      widgetTester.widget<CustomerForm>(formFinder).service.showUpdateFieldConfirmation();
      await testConfig.fakeDelay(1);
      await widgetTester.pumpAndSettle();
      
      // Find the confirmation dialog widget
      Finder confirmationDialogFinder = find.byType(JPConfirmationDialog);
      expect(confirmationDialogFinder, findsOneWidget);
      
      // Find the button widget in the confirmation dialog
      Finder buttonFinder = find.descendant(of: confirmationDialogFinder, matching: find.byType(JPButton));
      
      // Tap on the appropriate button based on the doCancel parameter
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: buttonFinder.at(doCancel ? 0 : 1));
      await widgetTester.pumpAndSettle();
      await testConfig.fakeDelay(2);
  }

  /// [_testFormFieldsShuffling] Test method for shuffling form fields.
  Future<void> _testFormFieldsShuffling() async {
      // Find the section and fields in the form
      Finder sectionFinder = find.byType(CustomerFormSection);
      Finder fieldsFinder = find.byType(CustomerFormFields);
      
      // Update fields with shuffled fields and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithShuffledFields, TestDescription.displayFieldsRandomly);
      await _expandCollapseAllSections(doUpdateDescription: false);
      expect(sectionFinder, findsNWidgets(4));
      expect(fieldsFinder, findsNWidgets(15));
  
      // Update fields with limited fields and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithLimitedFields, TestDescription.displayLimitedFields);
      await _expandCollapseAllSections(doUpdateDescription: false);
      expect(sectionFinder, findsNWidgets(4));
      expect(fieldsFinder, findsNWidgets(10));
  
      // Update fields with one section and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithOneSection, TestDescription.displayOneSection);
      expect(sectionFinder, findsNWidgets(1));
      expect(fieldsFinder, findsNWidgets(4));
  
      // Update fields with limited sections and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithLimitedSections, TestDescription.hideOtherInfoSection);
      await _expandCollapseAllSections(doUpdateDescription: false);
      expect(sectionFinder, findsNWidgets(3));
      expect(fieldsFinder, findsNWidgets(6));
  
      // Update fields with required fields and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithRequiredFields, TestDescription.displayRequiredFields);
      expect(sectionFinder, findsNWidgets(1));
      expect(fieldsFinder, findsNWidgets(3));
  
      // Update fields with one section without canceling and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithOneSection, TestDescription.notUpdateFields, doCancel: true);
      expect(sectionFinder, findsNWidgets(1));
      expect(fieldsFinder, findsNWidgets(3));
  
      // Update fields with one section and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithOneSection, TestDescription.displayOneSection);
      expect(sectionFinder, findsNWidgets(1));
      expect(fieldsFinder, findsNWidgets(4));

      // Update fields with two section and verify the number of sections and fields
      await _updateFields(CustomerFormMockResponse.companySettingsWithTwoSection, TestDescription.displayTwoSection);
      await _expandCollapseAllSections(doUpdateDescription: false);
      expect(sectionFinder, findsNWidgets(2));
      expect(fieldsFinder, findsNWidgets(5));

      // Set description and fill and validate fields
      await setDescription(TestDescription.fillLimitedFormFields);
      await _fillAndValidateFields(onlyRequired: true);
  
      // Update fields with empty company settings and verify the number of sections and fields
      await _updateFields({}, TestDescription.displayDefaultFieldsAndSection);
      await setDescription(TestDescription.preserveFilledData);
      expect(sectionFinder, findsNWidgets(4));
      expect(fieldsFinder, findsNWidgets(15));

      await _clickSaveButton(testSuccess: true);
  }

  /// [setDescription] sets the description of the test case
  /// Parameters:
  ///   - description: The new description to be displayed before executing case
  /// Returns: A Future that completes when the description is set.
  Future<void> setDescription(String description) async {
    // Set the test description in the test config
    testConfig.setTestDescription(TestDescription.customerFormGroupDesc, description);

    // Simulate a delay of 2 seconds
    await testConfig.fakeDelay(2);
  }
}