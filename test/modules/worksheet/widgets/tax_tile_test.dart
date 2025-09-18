import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/sheet_total_amount/label_value_tile.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/tax_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../integration_test/core/test_helper.dart';

void main() {
  setUpAll(() {
    Get.locale = const Locale('en', 'US');
  });

  Widget buildCalculationTaxTile(Widget child) {
    return TestHelper.buildWidget(
        Material(child: child)
    );
  }

  group("WorksheetCalculationsTaxTile@percentFraction should decide number of decimal places in value percentage", () {
    testWidgets("By default percentage should be displayed with 2 decimal places", (widgetTester) async {
      const widget = WorksheetCalculationsTaxTile(
        title: 'TEST',
        amount: 100,
        percent: 23.2345,
        isVisible: true,
      );
      await widgetTester.pumpWidget(buildCalculationTaxTile(widget));
      final labelFinder = find.descendant(of: find.byType(SheetLabelValueTile), matching: find.byType(JPText));
      final label = labelFinder.first.evaluate().first.widget as JPText;

      expect(label.text, "TEST");
    });

    testWidgets("Percentage should be displayed with customised decimal places", (widgetTester) async {
      const widget = WorksheetCalculationsTaxTile(
        title: 'TEST',
        amount: 100,
        percent: 23.2345,
        percentFraction: 3,
        isVisible: true,
      );
      await widgetTester.pumpWidget(buildCalculationTaxTile(widget));
      final labelFinder = find.descendant(of: find.byType(SheetLabelValueTile), matching: find.byType(JPText));
      final label = labelFinder.first.evaluate().first.widget as JPText;

      expect(label.text, "TEST");
    });
  });
}