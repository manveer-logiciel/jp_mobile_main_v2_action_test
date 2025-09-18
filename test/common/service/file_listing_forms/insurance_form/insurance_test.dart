import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/insurance_form_type.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_detail_category_model.dart';
import 'package:jobprogress/common/services/files_listing/forms/insurance_form_view/index.dart';
import 'package:jobprogress/modules/files_listing/forms/insurance/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {

  late Map<String, dynamic> tempInitialJson;

  JobModel tempJob = JobModel(
    id: 1, 
    customerId: 2)
  ;
  
  WorksheetDetailCategoryModel tempInsuranceCategoryDetail = WorksheetDetailCategoryModel(
    id: 23,
    slug: 'insurance',
    name: 'Insurance'
  );

  List<JPSingleSelectModel> tempDivisionList = [
    JPSingleSelectModel(label: 'Second Phase', id: '3'),
    JPSingleSelectModel(label: 'Third Phase', id: '4')
  ]; 

  SheetLineItemModel tempAddedItem = SheetLineItemModel(
    id: 12,
    productId: '12', 
    title: 'KiloGram', 
    price: '12', 
    qty: '12', 
    totalPrice: '144',
    depreciation: '50',
    tax: '12',

    tradeType: JPSingleSelectModel(label: 'Air Quality', id: '12'), 
    measurementFormulas:  [MeasurementFormulaModel(
      id: 24,
      tradeId: 12,
      productId: 12,
      formula: 'length*breadth',
    )], pageType: null
  );

  MeasurementModel tempMeasurement = MeasurementModel(
    measurements:
    
    [MeasurementDataModel(
      id: 12,
      attributes: [
        MeasurementAttributeModel(slug: 'length',name: 'Length', value: '20'),
        MeasurementAttributeModel(slug: 'breadth', name: 'Breadth', value: '20')
      ]
    )]
  ); 

  SheetLineItemModel tempUpdatedItem = SheetLineItemModel(
    id: 15,
    currentIndex: 0,
    productId: '14',
    title: 'gram', 
    price: '13', 
    qty: '23', 
    totalPrice: '299');

  group('In case of create insurance', () {
    InsuranceFormService service = InsuranceFormService(
      update: () {},
      jobModel: tempJob,
      pageType: InsuranceFormType.add, 
    );

    setUpAll(() {
      tempInitialJson = service.insuranceFormJson();
      service.insuranceCategoryDetail =  tempInsuranceCategoryDetail;
      service.divisionsList =  tempDivisionList;
      service.controller = InsuranceFormController();
    });

    group('InsuranceFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.titleController.text, "");
        expect(service.divisionController.text, "");
      });
    });

    test('Form expectations should be initialized with correct values', () {
      expect(service.isLoading, true);
      expect(service.isInsuranceInfoUpdated, false);
      expect(service.disableDivision, false);
      expect(service.isSavingForm, false);
      expect(service.isMeasurementApplied, false);
    });

    test('Form data helpers should be initialized with correct values', () {
      expect(service.jobModel != null, true);
      expect(service.initialJson, <String, dynamic>{});
    });

    test('InsuranceFormService@setUpAPIData() should set-up form values', () {
      service.initialJson = service.insuranceFormJson();
      expect(service.initialJson, tempInitialJson);
    });

    group('InsuranceFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.titleController.text = '12';
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.titleController.text = '';
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

   group('CreateInsuranceController@toggleIsSavingForm() should toggle form\'s saving state', () {
      test('Form editing should be disabled', () {
        service.toggleIsSaving();
        expect(service.isSavingForm, true);
      });

      test('Form editing should be allowed', () {
        service.toggleIsSaving();
        expect(service.isSavingForm, false);
      });
    });  

     group('InsuranceFormService@toggleIsInsuranceInfo() should toggle InsuranceInfoUpdated checkbox', () {
      test("When tap on InsuranceInfoUpdate", () {
        service.toggleIsInsuranceInfo(true);
        expect(service.isInsuranceInfoUpdated, true);
      });
      test("When tap again on InsuranceInfoUpdate", () {
        service.toggleIsInsuranceInfo(false);
        expect(service.isInsuranceInfoUpdated, false);
      });
    });  

    group('InsuranceFormService@setInsuranceItemsList() should update or add item in list', () {
      test("Should add item in list", () {
        service.setInsuranceItemsList(tempAddedItem);
        expect(service.insuranceItems.length, 1);
        expect(service.insuranceItems[0].id, 12);
        expect(service.insuranceItems[0].qty, '12');
      });
      test("Should update item in list", () {
        service.setInsuranceItemsList(tempUpdatedItem,isEdit: true);
        expect(service.insuranceItems.length, 1);
        expect(service.insuranceItems[0].id, 15);
        expect(service.insuranceItems[0].qty, '23');
      });
    });  

    test("InsuranceFormService@deleteItem() should delete item from list", () {
      service.deleteItem(0);
      expect(service.insuranceItems.length, 0);
    });

    test("InsuranceFormService@reapplyMeasurement() should return applied measurement values in qty", () {
      service.insuranceItems = [tempAddedItem];
      service.measurement = tempMeasurement;
      service.reapplyMeasurement();
      expect(service.insuranceItems[0].qty, '400.0');
    });

    test("InsuranceFormService@discardMeasurement() should return qty that present before applied measurement", () {
      service.discardMeasurement();
      expect(service.insuranceItems[0].qty, '12');
    });

    group('InsuranceFormService@calculateValues() should do calculation on item values & return total' , () {
      service.calculateValues();
      test("Should return sum of RCV of all items", () { 
        expect(service.totalRCV, 156.0);
      });
      test("Should return sum of ACV of all items", () {
        expect(service.totalACV, 106.0);
      });
      test("Should return sum of depreciation of all items", () {
        expect(service.totalDeprecation, 50);
      });
      test("Should return sum of tax of all items", () {
        expect(service.totalTax, 12.0);
      });

    });

    test("InsuranceFormService@getRCV() should return rcv  from price , quantity & tax", () { 
      service.getRCV(service.insuranceItems.first);
        expect(service.insuranceItems.first.rcv, '156');
      });

});
}