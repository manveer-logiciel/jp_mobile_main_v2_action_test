import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';

void main() {
  group("PhoneConsentModel@toPhoneModel should convert consent model to phone model", () {
    test("Nullable values should be handled correctly", () {
      final consentModel = PhoneConsentModel();
      final phoneModel = consentModel.toPhoneModel();
      expect(phoneModel?.number, isNull);
      expect(phoneModel?.consentStatus, isNull);
      expect(phoneModel?.consentEmail, isNull);
      expect(phoneModel?.consentCreatedAt, isNull);
    });

    test("Phone model should be created correctly with valid data", () {
      final consentModel = PhoneConsentModel(
        phoneNumber: '1234567890',
        status: ConsentStatusConstants.optedIn,
        email: 'a@example.com',
        createdAt: '2022-01-01 00:00:00'
      );
      final phoneModel = consentModel.toPhoneModel();
      expect(phoneModel?.number, '1234567890');
      expect(phoneModel?.consentStatus, ConsentStatusConstants.optedIn);
      expect(phoneModel?.consentEmail, consentModel.email);
      expect(phoneModel?.consentCreatedAt, consentModel.createdAt);
    });

    group("Consent status should override conditionally", () {
      test("Consent status should not be overridden if consent status is other than (Promotional Pending)", () {
        final consentModel = PhoneConsentModel(
          status: ConsentStatusConstants.optedIn,
        );
        final phoneModel = consentModel.toPhoneModel();
        expect(phoneModel?.consentStatus, ConsentStatusConstants.optedIn);
      });
    });

    test("Consent status should not be overridden if consent status is (Promotional Pending) and requested less than 48 hour ago", () {
      final consentModel = PhoneConsentModel(
        status: ConsentStatusConstants.expressOptInPending,
      );
      final phoneModel = consentModel.toPhoneModel();
      expect(phoneModel?.consentStatus, ConsentStatusConstants.expressOptInPending);
    });

    test("Consent status should be overridden if consent status is (Promotional Pending) and requested more than 48 hour ago", () {
      final consentModel = PhoneConsentModel(
        status: ConsentStatusConstants.expressOptInPending,
        createdAt: '2022-01-01 00:00:00'
      );
      final phoneModel = consentModel.toPhoneModel();
      expect(phoneModel?.consentStatus, ConsentStatusConstants.resend);
    });
  });
}