
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/modules/appointment_details/controller.dart';

void main() {

  final controller = AppointmentDetailsController();
  AppointmentModel? tempAppointmentModel;

  setUpAll(() {
    controller.appointment = tempAppointmentModel = AppointmentModel(
      id: 1,
    );
    controller.appointmentId = controller.appointment!.id;
  });

  test('AppointmentDetailsController should be initialized with default values', () {
    expect(controller.appointment, tempAppointmentModel);
    expect(controller.isLoading, true);
    expect(controller.appointmentId, controller.appointment!.id);
    expect(controller.jobDetailsList.isEmpty, true);
    expect(controller.resultOptions.isEmpty, true);
  });

  test('Appointment should be loaded from server with params', () {

    Map<String, dynamic> params = {
      'id': controller.appointment!.id,
      'includes[0]': 'customer',
      'includes[1]': 'jobs',
      'includes[2]': 'attendees',
      'includes[3]': 'created_by',
      'includes[4]': 'reminders',
      'includes[5]': 'attachments',
      'includes[6]': 'result_option',
      'includes[7]': 'jobs.trades',
      'includes[8]': 'customer.address',
      'includes[9]': 'jobs.division'
    };

    expect(controller.getParams(), params);

  });

  group('Appointment result options have params when', () {

    test('There is not any appointment result stored before', () {
      Map<String, dynamic> params = {
        'active' : 1,
        'limit' : 0,
      };
      expect(controller.getRequestOptionParams(), params);
    });

    test('Editing appointment result', () {
      controller.appointment!.resultOptionIds = ['1','2'];
      Map<String, dynamic> params = {
        'ids[]' : controller.appointment!.resultOptionIds,
        'limit' : 0,
      };
      expect(controller.getRequestOptionParams(), params);
    });

  });

  group('Appointment status should be updated with params', () {

    test('When appointment is not completed', () {
      Map<String, dynamic> params = {
        'id' : controller.appointment!.id,
        'impact_type' : 'only_this',
        'is_completed' : 1
      };
      expect(controller.getMarkAsCompletedParams(), params);
    });

    test('When appointment is already marked as completed', () {
      controller.appointment!.isCompleted = true;
      Map<String, dynamic> params = {
        'id' : controller.appointment!.id,
        'impact_type' : 'only_this',
        'is_completed' : 0
      };
      expect(controller.getMarkAsCompletedParams(), params);
    });

  });

  group('Details list should be constructed with correct values', () {

    test('When no details are available', (){
      final list = controller.getDetailsList();
      expect(list.isEmpty, true);
    });

    test('When customer phones are available', (){
      controller.appointment!.customer = CustomerModel(
        phones: <PhoneModel>[
          PhoneModel(number: '1'),
          PhoneModel(number: '2'),
          PhoneModel(number: '3'),
        ]
      );
      final list = controller.getDetailsList();
      expect(list.length, 3);
    });

    test('When invites are available', (){
      controller.appointment!.invites = ['1', '2'];
      final list = controller.getDetailsList();
      expect(list.length, 4);
    });

    test('When user is available', (){
      controller.appointment!.user = UserModel(
          id: 3,
          firstName: '',
          fullName: '',
          email: '',
      );
      final list = controller.getDetailsList();
      expect(list.length, 5);
    });

  });

}