
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/modules/job_financial/form/payment_forms/apply_payment_form/controller.dart';

void main() {

  ApplyPaymentFormController controller = ApplyPaymentFormController();

  setUpAll(() {
    controller.initForm();
  });
  test('ApplyPaymentFormController should be initialized with correct values', () {
    expect(controller.isSavingForm, false);
    expect(controller.validateFormOnDataChange, false);
    expect(controller.isLoading, true);
    expect(controller.jobId, null);
  });

  group('ApplyPaymentFormController@toggleIsSavingForm should toggle form\'s saving state', () {
      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });
}