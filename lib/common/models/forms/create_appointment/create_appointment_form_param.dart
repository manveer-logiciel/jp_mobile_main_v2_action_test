import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';

class CreateAppointmentFormParam {
  final CreateAppointmentFormController? controller;
  final AppointmentModel? appointment;
  final JobModel? jobModel;
  final CustomerModel? customerModel;
  final AppointmentFormType? pageType;
  final Function(dynamic val)? onUpdate;

  CreateAppointmentFormParam({
    this.controller,
    this.appointment,
    this.jobModel,
    this.customerModel,
    this.pageType,
    this.onUpdate
  });
}