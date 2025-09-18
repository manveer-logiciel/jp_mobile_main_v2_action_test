import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email/profile_detail.dart';
import 'package:jobprogress/common/models/forms/create_appointment/create_appointment_form_param.dart';
import 'package:jobprogress/common/repositories/company_settings.dart';
import 'package:jobprogress/common/services/appointment/create_appointment_form.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/forms/user_notification/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CreateAppointmentFormController extends GetxController {
  CreateAppointmentFormController({
    this.createAppointmentFormParam,
  });

  final formKey = GlobalKey<FormState>(); // used to validate form
  final userNotificationFormKey = GlobalKey<UserNotificationFormState>(); // use notification key

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  late CreateAppointmentFormService service;

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isAllDayReminderEnabled = false; // used to manage/control expansion state of reminder notification section
  bool isUserNotificationEnabled = false;  // used to hide/show reminder notification info

  final CreateAppointmentFormParam? createAppointmentFormParam;
  AppointmentModel? appointment; // help in retriving appointment from previous page
  CustomerModel? customerModel; // help in retrieving customer from previous page
  AppointmentFormType? pageType; // helps in manage form privileges

  bool isAdditionalDetailsExpanded =  CompanySettingsService.getCompanySettingByKey(
      CompanySettingConstants.showAppointmentAdditionalOptions,
      onlyValue: true,
    ) is bool ? true : Helper.isTrue( CompanySettingsService.getCompanySettingByKey(
      CompanySettingConstants.showAppointmentAdditionalOptions,
      onlyValue: true,
    ));// used to manage/control expansion state of additional details section
  
  
  String get pageTitle => pageType != AppointmentFormType.createForm && pageType != AppointmentFormType.duplicateForm && pageType != AppointmentFormType.createJobAppointmentForm
      ? 'update_appointment'.tr.toUpperCase()
      : 'create_appointment'.tr.toUpperCase();

  String get saveButtonText => pageType != AppointmentFormType.createForm && pageType != AppointmentFormType.duplicateForm && pageType != AppointmentFormType.createJobAppointmentForm
      ? 'update'.tr.toUpperCase()
      : 'create'.tr.toUpperCase();

  Function(dynamic val)? onUpdate;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  // // init(): will set up form service and form data
  Future<void> init() async {
    appointment ??= createAppointmentFormParam?.appointment ?? Get.arguments?[NavigationParams.appointment];
    pageType ??= createAppointmentFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType] ?? AppointmentFormType.createForm;
    customerModel ??= Get.arguments?[NavigationParams.customer];
    onUpdate = createAppointmentFormParam?.onUpdate;
    // setting up service
    service = CreateAppointmentFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      appointmentModel: appointment,
      customerModel: customerModel,
      pageType: pageType,
    );
    service.controller = this;
    if(pageType != AppointmentFormType.createForm) {
      if(appointment !=null){
      service.addAdditionalRecipientsList(appointment!.customer);}
      }
    await service.initForm(); // setting up form data
    onUserNotificationChanged(service.isUserNotificationSelected);

    if(pageType == AppointmentFormType.createJobAppointmentForm) {
      service.initialJson = service.appointmentFormJson();
    }
  }

  // createAppointment() : will save form data on validations completed otherwise scroll to error field
  Future<void> createAppointment() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    bool isRecurringOverlappedValid = service.validateOverLappedSchedules(); // validating form

    bool isScheduleTimeValid = service.validateAppointmentTime(); // validating form

    bool isDivisionsValid = service.validateDivisions();

    bool isValid = validateForm() && isRecurringOverlappedValid && isScheduleTimeValid && isDivisionsValid;  // validating form

    if (isValid) {
       saveForm(onUpdate: onUpdate);
    } else {
      service.scrollToErrorField();
    }
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
    if (doUpdate) update();
  }

  // validateForm(): validates form and returns result
  bool validateForm() {

    bool isValid = formKey.currentState?.validate() ?? false;
    bool isUserNotificationFormValid = true;

    if(isUserNotificationEnabled) {
      isUserNotificationFormValid = userNotificationFormKey.currentState?.validate(scrollOnValidate: false) ?? false;
    }

    return isValid && isUserNotificationFormValid;
  }

  // onAdditionalOptionsExpansionChanged(): toggles additional options section expansion state
  void onAdditionalOptionsExpansionChanged(bool val) {
    isAdditionalDetailsExpanded = val;
    saveAdditionalOptionsSettings(val);
  }

  Future<void> saveAdditionalOptionsSettings(bool val) async {
    try {
      dynamic preservedSettings = CompanySettingsService.getCompanySettingByKey(
        CompanySettingConstants.showAppointmentAdditionalOptions,
        onlyValue: false
      );
      // Creating settings for the first time
      if(preservedSettings is bool || preservedSettings == null) {
        preservedSettings = {
          "name": CompanySettingConstants.showAppointmentAdditionalOptions,
          "key": CompanySettingConstants.showAppointmentAdditionalOptions,
          "user_id": AuthService.userDetails?.id,
          "company_id": AuthService.userDetails?.companyDetails?.id
        };
      }
      preservedSettings['value'] = val ? '1' : '0';
      await CompanySettingRepository.saveSettings(preservedSettings);
    } catch (e) {
      rethrow;
    }
  }

  // toggle to save form
  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

    // onReminderChanged(): toggles reminder notification expansion state
  void onReminderChanged(bool val) {
    isAllDayReminderEnabled = val;
    service.toggleIsAllDayReminderSelected(val);
    service.validateAppointmentTime();
    update();
  }

    // onUserNotificationChanged(): toggles reminder notification expansion state
  void onUserNotificationChanged(bool val) {
    isUserNotificationEnabled = val;
    service.toggleIsUserNotificationSelected(val);
    update();
  }

  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
  bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      if (service.isRecurringSelected && pageType == AppointmentFormType.editForm) {
        openUpdateScheduleBottomSheet();
      } else {
        updateAppointment("this");
      }
    }
  }

  void openUpdateScheduleBottomSheet() {
    SingleSelectHelper.openSingleSelect(
        DropdownListConstants.updateAppointmentTypeList,
        "",
        'update_for'.tr,
        (String value) {
          Get.back();
          updateAppointment(value);
        },
        isFilterSheet: false
    );
  }

  void updateAppointment(String value) async {

    switch(value) {
      case "this":
        service.impactType = 'this_appointment';
        break;
      case "this_and_following":
        service.impactType = 'this_and_following_appointment';
        break;
      case 'all':
        service.impactType = 'all_appointment';
        break;
    }
    toggleIsSavingForm();
    await service.saveForm(onUpdate: toggleIsSavingForm);
    
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {
    bool isNewDataAdded = service.checkIfNewDataAdded();
    if (isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Get.back();
    }
    return false;
  }

// adding additional recipients
  void addEmailInList(EmailProfileDetail data){
      service.to.add(data.email);
      service.initialToValues.add(data);  
    update();
  }
}