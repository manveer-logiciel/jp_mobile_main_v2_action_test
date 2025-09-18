import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/forgot_password/controller.dart';
import 'package:jobprogress/modules/forgot_password/widget/form/forgot_password.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  RunModeService.setRunMode(RunMode.unitTesting);

  final ForgotPasswordController controller = ForgotPasswordController();

  test('ForgotPasswordController should be initialized with correct values', () {
    expect(controller.isLoading, false);
    expect(controller.isValidate, false);
  });

  group('ForgotPasswordController@validateForm function should validate form', () {
    testWidgets('When email is empty', (widgetTester) async {
      controller.emailController.text = '';
      await widgetTester.pumpWidget(getFormWidget(controller));
      expect(controller.validateForm(), isFalse);
      expect(controller.emailController.text, isEmpty);
    });
    testWidgets('When email is valid', (widgetTester) async {
      controller.emailController.text = 'abc@gmail.com';
      await widgetTester.pumpWidget(getFormWidget(controller));
      expect(controller.validateForm(), isTrue);
      expect(FormValidator.validateEmail(controller.emailController.text), isNull);
    });
    testWidgets('When email is not valid', (widgetTester) async {
        controller.emailController.text = 'abc@gmail';
        await widgetTester.pumpWidget(getFormWidget(controller));
        expect(controller.validateForm(), isFalse);
        expect(FormValidator.validateEmail(controller.emailController.text), isNotNull);
    });
  });

  group('ForgotPasswordController@onChangeEmail function should check', () {
    test('When realtime validation is active', () {
      controller.isValidate = true;
      expect(controller.onChangeEmail(''), isTrue);
    });
    test('When realtime validation is inactive', () {
      controller.isValidate = false;
      expect(controller.onChangeEmail(''), isFalse);
    });
  });
}

Widget getFormWidget(ForgotPasswordController controller) =>
    TestHelper.buildWidget(
        JPScaffold(
            body: ForgotPasswordForm(controller: controller)
        ));