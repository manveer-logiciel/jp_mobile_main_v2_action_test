import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';

void main() {
  test("PhoneModel@consentStatusObs should be initialized correctly", () {
    final phone = PhoneModel(number: '');
    expect(phone.consentStatusObs.value, "");
  });

  group("PhoneModel@setObsConsentStatus should set observable consent status", () {
    test("Observable consent status should be set if phone consent status is available", () {
      final phone = PhoneModel(number: '1234567890', consentStatus: ConsentStatusConstants.optedIn);
      phone.setObsConsentStatus();
      expect(phone.consentStatusObs.value, ConsentStatusConstants.optedIn);
    });

    test("Observable consent status should be empty if phone consent status is not available", () {
      final phone = PhoneModel(number: '1234567890', consentStatus: null);
      phone.setObsConsentStatus();
      expect(phone.consentStatusObs.value, '');
    });
  });
}