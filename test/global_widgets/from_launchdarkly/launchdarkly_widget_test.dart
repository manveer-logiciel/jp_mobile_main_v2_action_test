import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {
  UniqueKey widgetKey = UniqueKey();

  Widget buildFromLaunchDarklyWidget({
    required String flagKey,
    bool showHideOnly = true
  }) {
    return TestHelper.buildWidget(
      FromLaunchDarkly(
        flagKey: flagKey,
        showHideOnly: showHideOnly,
        child: (data) => JPText(
          key: widgetKey,
          text: "${data.value}",
        ),
      ),
    );
  }

  group("In case of boolean (on/off) feature flag", () {
    testWidgets('FromLaunchDarkly should display placeholder, if flag value is not known', (WidgetTester tester) async {
      final widget = buildFromLaunchDarklyWidget(flagKey: LDFlagKeyConstants.testStaffCalendar);
      await tester.pumpWidget(widget);

      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });

    group('FromLaunchDarkly should conditionally display widget, When flag value is known', () {
      testWidgets('FromLaunchDarkly widget should be displayed', (WidgetTester tester) async {
        LDService.ldFlagsStream.add(LDFlags.testStaffCalendar..value = true);
        final widget = buildFromLaunchDarklyWidget(flagKey: LDFlagKeyConstants.testStaffCalendar);
        await tester.pumpWidget(widget);

        expect(find.byType(FromLaunchDarkly), findsOneWidget);
        expect(find.byKey(widgetKey), findsOneWidget);
        expect(find.byType(SizedBox), findsNothing);
      });

      testWidgets('FromLaunchDarkly widget should not be displayed', (WidgetTester tester) async {
        LDService.ldFlagsStream.add(LDFlags.testStaffCalendar..value = false);
        final widget = buildFromLaunchDarklyWidget(flagKey: LDFlagKeyConstants.testStaffCalendar);
        await tester.pumpWidget(widget);

        expect(find.byType(FromLaunchDarkly), findsOneWidget);
        expect(find.byKey(widgetKey), findsNothing);
        expect(find.byType(SizedBox), findsOneWidget);
      });
    });

    testWidgets('FromLaunchDarkly should update (show/hide) in realtime', (WidgetTester tester) async {
      LDService.ldFlagsStream.add(LDFlags.testStaffCalendar..value = true);
      final widget = buildFromLaunchDarklyWidget(flagKey: LDFlagKeyConstants.testStaffCalendar);
      await tester.pumpWidget(widget);

      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);

      LDService.ldFlagsStream.add(LDFlags.testStaffCalendar..value = false);
      await tester.pump();

      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsNothing);
      expect(find.byType(SizedBox), findsOneWidget);
    });
  });

  group("In case of DATA feature flag", () {
    testWidgets('FromLaunchDarkly should not display placeholder, even if flag value is not known', (WidgetTester tester) async {
      final widget = buildFromLaunchDarklyWidget(
        flagKey: LDFlagKeyConstants.testStaffCalendarButtonText,
        showHideOnly: false,
      );
      await tester.pumpWidget(widget);

      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);
    });

    group('FromLaunchDarkly should always display widget, if flag value is known', () {
      testWidgets('FromLaunchDarkly widget should be displayed with default data', (WidgetTester tester) async {
        LDService.ldFlagsStream.add(LDFlags.testStaffCalendarButtonText..value = 'Text 1');
        final widget = buildFromLaunchDarklyWidget(
          flagKey: LDFlagKeyConstants.testStaffCalendarButtonText,
          showHideOnly: false,
        );
        await tester.pumpWidget(widget);

        final text = tester.widget<JPText>(find.byKey(widgetKey));
        expect(text.text, 'Text 1');

        expect(find.byType(FromLaunchDarkly), findsOneWidget);
        expect(find.byKey(widgetKey), findsOneWidget);
        expect(find.byType(SizedBox), findsNothing);
      });

      testWidgets('FromLaunchDarkly widget should be displayed with custom data', (WidgetTester tester) async {
        LDService.ldFlagsStream.add(LDFlags.testStaffCalendarButtonText..value = 'Text 2');
        final widget = buildFromLaunchDarklyWidget(
          flagKey: LDFlagKeyConstants.testStaffCalendarButtonText,
          showHideOnly: false,
        );
        await tester.pumpWidget(widget);

        final text = tester.widget<JPText>(find.byKey(widgetKey));
        expect(text.text, 'Text 2');
        expect(find.byType(FromLaunchDarkly), findsOneWidget);
        expect(find.byKey(widgetKey), findsOneWidget);
        expect(find.byType(SizedBox), findsNothing);
      });
    });

    testWidgets('FromLaunchDarkly should update (show/hide) in realtime', (WidgetTester tester) async {
      LDService.ldFlagsStream.add(LDFlags.testStaffCalendarButtonText..value = 'Text 1');
      final widget = buildFromLaunchDarklyWidget(
        flagKey: LDFlagKeyConstants.testStaffCalendarButtonText,
        showHideOnly: false,
      );
      await tester.pumpWidget(widget);

      dynamic text = tester.widget<JPText>(find.byKey(widgetKey));
      expect(text.text, 'Text 1');
      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);

      LDService.ldFlagsStream.add(LDFlags.testStaffCalendarButtonText..value = 'Text 2');
      await tester.pump();

      text = tester.widget<JPText>(find.byKey(widgetKey));
      expect(text.text, 'Text 2');
      expect(find.byType(FromLaunchDarkly), findsOneWidget);
      expect(find.byKey(widgetKey), findsOneWidget);
      expect(find.byType(SizedBox), findsNothing);
    });
  });

}