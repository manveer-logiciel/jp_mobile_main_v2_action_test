
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment_param.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/appointments/filter_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  AppointmentListingParamModel filterKeys = AppointmentListingParamModel(
      date: 'date',
      duration: 'MTD',
      endDate: '2022-07-01',
      jobAltId: 'jobAltId',
      jobNumber: 'jobNumber',
      dateRangeType: ["appointment_duration_date"], 
      appointmentResultOption: ['4','246'],
      assignedTo: ['85','87'],
      createdBy: 1,
      limit: 20,
      location: 'location',
      page: 1,
      sortBy: 'created_at',
      sortOrder: 'desc',
      startDate: '2022-07-01',
      title:  'title'  
  );

  test('AppointmentsFilterController should be initialized with following values', (){

    final controller = AppointmentsFilterController(filterKeys);

    expect(controller.isResetButtonDisable, true);
    expect(controller.count, null);
    expect(controller.selectedUsers, null);
    expect(controller.selectedCreatedUser, null);
    expect(controller.selectedAppointmentResultList, null);
    expect(controller.selectedDurationTypeList, null);
    expect(controller.jobAltIdController.text, '');
    expect(controller.jobNumberController.text, '');
    expect(controller.locationController.text, '');
    expect(controller.durationTypeController.text, '');
    expect(controller.durationController.text, '');
    expect(controller.createdByController.text, '');
    expect(controller.appointmentResultController.text, '');
  });

  test('AppointmentsFilterController should be initialized with date params', () async {

    final controller = AppointmentsFilterController(filterKeys);
 
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month, 1);

    controller.setDuration();

    expect(controller.filterKeys.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
    expect(controller.filterKeys.endDate, DateTimeHelper.format(today, DateFormatConstants.dateServerFormat));

  });

  group('AppointmentsFilterController@SetDuration function should set start date and end date correctly', () {

    final controller = AppointmentsFilterController(filterKeys);
 
    final today = DateTime.now();
    test('In case of duration = WTD', () {
      controller.filterKeys.duration = 'WTD';
      controller.setDuration();

      controller.getDurationType('DurationType.wtd');
      final startDate = today.subtract(Duration(days: today.weekday));
      final endDate = today;

      expect(controller.filterKeys.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.filterKeys.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of duration = MTD', () {
      controller.filterKeys.duration = 'MTD';
      controller.setDuration();
      controller.getDurationType('DurationType.mtd');

      final startDate = DateTime(today.year, today.month, 1);
      final endDate = today;

      expect(controller.filterKeys.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.filterKeys.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of duration = YTD', () {
      controller.filterKeys.duration = "YTD";
      controller.setDuration();
      controller.getDurationType('DurationType.ytd');

      final startDate = DateTime(today.year, 1, 1);
      final endDate = today;

      expect(controller.filterKeys.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.filterKeys.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of duration = Last Month', () {
      controller.filterKeys.duration = 'last_month''';
      controller.setDuration();
      controller.getDurationType('DurationType.lastMonth');

      final startDate = DateTime(today.year, today.month - 1, 1);
      final endDate = today.subtract(Duration(days: today.day));

      expect(controller.filterKeys.startDate, DateTimeHelper.format(startDate, DateFormatConstants.dateServerFormat));
      expect(controller.filterKeys.endDate, DateTimeHelper.format(endDate, DateFormatConstants.dateServerFormat));

    });

    test('In case of duration = Since Inception', () {
      controller.filterKeys.duration = 'since_inception';
      controller.setDuration();
      controller.getDurationType('DurationType.sinceInception');

      expect(controller.filterKeys.duration, 'since_inception');
    });

  });
  
  test('AppointmentsFilterController@resetFunction should on these keys', () {

    final controller = AppointmentsFilterController(filterKeys);    

    controller.titleController.text = 'title';
    controller.jobAltIdController.text = 'job_alt_id';
    controller.jobNumberController.text = 'job_number';      
    controller.appointmentResultController.text = 'appointment';     
    controller.assignedToController.text = 'assigned_to';      
    controller.createdByController.text = 'createdby';      
    controller.durationTypeController.text = 'duration_list';      

    controller.resetFilterKeys();    

    expect(controller.titleController.text, '');   
    expect(controller.jobAltIdController.text, '');  
    expect(controller.jobNumberController.text, '');
    expect(controller.appointmentResultController.text, '');  
    expect(controller.assignedToController.text, 'assigned_to');
    expect(controller.createdByController.text, 'none');   
    expect(controller.durationTypeController.text, 'appointment_date');

    });

  group('AppointmentsFilterController should set input field text from selected filters', (){
    final controller = AppointmentsFilterController(filterKeys);

    List<JPMultiSelectModel> multiSelecteValue = [JPMultiSelectModel(id: '1', isSelect: true, label: 'user')];

    test('When single value is selected', () {
      String val = controller.getInputFieldText(multiSelecteValue);
      expect(val, 'user');
    });

    test('When multiple values are selected', () {
      String val = controller.getInputFieldText(multiSelecteValue + multiSelecteValue);
      expect(val, 'user, user');
    });

  });
}