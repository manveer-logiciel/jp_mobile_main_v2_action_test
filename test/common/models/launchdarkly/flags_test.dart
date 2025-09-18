import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';

void main() {
  group('LaunchDarkly Flags Configuration - Mobile Maps SDK Feature Flag Implementation', () {
    group('New Feature Flag Definition - use-mobile-maps-sdk Flag Validation', () {
      test('use-mobile-maps-sdk flag should be defined in allFlags with correct properties', () {
        // Test that the new flag is properly defined
        expect(LDFlags.allFlags.containsKey(LDFlagKeyConstants.useMobileMapsSdk), true);

        final flag = LDFlags.allFlags[LDFlagKeyConstants.useMobileMapsSdk];
        expect(flag, isNotNull);
        expect(flag?.key, LDFlagKeyConstants.useMobileMapsSdk);
        expect(flag?.defaultValue, true); // Default should be true (use SDK)
      });

      test('use-mobile-maps-sdk flag key constant should match expected string value', () {
        // Test that the flag key constant is properly defined
        expect(LDFlagKeyConstants.useMobileMapsSdk, 'use-mobile-maps-sdk');
      });

      test('use-mobile-maps-sdk flag should be boolean type with correct default', () {
        final flag = LDFlags.allFlags[LDFlagKeyConstants.useMobileMapsSdk];
        expect(flag?.defaultValue, isA<bool>());
      });

      test('use-mobile-maps-sdk flag should have correct properties for mobile SDK switching', () {
        final flag = LDFlags.allFlags[LDFlagKeyConstants.useMobileMapsSdk];

        expect(flag?.key, LDFlagKeyConstants.useMobileMapsSdk);
        expect(flag?.defaultValue, true);
        expect(flag?.type.toString(), contains('boolean')); // LDValueType.boolean
      });
    });

    group('Flag Registry Completeness - All Expected Flags Present in allFlags Map', () {
      test('all flags should contain essential flags including new use-mobile-maps-sdk flag', () {
        // Test that allFlags contains all expected flags (only ones actually defined)
        final expectedFlags = [
          LDFlagKeyConstants.testStaffCalendar,
          LDFlagKeyConstants.testStaffCalendarButtonText,
          LDFlagKeyConstants.transactionalMessaging,
          LDFlagKeyConstants.metroBathFeature,
          LDFlagKeyConstants.userLocationTracking,
          LDFlagKeyConstants.userLocationsTrackingPollingInterval,
          LDFlagKeyConstants.srsV2MaterialIntegration,
          LDFlagKeyConstants.salesProForEstimate,
          LDFlagKeyConstants.abcMaterialIntegration,
          LDFlagKeyConstants.leapPayFeePassOver,
          LDFlagKeyConstants.leapPayWithDivision,
          LDFlagKeyConstants.jobCanvaser,
          LDFlagKeyConstants.workflowAutomationLogs,
          LDFlagKeyConstants.allowMultipleLanguages,
          LDFlagKeyConstants.useMobileMapsSdk, // Our new flag
        ];

        for (final flagKey in expectedFlags) {
          expect(LDFlags.allFlags.containsKey(flagKey), true, reason: 'Flag $flagKey should be defined in allFlags');
        }
      });
    });
  });
}
