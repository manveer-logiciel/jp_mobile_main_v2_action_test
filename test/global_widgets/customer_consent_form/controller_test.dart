import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/customer_consent_form/controller.dart';

void main() {
  final controller = ConsentFormDialogController();
  group('ConsentFormDialogController@consentMessage consent message should be returned on the basis of consent message status', () {
    test('When consent email is sent should return success message', () {
      controller.emailController.text = 'example@example.com';
      controller.showSuccessMessage = true;
      final result = controller.consentMessage;

      expect(result, equals('${'success_message'.tr}${controller.emailController.text}.'));
    });

    test('Consent form message without dropdown should return when emailList is null or empty', () {
      controller.emailList?.clear();
      controller.showSuccessMessage = false;
      final result = controller.consentMessage;

      expect(result, equals('consent_form_message_without_dropdown'.tr));
    });

    test('Consent form message should be return when Consent email is not sent and emailList is not null or empty', () {
      final controller = ConsentFormDialogController(emailList: ['example@example.com']);
      final result = controller.consentMessage;

      expect(result, equals('consent_form_message'.tr));
    });
  });
}