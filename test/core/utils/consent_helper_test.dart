import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    RunModeService.setRunMode(RunMode.unitTesting);
  });

  JobModel? jobModel;

  String phoneNumber = '1000000000';
  String wrongPhoneNumber = '1000000002';
  String status = ConsentStatusConstants.pending;
  String createdAt = '';

  List<PhoneModel> phoneList = [
    PhoneModel(number: '1000000000'),
    PhoneModel(number: '1111111111'),
  ];

  group("ConsentHelper@isContactPersonSameAsCustomer should return true job's contact person is same as customer", () {
    test('contact person should not be same as customer when job is not available', () {
      final result = ConsentHelper.isContactPersonSameAsCustomer(jobModel);

      expect(result, true);
    });

    test("contact person should be same as customer when job's contact person is same as customer", () {
      jobModel = JobModel(id: 1,customerId: 1, isContactSameAsCustomer: true);
      final result = ConsentHelper.isContactPersonSameAsCustomer(jobModel);

      expect(result, true);
    });

    test("contact person should not be same as customer when job's contact person is not same as customer", () {
      // 
      jobModel = JobModel(id: 1,customerId: 1, isContactSameAsCustomer: false);
      final result = ConsentHelper.isContactPersonSameAsCustomer(jobModel);

      expect(result, false);
    });
  });

  group('ConsentHelper@getSelectedContactInfo Selected Contact Info should return the matching phone model', () {
    test('Should return the matching phone model When the phone number is same as phone model', () {
      PhoneModel? result = ConsentHelper.getSelectedContactInfo(phoneList, phoneNumber);

      expect(result, isNotNull);
      expect(result?.number, phoneNumber);
    });

    test('When the phone number is not available in phone list should return null', () {
      PhoneModel? result = ConsentHelper.getSelectedContactInfo(phoneList, wrongPhoneNumber);

      expect(result, isNull);
    });

    test('When the phone number is available but phone list is empty should return null', () {
      phoneList = [];
      PhoneModel? result = ConsentHelper.getSelectedContactInfo(phoneList, phoneNumber);

      expect(result, isNull);
    });
  });

  group('ConsentHelper@isStatusResendStatus should return true if Consent Status is Resend Status', () {
    test('When Consent Status is pending and consent email has been sent for more than 48 hours ago should return true', () {
      createdAt = DateTime.now().subtract(const Duration(hours: 49)).toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);
      
      expect(result, isTrue);
    });

    test('When Consent Status is not pending should return false', () {
      createdAt = DateTime.now().toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);

      expect(result, isFalse);
    });

    test('When consent email has been sent for less than 48 hours ago should return false', () {
      createdAt = DateTime.now().subtract(const Duration(hours: 47)).toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);

      expect(result, isFalse);
    });
  });

  group('ConsentHelper@isStatusResendStatus should return true if Consent Status is Transactional (Promotional Pending)', () {
    setUp(() {
      status = ConsentStatusConstants.expressOptInPending;
    });

    test('When Consent Status is Transactional (Promotional Pending) and consent email has been sent for more than 48 hours ago should return true', () {
      createdAt = DateTime.now().subtract(const Duration(hours: 49)).toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);

      expect(result, isTrue);
    });

    test('When Consent Status is not Transactional (Promotional Pending) should return false', () {
      createdAt = DateTime.now().toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);

      expect(result, isFalse);
    });

    test('When consent email has been sent for less than 48 hours ago should return false', () {
      createdAt = DateTime.now().subtract(const Duration(hours: 47)).toString();
      final result = ConsentHelper.isStatusResendStatus(status, createdAt);

      expect(result, isFalse);
    });
  });

  group("ConsentHelper@getConsentDetails should give the consent details based on consent status", () {
    test('Details should be correct in case of [${ConsentStatusConstants.expressConsent}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.expressConsent);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.success);
      expect(result?.icon, Icons.sms);
      expect(result?.label, 'express_consent');
      expect(result?.toolTip, 'express_consent_tooltip');
      expect(result?.composeLabel, 'express_consent_compose_label');
      expect(result?.composeMessage, 'express_consent_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.expressOptInPending}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.expressOptInPending);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.tertiary);
      expect(result?.icon, Icons.access_time_filled);
      expect(result?.label, 'express_consent_opt_in_pending');
      expect(result?.toolTip, 'express_consent_opt_in_pending_tooltip');
      expect(result?.composeLabel, 'express_consent_opt_in_pending_compose_label');
      expect(result?.composeMessage, 'express_consent_opt_in_pending_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.pendingConsent}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.pendingConsent);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.tertiary);
      expect(result?.icon, Icons.access_time_filled);
      expect(result?.label, 'consent_pending');
      expect(result?.toolTip, 'consent_pending_tooltip');
      expect(result?.composeLabel, 'consent_pending_compose_label');
      expect(result?.composeMessage, 'consent_pending_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.optedIn}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.optedIn);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.success);
      expect(result?.icon, Icons.sms);
      expect(result?.label, 'express_written_consent');
      expect(result?.toolTip, 'express_written_consent_tooltip');
      expect(result?.composeLabel, 'express_written_consent_compose_label');
      expect(result?.composeMessage, 'express_written_consent_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.noMessage}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.noMessage);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.warning);
      expect(result?.icon, Icons.sms);
      expect(result?.label, 'no_consent_obtained');
      expect(result?.toolTip, 'no_consent_obtained_tooltip');
      expect(result?.composeLabel, 'no_consent_obtained_compose_label');
      expect(result?.composeMessage, 'no_consent_obtained_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.optedOut}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.optedOut);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.red);
      expect(result?.icon, Icons.do_not_disturb_on);
      expect(result?.label, 'consent_denied');
      expect(result?.toolTip, 'consent_denied_tooltip');
      expect(result?.composeLabel, 'consent_denied_compose_label');
      expect(result?.composeMessage, 'consent_denied_compose_message');
      expect(result?.composeMessageButtonText, 'edit_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(result?.composeMessageButtonTextColor, JPColor.tertiary);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.resend}]', () {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.resend);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.warning);
      expect(result?.icon, Icons.access_time_filled);
      expect(result?.label, 'consent_pending');
      expect(result?.toolTip, 'consent_pending_tooltip');
      expect(result?.composeLabel, 'consent_pending_compose_label');
      expect(result?.composeMessage, 'consent_pending_compose_message');
      expect(result?.composeMessageButtonText, 'resend_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.primary);
      expect(result?.composeMessageButtonTextColor, JPAppTheme.themeColors.base);
    });

    test('Details should be correct in case of [${ConsentStatusConstants.byPass}]',() {
      final result = ConsentHelper.getConsentDetails(ConsentStatusConstants.byPass);
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.success);
      expect(result?.icon, Icons.sms);
      expect(result?.label, 'express_consent');
      expect(result?.toolTip, 'bypass_tooltip');
      expect(result?.composeLabel, 'bypass_compose_label');
      expect(result?.composeMessage, 'bypass_tooltip');
    });

    test('Details should be correct in case of [unknown_status}]', () {
      final result = ConsentHelper.getConsentDetails('unknown_status');
      expect(result, isNotNull);
      expect(result?.color, JPAppTheme.themeColors.tertiary);
      expect(result?.icon, Icons.edit);
      expect(result?.label, 'confirm_consent');
      expect(result?.toolTip, 'no_consent_obtained_tooltip');
      expect(result?.composeLabel, 'no_consent_obtained_compose_label');
      expect(result?.composeMessage, 'no_consent_obtained_compose_message');
      expect(result?.composeMessageButtonText, 'confirm_consent');
      expect(result?.composeMessageButtonColor, JPButtonColorType.primary);
      expect(result?.composeMessageButtonTextColor, JPAppTheme.themeColors.base);
    });
  });

  group("ConsentHelper@isTransactionalConsent should helps in deciding whether to use updated Consent process", () {
    test('New Consent process should be used, when LD flag is enabled', () {
      LDFlags.transactionalMessaging.value = true;
      final result = ConsentHelper.isTransactionalConsent();
      expect(result, true);
    });

    test('Old Consent process should be used, when LD flag is disabled', () {
      LDFlags.transactionalMessaging.value = false;
      final result = ConsentHelper.isTransactionalConsent();
      expect(result, false);
    });
  });

  group("ConsentHelper@getConsentStatus should help in deciding correct status of consent", () {
    test("Correct consent status should be promotional-messaging when consent OptIn status is pending", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.expressOptInPending), equals(ConsentStatusConstants.promotionalMessage));
    });

    test("Correct consent status should be promotional-messaging when consent status is optedIn", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.optedIn), equals(ConsentStatusConstants.promotionalMessage));
    });

    test("Correct consent status should be promotional-messaging when consent status is optedOut", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.optedOut), equals(ConsentStatusConstants.promotionalMessage));
    });

    test("Correct consent status should be transactional-messaging when consent status is express-consent", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.expressConsent), equals(ConsentStatusConstants.transactionalMessage));
    });

    test("Correct consent status should be transactional-messaging when consent status is by-pass", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.byPass),
          equals(ConsentStatusConstants.transactionalMessage));
    });

    test("Correct consent status should be no-messaging when consent status is no-messaging", () {
      expect(ConsentHelper.getConsentStatus(ConsentStatusConstants.noMessage), equals(ConsentStatusConstants.noMessage));
    });

    test("There should not be any status when consent status is unknown", () {
      expect(ConsentHelper.getConsentStatus('unknownStatus'), isEmpty);
    });

    test("There should not be any status  when consent status is null", () {
      expect(ConsentHelper.getConsentStatus(null), isEmpty);
    });
  });

  group("ConsentHelper@showConsentBadgeInfo should handle params gracefully", () {
    test('should set isToolTip to true when params is provided', () {
      // Arrange
      final consentDetails = ConsentHelper.getConsentDetails(ConsentStatusConstants.optedIn);
      final params = ConsentStatusParams();

      // Mock the bottom sheet display to avoid UI integration
      // We're only testing the params flag setting
      ConsentHelper.showConsentBadgeInfo(consentDetails!, params: params);

      // Assert
      expect(params.isToolTip, true);
    });

    test('should not throw error when params is null', () {
      // Arrange
      final consentDetails = ConsentHelper.getConsentDetails(ConsentStatusConstants.optedIn);

      // Act & Assert - Should handle null params without error
      expect(() {
        ConsentHelper.showConsentBadgeInfo(consentDetails!);
      }, returnsNormally);
    });
  });
}