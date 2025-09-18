import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/consent_status/consent_status_params.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/default_consent_status.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/badge.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/banner.dart';
import 'package:jobprogress/global_widgets/consent_status/widgets/transactional_consent_status/index.dart';
import 'package:shimmer/shimmer.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  ConsentStatusParams params = ConsentStatusParams();

  Widget baseWidget({VoidCallback? onTap}) {
    return TestHelper.buildWidget(
        Material(
          child: ConsentStatus(params: params),
        )
    );
  }

  testWidgets("ConsentStatus widget should be rendered correctly", (widgetTester) async {
    await widgetTester.pumpWidget(baseWidget());
    await widgetTester.pumpAndSettle();
    expect(find.byType(ConsentStatus), findsOneWidget);
  });

  group("ConsentStatus widget should be rendered correctly with params", () {
    group("In case of using Transactional Consent Process", () {
      setUp(() {
        LDFlags.transactionalMessaging.value = true;
      });

      testWidgets("In case consent details are not available nothing should be rendered", (widgetTester) async {
        params = ConsentStatusParams(
          isComposeMessage: false,
        );
        await widgetTester.pumpWidget(baseWidget());
        await widgetTester.pumpAndSettle();

        expect(find.byType(TransactionalConsentStatusBanner), findsNothing);
        expect(find.byType(TransactionalConsentStatusBadge), findsNothing);
      });

      testWidgets("Edit Consent button should use edit icon", (widgetTester) async {
        params = ConsentStatusParams(
          isComposeMessage: true,
          phoneConsentDetail: PhoneModel(
            number: '1234567890',
            consentStatus: ConsentStatusConstants.expressConsent,
          ),
        );
        await widgetTester.pumpWidget(baseWidget());
        await widgetTester.pumpAndSettle();

        final editButtonIcon = find.byIcon(Icons.edit);
        expect(editButtonIcon, findsOneWidget);
      });

      group("In case consent details are available", () {
        testWidgets("Consent Banner should be rendered when [ConsentStatusParams.isComposeMessage] is true", (widgetTester) async {
          params = ConsentStatusParams(
            isComposeMessage: true,
            phoneConsentDetail: PhoneModel(number: '123'),
          );
          await widgetTester.pumpWidget(baseWidget());
          await widgetTester.pumpAndSettle();

          expect(find.byType(TransactionalConsentStatus), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBanner), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBadge), findsNothing);
        });

        testWidgets("Consent Badge should be rendered when [ConsentStatusParams.isComposeMessage] is false", (widgetTester) async {
          params = ConsentStatusParams(
            isComposeMessage: true,
            phoneConsentDetail: PhoneModel(number: '123'),
          );
          await widgetTester.pumpWidget(baseWidget());
          await widgetTester.pumpAndSettle();

          expect(find.byType(TransactionalConsentStatus), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBanner), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBadge), findsNothing);
        });

        testWidgets("Consent Badge should show shimmer when [ConsentStatusParams.isComposeMessage] is false and meta is loading", (widgetTester) async {
          params = ConsentStatusParams(
            isComposeMessage: true,
            isLoadingMeta: true,
            phoneConsentDetail: PhoneModel(number: '123'),
          );
          await widgetTester.pumpWidget(baseWidget());
          await widgetTester.pumpAndSettle();

          expect(find.byType(TransactionalConsentStatus), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBanner), findsOneWidget);
          expect(find.byType(TransactionalConsentStatusBadge), findsNothing);
          expect(find.byType(Shimmer), findsNothing);
        });
      });
    });

    testWidgets("In case of Default Consent Process, default consent status should be shown", (widgetTester) async {
      LDFlags.transactionalMessaging.value = false;

      params = ConsentStatusParams(
        isComposeMessage: false,
      );
      await widgetTester.pumpWidget(baseWidget());
      await widgetTester.pumpAndSettle();

      expect(find.byType(TransactionalConsentStatus), findsNothing);
      expect(find.byType(TransactionalConsentStatusBadge), findsNothing);
      expect(find.byType(TransactionalConsentStatusBanner), findsNothing);
      expect(find.byType(DefaultConsentStatus), findsOneWidget);
    });
  });
}