import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/core/utils/message_send_helper.dart';
import 'package:jobprogress/global_widgets/consent_status/index.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  Widget baseWidget({VoidCallback? onTap}) {
    return TestHelper.buildWidget(
      JPButton(
        onPressed: onTap,
      )
    );
  }

  testWidgets('Message actions bottom should be opened correctly', (WidgetTester tester) async {
    await tester.pumpWidget(baseWidget(
      onTap: () {
        SaveMessageSendHelper().saveMessageLogs("12345");
      },
    ));
    await tester.pumpAndSettle();
    final buttonFinder = find.byType(JPButton);
    expect(buttonFinder, findsOneWidget);

    await tester.tap(buttonFinder);
    await tester.pumpAndSettle();

    final bottomSheetFinder = find.byType(JPQuickAction);
    expect(bottomSheetFinder, findsOneWidget);
  });

  group("Consent Banner should be displayed conditionally in Message Quick Actions", () {
    testWidgets('Consent Banner should not be displayed when Consent details are not available', (WidgetTester tester) async {
      await tester.pumpWidget(baseWidget(
        onTap: () {
          SaveMessageSendHelper().saveMessageLogs("12345");
        },
      ));
      await tester.pumpAndSettle();
      final buttonFinder = find.byType(JPButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      final bottomSheetFinder = find.byType(JPQuickAction);
      expect(bottomSheetFinder, findsOneWidget);

      final consentBannerFinder = tester.widget<JPQuickAction>(bottomSheetFinder);
      expect(consentBannerFinder.subHeader, isNull);
    });

    testWidgets('Consent Banner should be displayed when Consent details are available', (WidgetTester tester) async {
      await tester.pumpWidget(baseWidget(
        onTap: () {
          SaveMessageSendHelper().saveMessageLogs("12345", phoneModel: PhoneModel(
              number: '12345',
              consentStatus: ConsentStatusConstants.optedIn,
            ),
          );
        },
      ));
      await tester.pumpAndSettle();
      final buttonFinder = find.byType(JPButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      final bottomSheetFinder = find.byType(JPQuickAction);
      expect(bottomSheetFinder, findsOneWidget);

      final consentBannerFinder = find.byType(ConsentStatus);
      expect(consentBannerFinder, findsOneWidget);
    });

    testWidgets('Consent Details should be updated on edited', (WidgetTester tester) async {
      final phoneModel = PhoneModel(
        number: '12345',
        consentStatus: ConsentStatusConstants.optedIn,
      );

      await tester.pumpWidget(baseWidget(
        onTap: () {
          SaveMessageSendHelper().saveMessageLogs("12345", phoneModel: phoneModel);
        },
      ));
      await tester.pumpAndSettle();
      final buttonFinder = find.byType(JPButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      final bottomSheetFinder = find.byType(JPQuickAction);
      expect(bottomSheetFinder, findsOneWidget);

      final consentBannerFinder = find.byType(ConsentStatus);
      expect(consentBannerFinder, findsOneWidget);

      final consentParams = tester.widget<ConsentStatus>(consentBannerFinder).params;
      consentParams?.onConsentChanged?.call(ConsentStatusConstants.optedOut);

      await tester.pumpAndSettle();
      expect(phoneModel.consentStatus, ConsentStatusConstants.optedOut);
    });
  });
}