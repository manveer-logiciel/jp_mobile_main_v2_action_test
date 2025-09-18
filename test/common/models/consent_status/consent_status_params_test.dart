import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';

void main() {
  test("ConsentStatusParams default values should be set correctly", ()  {
    final params = ConsentStatusParams();
    expect(params.phoneConsentDetail, null);
    expect(params.padding, null);
    expect(params.email, null);
    expect(params.additionalEmails, null);
    expect(params.customerId, null);
    expect(params.contactPersonId, null);
    expect(params.updateScreen, null);
    expect(params.isComposeMessage, false);
    expect(params.isLoadingMeta, false);
    expect(params.onConsentChanged, null);
    expect(params.customer, null);
    expect(params.job, null);
    expect(params.contact, null);
  });

  group("ConsentStatusParams should update observable consent status on initialization", () {
    test("Observable consent status should be initialized if phone consent status is available", () {
      final params = ConsentStatusParams(
        phoneConsentDetail: PhoneModel(
          number: '1234567890',
          consentStatus: ConsentStatusConstants.optedIn
        )
      );

      expect(params.phoneConsentDetail?.consentStatusObs.value, ConsentStatusConstants.optedIn);
    });

    test("Observable consent status should be null if phone consent is not available", () {
      final params = ConsentStatusParams(
          phoneConsentDetail: null
      );

      expect(params.phoneConsentDetail?.consentStatusObs.value, null);
    });

    test("Observable consent status should be empty if phone consent status is not available", () {
      final params = ConsentStatusParams(
          phoneConsentDetail: PhoneModel(
              number: '1234567890',
          )
      );

      expect(params.phoneConsentDetail?.consentStatusObs.value, "");
    });
  });

  group("ConsentStatusParams setToolTip method for tooltip interaction flag management", () {
    test("should correctly set isToolTip flag to true when enabling tooltip mode", () {
      // Arrange
      final params = ConsentStatusParams();

      // Act
      params.setToolTip(true);

      // Assert
      expect(params.isToolTip, true);
    });

    test("should correctly set isToolTip flag to false when disabling tooltip mode", () {
      // Arrange - Start with tooltip mode enabled
      final params = ConsentStatusParams(isToolTip: true);

      // Act - Disable tooltip mode
      params.setToolTip(false);

      // Assert
      expect(params.isToolTip, false);
    });

    test("should initialize with isToolTip flag set to false by default", () {
      // Arrange and Act - Create params with default constructor
      final params = ConsentStatusParams();

      // Assert - Default should be false
      expect(params.isToolTip, false, reason: 'isToolTip should default to false when not explicitly specified');
    });

    test("should honor the isToolTip value provided in the constructor", () {
      // Arrange and Act - Create params with explicit isToolTip value
      final params = ConsentStatusParams(isToolTip: true);

      // Assert - Should use the provided value
      expect(params.isToolTip, true, reason: 'isToolTip should be set to the value provided in the constructor');
    });
  });
}
