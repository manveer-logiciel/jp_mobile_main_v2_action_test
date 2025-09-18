import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/common/models/worksheet/settings/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/settings/widgets/percent_amount_dialog/controller.dart';

void main() {

  final settings = WorksheetSettingModel.fromJson({});
  final controller = WorksheetPercentAmountController(
    settings,
    WorksheetPercentAmountDialogType.overAllProfit
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("WorksheetPercentAmountController should be properly initialized", () {
    expect(controller.settings, settings);
    expect(controller.type, WorksheetPercentAmountDialogType.overAllProfit);
    expect(controller.isProfitMarkup, true);
    expect(controller.percentController.text, isEmpty);
    expect(controller.amountController.text, isEmpty);
    expect(controller.validateFieldsOnDataChange, false);
  });

  group("WorksheetPercentAmountController@title should give appropriate title to be displayed", () {
    test("Correct title should be displayed while updating/editing overall profit", () {
      expect(controller.title, "add_profit".tr);
    });

    test("Correct title should be displayed while updating/editing line item profit", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      expect(controller.title, "add_profit".tr);
    });

    test("Correct title should be displayed while updating/editing line item tax", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemTax;
      expect(controller.title, "add_tax".tr);
    });

    test("Correct title should be displayed while updating/editing commission", () {
      controller.type = WorksheetPercentAmountDialogType.commission;
      expect(controller.title, "add_commission".tr);
    });

    test("Correct title should be displayed while updating/editing overhead", () {
      controller.type = WorksheetPercentAmountDialogType.overhead;
      expect(controller.title, "add_overhead".tr);
    });

    test("Correct title should be displayed while updating/editing discount", () {
      controller.type = WorksheetPercentAmountDialogType.discount;
      expect(controller.title, "add_discount".tr);
    });
    test("Correct title should be displayed while updating/editing card fee", () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      expect(controller.title, "apply_processing_fee".tr);
    });

    group('Correct title should be displayed for overall profit while enabling/disabling line and worksheet profit', () {
      test('Correct title should be displayed when line and worksheet profit is enable', () {
        settings.applyLineAndWorksheetProfit = true;
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        expect(controller.title, equals('projected_worksheet_profit'.tr));
      });

      test('Correct title should be displayed when line and worksheet profit is enable', () {
        settings.applyLineAndWorksheetProfit = false;
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        expect(controller.title, equals('add_profit'.tr));
      });

      test('Correct title should be displayed when line and worksheet profit is not set', () {
        settings.applyLineAndWorksheetProfit = null;
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        expect(controller.title, equals('add_profit'.tr));
      });
    });

    group('Correct title should be displayed for line item profit while enabling/disabling line and worksheet profit', () {
      test('Correct line item profit title should be displayed when line and worksheet profit is enable', () {
        settings.applyLineAndWorksheetProfit = true;
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        expect(controller.title, equals('update_line_item_profit'.tr));
      });

      test('Correct line item profit title should be displayed when line and worksheet profit is disable', () {
        settings.applyLineAndWorksheetProfit = false;
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        expect(controller.title, equals('add_profit'.tr));
      });

      test('Correct line item profit title should be displayed when line and worksheet profit is not set', () {
        settings.applyLineAndWorksheetProfit = null;
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        expect(controller.title, equals('add_profit'.tr));
      });
    });
  });

  group("WorksheetPercentAmountController@percentFieldLabel should give appropriate field label to be displayed", () {
    test("Correct field label should be displayed while updating/editing overall profit", () {
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      expect(controller.percentFieldLabel, "profit_percent".tr);
    });

    test("Correct field label should be displayed while updating/editing line item profit", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      expect(controller.percentFieldLabel, "profit_percent".tr);
    });

    test("Correct field label should be displayed while updating/editing line item tax", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemTax;
      expect(controller.percentFieldLabel, "tax_percent".tr);
    });

    test("Correct field label should be displayed while updating/editing commission", () {
      controller.type = WorksheetPercentAmountDialogType.commission;
      expect(controller.percentFieldLabel, "commission_percent".tr);
    });

    test("Correct field label should be displayed while updating/editing overhead", () {
      controller.type = WorksheetPercentAmountDialogType.overhead;
      expect(controller.percentFieldLabel, "overhead_percent".tr);
    });

    test("Correct field label should be displayed while updating/editing discount", () {
      controller.type = WorksheetPercentAmountDialogType.discount;
      expect(controller.percentFieldLabel, "discount_percent".tr);
    });
    test("Correct field label should be displayed while updating/editing card fee", () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      expect(controller.percentFieldLabel, "processing_fee_percent".tr);
    });
  });

  group("WorksheetPercentAmountController@amountFieldLabel should give appropriate field label to be displayed", () {
    test("Correct field label should be displayed while updating/editing overall profit", () {
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      expect(controller.amountFieldLabel, "profit_amount".tr);
    });

    test("Correct field label should be displayed while updating/editing line item profit", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      expect(controller.amountFieldLabel, "profit_amount".tr);
    });

    test("Correct field label should be displayed while updating/editing line item tax", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemTax;
      expect(controller.amountFieldLabel, "");
    });

    test("Correct field label should be displayed while updating/editing commission", () {
      controller.type = WorksheetPercentAmountDialogType.commission;
      expect(controller.amountFieldLabel, "commission_amount".tr);
    });

    test("Correct field label should be displayed while updating/editing overhead", () {
      controller.type = WorksheetPercentAmountDialogType.overhead;
      expect(controller.amountFieldLabel, "overhead_amount".tr);
    });

     test("Correct field label should be displayed while updating/editing discount", () {
      controller.type = WorksheetPercentAmountDialogType.discount;
      expect(controller.amountFieldLabel, "discount_amount".tr);
    });
    test("Correct field label should be displayed while updating/editing card fee", () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      expect(controller.amountFieldLabel, "processing_fee_amount".tr);
    });
  });

  group("WorksheetPercentAmountController@showAmountField should decide and conditionally should amount field", () {
    group("Amount field should be displayed", () {
      test("While editing/updating over all profit", () {
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        expect(controller.showAmountField, true);
      });

      test("While editing/updating commission", () {
        controller.type = WorksheetPercentAmountDialogType.commission;
        expect(controller.showAmountField, true);
      });

      test("While editing/updating overhead", () {
        controller.type = WorksheetPercentAmountDialogType.overhead;
        expect(controller.showAmountField, true);
      });
      test("While editing/updating card fee", () {
        controller.type = WorksheetPercentAmountDialogType.discount;
      });
      test("While editing/updating card fee", () {
        controller.type = WorksheetPercentAmountDialogType.cardFee;
        expect(controller.showAmountField, true);
      });
    });

    group("Amount field should not be displayed", () {
      test("While editing/updating line item profit", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        expect(controller.showAmountField, false);
      });

      test("While editing/updating line item tax", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemTax;
        expect(controller.showAmountField, false);
      });
    });
  });

  group("WorksheetPercentAmountController@showMarkupMargin should decide and conditionally should markup margin", () {
    group("Markup margin should be displayed", () {
      test("While editing/updating over all profit", () {
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        expect(controller.showMarkupMargin, true);
      });

      test("While editing/updating commission", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        expect(controller.showMarkupMargin, true);
      });
    });

    group("Markup margin should not be displayed", () {
      test("While editing/updating line item profit", () {
        controller.type = WorksheetPercentAmountDialogType.commission;
        expect(controller.showMarkupMargin, false);
      });

      test("While editing/updating line item tax", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemTax;
        expect(controller.showMarkupMargin, false);
      });

      test("While editing/updating overhead", () {
        controller.type = WorksheetPercentAmountDialogType.overhead;
        expect(controller.showMarkupMargin, false);
      });
    });
  });

  group("WorksheetPercentAmountController@setUpFields should properly initialize dialog fields", () {
    test("Fields data should be properly initialized for overall profit", () {
      controller.settings.overAllProfitPercent = 5;
      controller.settings.isOverAllProfitMarkup = false;
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
      expect(controller.isProfitMarkup, false);
    });

    test("Fields data should be properly initialized for line item profit", () {
      controller.settings.lineItemProfitPercent = 5;
      controller.settings.isLineItemProfitMarkup = false;
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
      expect(controller.isProfitMarkup, false);
    });

    test("Fields data should be properly initialized for line item tax", () {
      controller.settings.lineItemTaxPercent = 5;
      controller.type = WorksheetPercentAmountDialogType.lineItemTax;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
    });

    test("Fields data should be properly initialized for commission", () {
      controller.settings.commissionPercent = 5;
      controller.type = WorksheetPercentAmountDialogType.commission;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
    });

    test("Fields data should be properly initialized for overhead", () {
      controller.settings.overHeadRate = 5;
      controller.type = WorksheetPercentAmountDialogType.overhead;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
    });

    test("Fields data should be properly initialized for discount", () {
      controller.settings.discountPercent = 5;
      controller.type = WorksheetPercentAmountDialogType.discount;
    });
    test("Fields data should be properly initialized for card fee", () {
      controller.settings.creditCardFeePercent = 5;
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      controller.setUpFields();
      expect(controller.percentController.text, "5");
    });
  });

  group("WorksheetPercentAmountController@changeProfitType should switch markup margin profit", () {
    test("Profit should be switched to markup profit", () {
      controller.settings.markup = '5';
      controller.changeProfitType(true);
      expect(controller.isProfitMarkup, true);
      expect(controller.percentController.text, '5');
    });

    test("Markup should be switched to profit margin", () {
      controller.settings.margin = '5';
      controller.changeProfitType(false);
      expect(controller.isProfitMarkup, false);
      expect(controller.percentController.text, '5');
    });
  });

  group("WorksheetPercentAmountController@updateValuesForType should updated settings", () {
    test("Overall profit settings should be updated", () {
      controller.percentController.text = '5';
      controller.amountController.text = '10';
      controller.isProfitMarkup = false;
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      controller.updateValuesForType();
      expect(controller.settings.overAllProfitPercent, 5);
      expect(controller.settings.overAllProfitAmount, 10);
      expect(controller.settings.isOverAllProfitMarkup, false);
      expect(controller.settings.isLineItemProfitMarkup, false);
    });

    test("Line item profit settings should be updated", () {
      controller.percentController.text = '5';
      controller.isProfitMarkup = false;
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      controller.updateValuesForType();
      expect(controller.settings.lineItemProfitPercent, 5);
      expect(controller.settings.lineItemTempProfitPercent, 5);
      expect(controller.settings.isLineItemProfitMarkup, false);
      expect(controller.settings.isOverAllProfitMarkup, false);
    });

    test("Line item tax settings should be updated", () {
      controller.percentController.text = '5';
      controller.type = WorksheetPercentAmountDialogType.lineItemTax;
      controller.updateValuesForType();
      expect(controller.settings.lineItemTaxPercent, 5);
    });

    test("Commission settings should be updated", () {
      controller.percentController.text = '5';
      controller.amountController.text = '10';
      controller.type = WorksheetPercentAmountDialogType.commission;
      controller.updateValuesForType();
      expect(controller.settings.commissionPercent, 5);
      expect(controller.settings.commissionAmount, 10);
    });

    test("Overhead settings should be updated", () {
      controller.percentController.text = '5';
      controller.amountController.text = '10';
      controller.type = WorksheetPercentAmountDialogType.overhead;
      controller.updateValuesForType();
      expect(controller.settings.overHeadRate, 5);
      expect(controller.settings.overriddenOverHeadRate, 5);
    });

    group("Profit types should be preserved while updating profit", () {
      group("Line Item Profit should be preserved, When Line Item Profit is markup", () {
        setUp(() {
          controller.settings.isLineItemProfitMarkup = true;
        });

        test("On updating Worksheet Profit to Markup", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = true;
          controller.type = WorksheetPercentAmountDialogType.overAllProfit;
          controller.updateValuesForType();
          expect(controller.settings.isLineItemProfitMarkup, true);
        });

        test("On updating Worksheet Profit to Profit Margin", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = false;
          controller.type = WorksheetPercentAmountDialogType.overAllProfit;
          controller.updateValuesForType();
          expect(controller.settings.isLineItemProfitMarkup, true);
        });
      });

      group("Line Item Profit should be preserved, When Line Item Profit is margin", () {
        setUp(() {
          controller.settings.isLineItemProfitMarkup = false;
        });

        test("On updating Worksheet Profit to Markup", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = true;
          controller.type = WorksheetPercentAmountDialogType.overAllProfit;
          controller.updateValuesForType();
          expect(controller.settings.isLineItemProfitMarkup, false);
        });

        test("On updating Worksheet Profit to Profit Margin", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = false;
          controller.type = WorksheetPercentAmountDialogType.overAllProfit;
          controller.updateValuesForType();
          expect(controller.settings.isLineItemProfitMarkup, false);
        });
      });

      group("OverAll Profit should be preserved, When OverAll Profit is markup", () {
        setUp(() {
          controller.settings.isOverAllProfitMarkup = true;
        });

        test("On updating Worksheet Profit to Markup", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = true;
          controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
          controller.updateValuesForType();
          expect(controller.settings.isOverAllProfitMarkup, true);
        });

        test("On updating Worksheet Profit to Profit Margin", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = false;
          controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
          controller.updateValuesForType();
          expect(controller.settings.isOverAllProfitMarkup, true);
        });
      });

      group("OverAll Profit should be preserved, When OverAll Profit is margin", () {
        setUp(() {
          controller.settings.isOverAllProfitMarkup = false;
        });

        test("On updating Worksheet Profit to Markup", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = true;
          controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
          controller.updateValuesForType();
          expect(controller.settings.isOverAllProfitMarkup, false);
        });

        test("On updating Worksheet Profit to Profit Margin", () {
          controller.percentController.text = '5';
          controller.isProfitMarkup = false;
          controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
          controller.updateValuesForType();
          expect(controller.settings.isOverAllProfitMarkup, false);
        });
      });
    });
  });

  group('WorksheetPercentAmountController@updateSettingsIfChanged should update settings if some value has changed', () {
    test('When old value and new value are equal then it should return old value', () {
      num oldValue = 10;
      String newValue = '10.00';
      num? updatedValue = controller.updateSettingsIfChanged(oldValue, newValue);
      expect(updatedValue, equals(oldValue));
    });

    test('When old value and new value are different then it should return new value', () {
      num oldValue = 10;
      String newValue = '15.00';
      num? updatedValue = controller.updateSettingsIfChanged(oldValue, newValue);
      expect(updatedValue, equals(15));
    });

    test('When old value is greater then new value then it should return new value', () {
      num oldValue = 15;
      String newValue = '10.00';
      num? updatedValue = controller.updateSettingsIfChanged(oldValue, newValue);
      expect(updatedValue, 10);
    });

    test('When old value is null then it should return parsed new value', () {
      num? oldValue;
      String newValue = '15.00';
      num? updatedValue = controller.updateSettingsIfChanged(oldValue, newValue);
      expect(updatedValue, equals(15));
    });

    test('When old value is null and new value is not a valid number then it should return null', () {
      num? oldValue;
      String newValue = 'abc';
      num? updatedValue = controller.updateSettingsIfChanged(oldValue, newValue);
      expect(updatedValue, equals(null));
    });
  });

  group('WorksheetPercentAmountController@getRoundOff should round given price with two decimal places', () {
    test('When price is a whole number then it should return rounded string with two decimal places', () {
      var price = 10;
      var result = controller.getRoundOff(price);
      expect(result, equals('10'));
    });

    test('When price has more than two decimal places then it should return rounded string with two decimal places', () {
      var price = 10.557;
      var result = controller.getRoundOff(price);
      expect(result, equals('10.56'));
    });

    test('When price is negative then it should return rounded string with two decimal places and preserve sign', () {
      var price = -10.557;
      var result = controller.getRoundOff(price);
      expect(result, equals('-10.56'));
    });

    test('When price is positive decimal price and avoidZero set to true then it should return "0.56"', () {
      var price = 0.5600;
      var result = controller.getRoundOff(price);
      expect(result, equals('0.56'));
    });

    test("When zero value is allowed, then it should return '0'", () {
      var price = 0;
      controller.type = WorksheetPercentAmountDialogType.commission;
      var result = controller.getRoundOff(price);
      expect(result, equals('0'));
    });
  });

  group('WorksheetPercentAmountController@setAmountOnPercentageChange should change amount when percentage is changed in setting', () {
    test('Set overall profit amount', () {
      var percentageChange = 100.0;
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      controller.setAmountOnPercentageChange(percentageChange);
      expect(controller.settings.overAllProfitAmount, equals(percentageChange));
    });

    test('Set commission amount', () {
      var percentageChange = 50.0;
      controller.type = WorksheetPercentAmountDialogType.commission;
      controller.setAmountOnPercentageChange(percentageChange);
      expect(controller.settings.commissionAmount, equals(percentageChange));
    });

    test('Set overhead amount', () {
      var percentageChange = 75.0;
      controller.type = WorksheetPercentAmountDialogType.overhead;
      controller.setAmountOnPercentageChange(percentageChange);
      expect(controller.settings.overHeadAmount, equals(percentageChange));
    });
    test("Set discount", () {
      controller.type = WorksheetPercentAmountDialogType.discount;
      controller.setAmountOnPercentageChange(25);
      expect(controller.settings.discountAmount, equals(25));
    });
    test("Set credit card fee", () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      controller.setAmountOnPercentageChange(25);
      expect(controller.settings.cardFeeAmount, equals(25));

    });
  });

  group('WorksheetPercentAmountController@percentageFraction should decide decimal fractions to be shown in percentage field', () {
    test('For card fee percentage should be displayed up to 20 decimal places', () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      expect(controller.percentageFraction, equals(20));
    });

    test('For any other type percentage should be displayed up to 20 decimal places', () {
      controller.type = WorksheetPercentAmountDialogType.commission;
      expect(controller.percentageFraction, equals(20));
    });
  });

  group('WorksheetPercentAmountController@allowZeroInput should decide whether zero input is allowed or not', () {
    test("Zero input should be allowed for commission", () {
      controller.type = WorksheetPercentAmountDialogType.commission;
      expect(controller.allowZeroInput, equals(true));
    });

    test("Zero input should be allowed for overhead", () {
      controller.type = WorksheetPercentAmountDialogType.overhead;
      expect(controller.allowZeroInput, equals(true));
    });

    test("Zero input should be allowed for discount", () {
      controller.type = WorksheetPercentAmountDialogType.discount;
      expect(controller.allowZeroInput, equals(true));
    });

    test("Zero input should be allowed for card fee", () {
      controller.type = WorksheetPercentAmountDialogType.cardFee;
      expect(controller.allowZeroInput, equals(true));
    });

    test("Zero input should be allowed for Worksheet profit", () {
      controller.type = WorksheetPercentAmountDialogType.overAllProfit;
      expect(controller.allowZeroInput, equals(true));
    });

    test("Zero input should be allowed for line item profit", () {
      controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
      expect(controller.allowZeroInput, equals(true));
    });
  });

  group('WorksheetPercentAmountController@onPercentChange should update amount on change in percentage', () {
    group('Amount should be conditionally filled in as zero', () {
      test("Zero amount should not be filled in for commission", () {
        controller.type = WorksheetPercentAmountDialogType.commission;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });

      test("Zero amount should not be filled in for overhead", () {
        controller.type = WorksheetPercentAmountDialogType.overhead;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });

      test("Zero amount should not be filled in for discount", () {
        controller.type = WorksheetPercentAmountDialogType.discount;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });

      test("Zero amount should not be filled in for card fee", () {
        controller.type = WorksheetPercentAmountDialogType.cardFee;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });

      test("Zero amount should not be filled in for Worksheet profit", () {
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });

      test("Zero amount should not be filled in for line item profit", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        controller.onPercentChange('0');
        expect(controller.amountController.text, equals('0'));
      });
    });
  });

  group('WorksheetPercentAmountController@onAmountChange should update percentage on change in amount', () {
    group('Percentage should be conditionally filled in as zero', () {
      test("Zero percentage should not be filled in for commission", () {
        controller.type = WorksheetPercentAmountDialogType.commission;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });

      test("Zero percentage should not be filled in for overhead", () {
        controller.type = WorksheetPercentAmountDialogType.overhead;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });

      test("Zero percentage should not be filled in for discount", () {
        controller.type = WorksheetPercentAmountDialogType.discount;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });

      test("Zero percentage should not be filled in for card fee", () {
        controller.type = WorksheetPercentAmountDialogType.cardFee;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });

      test("Zero percentage should not be filled in for Worksheet profit", () {
        controller.type = WorksheetPercentAmountDialogType.overAllProfit;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });

      test("Zero percentage should not be filled in for line item profit", () {
        controller.type = WorksheetPercentAmountDialogType.lineItemProfit;
        controller.onAmountChange('0');
        expect(controller.percentController.text, equals('0'));
      });
    });
  });
}