import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/long_press_location.dart';
import 'package:jobprogress/common/enums/taplocator.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/forms/email/fields/index.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/fields/tiles.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jobprogress/modules/customer/customer_form/form/fields/index.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/list.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../config/test_config.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'test_description.dart';

class TestHelper {

  /// Find & Visible field by key/finder to enter text
  static Future<void> enterText(WidgetTester widgetTester, TestConfig testConfig, { String? key, required String text, Finder? finder, bool isReplaceText = false }) async {
    if (finder != null || key != null) {
      Finder? field = finder ?? find.byKey(testConfig.getKey(key!));
      await TestHelper.ensureVisible(field, widgetTester);
      expect(field, findsOneWidget);
      if (isReplaceText) {
        await widgetTester.enterText(field, '');
        await testConfig.fakeDelay(1);
      }
      await widgetTester.enterText(field, text);
      await testConfig.fakeDelay(1);
    } else {
      expect(key, isNotNull);
    }
  }

  /// Find & Visible field by key/finder to tap on widget
  static Future<void> tapOnWidget(WidgetTester widgetTester, TestConfig testConfig, {
    String? key,
    Finder? tapFinder,
    TapAt? tapLocation = TapAt.center,
    bool isDragToFinderLocation = true,
    Offset tapOffset = Offset.zero
  }) async {
    if (tapFinder != null || key != null) {
      Finder? finder = tapFinder ?? find.byKey(testConfig.getKey(key!));
      if(isDragToFinderLocation) {
        await TestHelper.ensureVisible(finder, widgetTester);
      }
      expect(finder, findsOneWidget);
      await locationSpecificTap(tapLocation: tapLocation!, finder: finder, widgetTester: widgetTester, offset: tapOffset);
      await testConfig.fakeDelay(1);
    } else {
      expect(key, isNotNull);
    }
  }

  /// Find & Visible field by key/finder to tap on widget
  static Future<void> tapOnAddButton(WidgetTester widgetTester, TestConfig testConfig, { String? key, Finder? tapFinder }) async {
    if (tapFinder != null || key != null) {
      Finder? finder = find.byIcon(Icons.add);
      await widgetTester.ensureVisible(finder);
      expect(finder, findsOneWidget);
      await widgetTester.tap(finder);
      await testConfig.fakeDelay(1);
    } else {
      expect(key, isNotNull);
    }
  }

