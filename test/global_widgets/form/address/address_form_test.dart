import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/global_widgets/forms/address/controller.dart';

void main() {
  late AddressFormController controller;
  late AddressFormData formData;

  setUp(() {
    controller = AddressFormController(
      address: AddressModel(id: 1),
      isRequired: false,
      billingAddress: AddressModel(id: 1),
      isInitialSectionExpanded: true,
    );
    formData = AddressFormData(allStates: [], allCountries: []);
  });

  group('AddressFormController@onExpansionChanged should expand or collapse section according to passed value', () {
    test('Should expanded section when true is passed', () {
      controller.onExpansionChanged(formData, true);
      expect(formData.isSectionExpanded, true);
    });
    test('Should collapsed section when false is passed', () {
      controller.onExpansionChanged(formData, false);
      expect(formData.isSectionExpanded, false);
    });
  });

  test('AddressFormController@removeBillingAddress should remove billing address and set it to same as default', () {
    controller.removeBillingAddress();
    expect(controller.billingAddress?.sameAsDefault, true);   
    expect(controller.billingAddressData, isNull);
  });

  test('AddressFormController@removeName should clear name filed and name from billing address', () {
    controller.removeName();
    expect(formData.nameController.text, '');
    expect(controller.billingAddress?.name, '');
  });

  group('AddressFormController@addBillingAddress should add billing address correctly and expand or collapse section ', () {
    test('Should expand section by default & set billing address', () {
      controller.addBillingAddress();
      expect(controller.billingAddress?.sameAsDefault, false);
      expect(controller.billingAddressData, isNotNull);
      expect(controller.billingAddressData?.isBillingAddress, true);
      expect(controller.billingAddressData?.address, controller.billingAddress);
      expect(controller.billingAddressData?.allCountries, controller.allCountries);
      expect(controller.billingAddressData?.allStates, controller.allStates);
      expect(controller.billingAddressData?.isSectionExpanded, true);
    });

    test('Should collapse billing address when expandSection is false & set billing address', () {
      controller.addBillingAddress(expandSection: false);
      expect(controller.billingAddress?.sameAsDefault, false);
      expect(controller.billingAddressData, isNotNull);
      expect(controller.billingAddressData?.isBillingAddress, true);
      expect(controller.billingAddressData?.address, controller.billingAddress);
      expect(controller.billingAddressData?.allCountries, controller.allCountries);
      expect(controller.billingAddressData?.allStates, controller.allStates);
      expect(controller.billingAddressData?.isSectionExpanded, false);
    });   
  });
   group('AddressFormController@toggleSameAsCustomerAddress should set address correctly', () {
    test('Should not set address same as customer address when val is true', () {
      controller.toggleSameAsCustomerAddress(formData, true);
      expect(formData.sameAsCustomerAddress, false);
    });

    test('Should set address same as customer address when val is false', () {
      controller.toggleSameAsCustomerAddress(formData, false);
      expect(formData.sameAsCustomerAddress, true);
    });
  });
}