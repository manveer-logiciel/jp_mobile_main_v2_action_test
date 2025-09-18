import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/email/suggestion.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/ChipsInput/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/utils/helpers.dart';


/// CreateAppointmentFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
/// - Helps in comparing form data
class CreateAppointmentFormData {

  CreateAppointmentFormData({
    required this.update,
    required this.customerModel, 
    required this.appointmentModel,
    this.pageType});

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  AppointmentModel? appointmentModel; // used to set up form data
  CustomerModel? customerModel; // used to set up form data
  final AppointmentFormType? pageType; // pagetype

  // form field controllers
  JPInputBoxController customerController = JPInputBoxController();
  JPInputBoxController jobController = JPInputBoxController();
  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController appointmentForController = JPInputBoxController();
  JPInputBoxController attendeesController = JPInputBoxController();
  JPInputBoxController notesController = JPInputBoxController();
  JPInputBoxController dateTimeController = JPInputBoxController();
  JPInputBoxController recurringController = JPInputBoxController(text: 'does_not_repeat'.tr.capitalizeFirst.toString());
  JPInputBoxController locationController = JPInputBoxController();
  JPInputBoxController locationTypeController = JPInputBoxController(text: 'other'.tr.capitalize.toString());
  JPInputBoxController additionalRecipientsController = JPInputBoxController();

  // form toggles
  bool isAllDayReminderSelected = false;
  bool isRecurringSelected = false;
  bool isLoading = true;
  bool isUserNotificationSelected = false;

  // form string type
  String? startDateTime = DateTime.now().toString();
  String? endDateTime = DateTime.now().add(const Duration(hours: 1)).toString();
  String selectedRecurringType = DropdownListConstants.recurringDurationList.first.id;
  String? errorText;

  // models
  JobModel? jobModel; // used to store selected job data
  RecurringEmailModel? recurringEmail; 

  // selected id's
  String selectedAppointmentForId = '';
  String selectedLocationType = 'other';
  String selectCurrentadditionalRecipients = '';
  String selectedRecurringValue = 'does_not_repeat';
  String jobLocation = '';
  String customerLocation = '';
  String impactType = '';

  // lists
  List<JPSingleSelectModel> appointmentForList = []; // contains users beings display to appointment for 
  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user
  List<AttachmentResourceModel> uploadedAttachments = []; // contains attachments coming from server
  List<JPMultiSelectModel> attendeesUsers = []; // used to store users and display in attendies
  List<JPMultiSelectModel> tagList = []; 
  List<JPMultiSelectModel> selectedJobList = []; // used to store jobs and display in selected jobs
  List<JPMultiSelectModel> selectedadditionalRecipients  = []; // used to store selected additional recipients
  List<JPMultiSelectModel> additionalRecipientsList = []; // used to store additional recipients list
  List<ReminderModel> notificationReminders = []; // used to store notification remainder list
  List<JobModel> jobModelList=[]; // used to store jobs of tipe jobModel list 
  // location type list
  List<JPSingleSelectModel> locationTypeList = [
    JPSingleSelectModel(id: 'other', label: 'other'.tr.capitalizeFirst!),
  ]; 
  // recurring list
  List<JPSingleSelectModel> recurringList = [
    JPSingleSelectModel(id: 'does_not_repeat', label: 'does_not_repeat'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'custom', label: 'custom'.tr.capitalizeFirst!),
  ];

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // suggestion list data
  List<String>  to =[]; // used to store in string type
  List<EmailProfileDetail> initialToValues = []; // used to store additional recipients on suggestion
  final suggestionBuilderKey = GlobalKey<JPChipsInputState<dynamic>>();
  EmailSuggestionModel? emailSuggestionModel;
  List<EmailProfileDetail>? suggestionList;

