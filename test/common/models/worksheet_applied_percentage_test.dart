import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/worksheet/settings/applied_percentage.dart';

void main() {
  group("WorksheetAppliedPercentage.fromJson should set card fee rate properly", () {
    test("Card fee rate should not be set if not available", () {
      final result = WorksheetAppliedPercentage.fromJson({});
      expect(result.rate, isNull);
    });

    test("Card fee rate should not be set if Null", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'fee_rate': null
      });
      expect(result.rate, isNull);
    });

    test("Card fee rate should not be set if is invalid data", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'fee_rate': 'invalid'
      });
      expect(result.rate, isNull);
    });

    test("Card fee rate should be set if available and has valid value", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'fee_rate': 0.5
      });
      expect(result.rate, 0.5);
    });
  });

  group("WorksheetAppliedPercentage.fromJson should set commission rate properly", () {
    test("Commission rate should not be set if not available", () {
      final result = WorksheetAppliedPercentage.fromJson({});
      expect(result.commission, isNull);
    });

    test("Commission rate should not be set if Null", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'commission': null
      });
      expect(result.commission, isNull);
    });

    test("Commission rate should not be set if is invalid data", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'commission': 'invalid'
      });
      expect(result.commission, isNull);
    });

    test("Commission rate should be set if available and has valid value", () {
      final result = WorksheetAppliedPercentage.fromJson({
        'commission': 0.5
      });
      expect(result.commission, 0.5);
    });
  });

  group("WorksheetAppliedPercentage@toJson should json data properly", () {
    test("'discount' should be added if available", () {
      final result = WorksheetAppliedPercentage(
        discount: 0.5
      );
      expect(result.toJson()['discount'], 0.5);
    });

    test("'discount' should not be added if not available", () {
      final result = WorksheetAppliedPercentage();
      expect(result.toJson()['discount'], isNull);
    });

    test("'discount' should be added if available", () {
      final result = WorksheetAppliedPercentage(
        discount: 0.5
      );
      expect(result.toJson()['discount'], 0.5);
    });

    test("'discount' should not be added if not available", () {
      final result = WorksheetAppliedPercentage();
      expect(result.toJson()['discount'], isNull);
    });
    
    test("'commission' should be added if available", () {
      final result = WorksheetAppliedPercentage(
        commission: 0.5
      );
      expect(result.toJson()['commission'], 0.5);
    });

    test("'commission' should not be added if not available", () {
      final result = WorksheetAppliedPercentage();
      expect(result.toJson()['commission'], isNull);
    });

    test("'fee_rate' should be added if available", () {
      final result = WorksheetAppliedPercentage(
        feeRate: 0.5
      );
      expect(result.toJson()['fee_rate'], 0.5);
    });

    test("'fee_rate' should not be added if not available", () {
      final result = WorksheetAppliedPercentage();
      expect(result.toJson()['fee_rate'], isNull);
    });
  });
}