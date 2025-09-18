import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/taplocator.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/forms/address/widgets/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/fields/dropdown.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/fields/text.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/index.dart';
import 'package:jobprogress/global_widgets/forms/email/fields/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/fields/tiles.dart';
import 'package:jobprogress/global_widgets/search_location/search_screen/widgets/listing.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../config/test_config.dart';
import '../../../core/test_description.dart';
import '../../../core/test_helper.dart';

class TestCommonForm {

  final WidgetTester widgetTester;
  final TestConfig testConfig;
  final String groupDesc;

  TestCommonForm(this.widgetTester, this.testConfig, this.groupDesc);

  /// [testCustomFields] Tests the custom fields functionality.
  ///
  /// [fieldFinder] - The Finder for the custom fields.
  /// [deepTesting] - Whether to perform deep testing or not. Default is true.
  Future<void> testCustomFields(Finder fieldFinder, {bool deepTesting = true}) async {
    // Set the test description
    await setDescription(TestDescription.fillCustomFields);

    // Find the custom fields form widget
    Finder customFieldsFinder = find.descendant(of: fieldFinder, matching: find.byType(CustomFieldsForm));
    expect(customFieldsFinder, findsOneWidget);

    // Find the custom field text input and dropdown widgets
    Finder customFieldTextInputFinder = find.descendant(of: customFieldsFinder, matching: find.byType(CustomFieldTextInput));
    Finder customFieldDropDownFinder = find.descendant(of: customFieldsFinder, matching: find.byType(CustomFieldDropdown));

    // Hide keyboard
    Helper.hideKeyboard();

    // Set the test description
    await setDescription(TestDescription.fillCustomDropDown);

    // Iterate through each custom field dropdown widget
    for (int i = 0; i < customFieldDropDownFinder.evaluate().length; i++) {
      // Find the input box widget within the custom field dropdown widget
      Finder inputBoxFinders = find.descendant(of: customFieldDropDownFinder.at(i), matching: find.byType(JPInputBox));
      expect(inputBoxFinders, findsOneWidget);

      // Set the test description
      await setDescription(TestDescription.selectDropDown1Options);

      // Select the first option in the dropdown
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, inputBoxFinders.at(0), selectOnlyOne: true, isNetworkDropdown: true);
      expect(inputBoxFinders, findsNWidgets(2));

      // If deep testing is not enabled, continue to the next iteration
      if (!deepTesting) continue;

      // Set the test description
      await setDescription(TestDescription.selectDropDown2Options);

      // Select an option in the second dropdown
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, inputBoxFinders.at(1), isNetworkDropdown: true);
      expect(inputBoxFinders, findsNWidgets(3));

      // Set the test description
      await setDescription(TestDescription.selectDropDown3Options);

