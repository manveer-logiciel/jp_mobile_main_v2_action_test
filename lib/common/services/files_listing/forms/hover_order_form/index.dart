import 'dart:ui';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/hover.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/index.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/repositories/hover.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/forms/hover_order_form/controller.dart';

/// HoverOrderFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class HoverOrderFormService extends HoverOrderFormData {

  HoverOrderFormService({
    required VoidCallback update,
    int? jobId,
    this.params,
    required this.validateForm,
  }) : super(update,
      customer: params?.customer,
      jobId: params?.jobId,
      jobHoverUser: params?.hoverUser,
      formType: params?.formType ?? HoverFormType.add,
      hoverJob: params?.hoverJob
  );

  final HoverOrderFormParams? params;
  final VoidCallback validateForm; // helps in validating form when form data updates
  HoverOrderFormController? _controller; // helps in managing controller without passing object

  HoverOrderFormController get controller => _controller ?? HoverOrderFormController(params);

  set controller(HoverOrderFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {

      await getLocalDBdata();
      // filling form data
      setFormData();

    } catch (e) {
      rethrow;
    } finally {
      // Additional delay for form values to set-up
      await Future<void>.delayed(const Duration(milliseconds: 500));
      Get.back();
      update();
    }
  }

  /// getters

  bool get doShowPhoneSelect => customerPhones.length > 1 && requestForTypeId == requestForType.first.id;
  bool get doShowEmailSelect => customerEmails.length > 1 && requestForTypeId == requestForType.first.id;
  bool get doShowStateSelect => allStates.length > 1;
  bool get doShowCountrySelect => allCountries.length > 1;

  Future<void> getLocalDBdata() async {
    try {
      allStates = await FormsDBHelper.getAllStates();
      allCountries = await FormsDBHelper.getAllCountries();
    } catch (e) {
      rethrow;
    }
  }

  /// selectors to select form data (users, jobs etc) --------------------------

  void selectHoverDeliverables() {
    FormValueSelectorService.openSingleSelect(
        title: 'select_hover_deliverable'.tr,
        list: hoverDeliverables,
        controller: deliverableController,
        selectedItemId: selectedHoverDeliverableId,
        onValueSelected: (val) async {
          selectedHoverDeliverableId = val;
          validateForm();
        },
    );
  }

  void selectHoverUser() {
    FormValueSelectorService.openNetworkSingleSelect(
      title: 'select_hover_user'.tr,
      controller: usersController,
      selectedItemId: selectedHoverUserId,
      networkListType: JPNetworkSingleSelectType.hoverUsers,
      onValueSelected: (option) async {
        selectedHoverUserId = option.id;
        jobHoverUser = (option.additionalData as HoverUserModel?);
        validateForm();
      },
    );
  }

  void selectRequestFor() {
    Helper.hideKeyboard();
    FormValueSelectorService.openSingleSelect(
      title: 'request_for'.tr,
      list: requestForType,
      selectedItemId: requestForTypeId,
      onValueSelected: (val) {
        updateRequestFor(val);
        update();
        validateForm();
      },
    );
  }

  void selectState() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_state'.tr,
      list: allStates,
      selectedItemId: selectedStateId,
      controller: stateController,
      onValueSelected: (val) {
        selectedStateId = val;
      },
    );
  }

  void selectCountry() {
    FormValueSelectorService.openSingleSelect(
      title: 'select_country'.tr,
      list: allCountries,
      selectedItemId: selectedCountryId,
      controller: countryController,
      onValueSelected: (val) {
        selectedCountryId = val;
      },
    );
  }

  void selectPhone() {
    selectedPhoneId = PhoneMasking.unmaskPhoneNumber(phoneController.text);
    FormValueSelectorService.openSingleSelect(
      title: 'select_phone'.tr,
      list: customerPhones,
      selectedItemId: selectedPhoneId,
      controller: phoneController,
      onValueSelected: (val) {
        selectedPhoneId = val;
      },
    );
  }

  void selectEmail() {
    selectedEmailId = emailController.text.trim();
    FormValueSelectorService.openSingleSelect(
      title: 'select_email'.tr,
      list: customerEmails,
      selectedItemId: selectedEmailId,
      controller: emailController,
      onValueSelected: (val) {
        selectedEmailId = val;
      },
    );
  }

  void selectAddress() {
    FormValueSelectorService.selectAddress(
      controller: addressController,
      onDone: updateAddress
    );
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void updateRequestFor(String val) {
    requestForTypeId = val;
    if(val != requestForType.first.id) {
      requestForController.text = "";
      phoneController.text = '';
      emailController.text = '';
    } else {
      requestForController.text = customer?.fullName ?? "";
      phoneController.text =
          FormValueSelectorService.getSelectedSingleSelectValue(customerPhones, selectedPhoneId);
      emailController.text =
          FormValueSelectorService.getSelectedSingleSelectValue(customerEmails, selectedEmailId);
    }
  }

  void updateHoverRequest(dynamic val) {
    withCaptureRequest = val;
    validateForm();
    update();
  }

  void updateAddress(AddressModel address) {
    cityController.text = address.city ?? "";
    zipCodeController.text = address.zip ?? "";

    // updating selected state
    final state = allStates.firstWhereOrNull((state) {
      final stateCode = (state.additionalData as StateModel).code;
      return stateCode == address.state?.code;
    });

    selectedStateId = state?.id ?? "";
    stateController.text = FormValueSelectorService
        .getSelectedSingleSelectValue(allStates, selectedStateId);

    validateForm();
  }

  /// form field validators ----------------------------------------------------

  String? validateUser(String val) {
    return FormValidator.requiredFieldValidator(
        val,
        errorMsg: 'hover_user_is_required'.tr);
  }

  String? validateDeliverable(String val) {
    return FormValidator.requiredFieldValidator(
        val,
        errorMsg: 'hover_deliverable_is_required'.tr);
  }

  String? validateRequestFor(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'request_for_is_required'.tr
    );
  }

  String? validatePhoneNumber(String val) {
    return FormValidator.validatePhoneNumber(
        PhoneMasking.unmaskPhoneNumber(val),
        errorMsg: 'phone_number_is_required'.tr,
    );
  }

  String? validateEmail(String val) {
    return FormValidator.validateEmail(val,
        errorMsg: 'email_is_required'.tr, isRequired: true);
  }

  String? validateAddress(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'address_is_required'.tr);
  }

  /// helpers ------------------------------------------------------------------

  static bool canSyncHover(JobModel? job, SubscriberDetailsModel? subscriberDetails) {

    bool isNotOnCompleteStage = job?.hoverJob?.state != 'complete';
    bool isOwnerIdDifferent = job?.hoverJob?.ownerId != subscriberDetails?.hoverClient?.ownerId;

    return PhasesVisibility.canShowSecondPhase
        && job != null
        && isNotOnCompleteStage
        && (job.hoverJob == null || isOwnerIdDifferent);
  }

  void scrollToErrorField() {

    bool isUserError = validateUser(usersController.text) != null;
    bool isHoverDeliverableError = validateDeliverable(deliverableController.text) != null;
    bool isRequestForError = validateRequestFor(requestForController.text) != null;
    bool isPhoneError = validatePhoneNumber(phoneController.text) != null;
    bool isEmailError = validateEmail(emailController.text) != null;
    bool isAddressError = validateAddress(addressController.text) != null;

    if(isUserError) {
      usersController.scrollAndFocus();
    } else if (isHoverDeliverableError) {
      deliverableController.scrollAndFocus();
    } else if (isRequestForError) {
      requestForController.scrollAndFocus();
    } else if (isPhoneError) {
      phoneController.scrollAndFocus();
    } else if (isEmailError) {
      emailController.scrollAndFocus();
    } else if (isAddressError) {
      addressController.scrollAndFocus();
    }
  }

  // saveForm():  makes a network call to save form
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    try {

      final requestParams = hoverFormJson();

      if (formType == HoverFormType.linkWithJob) {
        params?.onHoverLinked?.call(toHoverModel(), requestParams);
        Get.back();
        return;
      }

      if (withCaptureRequest) {
        await captureRequestApiCall(requestParams);
      } else {
        await syncHoverApiCall(requestParams);
      }

    } catch (e) {
      rethrow;
    }
  }

  Future<void> syncHoverApiCall(Map<String, dynamic> params) async {
    final result = await HoverRepository.jobSync(params);
    if (result) {
      Helper.showToastMessage('job_synced_to_hover'.tr);
      Get.back(result: result);
    }
  }

  Future<void> captureRequestApiCall(Map<String, dynamic> params) async {
    final result = await HoverRepository.captureRequest(params);
    if (result) {
      Helper.showToastMessage('capture_request_created'.tr);
      Get.back(result: result);
    }
  }
}