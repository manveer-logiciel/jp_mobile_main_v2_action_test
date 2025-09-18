import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/add_multiple_measurement/controller.dart';

void main() {

  AddMultipleMeasurementController controller = AddMultipleMeasurementController();
  
  MeasurementDataModel measurement = MeasurementDataModel(
    attributes: [MeasurementAttributeModel()],
    values: [
      [
        MeasurementAttributeModel(id: 2, name: 'gaj' , value: '12'),
        MeasurementAttributeModel(id: 3, name: 'kila', value: '2'),
        MeasurementAttributeModel(id: 4, name: 'marla', value: ''),
        MeasurementAttributeModel(
          id: 5, 
          name: 'Bega', 
          value: null,
          subAttributes: [
            MeasurementAttributeModel( id: 85, name: 'akead', value:''),
            MeasurementAttributeModel(id: 86, name: 'wekad', value: null),
            MeasurementAttributeModel(id: 87, name: 'tekad', value: '18')
          ] 
        )
      ],
      [
        MeasurementAttributeModel(id: 2, name: 'gaj' , value: '20'),
        MeasurementAttributeModel(id: 3, name: 'kila', value: '25'),
        MeasurementAttributeModel(id: 4, name: 'marla', value: ''),
        MeasurementAttributeModel(
          id: 5, 
          name: 'Bega', 
          value: null,
          subAttributes: [
            MeasurementAttributeModel( id: 85, name: 'akead', value:''),
            MeasurementAttributeModel(id: 86, name: 'wekad', value: null),
            MeasurementAttributeModel(id: 87, name: 'tekad', value: '18')
          ] 
        )
      ] 
    ],
  );

  test('MeasurementFormController should be initialized with correct values', () {
    expect(controller.isEdit, false);
    expect(controller.totalMeasurement, null);
    expect(controller.controllerList.length, 0);
    expect(controller.initialMeasurement, null);
  });

  test('MeasurementFormController@addNewMeasurement() should add new measuremnt values with same name but empty values', () {
    
    controller.measurement = measurement;
    controller.initialMeasurement = MeasurementDataModel.copy(measurement);
    
    controller.addNewMeasurement();
    
    expect(controller.measurement.values!.length,3);
    expect(controller.measurement.values![2][0].name, 'gaj');
    expect(controller.measurement.values![2][0].value, '');
    expect(controller.measurement.values![2][1].name, 'kila');
    expect(controller.measurement.values![2][1].value, '');
    expect(controller.measurement.values![2][2].name, 'marla');
    expect(controller.measurement.values![2][2].value, '');
    expect(controller.measurement.values![2][3].name, 'Bega');
    expect(controller.measurement.values![2][3].value, '');
  });

  test('MeasurementFormController@getEmptyMeasurement() should return new measuremnt values with same name but empty values', () {
    
    List<MeasurementAttributeModel> emptyMeasurement =  controller.getEmptyMeasurement();
    
    expect(emptyMeasurement[0].name, 'gaj');
    expect(emptyMeasurement[0].value, '');
    expect(emptyMeasurement[1].name, 'kila');
    expect(emptyMeasurement[1].value, '');
    expect(emptyMeasurement[2].name, 'marla');
    expect(emptyMeasurement[2].value, '');
    expect(emptyMeasurement[3].name, 'Bega');
    expect(emptyMeasurement[3].value, '');
  });

  test('MeasurementFormController@initInputBoxController() should filled measurement values in inputbox controller', () {
    
    controller.initInputBoxController(0);
    
    expect(controller.controllerList.length, 7);
    expect(controller.controllerList['2']!.text, '12');
    expect(controller.controllerList['3']!.text, '2');
    expect(controller.controllerList['4']!.text, '');
    expect(controller.controllerList['5']!.text, '');
  });

  test("MeasurementFormController@calculateTotal() should  do total of  list of values 's element", (){
    
    controller.calculateTotal();
    
    expect(controller.totalMeasurement![0].value, '32');
    expect(controller.totalMeasurement![1].value, '27');
    expect(controller.totalMeasurement![2].value, '');
    expect(controller.totalMeasurement![3].value, '');
  });

  test("MeasurementFormController@removeMeasurement() should remove value from measurements's value list ", () {
    
    controller.removeMeasurement(2);
    
    expect(controller.measurement.values!.length, 2);
  });

  test('MeasurementFormController@assignControllerDataToMeasurement() should filled data in measuremnt  from inputbox controller', () {
    
    controller.controllerList['2']!.text = '55';
    
    controller.assignControllerDataToMeasurement(0);
    
    expect(measurement.values![0][0].value, '55');
    expect(measurement.values![0][1].value, '2');
    expect(measurement.values![0][2].value,'');
    expect(measurement.values![0][3].value, null);
  });

  group('MeasurementFormController@isBottomSheetDataModified() should check whether value is updated or not in input boxes', () { 
    test('When no data changes',() { 
      expect(controller.isBottomSheetDataModified(MeasurementDataModel(attributes:measurement.values![0])), false);
    });
    test('When data changes', () {
      controller.controllerList['2']!.controller.text = '15';
      expect(controller.isBottomSheetDataModified(MeasurementDataModel(attributes:measurement.values![0])), true);
    });
  });

  group('MeasurementFormController@isTableDataModified() should check whether value is updated or not in table', () { });
  test('When no data changes', () {
    controller.initialMeasurement = MeasurementDataModel.copy(measurement);
    expect(controller.isTableDataModified(), false);
  });

  test('When data changes', (){
    controller.measurement.values![0][1].value = '30';
    expect(controller.isTableDataModified(), true);  
  });
  
  group('MeasurementFormController@getSubAttributeValue() should check wheteher value is empty or null', () {
    test('When value is empty', () {
      String subAttributeValue = controller.getSubAttributeValue(0, 3, 0);
      expect(subAttributeValue, '--');
    });
    test('When value is null', (){
      String subAttributeValue = controller.getSubAttributeValue(0, 3, 1);
      expect(subAttributeValue, '--');
    });
    test('When value is not empty & also not null', (){
      String subAttributeValue = controller.getSubAttributeValue(0, 3, 2);
      expect(subAttributeValue, '18');
    });
  });
  
  group('MeasurementFormController@getSubAttributeTotal() should check wheteher value is empty or null', () {
    test('When value is empty', () {
      String subAttributeTotal = controller.getSubAttributeTotal(3, 0);
      expect(subAttributeTotal, '--');
    });

    test('When value is null', () {
      String subAttributeTotal = controller.getSubAttributeTotal(3, 1);
      expect(subAttributeTotal, '--');
    });

    test('When value is not null or empty', () {
      String subAttributeTotal = controller.getSubAttributeTotal(3, 2);
      expect(subAttributeTotal, '36');
    });
  });
  

  group('MeasurementFormController@getAttributeValue() should check wheteher value is null or empty', () {
    test('When value is empty', () {
      String attributeValue = controller.getAttributeValue(0, 3);
      expect(attributeValue, '--');
    });

    test('When value is null', () {
      String attributeValue = controller.getAttributeValue(0, 2);
      expect(attributeValue, '--');
    });

    test('When value is not null or empty', () {
      String attributeValue = controller.getAttributeValue(0, 1);
      expect(attributeValue, '30');
    });
  });

  group('MeasurementFormController@getAttributeTotal() should check wheteher value is null or empty', () { 
    test('When empty data', () {
      String attributeTotal = controller.getAttributeTotal(3);
      expect(attributeTotal, '--');
    });
    test('When null data present in attribute value property', () {
      String attributeTotal = controller.getAttributeTotal(2);
      expect(attributeTotal, '--');
    });
    test('When valid data present in attribute value property', () {
      String attributeTotal = controller.getAttributeTotal(1);
      expect(attributeTotal, '27');
    });
  });
    
  }