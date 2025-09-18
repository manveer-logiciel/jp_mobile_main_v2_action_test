import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/enums/division_unmatch.dart';
import 'package:jobprogress/common/enums/recurring.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/forms/create_appointment/index.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/recurring_email.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/common/repositories/email.dart';
import 'package:jobprogress/common/services/appointment/get_recuring.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/division_unmatch/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/recurring_bottom_sheet/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

/// CreateAppointmentFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class CreateAppointmentFormService extends CreateAppointmentFormData {
  CreateAppointmentFormService(
      {required super.update,
      required this.validateForm,
      super.appointmentModel,
      super.customerModel,
      super.pageType});

  final VoidCallback validateForm; // helps in validating form when form data updates
  CreateAppointmentFormController? _controller; // helps in managing controller without passing object

  double weekNo = 0 ;
  String weekCount = '';
  CreateAppointmentFormController get controller => _controller ?? CreateAppointmentFormController();

  bool get doReFetchAppointment => pageType == AppointmentFormType.editForm
      || pageType == AppointmentFormType.duplicateForm;

  set controller(CreateAppointmentFormController value) {
    _controller = value;
  }

  /// Determines if the selected location type is 'other'
  /// 
  /// Returns true if the user has selected 'other' as the location type,
  /// which enables the custom location search functionality
  bool get isLocationTypeOther => selectedLocationType == 'other';

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
       if (doReFetchAppointment) await fetchAppointment();
       await setAllUsers(); // loading users from local DB
       setFormData();// filling form data
       if (pageType == AppointmentFormType.createJobAppointmentForm) {
         onJobSelected(jobModelList);
       }

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  Future<void> fetchAppointment() async {
    try {
      final params = {
        'id': appointmentModel?.id,
        'includes[0]': 'customer',
        'includes[1]': 'jobs',
        'includes[2]': 'attendees',
        'includes[3]': 'created_by',
        'includes[4]': 'reminders',
        'includes[5]': 'attachments',
        'includes[6]': 'result_option',
        'includes[7]': 'jobs.trades',
        'includes[8]': 'customer.address',
        'includes[9]': 'jobs.division',
      };

      appointmentModel = await AppointmentRepository().fetchAppointment(params);
    } catch (e) {
      rethrow;
    }
  }

  // setAllUsers(): loads users from local DB & also fill fields with selected users
  Future<void> setAllUsers() async {
    List<String> userIds = appointmentModel?.attendees?.map((user) => user.id.toString()).toList() ?? [];

    // loading from DB
    attendeesUsers = await FormsDBHelper.getAllUsers(userIds);
    tagList =  await FormsDBHelper.getAllTags();
    appointmentForList = await FormsDBHelper.getUsersToSingleSelect(userIds);

    // filling fields
     FormValueSelectorService.parseMultiSelectData(attendeesUsers, attendeesController);
     FormValueSelectorService.parseMultiSelectData(selectedJobList, jobController);
  }

  /// getters
  List<JPMultiSelectModel> get selectedAttendees => FormValueSelectorService.getSelectedMultiSelectValues(attendeesUsers); // selected attendees list
  List<JPMultiSelectModel> get selectedJobs => FormValueSelectorService.getSelectedMultiSelectValues(selectedJobList);  // selected customer jobs list
  List<JPMultiSelectModel> get additionalRecipients => FormValueSelectorService.getSelectedMultiSelectValues(additionalRecipientsList);
  List<EmailProfileDetail> get selectedList => initialToValues;

  /// selectors to select form data (users, jobs etc) --------------------------

  // select customer
  void selectCustomer() {
    FormValueSelectorService.selectCustomer(
        customerController: customerController,
        customerModel: customerModel,
        onSelectionDone: onCustomerSelected
    );
  }

  void onCustomerSelected(CustomerModel customer) {
    jobModel = null;
    jobModelList.clear();
    selectedJobList.clear();
    removeDataFromLocationTypeList();
    jobController.text = '';
    customerModel = customer;
    setAppointmentFor(customerModel);
    addAdditionalRecipientsList(customerModel);
    locationTypeList.add(JPSingleSelectModel(id: 'customer', label: 'customer'.tr.capitalizeFirst!));
    selectedLocationType = 'customer';
    locationTypeController.text =  'customer'.tr.capitalizeFirst!;
    setDefaultTitle();
    setDefaultLocation();
    update();
  }

  void removeDataFromLocationTypeList() {
    locationController.text = '';
    locationTypeList.removeWhere(((element) => element.id == 'job'));
    locationTypeList.removeWhere(((element) => element.id == 'customer'));
    jobLocation = '';
    customerLocation = '';
    selectedLocationType = 'other';
    locationTypeController.text = 'other'.tr.capitalizeFirst!;
    update();
  }

  // select jobs list of customer
  void selectJobOfCustomer() {
    FormValueSelectorService.selectJobOfCustomer(
        customerModel: customerModel,
        controller: jobController,
        selectedJobs: jobModelList,
        onSelectionDone: onJobSelected
    );
  }

  Future<void> onJobSelected(List<JobModel> list) async {
    selectedJobList.clear();
    if(list.isEmpty){
      jobModelList.clear();
      locationTypeList.removeWhere((element) => element.id == 'job');
      jobLocation = '';
    }
    else if(listEquals(list, jobModelList) == true && jobModelList.isNotEmpty){
      for(var e in jobModelList){
        selectedJobList.add(JPMultiSelectModel(label:  '${Helper.getJobName(e)} / ${e.tradesString}',id: e.id.toString(), isSelect: true));
      }
      if(locationTypeList.where((element) => element.id == 'job').isEmpty){
        locationTypeList.add(JPSingleSelectModel(id: 'job', label: 'job'.tr.capitalizeFirst!));}
      selectedLocationType = 'job';
      locationTypeController.text = 'job'.tr.capitalizeFirst!;
    }
    else {
      for(var e in list){
        selectedJobList.add(JPMultiSelectModel(label:  '${Helper.getJobName(e)} / ${e.tradesString}',id: e.id.toString(), isSelect: true));
      }
      if(locationTypeList.where((element) => element.id == 'job').isEmpty){
        locationTypeList.add(JPSingleSelectModel(id: 'job', label: 'job'.tr.capitalizeFirst!));}
      selectedLocationType = 'job';
      locationTypeController.text = 'job'.tr.capitalizeFirst!;
    }
    setDefaultTitle();
    setDefaultLocation();
    await updateUsersOnJobChange();
    update();
  }

  Future<void> updateUsersOnJobChange() async {

    final selectedAttendeeIds = selectedAttendees.map((e) => e.id).toList();

    List<int?> divisionIds = FormValueSelectorService.getDivisionIdsFromJobs(jobs: jobModelList);

    attendeesUsers = await FormsDBHelper.getAllUsers(
      selectedAttendeeIds,
      divisionIds: divisionIds,
      withSubContractorPrime: true
    );

    appointmentForList = await FormsDBHelper.getUsersToSingleSelect(
        [selectedAppointmentForId],
        divisionIds: divisionIds,
        withSubContractorPrime: true
    );

    appointmentForController.text = FormValueSelectorService.getSelectedSingleSelectValue(appointmentForList, selectedAppointmentForId);

  }

  // remove job with its default values
  Future<void> onRemoveJob(String jobId) async {
     jobModelList.removeWhere((element) => element.id.toString() == jobId);
     if (jobId == jobModel?.id.toString()) {
       jobModel = null;
     }
     if(jobModelList.isEmpty) {
       locationTypeList.removeWhere(((element) => element.id == 'job'));
       jobLocation = '';
       selectedLocationType = 'customer';
       locationTypeController.text = locationTypeList.firstWhereOrNull((element) => element.id == selectedLocationType)?.label ?? "";
       setDefaultLocation();
     }
     await updateUsersOnJobChange();
     setDefaultTitle();
     update();
  }

  // remove customer data
  Future<void> removeCustomer() async {
    removeAppointmentFor(customerModel ?? appointmentModel?.job?.firstOrNull?.customer);
    customerModel = null;
    jobModel = null;
    jobModelList.clear();
    customerController.text = '';
    jobController.text = '';
    selectedJobList.clear();
    titleController.text = '';
    notesController.text = '';
    removeDataFromLocationTypeList();
    await updateUsersOnJobChange();
    update();
  }

  void removeAppointmentFor(CustomerModel? customer) {
    if(customer?.rep?.id.toString() == selectedAppointmentForId) {
      appointmentForController.text = '';
      selectedAppointmentForId = '';
      update();
    }
  }

  // select user for appointment
  void selectAppointmentFor() {
    FormValueSelectorService.openSingleSelect(
        list: appointmentForList,
        controller: appointmentForController,
        selectedItemId: selectedAppointmentForId,
        onValueSelected: (val) {
          Future<void>.delayed(const Duration(milliseconds: 100), () {
            selectedAppointmentForId = val;
            validateForm();
            update();
          });
    });
  }

  // open date picker
  void openDatePicker({String? initialDate, required DatePickerType datePickerType, String? firstDate}) {
    DateTimeHelper.openDatePicker(
      initialDate: initialDate,
      firstDate: datePickerType == DatePickerType.end ? firstDate : null,
      helpText: datePickerType == DatePickerType.start ? "start_date".tr : "end_date".tr).then((dateTime) {
        if(dateTime != null) {
          DateTime currentDateTime = DateTime.now();
          dateTime = dateTime.add(Duration(hours: currentDateTime.hour, minutes: currentDateTime.minute, seconds: currentDateTime.second));
          switch (datePickerType) {
            case DatePickerType.start:
              startDateTime = DateTimeHelper.dateTimePickerTimeFormatting(dateTime.toString(), startDateTime ?? "");
              recurringEmail?.startDateTime = startDateTime;
              setReccuringTextField();
              break;
            case DatePickerType.end:
              endDateTime = DateTimeHelper.dateTimePickerTimeFormatting(dateTime.toString(), endDateTime ?? "");
              break;
          }
          endDateTime = modifyEndDateTime(endDateTime!, startDateTime!, datePickerType)?? endDateTime;
          if(controller.validateFormOnDataChange)  validateAppointmentTime();
          update();
        }
      }
    );
  }

  //setReccuringTextField(): to set the text field for recurring appointments based on the selected recurrence option.
  void setReccuringTextField() {
    if (recurringList.length <= 2 || recurringEmail?.repeat == null) return;

    final recOption = RecurringService.getRecOption(recurringEmail);

    if (recurringEmail?.repeat == 'monthly') {
      if (!Helper.isValueNullOrEmpty(recurringEmail?.byDay)) {
        recurringController.text = getRecurringWeekNo();
        recurringEmail?.byDay = [
          '${weekNo.toInt()}${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.fullday).substring(0, 2).toUpperCase()}'
        ];
      } else {
        recurringController.text = recOption;
      }
    } else {
      recurringController.text = recOption;
    }

    recurringList[2] = JPSingleSelectModel(label: recurringController.text, id: '0');
    selectedRecurringValue = recurringList[2].id;
  }
  
  // getRecurringWeekNo(): to set recurring text field label with week number
  String getRecurringWeekNo() {
    String defaultLabel = '${'monthly'.tr.capitalize!} ${'on'.tr}';
    weekNo = (int.parse(DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.date)) / 7).ceilToDouble();

    switch (weekNo) {
      case 5:
        weekCount = 'last'.tr;
        break;
      case 4:
        weekCount = 'fourth'.tr;
        break;
      case 3:
        weekCount = 'third'.tr;
        break;
      case 2:
        weekCount = 'second'.tr;
        break;
      case 1:
        weekCount = 'first'.tr;
        break;
      default:
        weekCount = '';
    }
    
    return '$defaultLabel $weekCount ${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.fullday).capitalize!}';
  }

  // open time picker
  void openTimePicker({required DatePickerType datePickerType, String? initialTime}) {
    DateTimeHelper.openTimePicker(
        initialTime: initialTime,
        helpText: datePickerType == DatePickerType.start ? "start_time".tr : "end_time".tr).then((pickedTime) {
      if(pickedTime != null) {
        switch (datePickerType) {
          case DatePickerType.start:
            startDateTime = DateTimeHelper.dateTimePickerTimeFormatting(startDateTime ?? "", pickedTime.toDateTime().toString());
            break;
          case DatePickerType.end:
            endDateTime = DateTimeHelper.dateTimePickerTimeFormatting(endDateTime ?? "", pickedTime.toDateTime().toString());
            break;
        }
        endDateTime = modifyEndDateTime(endDateTime!, startDateTime!, datePickerType)?? endDateTime;
        update();
      }
    });
  }

  String? modifyEndDateTime(String endDateTime, String startDateTime, DatePickerType datePickerType) {
    // bool value to check if end date is before start date
    bool isEndDateAfterStartDate = DateTime.parse(endDateTime).isBefore(DateTime.parse(startDateTime)); 
    String  formattedEndTime = DateTimeHelper.formatDate(endDateTime,DateFormatConstants.dateTimeFormatWithoutSeconds);
    String  formattedStartDate = DateTimeHelper.formatDate(endDateTime,DateFormatConstants.dateTimeFormatWithoutSeconds);
    
    // Write if condition to check if end time is less than start time then add 1 hour in end time
    if(datePickerType == DatePickerType.start && (isEndDateAfterStartDate || formattedEndTime ==  formattedStartDate)) {
      return DateTimeHelper.dateTimePickerTimeFormatting(startDateTime, DateTime.parse(startDateTime).add(const Duration(hours: 1)).toString()); 
    }
    return null;
  }

  // select ocurrence times
  dynamic openRecurringActionsBottomSheet() async {
    showJPBottomSheet (
      ignoreSafeArea: true,
      isScrollControlled: true,
      child: (_) {
        return RecurringBottomSheet (
          recurringStartDate: startDateTime,
          recurringText: recurringController.text,
          defaultDurationValue: RecurringConstants.daily,
          recurringEmaildata: recurringEmail == null ? RecurringEmailModel() : recurringEmail!,
          type: RecurringType.appointment,
          onDone:(RecurringEmailModel? data) {
            recurringEmail = data;
            recurringController.text = RecurringService.getRecOption(recurringEmail);
            if(recurringList.length > 2){recurringList.removeAt(2);}
            recurringList.insert(2,JPSingleSelectModel(label: RecurringService.getRecOption(recurringEmail), id: '0'));
            selectedRecurringValue = recurringList[2].id;
            update();
            Get.back();
          } ,
        );
      },
    );
    return null;
  }

  // select recurring list
  void openRecurringDataBottomSheet() {
        FormValueSelectorService.openSingleSelect(
        list: recurringList,
        controller: recurringController,
        selectedItemId: selectedRecurringValue,
        onValueSelected: (val) async{
          if(val == 'custom'){
          await  openRecurringActionsBottomSheet();
          } else {
            if(val == 'does_not_repeat'){
              if(recurringList.length > 2){recurringList.removeAt(2);}
              recurringEmail?.repeat = null; 
              selectedRecurringValue = val;
            } else{
              selectedRecurringValue = val;
            }
          }
          update();
    });
  }


  // select attendees
  void selectAttendees() {
    FormValueSelectorService.openMultiSelect(
      list: attendeesUsers,
      tags: tagList,
      title: 'additional_attendees'.tr,
      controller: attendeesController,
      onSelectionDone: () {
        update();
      },
    );
  }

  // select location
  void selectLocationType() {
    FormValueSelectorService.openSingleSelect(
        list: locationTypeList,
        controller: locationTypeController,
        selectedItemId: selectedLocationType,
        onValueSelected: (val) {
          selectedLocationType = val;
          switch(selectedLocationType){
            case 'customer':
              locationController.text = customerLocation;
            break;
            case 'job':
              locationController.text = jobLocation;
            break;
            default:
            locationController.text = '';
            break;
          }
          update();
        });
  }

  // add additional recipients list on reload 
  void addAdditionalRecipientsList(CustomerModel? customerModel) {
    if(customerModel != null){
      if(customerModel.email != null && customerModel.email != ''){
        additionalRecipientsList.add(JPMultiSelectModel(label: customerModel.email.toString(), id: '0', isSelect: false));
      }
    if(customerModel.additionalEmails != null){
      if(customerModel.additionalEmails!.isNotEmpty){
    for(int i = 0;i<customerModel.additionalEmails!.length;i++){
      additionalRecipientsList.add(JPMultiSelectModel(label: customerModel.additionalEmails![i].toString(), id: '${i+1}', isSelect: false));
    }}}}
  }

  // select additional recipients from bottom sheet
  void selectAdditionalRecipients() {
    FormValueSelectorService.openMultiSelect(
      list: additionalRecipientsList,
      title: 'select_additional_recipients'.tr.capitalize.toString(), 
      controller: additionalRecipientsController,
      onSelectionDone: () {
        List<EmailProfileDetail> initialTo = [];
        
        for(int i=0;i<additionalRecipientsList.length;i++) { 
          if(additionalRecipientsList[i].isSelect){
          initialTo.add(EmailProfileDetail(name: additionalRecipientsList[i].label, email: additionalRecipientsList[i].label));
          } else {
          if(initialToValues.isNotEmpty){
          int index = initialToValues.indexWhere((element) => element.email == additionalRecipientsList[i].label);
          removeEmailInList(initialToValues[index]);
           }
          }
        }

        if(initialTo.isNotEmpty) {
         for(int i=0;i<initialTo.length;i++) {
         controller.addEmailInList( initialTo[i]);
         }}
         update();
      },
       );
  }

  // get suggestion list of additional recipients
  Future<void> getSuggestionEmailData(String query) async {
    Map<String, dynamic> params = {
      'query': query
    };
    emailSuggestionModel = (await EmailListingRepository.fetchEmailSuggestion(params))['email_suggestion'];  
  }

  // select suggestion list of additional recipients
  void setSuggestionEmailData(String query){
    List<EmailProfileDetail> tempList =[];
    if(GetUtils.isEmail(query)){
      tempList.add(
        EmailProfileDetail(
        name: query,
        email: query,
        initial: query[0].toUpperCase()
        )
      );
    }
    if(emailSuggestionModel!.customer != null){
      for (var element in emailSuggestionModel!.customer!) {
        tempList.add(
        EmailProfileDetail(
          name:element.email!,
          initial:element.intial ,
          email:element.email!,
        )); 
      }
      suggestionList = tempList;
    }
  }

  // remove suggestion list email
  void removeEmailInList(EmailProfileDetail data){
    int index = additionalRecipientsList.indexWhere((element) => element.label == data.email);
    if(additionalRecipients.isNotEmpty){
      additionalRecipientsList[index].isSelect = false;
    }
    to.remove(data.email);
    initialToValues.remove(data);
    update();
  }

  // remove additional recipients from list
  void removeAdditionalRecipients() {
    additionalRecipientsController.text = '';
    addAdditionalRecipientsList(customerModel);
    update();
  }

  // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
      attachments: attachments,
      jobId: jobModelList.isNotEmpty ? jobModelList.first.id : jobModel?.id,
      maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.totalAttachmentMaxSize),
      onSelectionDone: () {
        update();
      }
    );
  }

  // remove attachments
  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void toggleIsAllDayReminderSelected(bool val) => isAllDayReminderSelected = val; // toggle to update is all day or not

  void toggleIsUserNotificationSelected(bool val) => isUserNotificationSelected = val; // toggle of user notification

  /// form field validators ----------------------------------------------------

  String? validateTitle(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'title_cant_be_left_blank'.tr);
  }

  String? validateAppointmentFor(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'appointment_must_be_assigned_to_some_one'.tr);
  }

  String? validateLocation(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'location_cant_be_left_blank'.tr);
  }

  bool validateAppointmentTime() {
    if(startDateTime?.isEmpty ?? true) {
      errorText = "please_provide_start_date_and_time".tr;
    } else {
      errorText = null;
    }

    if(!isAllDayReminderSelected) {
      if(startDateTime?.isEmpty ?? true) {
        errorText = "please_provide_start_date_and_time".tr;
      } else if(endDateTime?.isEmpty ?? true) {
        errorText = "please_provide_end_date_and_time".tr;
      } else if(DateTime.parse(endDateTime ?? "" ).isBefore(DateTime.parse(startDateTime ?? ""))) {
        errorText = "end_time_must_be_greater_then_start_time".tr;
      } else if(endDateTime == startDateTime) {
        errorText = "end_time_must_be_greater_then_start_time".tr;
      } else if(!validateOverLappedSchedules()) {
        errorText = 'overlapped_schedules_are_not_allowed'.tr;
      } else {
        errorText = null;
      }
    }
    update();
    return errorText?.isEmpty ?? true;
  }

  bool validateOverLappedSchedules() {
    if(isAllDayReminderSelected || !isRecurringSelected) {
      return true;
    } else {

      final isValid = FormValidator.validateOverLappedRecurring(
        startDateTime: DateTime.parse(startDateTime!),
        endDateTime: DateTime.parse(endDateTime!),
        repeat: selectedRecurringType,
      );

      return isValid;
    }
  }

  bool validateDivisions() {

    List<int?> divisionIds = FormValueSelectorService.getDivisionIdsFromJobs(jobs: jobModelList);

    if(divisionIds.isEmpty) return true;

    final appointmentFor = attendeesUsers.firstWhereOrNull((user) => user.id == selectedAppointmentForId);

    List<JPMultiSelectModel> usersFromAnotherDivision = FormValidator.validateAllUsersBelongToSameDivision(
      divisionIds: divisionIds,
      selectedUsers: [
        ...selectedAttendees,
        if(appointmentFor != null) appointmentFor
      ],
    );

    if(usersFromAnotherDivision.isEmpty) {
      return true;
    } else {
      showDivisionFailedDialog(usersFromAnotherDivision);
      return false;
    }
  }

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable() {
    if(controller.isSavingForm) {
      return false;
    }
    return true;
  }



  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    bool isTitleError = validateTitle(titleController.text) != null;
    bool isAppointmentForError = validateAppointmentFor(appointmentForController.text) != null;

    if(isUserNotificationSelected) {
      controller.userNotificationFormKey.currentState?.validate(scrollOnValidate: true) ?? false;
    }
    if (isTitleError) {
      titleController.scrollAndFocus();
    } else if (isAppointmentForError) {
      appointmentForController.scrollAndFocus();
    } else if(!validateAppointmentTime()) {
      dateTimeController.scrollAndFocus();
    }
  }

  // saveForm():  makes a network call to save/update form
  Future<void> saveForm({required VoidCallback onUpdate}) async {
    try {
      final params = appointmentFormJson();
      switch(pageType) {
        case AppointmentFormType.createForm:
          await createAppointmentAPICall(params);
          break;
        case AppointmentFormType.editForm:
          await updateAppointmentAPICall(params);
          break;
        case AppointmentFormType.duplicateForm:
        case AppointmentFormType.createJobAppointmentForm:
          params.removeWhere((key, value) => key == 'id');
          await createAppointmentAPICall(params);
          break;
        default:
          break;
      }
    } catch (e) {
      rethrow;
    } finally {
      onUpdate();
    }
  }

  // create appointment
  Future<void> createAppointmentAPICall(Map<String, dynamic> params) async {
    
    try {
      final result = await AppointmentRepository().createAppointment(params);
      if (result["status"]) {
        if(pageType == AppointmentFormType.duplicateForm) {
          result.removeWhere((key, value) => key == 'appointment');
        }
        Helper.showToastMessage('appointment_created'.tr);
        Get.back(result: result);
      }
     
    } catch(e){
      rethrow;
    }   
  }

  // update appointment
  Future<void> updateAppointmentAPICall(Map<String, dynamic> params) async {
    try {
      final result = await AppointmentRepository().updateAppointment(params);
      if (result["status"]) {
        Helper.showToastMessage('appointment_updated'.tr);
        Get.back(result: result);
      }
    } catch(e) {
      rethrow;
    } 
  }

  void showDivisionFailedDialog(List<JPMultiSelectModel> userFromAnotherDivision) {
    showJPGeneralDialog(child: (_) => DivisionUnMatchAlert(
      jobs: jobModelList,
      type: DivisionUnMatchType.appointment,
      usersFromAnotherDivision: userFromAnotherDivision,
    ),
    );
  }

  /// Handles the selection of a custom location when location type is 'other'
  /// 
  /// Opens the address selector using FormValueSelectorService and updates
  /// the locationController with the formatted address when selection is complete.
  /// This method is triggered when the user taps on the location field with the
  /// location icon in the UI.
  void selectLocation() {
    FormValueSelectorService.selectAddress(
        controller: locationController,
        onDone: (response) {
          locationController.text = Helper.convertAddress(response);
        }
    );
  }

}
