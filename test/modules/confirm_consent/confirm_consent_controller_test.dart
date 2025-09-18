import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/modules/confirm_consent/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = ConfirmConsentController();

  setUpAll(() {
    controller.phone = PhoneModel(number: "8888888888");
    controller.customer = CustomerModel(id: 12345, fullName: 'Test Customer');
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  group('In case of obtain consent', () {
    test('ConfirmConsentController should be initialized with correct values', () {
      expect(controller.isSavingForm, isFalse);
      expect(controller.customerName, equals("Test Customer"));
      expect(controller.selectedConsent, isEmpty);
      expect(controller.isEdit, isFalse);
    });

    group("ConfirmConsentController@customerName should be filled with correct value", () {
      test("When data of contact person is available then customer name should be contact persons name ", () {
        controller.contactPerson = CompanyContactListingModel(id: 123, fullName: "Contact Person");
        expect(controller.customerName, equals("Contact Person"));
      });

      test("When contact person is not available and customer info is available then customer name should be customers name", () {
        controller.contactPerson = null;
        controller.customer = CustomerModel(id: 12345, fullName: 'Customer Name');
        expect(controller.customerName, equals("Customer Name"));
      });

      test("When info related to contact person and customer is not available but have information related to job then customers name should be jobs customer name", () {
        controller.contactPerson = null;
        controller.customer = null;
        controller.job = JobModel(id: 1, customerId: 12, customer: CustomerModel(id: 12, fullName: 'Jobs Customer Name'));
        expect(controller.customerName, equals('Jobs Customer Name'));
      });

      test('When information related to contact person, customer and job is not available then customer name should be null', () {
        controller.contactPerson = null;
        controller.customer = null;
        controller.job = null;
        expect(controller.customerName, isNull);
      });

      test('When information related to contact person, customer and job is available then customer name should be contact persons name', () {
        controller.contactPerson = CompanyContactListingModel(id: 123, fullName: "Contact Person");
        controller.customer = CustomerModel(id: 12345, fullName: 'Customer Name');
        controller.job = JobModel(id: 1, customerId: 12, customer: CustomerModel(id: 12, fullName: 'Jobs Customer Name'));
        expect(controller.customerName, equals("Contact Person"));
      });

      test('When information related to customer and job is available then customer name should be customers name', () {
        controller.contactPerson = null;
        controller.customer = CustomerModel(id: 12345, fullName: 'Customer Name');
        controller.job = JobModel(id: 1, customerId: 12, customer: CustomerModel(id: 12, fullName: 'Jobs Customer Name'));
        expect(controller.customerName, equals("Customer Name"));
      });
    });

    group("ConfirmConsentController@updateSelectedConsent should update selected consent type", () {
      test("When no-messaging is selected", () {
        controller.updateSelectedConsent(ConsentStatusConstants.noMessage);
        expect(controller.selectedConsent, equals(ConsentStatusConstants.noMessage));
      });
      test("When transactional-messaging is selected", () {
        controller.updateSelectedConsent(ConsentStatusConstants.transactionalMessage);
        expect(controller.selectedConsent, equals(ConsentStatusConstants.transactionalMessage));
      });
      test("When promotional-messaging is selected", () {
        controller.updateSelectedConsent(ConsentStatusConstants.promotionalMessage);
        expect(controller.selectedConsent, equals(ConsentStatusConstants.promotionalMessage));
      });
    });
  });

  group("In case of edit obtained consent", () {

    test('ConfirmConsentController should be initialized with correct values when no-messaging consent is obtained', () {
      controller.phone = PhoneModel(number: "8888888888");
      controller.customer = CustomerModel(id: 12345, fullName: 'Test Customer');
      controller.previouslySelectedConsent = ConsentStatusConstants.noMessage;
      controller.loadData();

      expect(controller.isSavingForm, isFalse);
      expect(controller.customerName, equals("Test Customer"));
      expect(controller.previouslySelectedConsent, equals(ConsentStatusConstants.noMessage));
      expect(controller.selectedConsent, equals(ConsentStatusConstants.noMessage));
      expect(controller.isEdit, isTrue);
    });

    test('ConfirmConsentController should be initialized with correct values when transactional-messaging consent is obtained', () {
      controller.previouslySelectedConsent = ConsentStatusConstants.transactionalMessage;
      controller.loadData();

      expect(controller.isSavingForm, isFalse);
      expect(controller.customerName, equals("Test Customer"));
      expect(controller.previouslySelectedConsent, equals(ConsentStatusConstants.transactionalMessage));
      expect(controller.selectedConsent, equals(ConsentStatusConstants.transactionalMessage));
      expect(controller.isEdit, isTrue);
    });

    test('ConfirmConsentController should be initialized with correct values when promotional-messaging consent is obtained', () {
      controller.previouslySelectedConsent = ConsentStatusConstants.promotionalMessage;
      controller.loadData();

      expect(controller.isSavingForm, isFalse);
      expect(controller.customerName, equals("Test Customer"));
      expect(controller.previouslySelectedConsent, equals(ConsentStatusConstants.promotionalMessage));
      expect(controller.selectedConsent, equals(ConsentStatusConstants.promotionalMessage));
      expect(controller.isEdit, isTrue);
    });
  });
}