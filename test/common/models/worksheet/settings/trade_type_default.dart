import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/worksheet/settings/trade_type_default.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';

void main() {
  group('WorksheetTradeTypeDefault.fromJson should parse trade properly', () {
    test("In case trade is not available, it should be null", () {
      final result = WorksheetTradeTypeDefault.fromJson({});
      expect(result.trade, null);
    });

    test("In case trade is available, it should be parsed", () {
      final result = WorksheetTradeTypeDefault.fromJson({
        "trade": {
          "id": 1,
          "name": "Trade Name",
          "color": "Red"
        }
      });
      expect(result.trade, isA<CompanyTradesModel>());
      expect(result.trade?.id, 1);
      expect(result.trade?.name, "Trade Name");
      expect(result.trade?.color, "Red");
    });

    test("In case trade is available but is invalid, it should be null", () {
      final result = WorksheetTradeTypeDefault.fromJson({
        "trade": "invalid"
      });
      expect(result.trade, null);
    });

    test("In case trade is available but is null, it should be null", () {
      final result = WorksheetTradeTypeDefault.fromJson({
        "trade": null
      });
      expect(result.trade, null);
    });
  });

  group('WorksheetTradeTypeDefault.toJson should serialize trade properly', () {
    test("In case trade is not available, it should be null", () {
      final model = WorksheetTradeTypeDefault();
      final result = model.toJson();
      expect(result['trade'], null);
    });

    test("In case trade is available, it should be serialized", () {
      final model = WorksheetTradeTypeDefault(
          trade: CompanyTradesModel(id: 1, name: "Trade Name", color: "Red")
      );
      final result = model.toJson();
      expect(result['trade'], isA<Map<String, dynamic>>());
      expect(result['trade']?['id'], 1);
      expect(result['trade']?['name'], "Trade Name");
      expect(result['trade']?['color'], "Red");
    });
  });
}