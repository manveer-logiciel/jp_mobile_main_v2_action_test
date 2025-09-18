import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_worksheet.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/calculations/tax_tile.dart';
import '../../../../integration_test/core/test_helper.dart';

void main() {

  final controller = WorksheetFormController();
  final settings = WorksheetSettingModel.fromJson({});
  final WorksheetCalculationsTile worksheetCalculationsTile = WorksheetCalculationsTile(controller: controller);

  setUpAll(() {
    Get.locale = const Locale('en', 'US');
    controller.service = WorksheetFormService(
      update: () {},
      worksheetType: '',
      formType: WorksheetFormType.add,
      hidePriceDialog: false,
    );
  });

  Widget buildCalculationsTile() {
    return TestHelper.buildWidget(
        Material(
          child: WorksheetCalculationsTile(
            controller: controller
          ),
        )
    );
  }

  group("WorksheetCalculationsTile should display Credit Card Fee conditionally", () {
    testWidgets("Card fee should not be displayed when its not applied", (widgetTester) async {
      controller.service.settings = settings..applyProcessingFee = false;
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.creditCardFeeKey)), findsNothing);
      expect(find.byKey(const Key(WidgetKeys.contractTotal)), findsNothing);
    });

    testWidgets("Card fee should not be displayed when metro-bath feature flag is not enabled", (widgetTester) async {
      controller.service.settings = settings..applyProcessingFee = true;
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.creditCardFeeKey)), findsNothing);
      expect(find.byKey(const Key(WidgetKeys.contractTotal)), findsNothing);
    });

    testWidgets("Card fee should not be displayed when metro-bath feature flag is enabled", (widgetTester) async {
      controller.service.settings = settings..applyProcessingFee = true;
      LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = true);
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.creditCardFeeKey)), findsOneWidget);
      expect(find.byKey(const Key(WidgetKeys.contractTotal)), findsOneWidget);
    });

    testWidgets("Card fee rate should display up to 3 decimal place", (widgetTester) async {
      controller.service.settings = settings..applyProcessingFee = true;
      LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = true);
      await widgetTester.pumpWidget(buildCalculationsTile());
      final cardFeeTile = find.byKey(const Key(WidgetKeys.creditCardFeeKey)).evaluate().first.widget as WorksheetCalculationsTaxTile;

      expect(cardFeeTile.percentFraction, equals(3));
    });
  });
  group("WorksheetCalculationsTile should display discount conditionally", () {
    testWidgets("Discount should not be displayed when its not applied", (widgetTester) async {
      controller.service.settings = settings..applyDiscount = false;
      LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = false);
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.discount)), findsNothing);
    });

    testWidgets("Discount should not be displayed when metro-bath feature flag is not enabled", (widgetTester) async {
      controller.service.settings = settings..applyDiscount = true;
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.discount)), findsNothing);
    });

    testWidgets("Discount should not be displayed when metro-bath feature flag is enabled", (widgetTester) async {
      controller.service.settings = settings..applyDiscount = true;
      LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = true);
      await widgetTester.pumpWidget(buildCalculationsTile());

      expect(find.byKey(const Key(WidgetKeys.discount)), findsOneWidget);
    });
  });

  group("WorksheetCalculationsTile@getWorksheetProfitTitle Should provide correct title to represent worksheet profit", () {

    test('Title should be Projected Worksheet Profit (Markup) when markup worksheet profit and individual line item profit is applied', () {
      settings.applyLineAndWorksheetProfit = true;
      settings.isMarkup = true;
      final title = worksheetCalculationsTile.getWorksheetProfitTitle;
      expect(title, equals('${'projected_worksheet_profit'.tr}${' (markup'.tr})'));
    });

    test('Title should be Projected Worksheet Profit (Margin) when margin worksheet profit and individual line item profit is applied', () {
      settings.applyLineAndWorksheetProfit = true;
      settings.isMarkup = false;
      final title = worksheetCalculationsTile.getWorksheetProfitTitle;
      expect(title, equals('${'projected_worksheet_profit'.tr}${' (margin'.tr})'));
    });

    test('Title should be Profit (Markup) when only markup worksheet profit is applied', () {
      settings.applyLineAndWorksheetProfit = false;
      settings.isMarkup = true;
      final title = worksheetCalculationsTile.getWorksheetProfitTitle;
      expect(title, equals('${'profit'.tr}${' (markup'.tr})'));
    });

    test('Title should be Profit (Margin) when only margin worksheet profit is applied', () {
      settings.applyLineAndWorksheetProfit = false;
      settings.isMarkup = false;
      final title = worksheetCalculationsTile.getWorksheetProfitTitle;
      expect(title, equals('${'profit'.tr}${' (margin'.tr})'));
    });
  });

  group("WorksheetCalculationsTile@getLineItemProfitTitle Should provide correct title to represent line item profit", () {

    test('Title should be Projected Line Profit (Markup) when markup line item profit and worksheet profit is applied', () {
      settings.applyLineAndWorksheetProfit = true;
      settings.isMarkup = true;
      final title = worksheetCalculationsTile.getLineItemProfitTitle;
      expect(title, equals('${'projected_line_profit'.tr}${' (markup'.tr})'));
    });

    test('Title should be Projected Line Profit (Margin) when margin line item profit and worksheet profit is applied', () {
      settings.applyLineAndWorksheetProfit = true;
      settings.isMarkup = false;
      final title = worksheetCalculationsTile.getLineItemProfitTitle;
      expect(title, equals('${'projected_line_profit'.tr}${' (margin'.tr})'));
    });

    test('Title should be Profit (Markup) when only markup line item profit is applied', () {
      settings.applyLineAndWorksheetProfit = false;
      settings.isMarkup = true;
      final title = worksheetCalculationsTile.getLineItemProfitTitle;
      expect(title, equals('${'profit'.tr}${' (markup'.tr})'));
    });

    test('Title should be Profit (Margin) when only margin line item profit is applied', () {
      settings.applyLineAndWorksheetProfit = false;
      settings.isMarkup = false;
      final title = worksheetCalculationsTile.getLineItemProfitTitle;
      expect(title, equals('${'profit'.tr}${' (margin'.tr})'));
    });
  });

}
