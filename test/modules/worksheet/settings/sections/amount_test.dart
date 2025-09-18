import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/controller.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/sections/amount.dart';
import '../../../../../integration_test/core/test_helper.dart';

void main() {
  late WorksheetSettingsController controller;

  setUpAll(() {
    Get.routing.args = {
      NavigationParams.settings: WorksheetSettingModel.fromJson({})
        ..hasTier = false
        ..isWorkOrderSheet = false
    };
    controller = WorksheetSettingsController();
  });

  Widget buildWidget() {
    return TestHelper.buildWidget(
        Material(
          child: WorksheetSettingAmountSection(
            controller: controller
          ),
        )
    );
  }

  testWidgets("WorksheetSettingsAmountSection should be rendered correctly", (tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();
    expect(find.byType(WorksheetSettingAmountSection), findsOneWidget);
  });

  group("Show Tier Sub Totals setting should be displayed conditionally", () {
    group("Setting option should not be displayed", () {
      testWidgets("When Tiers are not applied", (widgetTester) async {
        controller.settings.hasTier = false;
        await widgetTester.pumpWidget(buildWidget());
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key(WidgetKeys.showTierSubtotals)), findsNothing);
      });

      testWidgets("When Line Item Profit and Tax is not applied", (widgetTester) async {
        controller.settings.hasTier = true;
        controller.settings.addLineItemTax = false;
        controller.settings.applyLineItemProfit = false;
        await widgetTester.pumpWidget(buildWidget());
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key(WidgetKeys.showTierSubtotals)), findsNothing);
      });

      testWidgets("When metro bath feature is not enabled", (widgetTester) async {
        LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = false);
        controller.settings.hasTier = true;
        controller.settings.addLineItemTax = true;
        controller.settings.applyLineItemProfit = true;
        await widgetTester.pumpWidget(buildWidget());
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key(WidgetKeys.showTierSubtotals)), findsNothing);
      });
    });

    group("Setting option should be displayed", () {
      setUpAll(() {
        controller.settings.hidePricing = true;
      });

      testWidgets("When metro bath feature is enabled and line item profit applied", (widgetTester) async {
        LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = true);
        controller.settings.hasTier = true;
        controller.settings.addLineItemTax = false;
        controller.settings.applyLineItemProfit = true;
        await widgetTester.pumpWidget(buildWidget());
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key(WidgetKeys.showTierSubtotals)), findsOneWidget);
      });

      testWidgets("When metro bath feature is enabled and line item tax applied", (widgetTester) async {
        LDService.ldFlagsStream.add(LDFlags.metroBathFeature..value = true);
        controller.settings.hasTier = true;
        controller.settings.addLineItemTax = true;
        controller.settings.applyLineItemProfit = false;
        await widgetTester.pumpWidget(buildWidget());
        await widgetTester.pumpAndSettle();
        expect(find.byKey(const Key(WidgetKeys.showTierSubtotals)), findsOneWidget);
      });
    });
  });
}