  // // setFormData(): set-up form data to be pre-filled in form
  void setFormData() {
    if((pageType == AppointmentFormType.createForm || pageType == AppointmentFormType.createJobAppointmentForm)
      && !FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement])
    ) {
      appointmentForController.text = AuthService.userDetails!.fullName;
      selectedAppointmentForId = AuthService.userDetails!.id.toString();
    }
    if(customerModel != null) {
      customerController.text = customerModel!.fullName!;
      setAppointmentFor(customerModel);
    }
    if (appointmentModel != null) {
      // Setting customer details
      if(appointmentModel!.customer != null){
        customerModel = appointmentModel!.customer;
        customerController.text = appointmentModel!.customer!.fullName!;}

      // Setting job details
      if(appointmentModel!.job != null && appointmentModel!.job!.isNotEmpty){
        jobModel = appointmentModel!.job!.first;
        jobModelList = appointmentModel!.job ?? [];
        selectedJobList = FormValueSelectorService.parseJobsListToMultiselect(appointmentModel!.job!);}
        setAppointmentFor(jobModel?.customer);

      // Setting appointment details title
      if(appointmentModel!.title != null) titleController.text = appointmentModel!.title!;

      // Setting appointment for details
      if (appointmentModel!.user != null) {
        final JPSingleSelectModel? singleSelectModel = appointmentForList.firstWhereOrNull((element) => element.label == appointmentModel!.user!.fullName);
        if(singleSelectModel != null) {
          appointmentForController.text = singleSelectModel.label;
          selectedAppointmentForId = singleSelectModel.id;
        }
      }

      // Setting recurring 
      recurringEmail = RecurringEmailModel(
        occurrence: appointmentModel!.occurrence,
        interval: appointmentModel!.interval,
        repeat: appointmentModel!.repeat,
        untilDate: appointmentModel!.untilDate ?? '',
        startDateTime: appointmentModel!.startDateTime ?? '',
        byDay: appointmentModel!.byDay,
        endDateTime: appointmentModel!.endDateTime ?? '',
       );

      if(RecurringService.getRecOption(recurringEmail) != null) {
      recurringController.text = RecurringService.getRecOption(recurringEmail);
      recurringList.insert(2,JPSingleSelectModel(label: RecurringService.getRecOption(recurringEmail), id: '0'));
      selectedRecurringValue = recurringList[2].id;
      isRecurringSelected = true;
      }

      // Setting description 
      if(appointmentModel!.description != null) notesController.text = appointmentModel!.description!;

      // Setting all day
      isAllDayReminderSelected = appointmentModel!.isAllDay;

      // Setting date and time
      startDateTime = DateTime.parse(DateTimeHelper.formatDate(appointmentModel?.startDateTime ?? DateTime.now().toString(), DateFormatConstants.dateTimeServerFormat)).toString();
      endDateTime = DateTime.parse(DateTimeHelper.formatDate(appointmentModel?.endDateTime ?? DateTime.now().add(const Duration(hours: 1)).toString(), DateFormatConstants.dateTimeServerFormat)).toString();

      // Setting location 
      locationController.text = appointmentModel!.location!;
      
      // Setting location type
      if(appointmentModel!.locationType! == 'customer'){
        locationTypeList.add(JPSingleSelectModel(id: 'customer', label: 'customer'.tr.capitalizeFirst!));
        customerLocation = appointmentModel!.location!.capitalizeFirst!;
        selectedLocationType = 'customer';
      } else if(appointmentModel!.locationType! == 'job'){
        locationTypeList.add(JPSingleSelectModel(id: 'customer', label: 'customer'.tr.capitalizeFirst!));
        customerLocation = appointmentModel!.location!;
        locationTypeList.add(JPSingleSelectModel(id: 'job', label: 'job'.tr.capitalizeFirst!));
        jobLocation = appointmentModel!.location!;
        selectedLocationType = 'job';
      } else{
        selectedLocationType = locationTypeList.where((element) => element.id == 'other').first.id;
      }
      locationTypeController.text = locationTypeList.where((element) => element.id == selectedLocationType).first.label.capitalizeFirst!;

      // setting additional recipients
      if(appointmentModel!.invites != null) { to = appointmentModel!.invites!;}
      for(int i=0;i<to.length;i++){
      initialToValues.add(EmailProfileDetail(name: to[i], email: to[i]));}

      // Setting notification 
      notificationReminders.addAll(appointmentModel!.reminders ?? []);
      isUserNotificationSelected = notificationReminders.isNotEmpty;

      // Setting up attachment section
      uploadedAttachments.addAll(appointmentModel?.attachments ?? []);
      attachments.addAll(uploadedAttachments);
      update();
    } else {
      // Set default values when appointment model is null
      setDefaultTitle();
      setDefaultLocation();
    }

    if(pageType != AppointmentFormType.duplicateForm) {
      initialJson = appointmentFormJson();
    }
  }

  // get default values
  // setting title
  void setDefaultTitle(){
    titleController.text = '';
    String title = '';
    List<String> tempString = [];


    String? city = customerModel?.address?.city;
    if (Helper.isValueNullOrEmpty(city)) {
      city = jobModel?.address?.city;
    }

    if(customerModel != null){
      title = Helper.isValueNullOrEmpty(customerModel?.lastName) ?
      customerModel?.firstName ?? '' : customerModel?.lastName ?? '';
      if(!Helper.isValueNullOrEmpty(city)) {
        title = '$title / City: ${city ?? ""}';
      }
    }
    if(jobModelList.isNotEmpty && customerModel != null){
      for(int i = 0; i < jobModelList.length; i++){
        String titleString = '';
        if(!Helper.isValueNullOrEmpty(customerModel?.address?.address) &&
            jobModelList[i].address!.city! == city &&
            !Helper.isValueNullOrEmpty(jobModelList[i].altId)
        ) {
          titleString = ' / Job # ${jobModelList[i].altId!}';
        } else {
          String tradeString = '';
          jobModelList[i].tradesString.split(',').forEach((element) {
            tradeString += ' / $element';
          });
          if(!Helper.isValueNullOrEmpty(jobModelList[i].altId) && Helper.isValueNullOrEmpty(jobModelList[i].address?.city)) {
            titleString = '$tradeString / Job # ${jobModelList[i].altId!}';
          } else if(Helper.isValueNullOrEmpty(jobModelList[i].altId) && !Helper.isValueNullOrEmpty(jobModelList[i].address?.city) && jobModelList[i].address!.city! != city ) {
            titleString = ' / City: ${jobModelList[i].address!.city!}$tradeString';
          } else if(!Helper.isValueNullOrEmpty(jobModelList[i].altId) && !Helper.isValueNullOrEmpty(jobModelList[i].address?.city)) {
            titleString =  ' / City: ${jobModelList[i].address!.city!}$tradeString / Job # ${jobModelList[i].altId!}';
          } else {
            titleString = tradeString;
          }
        }
        tempString.add(titleString);
      }
    }

    for( int i=0;i<tempString.length;i++){
      title =  title + tempString[i];
    }

    titleController.text = title;
  }

  // setting location
  void setDefaultLocation(){
    String currentCustomerLocation = '';
    String currentJobLocation = '';
    List<String> tempString = [];

    if(customerModel != null){
      if(customerModel!.address != null) {
        currentCustomerLocation = Helper.convertAddress(customerModel!.address!);
        customerLocation = currentCustomerLocation;
      }
    }

    if(jobModelList.isNotEmpty){
      tempString.add(Helper.convertAddress(jobModelList.first.address) );
      currentJobLocation = tempString[0];
      jobLocation = currentJobLocation;
    }

    if(jobLocation == '' && customerLocation != ''){
      locationController.text = customerLocation;
      locationTypeController.text = 'customer'.tr.capitalizeFirst.toString();
    } else if(jobLocation != '') {
      locationController.text = jobLocation;
      locationTypeController.text = 'job'.tr.capitalizeFirst.toString();
    } else {
     if(locationTypeController.text.isEmpty) {
       locationTypeController.text = 'other'.tr.capitalizeFirst.toString();
     }
    }

      selectedLocationType = locationTypeController.text.toLowerCase();
      if(!locationTypeList.any((element) => element.label == selectedLocationType.capitalizeFirst)) {
        locationTypeList.add(JPSingleSelectModel(label: locationTypeController.text, id: locationTypeController.text.toLowerCase()));
      }
  }

  void setAppointmentFor(CustomerModel? customer) {
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]) && pageType != AppointmentFormType.editForm) {
      appointmentForController.text = customer?.rep?.fullName ?? '';
      selectedAppointmentForId = customer?.rep?.id.toString() ?? '';
    }
  }

  // // appointmentFormJson(): provides json to stores on server while submitting form
  Map<String, dynamic> appointmentFormJson() {
    final Map<String, dynamic> data = {};

    if(appointmentModel != null) {
      data['id'] = appointmentModel!.id.toString();
    }

    // Adding customer id 
    if(customerModel != null){
      data['customer_id'] = customerModel!.id;
    }

    // Adding list of jobs id's
    if(selectedJobList.isNotEmpty) {
      data['job_ids'] = FormValueParser.multiSelectToSelectedIds(selectedJobList);
    }

    // Adding title 
    if(titleController.text.isNotEmpty){
      data['title'] = titleController.text;
    }

    // Appointment for id
    if(appointmentForController.text.isNotEmpty){
      data['user_id'] = appointmentForList.where((element) => element.label == appointmentForController.text).first.id;
    }

    // Adding full day or not
    data['full_day'] = isAllDayReminderSelected ? 1 : 0;

    // Adding remainder time and date
    if(isAllDayReminderSelected) {
      data['date'] = DateTimeHelper.format(startDateTime.toString(), DateFormatConstants.dateTimeServerFormat);
    } else if((startDateTime?.isNotEmpty ?? false) && (endDateTime?.isNotEmpty ?? false)) {
      data['start_date_time'] = DateTimeHelper.format(startDateTime, DateFormatConstants.dateTimeServerFormat);
      data['end_date_time'] = DateTimeHelper.format(endDateTime, DateFormatConstants.dateTimeServerFormat);
    }

    // Recurring occurence
    if(recurringController.text.isNotEmpty && recurringEmail != null) {
      data['occurence'] = recurringEmail!.occurrence;
      data['interval'] = recurringEmail!.interval;
      data['until_date'] = recurringEmail!.untilDate;
      data['repeat'] = recurringEmail!.repeat;
      data['by_day'] = recurringEmail!.byDay ?? [];
    }

    // select impact type
    if(isRecurringSelected && pageType == AppointmentFormType.editForm) {
    data['impact_type'] = impactType;}

    // Adding attendees users
    if(attendeesController.text.isNotEmpty && attendeesUsers.isNotEmpty){
      data['attendees'] = FormValueParser.multiSelectToSelectedIds(attendeesUsers);
    }

    // Adding notes 
    if(notesController.text.isNotEmpty){
      data['description'] = notesController.text;
    }

    // Adding location 
    if(locationController.text.isNotEmpty){
      data['location'] = locationController.text;
    }

    // Adding location type
    if(locationTypeController.text.isNotEmpty){
      if(locationTypeList.where((element) => element.label == locationTypeController.text).isNotEmpty){
        data['location_type'] = locationTypeList.where((element) => element.label == locationTypeController.text).first.id;
      } else {
         data['location_type'] = locationTypeController.text;
      }
    }

    // Adding additional recipients
    if(initialToValues.isNotEmpty) {
      data['invites'] =  initialToValues.map((inivite) => inivite.email).toList();  
    }

    // Adding user notification
    if(isUserNotificationSelected) {
      data['reminders'] = notificationReminders.map((reminder) => {
        'type' : reminder.type,
        'minutes' : reminder.minutes
      }).toList();
    }

    // Attachments section
    if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

      List<AttachmentResourceModel> attachmentsToUpload = [];
      List<AttachmentResourceModel> attachmentsToDelete = [];

      attachmentsToUpload = attachments.where((attachment) => !uploadedAttachments.contains(attachment)).toList();
      attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

      // Map attachments for API payload
      // Using attachment.type with fallback to "resource" for backward compatibility
      // Some attachments may have null type due to legacy data or when created without explicit type
      // The "resource" type is the default expected by the backend API
      data['attachments'] = attachmentsToUpload.map((attachment) => {
        'type': attachment.type ?? "resource",
        'value': attachment.id,
      }).toList();

      data['delete_attachments[]'] = attachmentsToDelete.map((attachment) => attachment.id).toList();
    }
    return data;
  }

  // // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = appointmentFormJson();
    return initialJson.toString() != currentJson.toString();
  }
}