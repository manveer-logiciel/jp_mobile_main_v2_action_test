import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/device_info.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/modules/settings/controller.dart';
import 'package:jobprogress/modules/settings/widgets/device_settings.dart';
import 'package:jobprogress/modules/settings/widgets/language_settings.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  late SettingController controller;

  setUp(() {
    Get.testMode = true;
    controller = SettingController();
    controller.deviceInfo = DeviceInfo(
      deviceModel: 'Test Device',
      uuid: 'test-uuid',
      platform: 'iOS',
    );
    controller.selectedTimeZone = JPSingleSelectModel(id: '1', label: 'America/New_York');
    controller.selectedLanguage = JPSingleSelectModel(id: 'en_US', label: 'English');
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestWidget() {
    return GetMaterialApp(
      home: Scaffold(
        body: DeviceSettings(controller: controller),
      ),
      locale: const Locale('en', 'US'),
    );
  }

  group('LanguageSettings visibility based on LaunchDarkly flag', () {
    testWidgets('LanguageSettings should be visible when allowMultipleLanguages flag is enabled', (WidgetTester tester) async {
      // Set the flag to true using our mock
      LDFlags.allowMultipleLanguages.value = true;

      await tester.pumpWidget(buildTestWidget());
      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump();

      // LanguageSettings should be visible
      expect(find.byType(LanguageSettings), findsOneWidget);
    });

    testWidgets('LanguageSettings should not be visible when allowMultipleLanguages flag is disabled', (WidgetTester tester) async {
      // Set the flag to false using our mock
      LDFlags.allowMultipleLanguages.value = false;

      await tester.pumpWidget(buildTestWidget());
      // Use pump instead of pumpAndSettle to avoid timeout
      await tester.pump();

      // LanguageSettings should not be visible
      expect(find.byType(LanguageSettings), findsNothing);
    });
  });
}
