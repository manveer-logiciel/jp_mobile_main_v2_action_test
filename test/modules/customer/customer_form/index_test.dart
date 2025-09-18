
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';

void main() {

  CustomerFormController controller = CustomerFormController();
  CustomerModel tempCustomer = CustomerModel(
    id: 1,
    fullName: "Test Customer"
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller.init();
  });

  FormSectionModel tempSection = FormSectionModel(
      name: "Test Section",
      fields: [],
  );

  group('In case of add customer', () {

    test('CustomerFormController should be initialized with correct values', () {
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.customerId, isNull);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.saveButtonText, 'save'.tr.toUpperCase());
      expect(controller.pageTitle, 'add_lead_prospect_customer'.tr.toUpperCase());
    });

    group('CustomerFormController@onSectionExpansionChanged should toggle section\'s expansion', () {

      test('Section should be expanded', () {
        controller.onSectionExpansionChanged(tempSection, true);
        expect(tempSection.isExpanded, true);
      });

      test('Section should be collapsed', () {
        controller.onSectionExpansionChanged(tempSection, false);
        expect(tempSection.isExpanded, false);
      });
    });

    group('CustomerFormController@toggleIsSavingForm should toggle form\'s saving state', () {

      test('Form editing should be disabled', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });
    });

    test("CustomerFormController@addFieldsListener should bind a realtime listener for listening field changes", () async {
      controller.addFieldsListener();
      expect(controller.fieldsSubscription, isNotNull);
    });

    test("CustomerFormController@removeFieldsListener should remove realtime listener for listening field changes", () async {
      controller.removeFieldsListener();
      expect(controller.fieldsSubscription, isNull);
    });
  });

  group('In case of edit/update customer', () {

    test('CustomerFormController should be initialized with correct values', () {

      controller.customerId = tempCustomer.id;

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.customerId, tempCustomer.id);
      expect(controller.fieldsSubscription, isNull);
      expect(controller.saveButtonText, 'update'.tr.toUpperCase());
      expect(controller.pageTitle, 'update_lead_prospect_customer'.tr.toUpperCase());
    });
  });

}