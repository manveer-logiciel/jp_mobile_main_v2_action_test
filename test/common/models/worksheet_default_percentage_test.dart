import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/worksheet/settings/applied_percentage.dart';
import 'package:jobprogress/common/models/worksheet/settings/default_percentage.dart';

void main() {
  final defaultPercentage = WorksheetDefaultPercentage();

  group("WorksheetDefaultPercentage@fromDefaultJson should set default discount", () {
    test("Discount should not be set if not available", () {
      defaultPercentage.fromDefaultJson({});
      expect(defaultPercentage.defaultDiscount, isNull);
    });

    test("Discount should not be set if Null", () {
      defaultPercentage.fromDefaultJson({
        'apply_discount': null
      });
      expect(defaultPercentage.defaultDiscount, isNull);
    });

    test("Discount should not be set if is invalid data", () {
      defaultPercentage.fromDefaultJson({
        'apply_discount': {
          'discount': 'invalid'
        }
      });
      expect(defaultPercentage.defaultDiscount?.discount, isNull);
    });

    test("Discount should be set if available and has valid value", () {
      defaultPercentage.fromDefaultJson({
        'apply_discount': {
          'discount': 0.5,
        }
      });
      expect(defaultPercentage.defaultDiscount?.discount, 0.5);
    });
  });

  group("WorksheetDefaultPercentage@fromDefaultJson should set default card fee rate", () {
    test("Card fee rate should not be set if not available", () {
      defaultPercentage.fromDefaultJson({});
      expect(defaultPercentage.defaultFeeRate, isNull);
    });

    test("Card fee rate should not be set if Null", () {
      defaultPercentage.fromDefaultJson({
        'apply_processing_fee': null
      });
      expect(defaultPercentage.defaultFeeRate, isNull);
    });

    test("Card fee rate should not be set if is invalid data", () {
      defaultPercentage.fromDefaultJson({
        'apply_processing_fee': 'invalid'
      });
      expect(defaultPercentage.defaultFeeRate, isNull);
    });

    test("Card fee rate should be set if available and has valid value", () {
      defaultPercentage.fromDefaultJson({
        'apply_processing_fee': {
          'fee_rate': 0.5,
        }
      });
      expect(defaultPercentage.defaultFeeRate?.rate, 0.5);
    });
  });

  group("WorksheetDefaultPercentage@toDefaultJson should set default card fee rate", () {
    test("Card fee rate should not be set if not available", () {
      defaultPercentage.defaultFeeRate = null;
      final result = defaultPercentage.toDefaultJson();
      expect(result['apply_processing_fee'], isNull);
    });

    test("Card fee rate should not be set if available", () {
      defaultPercentage.defaultFeeRate = WorksheetAppliedPercentage(
        feeRate: 0.5
      );
      final result = defaultPercentage.toDefaultJson();
      expect(result['apply_processing_fee']['fee_rate'], 0.5);
    });
  });
}