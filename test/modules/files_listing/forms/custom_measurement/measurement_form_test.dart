import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/measurement_type.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/core/constants/measurement_constant.dart';
import 'package:jobprogress/modules/files_listing/forms/custom_measurement/measurement_form/controller.dart';

void main() {
  MeasurementFormController controller = MeasurementFormController();

  List<MeasurementDataModel> measurementList = [
    MeasurementDataModel(
      id: 1,
      name: 'Application',
      attributes: [
        MeasurementAttributeModel(id: 2, name: 'Square ft.',value: '10'),
        MeasurementAttributeModel(id: 3, name: 'cube ft.', value: ''),
        MeasurementAttributeModel(id: 4, name: 'Ft.', value: '30' ),
        MeasurementAttributeModel(id: 5, name: 'Meta ft.', value: '',
        subAttributes: [
          MeasurementAttributeModel(id: 7, name:'Square cm', value: '10'),
          MeasurementAttributeModel(id: 8, name: 'Meta ft', value: '15'),
        ]
        ),
        MeasurementAttributeModel(
          id: 6, 
          name: 'Feet', 
          value: '' 
        ),
      ]
    ),
    MeasurementDataModel(
      id: 10,
      attributes: [
        MeasurementAttributeModel(id: 10, name: '15', value: ''),
      ]
    ),
  ];

  MeasurementDataModel modifiedMeasurement = 
    MeasurementDataModel(
      id: 1,
      name: 'Application',
      attributes: [
        MeasurementAttributeModel(id: 2, name: 'Square ft.',value: '15'),
        MeasurementAttributeModel(id: 3, name: 'cube ft.', value: '18'),
        MeasurementAttributeModel(id: 4, name: 'Ft.', value: '87' ),
        MeasurementAttributeModel(id: 5, name: 'Meta ft.', value: '15',
        subAttributes: [
          MeasurementAttributeModel(id: 7, name:'Square cm', value: '85'),
          MeasurementAttributeModel(id: 8, name: 'Meta ft', value: '48'),
        ]
        ),
        MeasurementAttributeModel(
          id:6, 
          name: 'Feet', 
          value: '33' 
        ),
      ]
    );
   
  setUpAll(() {
    controller.initForm();
  });

  test('MeasurementFormController should be initialized with correct values', () {
    expect(controller.isSavingForm, false);
    expect(controller.isLoading, true);
    expect(controller.jobId, null);
    expect(controller.measurementList.length, 0);
    expect(controller.initialMeasurementList.length, 0);
    expect(controller.measurement, null);
    expect(controller.measurementId, null);
    expect(controller.jobId, null);
    expect(controller.isEdit, false);
    expect(controller.controllerList.length, 0);
  });

  test('MeasurementFormController@addNameAttribute() should add a attribute with name in list of attributes', (){
    controller.measurementList = measurementList;
    controller.addNameAttribute();
    expect(controller.measurementList[0].attributes![0].name, 'Name');
  });

  test('MeasurementFormController@initInputBoxController() should initialized input box with values present in measurement', () {
    controller.measurementList = measurementList;
    controller.initInputBoxController();
    expect(controller.controllerList.length, 10);
    expect(controller.controllerList['2']!.text, '10');
    expect(controller.controllerList['3']!.text, '');
    expect(controller.controllerList['4']!.text, '30');
    expect(controller.controllerList['5']!.text, '');
    expect(controller.controllerList['6']!.text, '');
    expect(controller.controllerList['7']!.text, '10');
    expect(controller.controllerList['8']!.text, '15');
    expect(controller.controllerList['-1']!.text, '');
    expect(controller.controllerList['-2']!.text, '');
    expect(controller.controllerList['10']!.text, '');
  });
  
  group('MeasurementFormController@isDataModified() should check wheter data is modified or not', () {
    test('When data is not modified', () => {
      expect(controller.isDataModified(measurementList: measurementList), false),
    });

    test('When data is modified', () => {
      controller.controllerList['2']!.controller.text = '55',
      expect(controller.isDataModified(measurementList: measurementList), true),
    });
  });

  test('MeasurementFormController@updateInputBoxFromMeasurement() should update data in input boxes from measurement data', () {
    
    controller.updateInputBoxFromMeasurement(modifiedMeasurement);
    
    expect(controller.controllerList['2']!.text, '15');
    expect(controller.controllerList['3']!.text, '18');
    expect(controller.controllerList['4']!.text, '87');
    expect(controller.controllerList['5']!.text, '15');
    expect(controller.controllerList['7']!.text, '85');
    expect(controller.controllerList['8']!.text, '48');
    expect(controller.controllerList['6']!.text, '33');
  });

  test('MeasurementFormController@saveMeasurementListFormInputBox() should update data in measurementList from input boxes', (){
    controller.controllerList['2']!.text = '15';
    controller.controllerList['3']!.text= '18';
    controller.controllerList['4']!.text= '87';
    controller.controllerList['5']!.text= '15';
    controller.controllerList['7']!.text= '85';
    controller.controllerList['8']!.text= '48';
    controller.controllerList['6']!.text= '33';
    controller.controllerList['10']?.text = '18';
    
    controller.saveMeasurementListFormInputBox(measurementList);
    
    expect(measurementList[0].attributes![0].value, '');
    expect(measurementList[0].attributes![1].value, '15');
    expect(measurementList[0].attributes![2].value, '18');
    expect(measurementList[0].attributes![3].value, '87');
    expect(measurementList[0].attributes![4].value, '15');
    expect(measurementList[0].attributes![4].subAttributes![0].value, '85');
    expect(measurementList[0].attributes![4].subAttributes![1].value, '48');
    expect(measurementList[1].attributes![0].value, '');
    expect(measurementList[1].attributes![1].value, '18');
  });

  test('MeasurementFormController@saveMeasurementFromInputBox() should save data in measurement from input boxes',(){
    controller.controllerList['2']!.text = '18';
    controller.controllerList['3']!.text= '85';
    controller.controllerList['4']!.text= '26';
    controller.controllerList['5']!.text= '15';
    controller.controllerList['7']!.text= '15';
    controller.controllerList['8']!.text= '48';
    controller.controllerList['6']!.text= '33';
    
    controller.saveMeasurementFromInputBox(modifiedMeasurement);
    
    expect(modifiedMeasurement.attributes![0].value, '18');
    expect(modifiedMeasurement.attributes![1].value, '85');
    expect(modifiedMeasurement.attributes![2].value, '26');
    expect(modifiedMeasurement.attributes![3].value, '15');
    expect(modifiedMeasurement.attributes![3].subAttributes![0].value, '15');
    expect(modifiedMeasurement.attributes![3].subAttributes![1].value, '48');
  });

  group('MeasurementFormController@isHoverWasteFactorSuggestionApplied', () {
    setUpAll(() {
      controller.measurement = MeasurementModel();
    });

    test('When measurement has no hover waste factor field and it is not applied', () {
      controller.hoverJobId = null;
      controller.measurement?.isHoverWasteFactor = false;
      controller.measurement?.type = '';
      expect(controller.isHoverWasteFactorSuggestionApplied(''), isFalse);
    });

    test('When measurement has hover waste factor field and its already applied', () {
      controller.hoverJobId = 1;
      controller.measurement?.isHoverWasteFactor = true;
      controller.measurement?.type = MeasurementType.hover.name;
      expect(controller.isHoverWasteFactorSuggestionApplied(MeasurementConstant.roofing), isTrue);
    });
  });

  group('MeasurementFormController@isHoverWasteFactorExist', () {
    setUpAll(() {
      controller.measurement = MeasurementModel();
    });

    test('When measurement has hover waste factor field', () {
      controller.hoverJobId = 1;
      controller.measurement?.isHoverWasteFactor = true;
      controller.measurement?.type = MeasurementType.hover.name;
      controller.measurement?.measurements = [
        MeasurementDataModel(name: MeasurementConstant.roofing,
            values: [[
              MeasurementAttributeModel(
                  id: 1,
                  thirdPartyAttributeEditable: true
              )
            ]]
        ),
      ];
      expect(controller.isHoverWasteFactorExist(MeasurementConstant.roofing), isTrue);
    });
  });

  group('MeasurementFormController@isSystemMeasurement', () {
    setUpAll(() {
      controller.measurement = MeasurementModel();
    });

    test('When measurement type is eagleView', () {
      controller.measurement?.type = MeasurementConstant.eagleView;
      expect(controller.isSystemMeasurement(), true);
    });

    test('When measurement type is hover', () {
      controller.measurement?.type = MeasurementConstant.hover;
      expect(controller.isSystemMeasurement(), true);
    });

    test('When measurement type is quickMeasure', () {
      controller.measurement?.type = MeasurementConstant.quickMeasure;
      expect(controller.isSystemMeasurement(), true);
    });

    test('When measurement type is not eagleView, hover, or quickMeasure', () {
      controller.measurement?.type = 'otherType';
      expect(controller.isSystemMeasurement(), false);
    });
  });

  group('MeasurementFormController@isWasteFactor', () {
    setUpAll(() {
      controller.measurement = MeasurementModel();
    });

    test('When measurementName is "roofing" and isSystem is true', () {
      controller.measurement?.type = MeasurementConstant.eagleView;
      expect(controller.isWasteFactor(MeasurementConstant.roofing), true);
    });

    test('When measurementName is not "roofing" and isSystem is true', () {
      controller.measurement?.type = MeasurementConstant.eagleView;
      expect(controller.isWasteFactor('nonRoofing'), false);
    });

    test('When isSystem is false', () {
      controller.measurement?.type = 'otherType';
      expect(controller.isWasteFactor(MeasurementConstant.roofing), false);
    });
  });
}