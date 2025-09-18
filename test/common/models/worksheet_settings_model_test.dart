import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/worksheet/settings/settings.dart';

void main() {
  WorksheetSheetSetting settings = WorksheetSheetSetting();

  group("WorksheetSheetSetting@fromWorksheetJson should set correct values", () {
    group("[show_tier_sub_totals] default settings should be set correctly", () {
      test("In case of nullable value, default value should be false", () {
        settings.fromJson({
          'show_tier_sub_totals': null
        });
        expect(settings.showTierSubTotals, false);
      });

      test("In case of invalid value, default value should be false", () {
        settings.fromJson({
          'show_tier_sub_totals': 'invalid'
        });
        expect(settings.showTierSubTotals, false);
      });

      test("In case of valid value, default value should be true", () {
        settings.fromJson({
          'show_tier_sub_totals': true
        });
        expect(settings.showTierSubTotals, true);
      });

      test("In case of valid value, default value should be false", () {
        settings.fromJson({
          'show_tier_sub_totals': false
        });
        expect(settings.showTierSubTotals, false);
      });

      test("In case of valid value, default value should be false", () {
        settings.fromJson({
          'show_tier_sub_totals': 0
        });
        expect(settings.showTierSubTotals, false);
      });

      test("In case of valid value, default value should be true", () {
        settings.fromJson({
          'show_tier_sub_totals': 1
        });
        expect(settings.showTierSubTotals, true);
      });
    });
  });

  group("[enable_line_worksheet_profit] default settings should be set correctly", () {
    test("In case of nullable value, default value should be false", () {
      settings.fromJson({'enable_line_worksheet_profit': null});
      expect(settings.applyLineAndWorksheetProfit, false);
    });
    test("In case of invalid value, default value should be false", () {
      settings.fromJson({'enable_line_worksheet_profit': 'invalid'});
      expect(settings.applyLineAndWorksheetProfit, false);
    });

    test("In case of valid value, default value should be true", () {
      settings.fromJson({'enable_line_worksheet_profit': true});
      expect(settings.applyLineAndWorksheetProfit, true);
    });

    test("In case of valid value, default value should be false", () {
      settings.fromJson({'enable_line_worksheet_profit': false});
      expect(settings.applyLineAndWorksheetProfit, false);
    });

    test("In case of valid value, default value should be false", () {
      settings.fromJson({'enable_line_worksheet_profit': 0});
      expect(settings.applyLineAndWorksheetProfit, false);
    });

    test("In case of valid value, default value should be true", () {
      settings.fromJson({'enable_line_worksheet_profit': 1});
      expect(settings.applyLineAndWorksheetProfit, true);
    });

    test("In case of valid value, default value should be true", () {
      settings.fromJson({'enable_line_worksheet_profit': 1});
      expect(settings.applyLineAndWorksheetProfit, true);
    });
  });

  group("[applyLineItemProfit] default settings should be set correctly", () {
    test("In case of applyLineAndWorksheetProfit is enabled, default value for applyLineItemProfit should be true", () {
      settings.fromJson({'enable_line_worksheet_profit': true});
      expect(settings.applyLineAndWorksheetProfit, isTrue);
      expect(settings.applyLineItemProfit, isTrue);
    });
    test("In case of applyLineAndWorksheetProfit is disable, default value for applyLineItemProfit should be based on [apply_line_item_profit]", () {
      settings.fromJson({'enable_line_worksheet_profit': false, 'apply_line_item_profit' : true});
      expect(settings.applyLineAndWorksheetProfit, isFalse);
      expect(settings.applyLineItemProfit, isTrue);
    });
  });

  group("[applyProfit] default settings should be set correctly", () {
    test("In case of applyLineAndWorksheetProfit is enabled, default value for applyLineItemProfit should be true", () {
      settings.fromJson({'enable_line_worksheet_profit': true});
      expect(settings.applyLineAndWorksheetProfit, isTrue);
      expect(settings.applyProfit, isTrue);
    });
    test("In case of applyLineAndWorksheetProfit is disable, default value for applyProfit should be based on [apply_profit]", () {
      settings.fromJson({'enable_line_worksheet_profit': false, 'apply_profit' : true});
      expect(settings.applyLineAndWorksheetProfit, isFalse);
      expect(settings.applyProfit, isTrue);
    });
  });

}