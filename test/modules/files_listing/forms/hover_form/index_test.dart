import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';

void main() {

  HoverOrderFormParams? params;

  HoverOrderFormParams tempParams = HoverOrderFormParams(
    jobId: 100,
    hoverUser: HoverUserModel(id: 1, firstName: "Hover User",),
    customer: CustomerModel(
      id: 1
    )
  );

  setUpAll(() {
    params = tempParams;
  });

  HoverOrderFormController controller = HoverOrderFormController(null);

  group('HoverOrderFormController should be initialized with correct values', () {

    test('When form params do not exist', () {
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.params, null);
      expect(controller.pageTitle, 'hover_order'.tr.toUpperCase());
    });

    test('When form params exists', () {
      controller.params = tempParams;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.params, params);
      expect(controller.pageTitle, 'hover_order'.tr.toUpperCase());
    });

  });

  group('HoverOrderFormController@toggleIsSavingForm should toggle form\'s saving state', () {

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