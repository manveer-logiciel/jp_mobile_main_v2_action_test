
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_option_fields.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/modules/appointment_details/widgets/result_options_dialog/controller.dart';

void main() {

  List<AppointmentResultOptionsModel> resultOptions = resultOptionsList;

  AppointmentModel appointment = AppointmentModel(
    id: 1
  );

  final controller = AppointmentResultOptionsDialogController(
    resultOptions,
    appointment
  );

  test('AppointmentResultOptionsDialogController should be initialized with following values', () {
    expect(controller.appointment, appointment);
    expect(controller.resultOptions, resultOptions);
    expect(controller.isLoading, false);
    expect(controller.fieldsFilter.isEmpty, true);
    expect(controller.selectedFilter, '');
  });

  group('Filter dialog should loaded with available filters', () {

    test('While adding for the first time, very first option should be selected', () {
      controller.setUpFieldsFilter();
      expect(controller.fieldsFilter.length, resultOptions.length);
      expect(controller.selectedFilter, '1');
    });

    test('While appointment results exist, filter having data should be selected', () {
      controller.appointment.resultOption = resultOptions[1];
      controller.fieldsFilter.clear();
      controller.setUpFieldsFilter();
      expect(controller.fieldsFilter.length, 2);
      expect(controller.selectedFilter, '2');
    });

  });

  test('Fields should update on updating appointment options', () {
    controller.updateFields('1');
    expect(controller.selectedFilter, '1');
    expect(controller.fieldsList.length, 2);

    controller.updateFields('2');
    expect(controller.selectedFilter, '2');
    expect(controller.fieldsList.length, 3);
  });

  test('toggleIsLoading() should update loading state', () {
    controller.toggleIsLoading();
    expect(controller.isLoading, true);
    controller.toggleIsLoading();
    expect(controller.isLoading, false);
  });

}

final resultOptionsList = <AppointmentResultOptionsModel>[

  AppointmentResultOptionsModel(
    name: '1',
    id: 1,
    isActive: true,
    fields: <AppointmentResultOptionFieldModel>[
      AppointmentResultOptionFieldModel(
        name: '1',
        type: 'textarea',
        value: '',
        controller: TextEditingController(),
      ),
      AppointmentResultOptionFieldModel(
        name: '2',
        value: '',
        controller: TextEditingController(),
      ),
    ]
  ),
  AppointmentResultOptionsModel(
    name: '2',
    id: 2,
    isActive: true,
    fields: <AppointmentResultOptionFieldModel>[
      AppointmentResultOptionFieldModel(
        name: '3',
        type: 'textarea',
        value: '',
        controller: TextEditingController(),
      ),
      AppointmentResultOptionFieldModel(
        name: '4',
        value: '',
        controller: TextEditingController(),
      ),
      AppointmentResultOptionFieldModel(
        name: '5',
        value: '',
        controller: TextEditingController(),
      ),
    ]
  ),

];