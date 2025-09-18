import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';

void main() {
  group("FilesListingService@haveConsent should decide whether 'Send Via Leap' action is to be enabled or disabled", () {
    group("In case of Transactional/Promotional messaging", () {
      setUp(() {
        LDFlags.transactionalMessaging.value = true;
      });

      test("In case Consent Status is not available, option should not be disabled", () {
        expect(FilesListingService.haveConsent(null), isTrue);
      });

      group("In case consent status is available", () {
        test("In case consent status is ${ConsentStatusConstants.byPass}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.byPass, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.optedIn}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.optedIn, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.expressConsent}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.expressConsent, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.expressOptInPending}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.expressOptInPending, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.resend}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.resend, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.expressOptInPending}, option should not be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.expressOptInPending, overrideConsentStatus: false), isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.optedOut}, option should be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.optedOut, overrideConsentStatus: false), isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.pending}, option should be disabled", () {
          expect(FilesListingService.haveConsent(ConsentStatusConstants.pending, overrideConsentStatus: false), isFalse);
        });
      });
    });

    group("In case of default Consent messaging", () {
      setUp(() {
        LDFlags.transactionalMessaging.value = false;
      });

      test("In case consent status is ${ConsentStatusConstants.byPass}, option not should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.byPass, overrideConsentStatus: false), isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.optedIn}, option not should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.optedIn, overrideConsentStatus: false), isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.optedOut}, option should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.optedOut, overrideConsentStatus: false), isFalse);
      });

      test("In case consent status is ${ConsentStatusConstants.pending}, option should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.pending, overrideConsentStatus: false), isFalse);
      });

      test("In case consent status is ${ConsentStatusConstants.resend}, option should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.resend, overrideConsentStatus: false), isFalse);
      });

      test("In case consent status is ${ConsentStatusConstants.expressOptInPending}, option should be disabled", () {
        expect(FilesListingService.haveConsent(ConsentStatusConstants.expressOptInPending, overrideConsentStatus: false), isFalse);
      });
    });
  });

  group("FilesListingService@sendViaTextOptions should show enabled/disabled 'Send Via Leap' action", () {
    group("In case of Transactional/Promotional messaging", () {
        setUp(() {
          LDFlags.transactionalMessaging.value = true;
        });

        test("In case consent status is ${ConsentStatusConstants.byPass}, option not should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
              consentStatus: ConsentStatusConstants.byPass,
              overrideConsentStatus: false,
          );
          expect(actions[1].disable, isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.optedIn}, option not should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
              consentStatus: ConsentStatusConstants.optedIn,
              overrideConsentStatus: false,
          );
          expect(actions[1].disable, isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.expressConsent}, option not should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.expressConsent,
            overrideConsentStatus: false,
          );
          expect(actions[1].disable, isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.expressOptInPending}, option not should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.expressOptInPending,
            overrideConsentStatus: false,
          );
          expect(actions[1].disable, isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.pending}, option should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.pending,
            overrideConsentStatus: false,
          );
          expect(actions[1].disable, isTrue);
        });

        test("In case consent status is ${ConsentStatusConstants.resend}, option should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.resend,
            overrideConsentStatus: false,
          );
          expect(actions[1].disable, isFalse);
        });

        test("In case consent status is ${ConsentStatusConstants.optedOut}, option should be disabled", () {
          final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.optedOut,
            overrideConsentStatus: false,
          );
          expect(actions[1].disable, isTrue);
        });
      });

    group("In case of Non Transactional messaging", () {
      setUp(() {
        LDFlags.transactionalMessaging.value = false;
      });

      test("In case consent status is ${ConsentStatusConstants.byPass}, option not should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.byPass,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isFalse);
      });

      test("In case consent status is ${ConsentStatusConstants.optedIn}, option not should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.optedIn,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isFalse);
      });

      test("In case consent status is ${ConsentStatusConstants.expressConsent}, option not should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.expressConsent,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.expressOptInPending}, option not should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
            consentStatus: ConsentStatusConstants.expressOptInPending,
            overrideConsentStatus: false
        );
        expect(actions[1].disable, isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.pending}, option should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.pending,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.resend}, option should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.resend,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isTrue);
      });

      test("In case consent status is ${ConsentStatusConstants.optedOut}, option should be disabled", () {
        final actions = FilesListingService.sendViaTextOptions(
          consentStatus: ConsentStatusConstants.optedOut,
          overrideConsentStatus: false,
        );
        expect(actions[1].disable, isTrue);
      });
    });
  });
  
  group("FilesListingService.doShowModuleName modules name should decide whether to display module name or not", () {
    test("Module name should be displayed for Contracts", () {
      expect(FilesListingService.doShowModuleName(FLModule.jobContracts), isTrue);
    });
  });
}