import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/invoice_form_type.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/models/forms/invoice_form/invoice_form_param.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/modules/job_financial/form/invoice_form/controller.dart';

void main() {
  InvoiceFormController controller = InvoiceFormController();

  List<SheetLineItemModel> invoiceItems = [
    SheetLineItemModel(currentIndex: 0, pageType: AddLineItemFormType.changeOrderForm,
        productId: "1", title: "title - 1", price: "12.00", qty: "2", totalPrice: "24.00"),
    SheetLineItemModel(currentIndex: 1, pageType: AddLineItemFormType.changeOrderForm,
        productId: "2", title: "title - 2", price: "6.00", qty: "1", totalPrice: "6.00"),
    SheetLineItemModel(currentIndex: 2, pageType: AddLineItemFormType.changeOrderForm,
        productId: "3", title: "title - 3", price: "2.00", qty: "3", totalPrice: "6.00")
  ];

  List<SheetLineItemModel> invoiceItem = [
    SheetLineItemModel(currentIndex: 0, pageType: AddLineItemFormType.invoiceForm,
        productId: "1", title: "title - 1", price: "12.00", qty: "2", totalPrice: "24.00"),
  ];

  setUpAll(() {
    WidgetsFlutterBinding.ensureInitialized();
    Get.testMode = true;
    RunModeService.setRunMode(RunMode.unitTesting);
    controller.init();
  });

  group('In case of create change order', () {
    test('InvoiceFormController should be initialized with correct values', () {
      controller.pageType = InvoiceFormType.changeOrderCreateForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.jobId, null);
      expect(controller.customerId, null);
      expect(controller.orderId, null);
      expect(controller.invoiceFormParam != null, false);
      expect(controller.pageType, InvoiceFormType.changeOrderCreateForm);
      expect(controller.formTitle, 'change_order_details'.tr.toUpperCase());
      expect(controller.isWithSignature, true);
    });

    group('InvoiceFormController@toggleIsSavingForm should toggle is form saving', () {
      test('should be showing loading', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, true);
      });
      test('should stop loading', () {
        controller.toggleIsSavingForm();
        expect(controller.isSavingForm, false);
      });
    });

    group('InvoiceFormController@updateInvoice should save change order with or without invoice', () {
      test('should create change order with invoice', () {
        controller.updateInvoice("with_invoice");
        expect(controller.service.isWithInvoice, true);
      });
      test('should create change order without invoice', () {
        controller.updateInvoice("without_invoice");
        expect(controller.service.isWithInvoice, false);
      });
    });

    group('InvoiceFormController@updateInvoice should save change order with or without invoice', () {
      // Commented this code as of behaviour changes in invoice selection
      // test('should create change order with invoice', () {
      //   controller.updateInvoice("with_invoice");
      //   expect(controller.service.isWithInvoice, true);
      // });
      test('should create change order without invoice', () {
        controller.updateInvoice("without_invoice");
        expect(controller.service.isWithInvoice, false);
      });
    });

    group('InvoiceFormController@onListItemReorder should should reorder invoice item list', () {
      test('initial invoiceItems list order', () {
        controller.service.invoiceItems = invoiceItems;
        List<String?> list = controller.service.invoiceItems.map((v) => v.productId).toList();
        expect(listEquals(list, ["1", "2", "3"]), true);
      });

      test('invoiceItems list should reorder by replacing item of 3rd index to 1st index', () {
        controller.onListItemReorder(2, 0);
        List<String?> list = controller.service.invoiceItems.map((v) => v.productId).toList();
        expect(listEquals(list, ["3", "1", "2"]), true);
      });

      test('invoiceItems list should reorder by replacing item of 3rd index to 1st index', () {
        controller.onListItemReorder(2, 1);
        List<String?> list = controller.service.invoiceItems.map((v) => v.productId).toList();
        expect(listEquals(list, ["3", "2", "1"]), true);
      });

      test('invoiceItems list should reorder by replacing item of 2nd index to 1st index', () {
        controller.onListItemReorder(1, 0);
        List<String?> list = controller.service.invoiceItems.map((v) => v.productId).toList();
        expect(listEquals(list, ["2", "3", "1"]), true);
      });
    });

  });

  group('In case of update change order', () {

    InvoiceFormParam param = InvoiceFormParam(
        jobModel: JobModel(id: 123, customerId: 321),
        financialListingModel: FinancialListingModel(id: 456),
        controller: controller,
        pageType: InvoiceFormType.changeOrderEditForm
    );

    test('InvoiceFormController should be initialized with correct values in edit case', () {
      controller = InvoiceFormController(invoiceFormParam: param);
      controller.init();

      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.jobId, 123);
      expect(controller.customerId, 321);
      expect(controller.orderId, 456);
      expect(controller.invoiceFormParam != null, true);
      expect(controller.pageType, InvoiceFormType.changeOrderEditForm);
      expect(controller.formTitle, 'change_order_details'.tr.toUpperCase());
      expect(controller.isWithSignature, true);
    });

    group('InvoiceFormController@updateInvoice should save updated change order with or without invoice', () {
      test('should update change order with invoice', () {
        controller.updateInvoice("with_invoice");
        expect(controller.service.isWithInvoice, true);
      });
      test('should update change order without invoice', () {
        controller.updateInvoice("without_invoice");
        expect(controller.service.isWithInvoice, false);
      });
    });

  });


  group('In case of create invoice', () {
    test('InvoiceFormController should be initialized with correct values', () {
      controller = InvoiceFormController();
      controller.init();
      controller.pageType = InvoiceFormType.invoiceCreateForm;
      
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.jobId, null);
      expect(controller.customerId, null);
      expect(controller.orderId, null);
      expect(controller.invoiceFormParam, null);
      expect(controller.pageType, InvoiceFormType.invoiceCreateForm);
      expect(controller.formTitle, 'invoice_details'.tr.toUpperCase());
      expect(controller.isWithSignature, false);
    });

    test('invoiceItems should not be empty', () {
      controller.service.invoiceItems = invoiceItem;
      expect(controller.service.invoiceItems.isNotEmpty, true);
    });

  });

}