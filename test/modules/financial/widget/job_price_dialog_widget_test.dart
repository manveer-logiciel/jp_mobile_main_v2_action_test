import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/job_financial/widgets/job_price_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

void main() {
  final controller = JobPriceDialogController();

  group('JPTextButton should disable or enable', () {
    testWidgets('Should disable the JPTextButton, when loading is true', (WidgetTester tester) async {
      controller.isLoading = true;

      // Build the widget with the code block
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JPTextButton(
              isDisabled: controller.isLoading,
              onPressed: () {},
              color: JPAppTheme.themeColors.text,
              icon: Icons.clear,
              iconSize: 24,
            ),
          ),
        ),
      );

      // Verify that the JPTextButton widget is rendered
      expect(find.byType(JPTextButton), findsOneWidget);

      // Verify that the widget has the correct properties
      final jpTextButtonFinder = find.byType(JPTextButton);
      final jpTextButtonWidget = tester.widget<JPTextButton>(jpTextButtonFinder);

      expect(jpTextButtonWidget.isDisabled, true);
    });

    testWidgets('Should enable the JPTextButton, when loading is false', (WidgetTester tester) async {
      controller.isLoading = false;

      // Build the widget with the code block
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: JPTextButton(
              isDisabled: controller.isLoading,
              onPressed: () {},
              color: JPAppTheme.themeColors.text,
              icon: Icons.clear,
              iconSize: 24,
            ),
          ),
        ),
      );

      // Verify that the JPTextButton widget is rendered
      expect(find.byType(JPTextButton), findsOneWidget);

      // Verify that the widget has the correct properties
      final jpTextButtonFinder = find.byType(JPTextButton);
      final jpTextButtonWidget = tester.widget<JPTextButton>(jpTextButtonFinder);

      expect(jpTextButtonWidget.isDisabled, false);
    });
  });
}