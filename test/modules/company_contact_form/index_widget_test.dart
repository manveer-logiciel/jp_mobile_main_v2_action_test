import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';

void main() {
  testWidgets('EmailForm@List should have correct padding', (WidgetTester tester) async {
    // Arrange
    final emails = [EmailModel(email: '')];
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: EmailsForm(
          emails: emails,
          isRequired: false,
          isDisabled: false,
        )
      )
    );

    // Assert
    final listViewWidget = tester.widget<ListView>(find.byType(ListView));
    expect(listViewWidget.padding, EdgeInsets.zero);
  });
}