  /// Find & Visible field by key/finder to tap on widget
  static Future<void> tapOnDescendantWidget(Finder of, Finder tapFinder, TestConfig testConfig, WidgetTester widgetTester) async {
    Finder? finder = find.descendant(of: of, matching: tapFinder);
    await widgetTester.ensureVisible(finder);
    expect(finder, findsOneWidget);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: finder);
  }

  static Future<void> locationSpecificTap({TapAt? tapLocation, required WidgetTester widgetTester, required Finder finder, Offset offset = Offset.zero}) async {
    switch (tapLocation) {
      case TapAt.topLeft:
        await widgetTester.tapAt(widgetTester.getTopLeft(finder) + offset);
        break;
      case TapAt.bottomLeft:
        await widgetTester.tapAt(widgetTester.getBottomLeft(finder) + offset);
        break;
      case TapAt.topRight:
        await widgetTester.tapAt(widgetTester.getTopRight(finder) + offset);
        break;
      default:
        await widgetTester.tap(finder, warnIfMissed: false);
    }
  }



  /// Find & Visible field by key/finder to long press on widget
  static Future<void> longPressOnWidget(WidgetTester widgetTester, TestConfig testConfig, { String? key, Finder? tapFinder, LongPressAt? longPressLocation = LongPressAt.center}) async {
    if (tapFinder != null || key != null) {
      Finder? finder = tapFinder ?? find.byKey(testConfig.getKey(key!));
      await widgetTester.ensureVisible(finder);
      expect(finder, findsOneWidget);
      await locationSpecificLongPress(longPressLocation: longPressLocation!,finder: finder,widgetTester: widgetTester );
      await testConfig.fakeDelay(1);
    } else {
      expect(key, isNotNull);
    }
  }

  static Future<void> locationSpecificLongPress({required WidgetTester widgetTester, required Finder finder, LongPressAt? longPressLocation}) async {
    switch (longPressLocation) {
      case LongPressAt.topLeft:
        await widgetTester.longPressAt(widgetTester.getTopLeft(finder));
        break;
      case LongPressAt.bottomLeft:
        await widgetTester.longPressAt(widgetTester.getBottomLeft(finder));
        break;
      default:
        await widgetTester.longPress(finder);
    }
  }

  /// Find & Check values of JPInputBox field
    // (dynamic matcherValue) to check text field controller value is matching with expected value
    // (bool checkReadOnly) to check text field is readonly
  static Future<void> checkJPInputFieldValue(WidgetTester widgetTester, TestConfig testConfig, { required String key, required dynamic matcherValue, bool checkReadOnly = false }) async {
    Finder? field = find.byKey(testConfig.getKey(key));
    await widgetTester.ensureVisible(field);
    expect(field, findsOneWidget);
    JPInputBox jpInputBox = widgetTester.firstWidget(field);
    if (checkReadOnly) {
      expect(jpInputBox.readOnly, isTrue);
    }
    expect(jpInputBox.inputBoxController?.text, matcherValue);
  }

  /// return back to home page
  static Future<void> backToHomePage(WidgetTester widgetTester, TestConfig testConfig) async {
    testConfig.fakeDelay(5);
    Get.offAllToFirst();
    testConfig.fakeDelay(2);
  }
  
  /// Tap on end drawer button in home page 
  static Future<void> openEndDrawer(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: WidgetKeys.mainDrawerMenuKey);
  }

   /// Tap on secondary drawer button 
  static Future<void> openSecondaryDrawer(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: WidgetKeys.secondaryDrawerMenuKey);
  }
  
  /// Tap on recent jobs item button in drawer 
  static Future<void> clickRecentJobsDrawerSection(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: WidgetKeys.recentJobsItemKey);
  }

  /// Tap on refresh item button in drawer 
  static Future<void> clickRefreshDrawerSection(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: WidgetKeys.refreshKey);
  }

  /// Select on first jobs view
  static Future<void> selectFirstJobFromRecentJobsSheet(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.recentJobs}[0]');
  }

  /// Find & Tap date on date picker dialog
  static Future<void> selectDateFromDialog(WidgetTester widgetTester, TestConfig testConfig) async {
    await testConfig.fakeDelay(2);
    Offset center = widgetTester.getCenter(find.byType(DatePickerDialog));
    /// Tap on center of date picker dialog to select date
    await widgetTester.tapAt(Offset(center.dx - 10, center.dy));
    /// Tap on "OK" text button in date picker to close dialog
    await widgetTester.tap(find.text('OK'));
  }

  /// Click system back button to call onWillPop async method
  static Future<void> clickSystemBackButton(WidgetTester widgetTester) async {
    // Use didPopRoute() to simulate the system back button. Check that
    // didPopRoute() indicates that the notification was handled.
    final dynamic widgetsAppState = widgetTester.state(find.byType(WidgetsApp));
    await widgetsAppState.didPopRoute();
  }

  /// Check no changes made test case in form & back to previos page
  static Future<void> noChangesMadeTestCase(WidgetTester widgetTester, TestConfig testConfig, {required Type currentPage, required Type previousPage}) async {    
    await testConfig.fakeDelay(2);
    expect(find.byType(currentPage), findsOneWidget);

    /// Hide test keyboard from screen
    testConfig.binding?.testTextInput.onCleared?.call();
    await testConfig.fakeDelay(1);

    await clickSystemBackButton(widgetTester);

    await testConfig.fakeDelay(2);
    expect(find.byType(previousPage), findsOneWidget);
  }

  /// Check unsaved changes made dialog test case in form & show (current page / back to previos page)
  static Future<void> unsavedChangesMadeTestCase(WidgetTester widgetTester, TestConfig testConfig, {required Type currentPage, required Type previousPage, bool tapOnDontSave = false}) async {
    await testConfig.fakeDelay(2);
    expect(find.byType(currentPage), findsOneWidget);

    /// Hide test keyboard from screen
    testConfig.binding?.testTextInput.onCleared?.call();
    await testConfig.fakeDelay(1);

    await clickSystemBackButton(widgetTester);

    await testConfig.fakeDelay(2);

    try{
      expect(find.byType(JPConfirmationDialog),findsOneWidget);
    } catch (e) {
      return;
    }

    /// Should show one "unsaved dialog"
    expect(find.widgetWithText(JPConfirmationDialog, 'unsaved_changes'.tr), findsOneWidget);

    /// Find "dont save" button in unsaved dialog
    Finder? suffixBtn = find.widgetWithText(JPButton, 'dont_save'.tr.toUpperCase());
    expect(suffixBtn, findsOneWidget);

    /// Find "cancel" button in unsaved dialog
    Finder? prefixBtn = find.widgetWithText(JPButton, 'cancel'.tr.toUpperCase());
    expect(prefixBtn, findsOneWidget);

    await testConfig.fakeDelay(2);

    if (tapOnDontSave) {
      /// Tap on "dont save" button & back to previous page
      widgetTester.tap(suffixBtn);
      await testConfig.fakeDelay(2);
      expect(find.byType(previousPage), findsOneWidget);
    }
    else {
      /// Tap on "cancel" button & stay on current page
      widgetTester.tap(prefixBtn);
      await testConfig.fakeDelay(2);
      expect(find.byType(currentPage), findsOneWidget);
    }
  }

  /// Find & Enter Text on phone form fields
  static Future<void> enterTextOnPhoneFields(WidgetTester widgetTester, TestConfig testConfig, String number, {int? fieldIndex, bool skipExt = false}) async {
    /// descendant means finding child widget from parent. example: PhoneForm (Parent) -> PhoneFormFields -> ListView -> PhoneFormTile (Child)
    Finder phoneFields = find.descendant(of: find.byType(PhoneForm), matching: find.byType(PhoneFormTile));
    /// Get all phone widgets list from finder
    List<PhoneFormTile> phoneWidgets = widgetTester.widgetList(phoneFields).toList().cast<PhoneFormTile>();
    expect(phoneFields, findsNWidgets(phoneWidgets.length));

    /// Find fields by placeholder through parent widget & Enter text on phone extension fields
    Finder phoneExtFields = find.descendant(of: find.byType(PhoneForm), matching: find.bySemanticsLabel('Ext'));

    int index = 0;

    /// Enter text in all phone fields
    if (fieldIndex == null) {
      await Future.forEach(phoneWidgets, (PhoneFormTile phoneWidget) async {
        phoneWidgets[index].data.phoneController.text = PhoneMasking.maskPhoneNumber(number);
        await testConfig.fakeDelay(1);
        await widgetTester.enterText(phoneExtFields.at(index), '12');
        index++;
        await testConfig.fakeDelay(2);
      });
    }
    
    /// Enter text at specified phone field by index
    if (fieldIndex != null && fieldIndex < phoneWidgets.length) {
      phoneWidgets[fieldIndex].data.phoneController.text = PhoneMasking.maskPhoneNumber(number);
      phoneWidgets[fieldIndex].onDataChanged?.call();
      await testConfig.fakeDelay(1);
      if (!skipExt) await widgetTester.enterText(phoneExtFields.first, '12');
    } 
  }

  /// Find & Tap on add remove button of field
  static Future<void> addRemoveFieldButton(WidgetTester widgetTester, TestConfig testConfig, Type parentType, {required bool isAddBtn, int? deleteIndex}) async {
    /// finding child with using widget property condition from parent widget stack (descendant).
    Finder addRemoveFields = find.descendant(of: find.byType(parentType), matching: find.byWidgetPredicate((widget) => widget is JPAddRemoveButton && widget.isAddBtn == isAddBtn));
    /// if delete index is specified then it will get remove button from indexed field
    /// else it will get last add button to create more field
    addRemoveFields = deleteIndex != null ? addRemoveFields.at(deleteIndex) : addRemoveFields.last;
    await TestHelper.ensureVisible(addRemoveFields, widgetTester);
    expect(addRemoveFields, findsOneWidget);
    await widgetTester.tap(addRemoveFields, warnIfMissed: false);
    await testConfig.fakeDelay(1);
  }

  /// Find & Enter Text on email form fields
  static Future<void> enterTextOnEmailFields(WidgetTester widgetTester, TestConfig testConfig, String email, {int? fieldIndex}) async {
    /// descendant means finding child widget from parent. example: EmailsForm (Parent) -> ListView -> EmailFormField (Child)
    Finder emailFields = find.descendant(of: find.byType(EmailsForm), matching: find.byType(EmailFormField));
    /// Get all email widgets list from finder
    List<EmailFormField> emailWidgets = widgetTester.widgetList(emailFields).toList().cast<EmailFormField>();
    expect(emailFields, findsNWidgets(emailWidgets.length));

    int index = 0;

    /// Enter text in all email fields
    if (fieldIndex == null) {
      await Future.forEach(emailWidgets, (EmailFormField emailWidget) async {
        await widgetTester.enterText(emailFields.at(index), email);
        index++;
        await testConfig.fakeDelay(2);
      });
    }

    /// Enter text at specified email field by index
    if (fieldIndex != null && fieldIndex < emailWidgets.length) {
      await widgetTester.enterText(emailFields.at(fieldIndex), email);
    } 
  }

  /// Select on first workflow stage
  static Future<void> selectFirstWorkflowStageFromHomePage(WidgetTester widgetTester, TestConfig testConfig) async {
    await tapOnWidget(widgetTester, testConfig, key: '${WidgetKeys.workflowStages}[0]');
  }

  ///   Multiselect
  static Future<void> selectMultiSelectDropDown(WidgetTester widgetTester, TestConfig testConfig, Finder dropDownFinder, {
    bool selectOnlyOne = false,
    bool updateSelection = false,
    bool isNetworkDropdown = false,
  }) async {
    await TestHelper.ensureVisible(dropDownFinder, widgetTester);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: dropDownFinder, tapLocation: TapAt.topRight, tapOffset: const Offset(-10, 10));

    Finder multiSelectDropDownList = find.descendant(of: find.byType(JPMultiSelectList), matching: find.byType(JPCheckbox));
    expect(multiSelectDropDownList, findsWidgets);
    final optionFinder = isNetworkDropdown ? multiSelectDropDownList.at(0).last : multiSelectDropDownList.first;
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: optionFinder);
    await widgetTester.pumpAndSettle();

    if (!selectOnlyOne) {
      await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: multiSelectDropDownList.at(1));
      await widgetTester.pumpAndSettle();
    }

    Finder doneFinder = find.byType(JPButton).last;
    expect(doneFinder, findsWidgets);
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: doneFinder);
    await TestHelper.ensureVisible(dropDownFinder, widgetTester);

    if (updateSelection) {
      await selectMultiSelectDropDown(widgetTester, testConfig, dropDownFinder, updateSelection: true);
    }
  }

  static Future<void> cancelButtonClick(WidgetTester widgetTester, TestConfig testConfig, {String? btnText}) async {
    /// Find "cancel" button
    Finder? cancelBtn = find.widgetWithText(JPButton, btnText ??'cancel'.tr.toUpperCase());
    expect(cancelBtn, findsOneWidget);

    tapOnWidget(widgetTester, testConfig, tapFinder: cancelBtn);
    await testConfig.fakeDelay(2);
  }

  /// Single select
  static Future<void> selectDropDown(WidgetTester widgetTester, TestConfig testConfig, Finder dropDownFinder, { int index = 1}) async {
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: dropDownFinder);

    await testConfig.fakeDelay(1);
    final dropDownOptions = find.byType(AutoScrollTag);
    if (index >= dropDownOptions.evaluate().length) {
      return;
    }
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: dropDownOptions.at(index));

    await testConfig.fakeDelay(1);
  }

  static Future<void> pullToRefresh(WidgetTester widgetTester, TestConfig testConfig, Finder listFinder) async {
    await testConfig.fakeDelay(2);

    await widgetTester.fling(listFinder.first, const Offset(0, 500), 1000);

    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    await testConfig.fakeDelay(2);
  }

  /// Ensures that the given [finder] is visible on the screen.
  ///
  /// This function uses the [widgetTester] to determine the position of the
  /// [finder] on the screen and checks if it is visible within the available
  /// height of the screen. If the [finder] is not visible, it scrolls to make
  /// it visible.
  ///
  /// Parameters:
  /// - [finder]: The [Finder] object that represents the widget to be made visible.
  /// - [widgetTester]: The [WidgetTester] object used to interact with the widget tree.
  ///
  /// Returns: A [Future] that completes once the [finder] is visible and the
  /// widget tree has settled.
  static Future<void> ensureVisible(Finder finder, WidgetTester widgetTester) async {
      // Get the top left and bottom right coordinates of the [finder] on the screen
      final topLeft = widgetTester.getTopLeft(finder);
      final bottomRight = widgetTester.getBottomRight(finder);
      // Calculate the height of the onscreen keyboard
      final keyboardHeight = Get.mediaQuery.viewInsets.bottom;
      // Calculate the available height on the screen by subtracting the keyboard height and 50 (for some padding)
      final availableHeight = Get.height - keyboardHeight - 50;
      // Check if the [finder] is within the visible bounds of the screen
      // [60] is the appbar height
      final isVisible = topLeft.dx >= 0
          && topLeft.dy >= 60
          && bottomRight.dx <= Get.width
          && bottomRight.dy <= availableHeight;
      // If the [finder] is not visible, scroll to make it visible
      if (!isVisible) {
        await widgetTester.ensureVisible(finder);
      }
      // Wait for the widget tree to settle
      await widgetTester.pumpAndSettle();
  }

  /// Iterates over a dynamic form and performs a specified action on each field.
  ///
  /// Parameters:
  /// - [widgetTester]: The [WidgetTester] instance to use for testing.
  /// - [testConfig]: The [TestConfig] instance for configuring the test.
  /// - [sectionType]: The type of the section in the dynamic form.
  /// - [fieldType]: The type of the field in the dynamic form.
  /// - [onFindField]: A function that takes a [Finder] and a [String] as parameters and performs an action on the field.
  /// - [groupDesc]: The description of the test group.
  /// - [onlyRequired]: Whether to only process required fields.
  static Future<void> iterateDynamicForm(
    WidgetTester widgetTester,
    TestConfig testConfig,
    Type sectionType,
    Type fieldType, {
    required Future<void> Function(Finder, String) onFindField,
    required String groupDesc,
    bool onlyRequired = false,
  }) async {
    final sectionFinder = find.byType(sectionType);
  
    for (int sectionIndex = 0; sectionIndex < sectionFinder.evaluate().length; sectionIndex++) {
      if (sectionIndex > 0) {
        // Collapse the section if it's not the first section.
        await expandCollapseSection(widgetTester, testConfig, finder: sectionFinder.at(sectionIndex), toggleOnly: true);
      }
      final parentFinder = sectionFinder.at(sectionIndex);
      final childMatcher = find.byType(fieldType);
      final fieldsFinder = find.descendant(of: parentFinder, matching: childMatcher);
      for (int fieldIndex = 0; fieldIndex < fieldsFinder.evaluate().length; fieldIndex++) {
        final fieldFinder = fieldsFinder.at(fieldIndex);
        final fieldWidget = fieldFinder.evaluate().first.widget;
        if (fieldWidget is CustomerFormFields) {
          String key = fieldWidget.field.key;
          
          // Check if the current field is not the custom fields field.
          onlyRequired = key != CustomerFormConstants.customFields && onlyRequired;
          
          // Skip the field if it's not required and we're only processing required fields.
          if (!fieldWidget.field.isRequired && onlyRequired) continue;
          
          // Perform the specified action on the field.
          await onFindField.call(fieldFinder, key);
        }
      }
      if (sectionFinder.evaluate().length > 1) {
        // Set the test description and wait for a fake delay.
        testConfig.setTestDescription(groupDesc, TestDescription.collapseExpandedSection);
        await testConfig.fakeDelay(2);
        await expandCollapseSection(widgetTester, testConfig, finder: sectionFinder.at(sectionIndex), toggleOnly: true);
      }
    }
  }

  /// Expands or collapses a section.
  ///
  /// The [finder] parameter is used to locate the widget to expand or collapse.
  /// The [toggleOnly] parameter determines whether only the toggle action should be performed.
  static Future<void> expandCollapseSection(WidgetTester widgetTester, TestConfig testConfig, {required Finder finder, bool toggleOnly = false}) async {
    // Perform a tap on the widget to expand or collapse it.
    await tapExpansionTile(widgetTester, testConfig, finder);
    // If toggleOnly is false, perform additional actions after the first tap.
    if (!toggleOnly) await tapExpansionTile(widgetTester, testConfig, finder);
  }

  /// [_tapExpansionTile] A method to tap on an expansion tile and verify if its size changes.
  ///
  /// Takes a [finder] as input, which is used to locate the expansion tile widget.
  /// It performs a tap on the widget using [TestHelper.tapOnWidget] method.
  /// The [tapLocation] is set to [TapAt.topLeft] and [isDragToFinderLocation] is set to true.
  /// The [tapOffset] is set to [Offset(10, 10)].
  /// Finally, it compares the old and new sizes of the finder widget using the [expect] assertion.
  static Future<void> tapExpansionTile(WidgetTester widgetTester, TestConfig testConfig, Finder finder) async {
    // Get the old size of the finder widget
    Size oldSize = finder.evaluate().first.size!;
    // Perform a tap on the widget
    await TestHelper.tapOnWidget(widgetTester, testConfig, tapFinder: finder, tapLocation: TapAt.topLeft, isDragToFinderLocation: true, tapOffset: const Offset(10, 10));
    await widgetTester.pumpAndSettle();
    // Get the new size of the finder widget
    Size newSize = finder.evaluate().first.size!;
    // Verify if the old size is not equal to the new size
    expect(oldSize, isNot(newSize));
  }

  static Future<void> scrollToLast(WidgetTester widgetTester, TestConfig testConfig, Key finderKey) async {
    await widgetTester.scrollUntilVisible(
        find.byKey(finderKey),
        500.0
    );
    await testConfig.fakeDelay(1);
  }

  static Widget buildWidget(Widget widget, {bool useTranslations = false}) => GetMaterialApp(
    home: widget,
    locale: useTranslations ? LocaleConst.usa : null,
    translations: useTranslations ? JPTranslations() : null,
  );
}