import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';

void main() {

  HoverOrderFormService service = HoverOrderFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  AddressModel address = AddressModel(
      id: 1,
      address: "New york, USA",
      city: "New York",
      addressLine1: "Address line 1",
      zip: "112233",
      state: StateModel(id: 0, name: "Texas", code: "TA", countryId: 1),
      country: CountryModel(id: 0, name: 'Unites State', code: 'US', currencyName: '', currencySymbol: '')
  );

  CustomerModel customer = CustomerModel(
    id: 1,
    fullName: "Test Customer",
    address: AddressModel(
      id: 1,
      address: "New york, USA",
    )
  );

  List<PhoneModel> phones = [
    PhoneModel(id: 0, number: '1234567890'),
    PhoneModel(id: 1, number: '1234567893'),
    PhoneModel(id: 2, number: '1234567894'),
  ];

  List<String> emails = [
    '1@gmail.com',
    '2@gmail.com',
  ];

  HoverUserModel hoverUser = HoverUserModel(
    id: 1,
    firstName: "Hover User",
  );

  HoverOrderFormParams params = HoverOrderFormParams(
      customer: customer,
      jobId: 100,
      hoverUser: hoverUser
  );

  HoverOrderFormService serviceWithParams = HoverOrderFormService(
      params: params, // contains additional data to be used by service
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  setUp(() {
    PhoneMasking.setUp();
    PhoneMasking.maskPhoneNumber("999");
  });

  group("In case there is no customer associated with job", () {

    group('HoverOrderFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.usersController.text, "");
        expect(service.deliverableController.text, "");
        expect(service.requestForController.text, "");
        expect(service.phoneController.text, "");
        expect(service.emailController.text, "");
        expect(service.addressController.text, "");
        expect(service.addressLineTwoController.text, "");
        expect(service.cityController.text, "");
        expect(service.stateController.text, "");
        expect(service.zipCodeController.text, "");
        expect(service.countryController.text, "");
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.withCaptureRequest, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.allStates, isEmpty);
        expect(service.allCountries, isEmpty);
        expect(service.customerPhones, isEmpty);
        expect(service.customerEmails, isEmpty);
        expect(service.hoverDeliverables.length, 3);
        expect(service.requestForType.length, 2);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.selectedHoverDeliverableId, isEmpty);
        expect(service.selectedHoverUserId, isEmpty);
        expect(service.requestForTypeId, isEmpty);
        expect(service.selectedStateId, isEmpty);
        expect(service.selectedPhoneId, isEmpty);
        expect(service.selectedEmailId, isEmpty);
        expect(service.selectedCountryId, isEmpty);
        expect(service.customer, isNull);
        expect(service.jobId, isNull);
        expect(service.jobHoverUser, isNull);
      });
    });

    test('HoverOrderFormService@setFormData() should set-up form values', () {
      service.setFormData();
      expect(service.selectedHoverDeliverableId, service.hoverDeliverables.first.id);
      expect(service.deliverableController.text, service.hoverDeliverables.first.label);
      expect(service.requestForTypeId, service.requestForType.first.id);
    });

    test('HoverOrderFormService@hoverFormJson() should generate json from form-data', () {
      final currentJson = service.hoverFormJson();
      expect(service.initialJson, currentJson);
    });

    group('HoverOrderFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      String initialSelectedUserId = service.selectedHoverUserId;

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.selectedHoverUserId = hoverUser.id.toString();
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.selectedHoverUserId = initialSelectedUserId;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('HoverOrderFormService@updateHoverRequest should switch order form request', () {

      test('When switched to capture request', () {
        service.updateHoverRequest(true);
        expect(service.withCaptureRequest, true);
      });

      test('When switched to capture request', () {
        service.updateHoverRequest(false);
        expect(service.withCaptureRequest, false);
      });

    });

    group('HoverOrderFormService@validateUser should validate hover user', () {

      test('Validation should fail when no user is selected', () {
        service.usersController.text = "";
        final val = service.validateUser(service.usersController.text);
        expect(val, 'hover_user_is_required'.tr);
      });

      test('Validation should pass when user is selected', () {
        service.usersController.text = hoverUser.firstName ?? "";
        final val = service.validateUser(service.usersController.text);
        expect(val, isNull);
      });

    });

    group('HoverOrderFormService@validateDeliverable should validate hover deliverable', () {

      test('Validation should fail when no deliverable is selected', () {
        service.deliverableController.text = "";
        final val = service.validateDeliverable(service.deliverableController.text);
        expect(val, 'hover_deliverable_is_required'.tr);
      });

      test('Validation should pass when deliverable is selected', () {
        service.deliverableController.text = service.hoverDeliverables.first.label;
        final val = service.validateDeliverable(service.usersController.text);
        expect(val, isNull);
      });

    });

    group('HoverOrderFormService@validateRequestFor should validate hover request for', () {

      test('Validation should fail when request for is empty', () {
        service.requestForController.text = "";
        final val = service.validateRequestFor(service.requestForController.text);
        expect(val, 'request_for_is_required'.tr);
      });

      test('Validation should pass when request for is not empty', () {
        service.requestForController.text = hoverUser.firstName ?? "";
        final val = service.validateRequestFor(service.usersController.text);
        expect(val, isNull);
      });

    });

    group('HoverOrderFormService@validateEmail should validate phone number', () {

      test('Validation should fail when phone number is empty', () {
        service.phoneController.text = "";
        final val = service.validatePhoneNumber(service.phoneController.text);
        expect(val, 'phone_number_is_required'.tr);
      });

      test('Validation should fail when phone number is not properly filled', () {
        service.phoneController.text = "123";
        final val = service.validatePhoneNumber(service.phoneController.text);
        expect(val, 'phone_number_must_be_between_range'.tr);
      });

      test('Validation should pass when phone number properly filled', () {
        service.phoneController.text = "1234567890";
        final val = service.validatePhoneNumber(service.phoneController.text);
        expect(val, isNull);
      });

    });

    group('HoverOrderFormService@validatePhoneNumber should validate email address', () {

      test('Validation should fail when email is empty', () {
        service.emailController.text = "";
        final val = service.validateEmail(service.emailController.text);
        expect(val, 'email_is_required'.tr);
      });

      test('Validation should fail when email is incorrect', () {
        service.emailController.text = "123";
        final val = service.validateEmail(service.emailController.text);
        expect(val, 'please_enter_valid_email'.tr);
      });

      test('Validation should pass when email is correct', () {
        service.emailController.text = "test@gmail.com";
        final val = service.validateEmail(service.emailController.text);
        expect(val, isNull);
      });

    });

    group('HoverOrderFormService@validateAddress should validate address', () {

      test('Validation should fail when address is empty', () {
        service.addressController.text = "";
        final val = service.validateAddress(service.addressController.text);
        expect(val, 'address_is_required'.tr);
      });

      test('Validation should pass when address is filled', () {
        service.addressController.text = customer.address!.address!;
        final val = service.validateAddress(service.addressController.text);
        expect(val, isNull);
      });

    });

  });

  group("In case there is customer associated with job", () {

    group('HoverOrderFormService@setFormData() should set-up form values', () {

      test("When customer contains limited details", () {
        service = serviceWithParams;
        service.setFormData();
        expect(service.selectedHoverDeliverableId, service.hoverDeliverables.first.id);
        expect(service.deliverableController.text, service.hoverDeliverables.first.label);
        expect(service.requestForTypeId, service.requestForType.first.id);
        expect(service.requestForController.text, customer.fullName);
      });

      group("Phone field should be filled", () {

        test("With empty string if customer doesn't have phone numbers", () {
          service.setFormData();
          expect(service.phoneController.text, isEmpty);
        });

        test("With first customer phone number if exists", () {
          service.customer?.phones = phones;
          service.setFormData();
          expect(service.customerPhones, isNotEmpty);
          expect(service.phoneController.text, PhoneMasking.maskPhoneNumber(phones.first.number.toString()));
        });
      });

      group("Email field should be filled", () {

        test("With empty string if customer doesn't have email", () {
          service.setFormData();
          expect(service.emailController.text, isEmpty);
        });

        test("With first email if exists", () {
          service.customer?.additionalEmails = emails;
          service.setFormData();
          expect(service.customerEmails, isNotEmpty);
          expect(service.emailController.text, service.emailController.text);
        });
      });

      test("Address fields should be filled with customer address", () {
        service.customer?.address = address;
        service.setFormData();
        expect(service.addressController.text, address.address);
        expect(service.addressLineTwoController.text, address.addressLine1);
        expect(service.stateController.text, address.state?.name);
        expect(service.countryController.text, address.country?.name);
        expect(service.zipCodeController.text, address.zip);
        expect(service.cityController.text, address.city);
      });

      group("HoverOrderFormService@updateRequestFor should update request for and it's associated data", () {

        test("When request is for 'other' type", () {
          service.updateRequestFor('other');
          expect(service.requestForController.text, isEmpty);
          expect(service.phoneController.text, isEmpty);
          expect(service.emailController.text, isEmpty);
        });

        test("When request is for 'customer' type", () {
          service.updateRequestFor('customer');
          expect(service.requestForController.text, customer.fullName);
          expect(service.phoneController.text, PhoneMasking.maskPhoneNumber(phones.first.number.toString()));
          expect(service.emailController.text, emails.first);
        });
      });

    });
  });

}
