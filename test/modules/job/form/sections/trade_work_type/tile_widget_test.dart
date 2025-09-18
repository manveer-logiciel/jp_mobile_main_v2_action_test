import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/widgets/list.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/widgets/tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../../integration_test/core/test_helper.dart';

void main() {

  List<CompanyTradesModel> tempTrades = [
    CompanyTradesModel(
      id: 1,
      name: 'Trade 1',
    ),
    CompanyTradesModel(
      id: 2,
      name: 'Trade 2',
    )
  ];

  JobTradeWorkTypeInputsController controller = JobTradeWorkTypeInputsController(
    tradesList: [],
    workTypesList: []
  );

  Widget getTestableWidget() {
    return TestHelper.buildWidget(
        JobTradeWorkTypeInputsList(
          controller: controller,
          hideAddButton: false,
          isDisabled: false,
        )
    );
  }

  void setUpController([List<CompanyTradesModel>? trades]) {
    controller.tradesList.clear();
    if (trades != null) controller.tradesList.addAll(trades);
    controller.allTrades = [
      JPSingleSelectModel(id: '1', label: 'Trade 1'),
      JPSingleSelectModel(id: '2', label: 'Trade 2'),
      JPSingleSelectModel(id: '3', label: 'Trade 3'),
    ];
    controller.tradeWorkTypeList.clear();
    controller.setUpFields();
  }

  JobFormTradeWorkTypeTile findTradeWorkTypeTile(int index) {
    return find.byType(JobFormTradeWorkTypeTile)
        .evaluate()
        .elementAt(index)
        .widget as JobFormTradeWorkTypeTile;
  }

  Finder findAddRemoveButtons(int tileIndex) {
    final parent = find.byType(JobFormTradeWorkTypeTile).at(tileIndex);
    final child = find.byType(JPAddRemoveButton);
    return find.descendant(of: parent, matching: child);
  }

  T getWidgetFromFinder<T>(Finder finder, {int index = 0}) {
    return finder.at(index).evaluate().elementAt(0).widget as T;
  }

  testWidgets("Trade selector should not be disabled, when no trades were selected", (widgetTester) async {
    setUpController();
    await widgetTester.pumpWidget(getTestableWidget());

    expect(find.byType(JobTradeWorkTypeInputsList), findsOneWidget);
    expect(find.byType(JobFormTradeWorkTypeTile), findsOneWidget);
    expect(findTradeWorkTypeTile(0).isTradeTypeDisabled, isFalse);
  });

  group('When selected trades are not scheduled', () {
    testWidgets("Trade selector should not be disabled", (widgetTester) async {
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());

      expect(find.byType(JobTradeWorkTypeInputsList), findsOneWidget);
      expect(find.byType(JobFormTradeWorkTypeTile), findsNWidgets(2));
      expect(findTradeWorkTypeTile(0).isTradeTypeDisabled, isFalse);
      expect(findTradeWorkTypeTile(1).isTradeTypeDisabled, isFalse);
    });
  });

  group("When selected trades are scheduled", () {
    testWidgets("Trade selector should be disabled for only scheduled trades", (widgetTester) async {
      tempTrades[0].isScheduled = true;
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());

      expect(find.byType(JobTradeWorkTypeInputsList), findsOneWidget);
      expect(find.byType(JobFormTradeWorkTypeTile), findsNWidgets(2));
      expect(findTradeWorkTypeTile(0).isTradeTypeDisabled, isTrue);
      expect(findTradeWorkTypeTile(1).isTradeTypeDisabled, isFalse);
    });

    testWidgets("Trade selector should be disabled for all the trades, if scheduled", (widgetTester) async {
      tempTrades[1].isScheduled = true;
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());

      expect(find.byType(JobTradeWorkTypeInputsList), findsOneWidget);
      expect(find.byType(JobFormTradeWorkTypeTile), findsNWidgets(2));
      expect(findTradeWorkTypeTile(0).isTradeTypeDisabled, isTrue);
      expect(findTradeWorkTypeTile(1).isTradeTypeDisabled, isTrue);
    });
  });

  group("Section icons should be displayed conditionally", () {
    testWidgets("Remove icon should not be visible on scheduled trades", (widgetTester) async {
      tempTrades[0].isScheduled = false;
      tempTrades[1].isScheduled = true;
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());
      Finder? buttons = findAddRemoveButtons(1);
      expect(buttons, findsOneWidget);
      expect(getWidgetFromFinder<JPAddRemoveButton>(buttons).isAddBtn, isTrue);
    });

    testWidgets("Remove icon should be visible on unscheduled trades", (widgetTester) async {
      tempTrades[0].isScheduled = false;
      tempTrades[1].isScheduled = false;
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());
      Finder? buttons = findAddRemoveButtons(1);
      expect(buttons, findsNWidgets(2));
      expect(getWidgetFromFinder<JPAddRemoveButton>(buttons).isAddBtn, isFalse);
    });

    testWidgets("Add icon should be visible on scheduled trades", (widgetTester) async {
      tempTrades[1].isScheduled = true;
      setUpController(tempTrades);
      await widgetTester.pumpWidget(getTestableWidget());
      Finder? buttons = findAddRemoveButtons(1);
      expect(buttons, findsNWidgets(1));
      expect(getWidgetFromFinder<JPAddRemoveButton>(buttons).isAddBtn, isTrue);
    });
  });
}