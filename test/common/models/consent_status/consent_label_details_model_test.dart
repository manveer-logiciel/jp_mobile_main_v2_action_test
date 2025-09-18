
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/consent_status/consent_label_details_model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  group("ConsentLabelDetailsModel should be initialized with default values", () {
    test('ConsentLabelDetailsModel should be initialized with default values', () {
      final details = ConsentLabelDetailsModel(
        color: JPAppTheme.themeColors.themeBlue,
        icon: Icons.sms,
        label: 'confirm_consent',
        toolTip: 'no_consent_obtained_tooltip',
        composeLabel: 'no_consent_obtained_compose_label',
        composeMessage: 'no_consent_obtained_compose_message',
        composeMessageButtonText: 'confirm_consent',
        composeMessageButtonColor: JPButtonColorType.primary,
        composeMessageButtonTextColor: JPAppTheme.themeColors.base,
      );
      expect(details.color, JPAppTheme.themeColors.themeBlue);
      expect(details.icon, Icons.sms);
      expect(details.label, 'confirm_consent');
      expect(details.toolTip, 'no_consent_obtained_tooltip');
      expect(details.composeLabel, 'no_consent_obtained_compose_label');
      expect(details.composeMessage, 'no_consent_obtained_compose_message');
      expect(details.composeMessageButtonText, 'confirm_consent');
      expect(details.composeMessageButtonColor, JPButtonColorType.primary);
      expect(details.composeMessageButtonTextColor, JPAppTheme.themeColors.base);
    });

    test('ConsentLabelDetailsModel button data should have default values if not given', () {
      final details = ConsentLabelDetailsModel(
        color: JPAppTheme.themeColors.themeBlue,
        icon: Icons.sms,
        label: 'confirm_consent',
        toolTip: 'no_consent_obtained_tooltip',
        composeLabel: 'no_consent_obtained_compose_label',
        composeMessage: 'no_consent_obtained_compose_message',
      );
      expect(details.color, JPAppTheme.themeColors.themeBlue);
      expect(details.icon, Icons.sms);
      expect(details.label, 'confirm_consent');
      expect(details.toolTip, 'no_consent_obtained_tooltip');
      expect(details.composeLabel, 'no_consent_obtained_compose_label');
      expect(details.composeMessage, 'no_consent_obtained_compose_message');
      expect(details.composeMessageButtonText, 'edit_consent');
      expect(details.composeMessageButtonColor, JPButtonColorType.lightGray);
      expect(details.composeMessageButtonTextColor, JPColor.tertiary);
    });
  });
}