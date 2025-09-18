import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/modules/worksheet/widgets/default_setting_selector/index.dart';
import 'package:jobprogress/translations/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    Get.locale = const Locale('en', 'US');
    Get.addTranslations(JPTranslations().keys);
  });

  testWidgets('WorksheetDefaultSettingSelector - should render with checkbox unchecked by default', (WidgetTester tester) async {
    bool onToggleCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            onToggle: (_) => onToggleCalled = true,
          ),
        ),
      ),
    );

    // Verify that the widget renders with correct default title and description
    expect(find.text('Use Default Settings'), findsOneWidget);
    expect(find.text('Enable this option to generate worksheet based on predefined default settings.'), findsOneWidget);

    // Verify checkbox is not selected
    final checkbox = tester.widget<JPCheckbox>(find.byType(JPCheckbox));
    expect(checkbox.selected, isFalse);

    // Test onTap callback
    await tester.tap(find.byType(InkWell).first);
    expect(onToggleCalled, isTrue);
  });

  testWidgets('WorksheetDefaultSettingSelector - should display checkbox as checked when isSelected is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            isSelected: true,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    // Verify checkbox is selected
    final checkbox = tester.widget<JPCheckbox>(find.byType(JPCheckbox));
    expect(checkbox.selected, isTrue);
  });

  testWidgets('WorksheetDefaultSettingSelector - should display material list specific text for material list worksheet type', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            worksheetType: WorksheetConstants.materialList,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Use Material List Default Settings'), findsOneWidget);
    expect(find.text('Enable this option to generate material list based on predefined default settings.'), findsOneWidget);
  });

  testWidgets('WorksheetDefaultSettingSelector - should display work order specific text for work order worksheet type', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            worksheetType: WorksheetConstants.workOrder,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Use Work Order Default Settings'), findsOneWidget);
    expect(find.text('Enable this option to generate work order based on predefined default settings.'), findsOneWidget);
  });

  testWidgets('WorksheetDefaultSettingSelector - should display proposal specific text for proposal worksheet type', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            worksheetType: WorksheetConstants.proposal,
            onToggle: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Use Document Default Settings'), findsOneWidget);
    expect(find.text('Enable this option to generate document based on predefined default settings.'), findsOneWidget);
  });

  testWidgets('WorksheetDefaultSettingSelector - should call onToggle with current selection state when tapped', (WidgetTester tester) async {
    bool? receivedState;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WorksheetDefaultSettingSelector(
            isSelected: true,
            onToggle: (state) => receivedState = state,
          ),
        ),
      ),
    );

    // Tap on the checkbox
    await tester.tap(find.byType(JPCheckbox));

    // Verify that onToggle was called with the current state (true)
    expect(receivedState, isTrue);

    // Tap on the container
    receivedState = null;
    await tester.tap(find.byType(InkWell).first);

    // Verify that onToggle was called with the current state (true)
    expect(receivedState, isTrue);
  });

  group('WorksheetDefaultSettingSelector.getTitle()', () {
    test('should return material list title for material list worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.materialList,
        onToggle: (_) {},
      );
      expect(selector.getTitle(), equals('use_material_list_default_settings'.tr));
    });

    test('should return work order title for work order worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.workOrder,
        onToggle: (_) {},
      );
      expect(selector.getTitle(), equals('use_work_order_default_settings'.tr));
    });

    test('should return proposal title for proposal worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.proposal,
        onToggle: (_) {},
      );
      expect(selector.getTitle(), equals('use_document_default_settings'.tr));
    });

    test('should return generic title when no specific worksheet type is provided', () {
      final selector = WorksheetDefaultSettingSelector(
        onToggle: (_) {},
      );
      expect(selector.getTitle(), equals('use_default_settings'.tr));
    });
  });

  group('WorksheetDefaultSettingSelector.getDescription()', () {
    test('should return material list description for material list worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.materialList,
        onToggle: (_) {},
      );
      expect(selector.getDescription(), equals('use_material_list_default_settings_desc'.tr));
    });

    test('should return work order description for work order worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.workOrder,
        onToggle: (_) {},
      );
      expect(selector.getDescription(), equals('use_work_order_default_settings_desc'.tr));
    });

    test('should return proposal description for proposal worksheet type', () {
      final selector = WorksheetDefaultSettingSelector(
        worksheetType: WorksheetConstants.proposal,
        onToggle: (_) {},
      );
      expect(selector.getDescription(), equals('use_document_default_settings_desc'.tr));
    });

    test('should return generic description when no specific worksheet type is provided', () {
      final selector = WorksheetDefaultSettingSelector(
        onToggle: (_) {},
      );
      expect(selector.getDescription(), equals('use_default_settings_desc'.tr));
    });
  });
}