      // Select an option in the third dropdown
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, inputBoxFinders.at(2), isNetworkDropdown: true);
      expect(inputBoxFinders, findsNWidgets(3));

      // Set the test description
      await setDescription(TestDescription.removeOneDropDown3Options);

      // Remove the selected option in the third dropdown
      Finder chipsFinder = find.descendant(of: inputBoxFinders.at(2), matching: find.byType(JPChip));
      Finder crossButtonFinder = find.descendant(of: chipsFinder.at(0), matching: find.byIcon(Icons.close));
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: crossButtonFinder);
      expect(inputBoxFinders, findsNWidgets(3));

      // Set the test description
      await setDescription(TestDescription.removeChildDropdown2);

      // Remove the selected option in the second dropdown
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, inputBoxFinders.at(1), isNetworkDropdown: true);
      expect(inputBoxFinders, findsNWidgets(2));

      // Set the test description
      await setDescription(TestDescription.notPreserveDropdownValue);

      // Select a different option in the second dropdown
      await TestHelper.selectMultiSelectDropDown(widgetTester, testConfig, inputBoxFinders.at(1), selectOnlyOne: true, isNetworkDropdown: true);
      expect(inputBoxFinders, findsNWidgets(3));
    }

    // List of options to fill in the custom text input fields
    List<String> fillInOptions = ['Lorem Ipsum', 'Great wall of china', 'Test Input', 'Mountains'];

    // Iterate over the custom fields
    for (int i = 0; i < customFieldTextInputFinder.evaluate().length; i++) {
      // Set the description for the test
      await setDescription(TestDescription.fillInCustomFields);

      // Get the widget for the current custom field
      final fieldWidget = customFieldTextInputFinder.at(i).evaluate().first.widget as CustomFieldTextInput;

      // Find the text input field widget for the current custom field
      final textInputField = find.descendant(of: customFieldTextInputFinder.at(i), matching: find.byType(JPInputBox));

      // Check if the custom field is empty
      if (fieldWidget.field.controller.text.isEmpty) {
        // Store the previous text value
        final previousText = fieldWidget.field.controller.text;

        // Assert that the custom field is empty
        expect(fieldWidget.field.controller.text, isEmpty);

        // Enter a random value into the text input field
        await TestHelper.enterText(widgetTester, testConfig, text: fillInOptions[Random().nextInt(3)], finder: textInputField.at(0));

        // Assert that the custom field is not empty anymore
        expect(fieldWidget.field.controller.text, isNot(previousText));
      }
    }
  }

  /// [testNormalTextInput] A function to test normal text input.
  ///
  /// [fieldFinder] - The finder for the input field.
  /// [description] - The description for the test.
  /// [text] - The text to enter into the input field.
  Future<void> testNormalTextInput(Finder fieldFinder, {required String description, required String text,}) async {
      // Find the input box widget
      final childMatcher = find.byType(JPInputBox);
      Finder inputBoxFinder = find.descendant(of: fieldFinder, matching: childMatcher);
      expect(inputBoxFinder, findsOneWidget);
  
      // Set the description
      await setDescription(description);
  
      // Enter the text into the input box
      await TestHelper.enterText(widgetTester, testConfig, text: text, finder: inputBoxFinder);
  }

  /// [testAddressForm] Tests the address form.
  /// 
  /// [fieldFinder] - The finder for the field.
  /// [hasBillingAddress] - Whether the form has a billing address. Defaults to true.
  Future<void> testAddressForm(Finder fieldFinder, {bool hasBillingAddress = true}) async {
      // Find the address section within the field
      Finder addressSectionFinder = find.descendant(of: fieldFinder, matching: find.byType(AddressSection));
      // Find the billing address toggle within the address section
      Finder billAddressToggleFinder = find.descendant(of: addressSectionFinder.at(0), matching: find.byType(JPCheckbox));
  
      // If there is no billing address, return
      if (!hasBillingAddress) return;
  
      // Test the address input for the first address section
      await testAddressInput(addressSectionFinder.at(0));
  
      // Set the description for displaying the billing address
      await setDescription(TestDescription.displayBillingAddress);
      // Tap on the billing address toggle
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: billAddressToggleFinder);
      // Expect to find 2 address sections
      expect(addressSectionFinder, findsNWidgets(2));
  
      // Test the address input for the second address section
      await testAddressInput(addressSectionFinder.at(1));
  
      // Set the description for hiding the billing address
      await setDescription(TestDescription.hideBillingAddress);
      // Tap on the billing address toggle
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: billAddressToggleFinder);
      // Expect to find 1 address section
      expect(addressSectionFinder, findsNWidgets(1));
  
      // Set the description for preserving the billing address
      await setDescription(TestDescription.preserveBillingAddress);
      // Tap on the billing address toggle
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: billAddressToggleFinder);
      // Expect to find 2 address sections
      expect(addressSectionFinder, findsNWidgets(2));
  
      // Set the description for collapsing the billing address
      await setDescription(TestDescription.collapseBillingAddress);
      // Tap on the second address section to collapse it
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addressSectionFinder.at(1), tapLocation: TapAt.topLeft, tapOffset: const Offset(10, 10));
  }

  /// [testAddressInput] Test for address input
  Future<void> testAddressInput(Finder addressSectionFinder) async {
    // Set the description for the test
    await setDescription(TestDescription.fillAddressDetails);

    // Find the address fields within the address section
    Finder addressFieldsFinder = find.descendant(of: addressSectionFinder, matching: find.byType(JPInputBox));

    // Get the individual address fields
    JPInputBox address = addressFieldsFinder.at(0).evaluate().first.widget as JPInputBox;
    JPInputBox addressLine2 = addressFieldsFinder.at(1).evaluate().first.widget as JPInputBox;
    JPInputBox city = addressFieldsFinder.at(2).evaluate().first.widget as JPInputBox;
    JPInputBox state = addressFieldsFinder.at(3).evaluate().first.widget as JPInputBox;
    JPInputBox zipCode = addressFieldsFinder.at(4).evaluate().first.widget as JPInputBox;
    JPInputBox country = addressFieldsFinder.at(5).evaluate().first.widget as JPInputBox;

    // Assertions for the address fields
    expect(addressSectionFinder, findsOneWidget);
    expect(address.inputBoxController?.text, isEmpty);
    expect(addressLine2.inputBoxController?.text, isEmpty);
    expect(city.inputBoxController?.text, isEmpty);
    expect(state.inputBoxController?.text, isEmpty);
    expect(zipCode.inputBoxController?.text, isEmpty);
    expect(country.inputBoxController?.text, isNotEmpty);

    // Set the description for opening the address search page
    await setDescription(TestDescription.openAddressSearchPage);
    // Tap on the address field to trigger the address search
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addressFieldsFinder.at(0));
    // Set the description for the address search action
    await setDescription(TestDescription.performAddressSearch);

    // Find the search field
    Finder searchFieldFinder = find.byType(JPInputBox);
    // Find the address search results
    Finder addressFinders = find.byType(CustomMaterialCard);

    // Enter text into the search field
    await TestHelper.enterText(widgetTester, testConfig, text: '915 South Jackson Street', finder: searchFieldFinder);
    await widgetTester.pumpAndSettle();

    // Assertions for the address search results
    expect(find.byType(SearchResultListing), findsOneWidget);
    expect(addressFinders, findsWidgets);


    // Set the description for the test step
    await setDescription(TestDescription.selectAndFillAddress);
    // Tap on the address widget at the specified index
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: addressFinders.at(0));
    await widgetTester.pumpAndSettle();

    // Assert that the input boxes have the expected values
    expect(address.inputBoxController?.text, isNotEmpty);
    expect(addressLine2.inputBoxController?.text, isEmpty);
    expect(city.inputBoxController?.text, isNotEmpty);
    expect(state.inputBoxController?.text, isNotEmpty);
    expect(zipCode.inputBoxController?.text, isNotEmpty);
    expect(country.inputBoxController?.text, isNotEmpty);

    // Set the description for the test step
    await setDescription(TestDescription.fillAddressLine2);
    // Enter text in the address field at the specified index
    await TestHelper.enterText(widgetTester, testConfig, text: '918 South Chain Street Long Route', finder: addressFieldsFinder.at(1));

    // Set the description for the test step
    await setDescription(TestDescription.updateAutoFilledState);
    // Select an item from the dropdown at the specified index
    await TestHelper.selectDropDown(widgetTester, testConfig, addressFieldsFinder.at(3), index: 2);

    // Set the description for the test step
    await setDescription(TestDescription.updateFilledZipCode);
    // Enter text in the zip code field at the specified index
    await TestHelper.enterText(widgetTester, testConfig, text: '123456BH', finder: addressFieldsFinder.at(4));

    // Set the description for the test step
    await setDescription(TestDescription.updateAutoFilledCountry);
    // Select an item from the dropdown at the specified index
    await TestHelper.selectDropDown(widgetTester, testConfig, addressFieldsFinder.at(5), index: 2);
  }

  /// [testEmailField] Test the email field.
  ///
  /// [fieldFinder]: The finder for the email field.
  /// [deepTesting]: Flag to indicate whether deep testing should be performed.
  Future<void> testEmailField(Finder fieldFinder, {bool deepTesting = true}) async {
    // Validate wrong email
    await setDescription(TestDescription.validateEmailForWrongEmail);
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'abc', fieldIndex: 0);

    // Validate correct email
    await setDescription(TestDescription.validateEmailForCorrectEmail);
    await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, 'abc@gmail.com', fieldIndex: 0);

    // Add additional email fields
    await testConfig.fakeDelay(1);
    if (!deepTesting) return;
    await setDescription(TestDescription.fillAdditionalEmail);
    for (int i = 0; i < 4; i++) {
      await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: true);
      await testConfig.fakeDelay(1);
      await TestHelper.enterTextOnEmailFields(widgetTester, testConfig, '${i + 2}@gmail.com', fieldIndex: i + 1);
    }

    // Hide keyboard
    Helper.hideKeyboard();

    // Pump and settle
    await widgetTester.pumpAndSettle();

    // Remove last email field
    await setDescription(TestDescription.removeLastEmail);
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: false, deleteIndex: 3);

    // Remove email field in between
    await setDescription(TestDescription.removeInBetweenEmail);
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: false, deleteIndex: 1);

    // Add another email field
    await setDescription(TestDescription.notPreserveEmailAddress);
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: true);

    // Remove failed validation email field
    await setDescription(TestDescription.removeFailedValidationEmail);
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, EmailFormField, isAddBtn: false);
  }

  /// [testPhoneField] Tests the phone field.
  ///
  /// [fieldFinder] - The finder for the phone field.
  /// [deepTesting] - Flag indicating whether to perform deep testing or not.
  Future<void> testPhoneField(Finder fieldFinder, {bool deepTesting = true}) async {
    // Hide the keyboard
    Helper.hideKeyboard();

    if (deepTesting) {
      // Set the description for validating phone for wrong input
      await setDescription(TestDescription.validatePhoneForWrongInput);

      // Enter text on the phone field with wrong input
      await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '1234', fieldIndex: 0);
    }

    // Set the description for validating phone for correct input
    await setDescription(deepTesting ? TestDescription.validatePhoneForCorrectInput : TestDescription.fillPhoneNumber);

    // Enter text on the phone field with correct input
    await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '1234567890', fieldIndex: 0, skipExt: true);

    // Hide the keyboard
    Helper.hideKeyboard();

    // Wait for a delay of 1 second
    await testConfig.fakeDelay(1);

    // Return if deep testing is disabled
    if (!deepTesting) return;

    // Set the description for updating phone number type
    await setDescription(TestDescription.updatePhoneNumberType);

    // Find the phone type button
    Finder phoneTypeFinder = find.descendant(of: fieldFinder, matching: find.byType(JPTextButton)).first;

    // Get the current phone type
    final currentPhoneType = widgetTester.widget<JPTextButton>(phoneTypeFinder).text;

    // Select the third option from the phone type dropdown
    await TestHelper.selectDropDown(widgetTester, testConfig, phoneTypeFinder, index: 2);

    // Get the updated phone type
    final updatedPhoneType = widgetTester.widget<JPTextButton>(phoneTypeFinder).text;

    // Check if the current phone type is different from the updated phone type
    expect(currentPhoneType == updatedPhoneType, isFalse);

    // Set the description for validating additional phone number
    await setDescription(TestDescription.validateAdditionalPhoneNumber);

    // Add and remove 4 additional phone fields
    for (int i = 0; i < 4; i++) {
      await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: true);
      await testConfig.fakeDelay(1);
      await TestHelper.enterTextOnPhoneFields(widgetTester, testConfig, '${i + 2}234567890', fieldIndex: i + 1, skipExt: true);
    }

    // Pump and settle the widget tester
    await widgetTester.pumpAndSettle();

    // Set the description for removing the last phone number
    await setDescription(TestDescription.removeLastPhoneNumber);

    // Remove the last phone field
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: false, deleteIndex: 3);

    // Set the description for removing the phone number in between
    await setDescription(TestDescription.removeInBetweenPhoneNumber);

    // Remove the phone field in between
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: false, deleteIndex: 1);

    // Set the description for not preserving the phone number
    await setDescription(TestDescription.notPreservePhoneNumber);

    // Add a new phone field
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: true);

    // Set the description for removing the phone field with failed validation
    await setDescription(TestDescription.removeFailedValidationPhone);

    // Remove the phone field with failed validation
    await TestHelper.addRemoveFieldButton(widgetTester, testConfig, PhoneFormTile, isAddBtn: false);
  }

  /// [setDescription] sets the description of the test case
  /// Parameters:
  ///   - description: The new description to be displayed before executing case
  /// Returns: A Future that completes when the description is set.
  Future<void> setDescription(String description) async {
    // Set the test description in the test config
    testConfig.setTestDescription(groupDesc, description);

    // Simulate a delay of 2 seconds
    await testConfig.fakeDelay(2);
  }
}