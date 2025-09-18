import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/financial_product/financial_product_model.dart';
import 'package:jobprogress/common/models/forms/payment/method.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/refund/index.dart';
import 'package:jobprogress/modules/job_financial/form/refund_form/bottom_sheet/refund_add_item_bottom_sheet/controller.dart';
import 'package:jobprogress/modules/job_financial/form/refund_form/controller.dart';


void main() {
  late RefundFormController controller;
  late RefundAddItemController refundAddItemController;
  late RefundService refundService;

  List<MethodModel> methodList = [
    MethodModel(id: 1,
        label: 'Demo Label'
    )
  ];

  setUpAll(() {
    controller = RefundFormController();
    refundAddItemController = RefundAddItemController();
    
    refundService = RefundService(
        controller: controller,
        customerId: '1',
        jobId: '1',
        validateForm: () {});

    controller.service = refundService;

    refundService.job = JobModel(
      id: -1, 
      customerId: -1,
      customer: CustomerModel(
      )
      
    );
  });

  group('In case of create refund form', () {

    test('RefundFormController should be initialized with correct data', () {
      expect(controller.isLoading, isTrue);
      expect(refundAddItemController.validateItemFormOnDataChange, isFalse);
      expect(controller.isSavingForm, isFalse);
    });

    test('RefundAddItemController should be initialized with correct data', () {
      expect(refundAddItemController.validateItemFormOnDataChange, isFalse);

      expect(refundAddItemController.productId, isEmpty);

      expect(refundAddItemController.itemTotalPrice, 0.0);
    });

    test('RefundFormData should be initialized with correct data', () {
      expect(refundService.refundFromList, isEmpty);
      expect(refundService.refunds, isEmpty);
      expect(refundService.paymentMethods, isEmpty);
      expect(refundService.refundItems, isEmpty);

      expect(refundService.selectedRefundFrom, isNotNull);
      expect(refundService.selectedPaymentMethod, isNull);

      expect(refundService.initialJson, isEmpty);

      expect(refundService.note, isEmpty);
    });

  });

  group('RefundFormController@validateRefundFrom() should validate refund from', () {
    test('Validation should fail when refund from is empty', () {
      String? refundFromError = controller.validateRefundFrom('');
      expect(refundFromError, 'accounting_head_is_required'.tr);
    });

    test('Validation should fail refund from only contains empty spaces', () {
      String? refundFromError = controller.validateRefundFrom('     ');
      expect(refundFromError, 'accounting_head_is_required'.tr);
    });

    test('Validation should pass when refund from is not-empty', () {
      String? refundFromError = controller.validateRefundFrom('Account 1');
      expect(refundFromError, isNull);
    });

  });

  group('RefundFormController@onListItemReorder() should check reorder of list item', () {
    setUpAll(() {
      for(int i = 0; i <= 3; i++) {
        final int price = i+1;
        final int qty = i+1;

        refundService.refundItems.add(
            SheetLineItemModel(
              pageType: AddLineItemFormType.refundForm,
                productId: '$i',
                title: 'Demo Title $i',
                price: price.toString(),
                totalPrice: (price+qty).toString(),
                qty: qty.toString()
            ));
      }
    });

    test('When list item is reordered', () {
      final beforeReorderFirstItem = refundService.refundItems.first.productId;
      controller.onListItemReorder(0, 2);
      final afterReorderFirstItem = refundService.refundItems.first.productId;
      expect(beforeReorderFirstItem == afterReorderFirstItem, isFalse);
    });

    test('When list item is not reordered', () {
      final beforeReorderFirstItem = refundService.refundItems.first.productId;
      controller.onListItemReorder(0, 1);
      final afterReorderFirstItem = refundService.refundItems.first.productId;
      expect(beforeReorderFirstItem == afterReorderFirstItem, isTrue);
    });

  });

  group('RefundAddItemController@validateActivityTitle() should validate activity title', () {

    test('Validation should fail when activity title is empty', () {
      final val = refundAddItemController.validateActivityTitle('');
      expect(val, 'activity_is_required'.tr);
    });

    test('Validation should fail when activity title only contains empty spaces', () {
      final val = refundAddItemController.validateActivityTitle('    ');
      expect(val, 'activity_is_required'.tr);
    });

    test('Validation should pass when activity title is not-empty', () {
      final val = refundAddItemController.validateActivityTitle('Test');
      expect(val, isNull);
    });

  });

  group('RefundFormData@checkIfNewDataAdded() should check if any addition/update is made in form', () {
    setUpAll(() {
      refundService.initialJson = refundService.createRefundFormJson('1', '1');
    });

    test('When changes in form are made', () {
      refundService.addressController.text = 'Test Address';
      expect(refundService.checkIfNewDataAdded(), isTrue);
    });

    test('When no changes in form are made', () {
      refundService.addressController.text = '';
      expect(refundService.checkIfNewDataAdded(), isFalse);
    });
  });

  group('RefundService@setPaymentMethods() should set payment method\'s variables', () {
    test('RefundFormData@paymentMethods list should not be empty', () {
      refundService.paymentMethods = [];
      refundService.setPaymentMethods(methodList);
      expect(refundService.paymentMethods, isNotEmpty);
    });

    test('RefundFormData@selectedPaymentMethod should not be null', () {
      refundService.paymentMethods = [];
      refundService.selectedPaymentMethod = null;
      refundService.setPaymentMethods(methodList);
      expect(refundService.selectedPaymentMethod, isNotNull);
    });

    test('RefundFormData@paymentMethodController should not be empty', () {
      refundService.paymentMethods = [];
      refundService.selectedPaymentMethod = null;
      refundService.paymentMethodController.text = '';
      refundService.setPaymentMethods(methodList);
      expect(refundService.paymentMethodController.text, 'none'.tr);
    });

  });

  group('RefundService@setAddress() should set address in address field', () {
  test('Should set address to billing address when billing address is present in customer', () {
    refundService.job?.customer?.addressString = '123 Main St';
    refundService.job?.customer?.billingAddressString = '456 Elm St';
  
    refundService.setAddress();
  
    expect(refundService.addressController.text, '456 Elm St');
  });

  test('Should set address to customer address when billing address is empty in customer', () {
    refundService.job?.customer?.addressString = '123 Main St';
    refundService.job?.customer?.billingAddressString = '';
  
    refundService.setAddress();
  
    expect(refundService.addressController.text, '123 Main St');
  });

  test('Should set address to empty when customer address is empty and billing address is empty', () {
    refundService.job?.customer?.addressString = '';
    refundService.job?.customer?.billingAddressString = '';
  
    refundService.setAddress();
  
    expect(refundService.addressController.text, '');
  });
});

  group('RefundAddItemController@onChangePriceOrQty() should check item total price', () {
    test('When price is empty', () {
      refundAddItemController.priceController.text = '';

      refundAddItemController.onChangePriceOrQty();

      expect(refundAddItemController.itemTotalPrice, 0.0);
    });

    test('When price is equal to dot', () {
      refundAddItemController.priceController.text = '.';

      refundAddItemController.onChangePriceOrQty();

      expect(refundAddItemController.itemTotalPrice, 0.0);
    });

    test('When qty is empty', () {
      refundAddItemController.priceController.text = '1';
      refundAddItemController.qtyController.text = '';

      refundAddItemController.onChangePriceOrQty();

      expect(refundAddItemController.itemTotalPrice, 0.0);
    });

    test('When qty is equal to dot', () {
      refundAddItemController.priceController.text = '1';
      refundAddItemController.qtyController.text = '.';

      refundAddItemController.onChangePriceOrQty();

      expect(refundAddItemController.itemTotalPrice, 0.0);
    });

    test('When price & qty has correct values', () {
      refundAddItemController.priceController.text = '1';
      refundAddItemController.qtyController.text = '1';

      refundAddItemController.onChangePriceOrQty();

      expect(refundAddItemController.itemTotalPrice, 1.0);
    });

  });

  test('RefundAddItemController@setRefundItemData() should filled add item bottom sheet data variables', () {
    refundAddItemController.setRefundItemData(
        SheetLineItemModel(
          pageType: AddLineItemFormType.refundForm,
            productId: '1',
            title: 'Demo Title',
            price: '1',
            qty: '1',
            totalPrice: '1.0'
        ));

    expect(refundAddItemController.productId, '1');
    expect(refundAddItemController.activityController.text, 'Demo Title');
    expect(refundAddItemController.priceController.text, '1');
    expect(refundAddItemController.qtyController.text, '1');
    expect(refundAddItemController.itemTotalPrice, 1.0);
  });

  test('RefundAddItemController@saveRefundItemValues() should save add item bottom sheet data variables', () {
    refundAddItemController.productId = '';
    refundAddItemController.activityController.text = '';
    refundAddItemController.priceController.text = '';

    refundAddItemController.saveRefundItemValues(
        FinancialProductModel(
          id: 1,
          name: 'Demo Title',
          sellingPrice: '1',
        ));

    expect(refundAddItemController.productId, '1');
    expect(refundAddItemController.activityController.text, 'Demo Title');
    expect(refundAddItemController.priceController.text, '1');    

  });

  group('RefundAddItemController@calculateItemsPrice() should return sheet line item total price', () {
    test('When there is sheet line item in list', () {
      refundService.refundItems = [
        SheetLineItemModel(
          pageType: AddLineItemFormType.refundForm,
            productId: '1',
            title: 'Demo Title',
            price: '1',
            qty: '1',
            totalPrice: '1.0'
        )
      ];

      refundService.calculateItemsPrice();

      expect(refundService.totalPrice, 1.0);
    });

    test('When there is no sheet line item in list', () {
      refundService.refundItems = [];
      refundService.calculateItemsPrice();
      expect(refundService.totalPrice, 0.0);
    });
  });
}