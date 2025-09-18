import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/appointments.dart';
import 'package:jobprogress/common/models/customer/customer.dart';

void main() {
  final customer = CustomerModel();

  group("CustomerModel@getAppointment should give appropriate appointment to be displayed on on customer tile", () {
    test("If there are no appointments, should return null", () {
      expect(customer.getAppointment(), null);
    });

    test("If there is any appointment for today only and not upcoming, should return that appointment", () {
      customer.appointments?.upcomingFirst = null;
      customer.appointments = CustomerAppointments(
        todayFirst: AppointmentModel()
      );
      expect(customer.getAppointment(), customer.appointments?.todayFirst);
    });

    test("If there is any appointment upcoming and not for today, should return that appointment", () {
      customer.appointments?.todayFirst = null;
      customer.appointments = CustomerAppointments(
        upcomingFirst: AppointmentModel()
      );
      expect(customer.getAppointment(), customer.appointments?.upcomingFirst);
    });

    test("If there is any appointment for today and upcoming, should prioritize today's appointment", () {
      customer.appointments = CustomerAppointments(
        todayFirst: AppointmentModel(),
        upcomingFirst: AppointmentModel()
      );
      expect(customer.getAppointment(), customer.appointments?.todayFirst);
    });
  });
}