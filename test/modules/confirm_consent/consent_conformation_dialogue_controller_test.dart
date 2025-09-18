import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/core/constants/consent_status_constants.dart';
import 'package:jobprogress/modules/confirm_consent/widgets/conformation_dialogue/controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final tempPhone = PhoneModel(number: "8888888888");
  late ConsentConformationDialogueController controller;

  group('In case of obtain consent', () {
    setUpAll(() {
      controller = ConsentConformationDialogueController(phone: tempPhone);
    });
    test('ConfirmConsentController should be initialized with correct values', () {
      expect(controller.isRemoveConsentDialogue, isFalse);
      expect(controller.isExpressConsentCheckBoxSelected, isFalse);
      expect(controller.isSkipDisable, isFalse);
      expect(controller.isSaveDisable, isFalse);
      expect(controller.isLoading, isFalse);
      expect(controller.consentStatusConstants, isNull);
      expect(controller.previouslySelectedConsent, isNull);
      expect(controller.title, equals("confirm_express_consent".tr.toUpperCase()));
      expect(controller.description, equals("express_consent_conformation_message".tr));
      expect(controller.checkBoxText, equals("express_consent_conformation_checkbox_message".tr));
      expect(controller.saveButtonText, equals("save".tr.toUpperCase()));
      expect(controller.isSkipVisible, isFalse);
    });

    group("ConsentConformationDialogueController@onExpressConsentCheckBoxToggle should toggle express consent checkbox", () {
      test('Express consent checkbox should be selected', () {
        controller.onExpressConsentCheckBoxToggle(true);
        expect(controller.isExpressConsentCheckBoxSelected, isTrue);
      });

      test('Express consent checkbox should not be selected', () {
        controller.onExpressConsentCheckBoxToggle(false);
        expect(controller.isExpressConsentCheckBoxSelected, isFalse);
      });
    });

    group("ConsentConformationDialogueController@oupdateButtonsDisability should toggle disability of save button", () {
      test("When express consent check box is not selected then save button should be disable", () {
        controller.isExpressConsentCheckBoxSelected = false;
        controller.updateButtonsDisability();
        expect(controller.isExpressConsentCheckBoxSelected, isFalse);
        expect(controller.isSkipDisable, isFalse);
        expect(controller.isSaveDisable, isTrue);
      });

      test("When express consent check box is selected then save button should not be disable", () {
        controller.isExpressConsentCheckBoxSelected = true;
        controller.updateButtonsDisability();
        expect(controller.isExpressConsentCheckBoxSelected, isTrue);
        expect(controller.isSkipDisable, isTrue);
        expect(controller.isSaveDisable, isFalse);
      });
    });
  });

  group('In case of remove consent', () {
    setUpAll(() {
      controller = ConsentConformationDialogueController(phone: tempPhone, isRemoveConsentDialogue: true);
    });

    test('ConfirmConsentController should be initialized with correct values', () {
      expect(controller.isRemoveConsentDialogue, isTrue);
      expect(controller.isExpressConsentCheckBoxSelected, isFalse);
      expect(controller.isSkipDisable, isFalse);
      expect(controller.isSaveDisable, isFalse);
      expect(controller.isLoading, isFalse);
      expect(controller.consentStatusConstants, isNull);
      expect(controller.previouslySelectedConsent, isNull);
      expect(controller.title, equals("remove_consent".tr.toUpperCase()));
      expect(controller.description, equals("remove_consent_message".tr));
      expect(controller.checkBoxText, equals("remove_consent_checkbox_message".tr));
      expect(controller.saveButtonText, equals("remove_consent".tr.toUpperCase()));
      expect(controller.isSkipVisible, isFalse);
    });
  });

  group('In case of remove express consent', () {
    setUpAll(() {
      controller = ConsentConformationDialogueController(
        phone: tempPhone, 
        isRemoveConsentDialogue: true, 
        previouslySelectedConsent: ConsentStatusConstants.promotionalMessage
      );
    });

    test('ConfirmConsentController should be initialized with correct values', () {
      expect(controller.isRemoveConsentDialogue, isTrue);
      expect(controller.isExpressConsentCheckBoxSelected, isFalse);
      expect(controller.isSkipDisable, isFalse);
      expect(controller.isSaveDisable, isFalse);
      expect(controller.isLoading, isFalse);
      expect(controller.consentStatusConstants, isNull);
      expect(controller.previouslySelectedConsent, equals(ConsentStatusConstants.promotionalMessage));
      expect(controller.title, equals("remove_express_consent".tr.toUpperCase()));
      expect(controller.description, equals("remove_express_consent_message".tr));
      expect(controller.checkBoxText, equals("remove_express_consent_checkbox_message".tr));
      expect(controller.saveButtonText, equals("remove_consent".tr.toUpperCase()));
      expect(controller.isSkipVisible, isFalse);
    });
  });
}