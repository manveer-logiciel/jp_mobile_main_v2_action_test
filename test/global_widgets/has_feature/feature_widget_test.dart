import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/feature_flag/controller.dart';
import 'package:jobprogress/global_widgets/feature_flag/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  UniqueKey widgetKey = UniqueKey();

  Map<String, dynamic> tempFeatures = {
    FeatureFlagConstant.production: 0,
    FeatureFlagConstant.reports: 0,
    FeatureFlagConstant.thirdPartyIntegrations: 0,
    FeatureFlagConstant.userManagement: 0,
    FeatureFlagConstant.financeAndAccounting: 0,
    FeatureFlagConstant.materialLabourLibrary: 0,
    FeatureFlagConstant.miscellaneousFeatures: 0,
    FeatureFlagConstant.documents: 0,
    FeatureFlagConstant.customerJobFeatures: 0,
    FeatureFlagConstant.automation: 0,
  };

  Widget buildHasFeatureAllowedWidget(List<String> keys) {
    return TestHelper.buildWidget(
      HasFeatureAllowed(
        feature: keys,
        child: JPText(
          key: widgetKey,
          text: "",
        ),
      ),
    );
  }

  testWidgets("HasFeatureAllowed widget should initialize FeatureFlagController if not already", (WidgetTester tester) async {
    final widget = buildHasFeatureAllowedWidget([]);
    await tester.pumpWidget(widget);

    expect(find.byKey(widgetKey), findsOneWidget);
    expect(Get.isRegistered<FeatureFlagController>(), isTrue);
  });

  testWidgets("HasFeatureAllowed widget should display correct placeholder", (WidgetTester tester) async {
    FeatureFlagService.setFeatureData(tempFeatures);
    final widget = buildHasFeatureAllowedWidget([FeatureFlagConstant.production]);
    await tester.pumpWidget(widget);

    expect(find.byType(SizedBox), findsOneWidget);
  });

  group("HasFeatureAllowed widget should decide and display widgets as per available features", () {
    group("When features data is not available", () {
      setUp(() {
        FeatureFlagService.setFeatureData({});
      });

      testWidgets("HasFeatureAllowed widget should display widget, when feature keys are empty", (WidgetTester tester) async {
        final widget = buildHasFeatureAllowedWidget([]);
        await tester.pumpWidget(widget);

        expect(find.byKey(widgetKey), findsOneWidget);
      });

      testWidgets("HasFeatureAllowed widget should display widget, when feature keys are not empty", (WidgetTester tester) async {
        final widget = buildHasFeatureAllowedWidget([FeatureFlagConstant.production]);
        await tester.pumpWidget(widget);

        expect(find.byKey(widgetKey), findsOneWidget);
      });
    });

    group("When features data is available", () {
      setUp(() {
        tempFeatures.remove(FeatureFlagConstant.automation);
        tempFeatures.remove(FeatureFlagConstant.documents);
        FeatureFlagService.setFeatureData(tempFeatures);
      });

      testWidgets("HasFeatureAllowed widget should display widget, when feature keys are empty", (WidgetTester tester) async {
        final widget = buildHasFeatureAllowedWidget([]);
        await tester.pumpWidget(widget);

        expect(find.byKey(widgetKey), findsOneWidget);
      });

      group("When features keys are not empty", () {
        group("In case of single feature key", () {
          testWidgets("HasFeatureAllowed widget should not display widget, if feature is not in the features data", (WidgetTester tester) async {
            final widget = buildHasFeatureAllowedWidget([FeatureFlagConstant.automation]);
            await tester.pumpWidget(widget);

            expect(find.byKey(widgetKey), findsNothing);
          });

          testWidgets("HasFeatureAllowed widget should not display widget, if feature is not enabled", (WidgetTester tester) async {
            final widget = buildHasFeatureAllowedWidget([FeatureFlagConstant.production]);
            await tester.pumpWidget(widget);

            expect(find.byKey(widgetKey), findsNothing);
          });

          testWidgets("HasFeatureAllowed widget should display widget if feature is enabled", (WidgetTester tester) async {
            tempFeatures[FeatureFlagConstant.production] = 1;
            final widget = buildHasFeatureAllowedWidget([FeatureFlagConstant.production]);
            await tester.pumpWidget(widget);

            expect(find.byKey(widgetKey), findsOneWidget);
          });
        });

        group("In case of multiple feature keys", () {
          group("When one or more feature keys are not available in features data", () {
            testWidgets("HasFeatureAllowed widget should not display widget, when none of key exists in features data", (WidgetTester tester) async {
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.automation,
                FeatureFlagConstant.documents
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsNothing);
            });

            testWidgets("HasFeatureAllowed widget should not display widget, when any one key does not exists and existing features are enabled", (WidgetTester tester) async {
              tempFeatures[FeatureFlagConstant.production] = 1;
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.production,
                FeatureFlagConstant.documents,
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsNothing);
            });

            testWidgets("HasFeatureAllowed widget should not display widget, when any one key does not exists and existing features are disabled", (WidgetTester tester) async {
              tempFeatures[FeatureFlagConstant.production] = 0;
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.production,
                FeatureFlagConstant.documents,
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsNothing);
            });
          });

          group("When all features keys are available in features data", () {
            testWidgets("HasFeatureAllowed widget should not display widget, if any of the features is disabled", (WidgetTester tester) async {
              tempFeatures[FeatureFlagConstant.production] = 1;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 0;
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsNothing);
            });

            testWidgets("HasFeatureAllowed widget should not display widget, if all the features are disabled", (WidgetTester tester) async {
              tempFeatures[FeatureFlagConstant.production] = 0;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 0;
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsNothing);
            });

            testWidgets("HasFeatureAllowed widget should display widget, if all the features are enabled", (WidgetTester tester) async {
              tempFeatures[FeatureFlagConstant.production] = 1;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 1;
              final widget = buildHasFeatureAllowedWidget([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              await tester.pumpWidget(widget);

              expect(find.byKey(widgetKey), findsOneWidget);
            });
          });
        });
      });
    });
  });
}