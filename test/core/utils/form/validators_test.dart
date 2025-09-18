
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/utils/form/validators.dart';

void main() {

  List<FilesListingModel> invoiceList = [
    FilesListingModel(
      id: '1',
      openBalance: '100',
      name: 'Invoice # 12345'
    ),
    FilesListingModel(
      id: '2',
      openBalance: '102',
      name: 'Invoice # 1435'
    ),
  ];

  group('FormValidator@requiredFieldValidator should validate a empty field', () {

    test('Validation should fail when text is empty', () {
      final val = FormValidator.requiredFieldValidator('');
      expect(val, 'this_field_is_required'.tr);
    });

    test('Validation should fail when text is contains only spaces', () {
      final val = FormValidator.requiredFieldValidator('    ');
      expect(val, 'this_field_is_required'.tr);
    });

    test('Validation should display custom error message', () {
      final val = FormValidator.requiredFieldValidator('    ', errorMsg: 'Failed!');
      expect(val, 'Failed!');
    });

    test('Validation should pass when text is not empty', () {
      final val = FormValidator.requiredFieldValidator('Data');
      expect(val, null);
    });

  });

  group('FormValidator@validateCreditAmount should validate amount', () {

    test('Validation should return please_enter_valid_amount when text is empty', () {
      final val = FormValidator.validateCreditAmount('','1', invoiceList);
      expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
    });

    test('Validation should return please_enter_valid_amount when text is 0', () {
      final val = FormValidator.validateCreditAmount('0', '1', invoiceList);
      expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
    });

    test('Validation should return value_should_not_greater_than_invoice_value when amount is greater than invoice value', () {
      final val = FormValidator.validateCreditAmount('101', '1', invoiceList);
      expect(val, 'value_should_not_greater_than_invoice_value'.tr.capitalizeFirst);
    });

    test('Validation should  pass when amount >= invoice value & amount is not empty or zero', () {
      final val = FormValidator.validateCreditAmount('99', '1', invoiceList);
      expect(val, null);
    });

    test('Validation should  pass when  selectedInvoiceId is null & amount is not empty or zero', () {
      final val = FormValidator.validateCreditAmount('125', null, invoiceList);
      expect(val, null);
    });

  });

  group('FormValidator@typeToFrequencyValidator should validate a time frequency', () {

    group('In case of hour', () {

      test('Zero(0) should not be allowed', () {
        final result = FormValidator.typeToFrequencyValidator('hour').hasMatch('0');
        expect(result, false);
      });

      group('When value(x) is in range 0 < x <= 24', () {

        test('Value less than equal to 24 should be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('hour').hasMatch('12');
          expect(result, true);
        });

        test('Value greater than 24 should not be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('hour').hasMatch('25');
          expect(result, false);
        });

      });

    });

    group('In case of day limited', () {

      test('Zero(0) should not be allowed', () {
        final result = FormValidator.typeToFrequencyValidator('day_limited').hasMatch('0');
        expect(result, false);
      });

      group('When value(x) is in range 0 < x <= 31', () {

        test('Value less than equal to 31 should be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('day_limited').hasMatch('12');
          expect(result, true);
        });

        test('Value greater than 31 should not be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('day_limited').hasMatch('35');
          expect(result, false);
        });

      });

    });

    group('In case of day', () {

      test('Zero(0) should not be allowed', () {
        final result = FormValidator.typeToFrequencyValidator('day').hasMatch('0');
        expect(result, false);
      });

      group('When value(x) is in range 0 < x <= 999', () {

        test('Value less than equal to 999 should be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('day').hasMatch('12');
          expect(result, true);
        });

        test('Value greater than 999 should not be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('day').hasMatch('1235');
          expect(result, false);
        });

      });

    });

    group('In case of week', () {

      test('Zero(0) should not be allowed', () {
        final result = FormValidator.typeToFrequencyValidator('week').hasMatch('0');
        expect(result, false);
      });

      group('When value(x) is in range 0 < x <= 52', () {

        test('Value less than equal to 52 should be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('week').hasMatch('12');
          expect(result, true);
        });

        test('Value greater than 52 should not be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('week').hasMatch('55');
          expect(result, false);
        });

      });

    });

    group('In case of month', () {

      test('Zero(0) should not be allowed', () {
        final result = FormValidator.typeToFrequencyValidator('month').hasMatch('0');
        expect(result, false);
      });

      group('When value(x) is in range 0 < x <= 12', () {

        test('Value less than equal to 12 should be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('month').hasMatch('12');
          expect(result, true);
        });

        test('Value greater than 12 should not be allowed', () {
          final result = FormValidator.typeToFrequencyValidator('month').hasMatch('35');
          expect(result, false);
        });

      });

    });

  });

  group('FormValidator@setMaxAvailableFrequencyValue should set maximum available frequency', () {

    group('In case hour is selected', () {

      test('Value less than 0 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('hour', '-12');
        expect(result, '12');
      });

      test('Value less then equal 24 should be accepted', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('hour', '12');
        expect(result, '12');
      });

      test('Value greater than 24 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('hour', '28');
        expect(result, '24');
      });

    });

    group('In case day is selected', () {

      test('Value less than 0 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('day', '-12');
        expect(result, '12');
      });

      test('Value less then equal 31 should be accepted', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('day', '12');
        expect(result, '12');
      });

      test('Value greater than 31 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('day', '35');
        expect(result, '31');
      });

    });

    group('In case week is selected', () {

      test('Value less than 0 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('week', '-12');
        expect(result, '12');
      });

      test('Value less then equal 52 should be accepted', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('week', '12');
        expect(result, '12');
      });

      test('Value greater than 52 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('week', '55');
        expect(result, '52');
      });

    });

    group('In case month is selected', () {

      test('Value less than 0 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('month', '-12');
        expect(result, '12');
      });

      test('Value less then equal 12 should be accepted', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('month', '12');
        expect(result, '12');
      });

      test('Value greater than 12 should be modified', () {
        final result = FormValidator.setMaxAvailableFrequencyValue('month', '55');
        expect(result, '12');
      });

    });

  });

  group("FormValidator@validatePhoneNumber should validate phone number", () {

    test("Validation should fail when phone number is empty", () {
      final val = FormValidator.validatePhoneNumber("");
      expect(val, 'this_field_is_required'.tr);
    });

    test("Validation should fail when phone number is incorrect", () {
      final val = FormValidator.validatePhoneNumber(PhoneMasking.maskPhoneNumber("123"));
      expect(val, 'phone_number_must_be_between_range'.tr);
    });

    test("Validation should pass when correct phone number is entered", () {
      final val = FormValidator.validatePhoneNumber(PhoneMasking.maskPhoneNumber("1234567890"));
      expect(val, isNull);
    });

    test("Validation should pass when correct phone number is entered and is not masked", () {
      final val = FormValidator.validatePhoneNumber("1234567890");
      expect(val, isNull);
    });
  });

  group("FormValidator@validateEmail should validated email", () {

    group("When email is not required", () {

      test("Validation should pass when email is empty", () {
        final result = FormValidator.validateEmail("");
        expect(result, isNull);
      });

      test("Validation should fail when email is incorrect", () {
        final result = FormValidator.validateEmail("1232");
        expect(result, 'please_enter_valid_email'.tr);
      });

      test("Validation should pass when email is correct", () {
        final result = FormValidator.validateEmail("1232@gmail.com");
        expect(result, isNull);
      });

    });

    group("When email is required", () {

      test("Validation should fail when email is empty", () {
        final result = FormValidator.validateEmail("", isRequired: true);
        expect(result, 'this_field_is_required'.tr);
      });

      test("Validation should fail when email is incorrect", () {
        final result = FormValidator.validateEmail("1232", isRequired: true);
        expect(result, 'please_enter_valid_email'.tr);
      });

      test("Validation should pass when email is correct", () {
        final result = FormValidator.validateEmail("1232@gmail.com", isRequired: true);
        expect(result, isNull);
      });

    });

  });

  group("FormValidator@validateAddressForm should validated address", () {

    AddressModel? addressModel = AddressModel(
      id: 0,
      address: "Address Line 1",
      addressLine1: "Address Line 2",
      addressLine3: "Address Line 3",
      city: "City Line",
      state: StateModel(id: 0, name: "State", code: "ST", countryId: 0),
      country: CountryModel(id: 0, name: "Country", code: "CO", currencyName: "Currency", currencySymbol: "c", phoneCode: "PhoneCode", phoneFormat: "-- ------ ----- "),
      zip: "Zip Code"
    );

    test("Validation should pass when address is not empty", () {
      final result = FormValidator.validateAddressForm(addressModel);
      expect(result, isNull);
    });

    test("Validation should fail when address data is empty", () {
      addressModel?.address = addressModel?.addressLine1 = addressModel?.addressLine3 = null;
      expect(FormValidator.validateAddressForm(addressModel), "address_required".tr);
    });

    test("Validation should fail when city data is empty", () {
      addressModel?.city = null;
      expect(FormValidator.validateAddressForm(addressModel), "address_required".tr);
    });

    test("Validation should fail when country data is empty", () {
      addressModel?.country = null;
      expect(FormValidator.validateAddressForm(addressModel), "address_required".tr);
    });

    test("Validation should fail when address data is empty", () {
      addressModel = null;
      expect(FormValidator.validateAddressForm(addressModel), "address_required".tr);
    });
  });

  group("FormValidator@validatePrice should validate price and give error message", () {
    group("[maxValue] validation should be handled properly", () {
      test("In case price is less than [maxValue] validation should pass", () {
        final result = FormValidator.validatePrice(10, maxValue: 20);
        expect(result, isNull);
      });

      test("In case price is greater than [maxValue] validation should fail", () {
        final result = FormValidator.validatePrice(30, maxValue: 20);
        expect(result, "invalid_price".tr);
      });

      test("In case price is equal to [maxValue] validation should pass", () {
        final result = FormValidator.validatePrice(20, maxValue: 20);
        expect(result, isNull);
      });

      test("In case price is null validation should pass", () {
        final result = FormValidator.validatePrice(null, maxValue: 20);
        expect(result, isNull);
      });

      test("In case price is empty validation should pass", () {
        final result = FormValidator.validatePrice("", maxValue: 20, isNumberRequired: false);
        expect(result, isNull);
      });

      test("In case price is zero validation should pass", () {
        final result = FormValidator.validatePrice(0, maxValue: 20);
        expect(result, isNull);
      });

      test('Custom validation message should be displayed', () {
        final result = FormValidator.validatePrice(30, maxValue: 20, invalidRangeErrorMsg: 'custom_error_message');
        expect(result, "custom_error_message");
      });
    });
  });
}