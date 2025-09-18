
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/insurance_details/controller.dart';
void main() {

  InsuranceDetailsFormController controller = InsuranceDetailsFormController();
  InsuranceModel insuranceModel = InsuranceModel(id: 1);

  group('In case of create insurance details', () {

    test('InsuranceDetailsFormController should be initialized with correct values', () {
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.insuranceDetails, null);
      expect(controller.pageTitle, 'add_insurance_details'.tr.toUpperCase());
    });

    group('InsuranceDetailsFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });

    });

  });

  group('In case of edit/update insurance details', () {

    test('InsuranceDetailsFormController should be initialized with correct values', () {

      controller.insuranceDetails = insuranceModel;

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.insuranceDetails, insuranceModel);
      expect(controller.pageTitle, 'edit_insurance_details'.tr.toUpperCase());
    });

  });
  
}