import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/controller.dart';

void main() {

  ApplyCreditFormController controller = ApplyCreditFormController();

  setUpAll(() {
    controller.initForm();
  });

  test('ApplyCreditFormController should be initialized with correct values', () {
    expect(controller.service.isSavingForm, false);
    expect(controller.validateFormOnDataChange, false);
    expect(controller.isLoading, true);
  });

   group('ApplyCreditFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.service.toggleIsSavingForm();
        expect(controller.service.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.service.toggleIsSavingForm();
        expect(controller.service.isSavingForm, false);
      });

    });
}