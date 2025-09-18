
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/credit/apply_credit_form.dart';
import 'package:jobprogress/modules/job_financial/form/apply_credit_form/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

  JobModel job = JobModel(customerId: 001, id: 011);
  List<FilesListingModel> invoiceList = [
    FilesListingModel(
      id: '1',
      openBalance: '100',
      name: 'Invoice # 12345'
    ),
    FilesListingModel(
      id: '2',
      openBalance: '102',
      name: 'Invoice # 1435'
    ),
  ];

  List<JPSingleSelectModel> linkInvoiceList = [
    JPSingleSelectModel(id: '', label: 'None'),
    JPSingleSelectModel(id: '2', label: 'Invoice # 12346'),
    JPSingleSelectModel(id: '1', label: 'Invoice # 12345')
  ];

  List<JPSingleSelectModel> linkInvoiceList2 = [
    JPSingleSelectModel(id: '', label: 'None'),
  ];
  
  ApplyCreditFormController controller = ApplyCreditFormController();
 
  ApplyCreditFormService service = ApplyCreditFormService(
    update: controller.update,
    job: job,
    invoiceList: invoiceList,
    validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  ApplyCreditFormService serviceWitchInvoiceId = ApplyCreditFormService(
    update: controller.update,
    job: job,
    invoiceList: invoiceList,
    invoiceId: 1,
    validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );
   ApplyCreditFormService serviceWithoutInvoiceList = ApplyCreditFormService(
    update: controller.update,
    job: job,
    invoiceId: 1,
    validateForm: () { } // method used to validate form using form key with is ui based, so can be passes empty for unit testing
  );

  test('ApplyCreditFormService should be initialized with correct data', () {
    expect(service.creditAmountController.text, "");
    expect(service.linkInvoiceListController.text, "Invoice # 12346");
    expect(service.creditAmountController.text, "");
    expect(service.dateController.text,service.dueOnDate.toString());
    expect(service.invoiceId, null);
    expect(service.invoiceList, null);
    expect(service.job, job);
    expect(service.selectedInvoiceId, '2');
    expect(service.linkInvoiceList.length, 3);
    expect(service.showLinkInvoiceField, true);
  });

    group('ApplyCreditFormService@initFormDefaultData set different value according to invoice id availability', () {
      group('when invoiceId is null', () {
        service.dueOnDate = DateTime.now();  
        service.linkInvoiceList = linkInvoiceList;
        service.initFormDefaultData(date: service.dueOnDate.toString());
        test('Should set selectedInvoiceId to linkInvoiceList second element id', () {
          expect(service.selectedInvoiceId, '2');
        });
        test('Should set linkInvoiceListController.text to linkInvoiceList second element', () {
          expect(service.linkInvoiceListController.text,'Invoice # 12346');
        });
      });
    });

    group('When invoiceId is not null', () {
      serviceWitchInvoiceId.invoiceList = invoiceList;
      serviceWitchInvoiceId.linkInvoiceList = linkInvoiceList;
      serviceWitchInvoiceId.initFormDefaultData(date: serviceWitchInvoiceId.dueOnDate.toString());
      test('Should set selectedInvoiceId to invoiceId ', () {
        expect(serviceWitchInvoiceId.selectedInvoiceId, '1');
      });
      test('Should set linkInvoiceListController.text to linkInvoicelist.label where invoiceId is equal to linkInvoicelist.id', () {
        expect(serviceWitchInvoiceId.linkInvoiceListController.text,'Invoice # 12345');
      });
    });

    group('ApplyCreditFormService data value when linkInvoiceList is has only one element', () {
      serviceWithoutInvoiceList.linkInvoiceList = linkInvoiceList2;
      serviceWithoutInvoiceList.initFormDefaultData(date: service.dueOnDate.toString());
        test('Should set showLinkInvoiceField to false', () {
        expect(serviceWithoutInvoiceList.showLinkInvoiceField, false);
      });
    });
    
    group('ApplyCreditFormService@validateNote should validate note ', () { 
      test('Validation should fail when note is empty', () {
      service.noteController.text = "";
        final val = service.validateNote(service.noteController.text);
        expect(val, 'please_enter_note'.tr);
      });
     test('Validation should fail when note only contains empty spaces', () {
       service.noteController.text = "   ";
        final val = service.validateNote(service.noteController.text);
        expect(val, 'please_enter_note'.tr);
      });
      test('Validation should pass when note contains special characters', () {
        service.noteController.text = "#kpl& - /";
        final val = service.validateNote(service.noteController.text);
        expect(val, null);
      });
      test('Validation should pass  when note contains value', () {
        service.noteController.text = "1234";
        final val = service.validateNote(service.noteController.text);
        expect(val, null);
      });
    });
    
    group('ApplyCreditFormService@validateCredit should validate credit Amount', () {
      test('Validation should fail  when creditAmount is empty', () {
        serviceWitchInvoiceId.creditAmountController.text = "";
        final val = serviceWitchInvoiceId.validateCredit(service.creditAmountController.text,);
        expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
      });
      test('Validation should fail when creditAmount is zero', () {
        serviceWitchInvoiceId.creditAmountController.text = "0";
        final val = serviceWitchInvoiceId.validateCredit(serviceWitchInvoiceId.creditAmountController.text);
        expect(val, 'please_enter_valid_amount'.tr.capitalizeFirst);
      });
      test('Validation should fail when credit amount > invoice value', () {
        service.creditAmountController.text = "112";
        service.invoiceList = invoiceList;
        service.selectedInvoiceId = '1';
        final val = service.validateCredit(service.creditAmountController.text);
        expect(val, 'value_should_not_greater_than_invoice_value'.tr.capitalizeFirst);
      });
      test('Validation should pass when credit is not zero or empty & selectedInvoiceId is null', () {
        service.creditAmountController.text = "112";
          service.selectedInvoiceId = null;
        final val = service.validateCredit(service.creditAmountController.text);
        expect(val, null);
      });
      test('Validation should pass when credit amount >= inovice value && credit amount is not empty or zero', () {
        service.creditAmountController.text = "99";
          service.invoiceList = invoiceList;
        service.selectedInvoiceId = '1';
        final val = service.validateCredit(service.creditAmountController.text);
        expect(val, null);
      });  
    });
}