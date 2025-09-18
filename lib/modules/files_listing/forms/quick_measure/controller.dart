import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/services/location/loaction_service.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/form_builder/controller.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

import '../../../../common/enums/form_field_type.dart';
import '../../../../common/models/forms/quick_measure/quick_measure_param.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/services/files_listing/forms/quck_measure_form/quick_measure_form.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../core/utils/form/validators.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import 'order_verification_dialogue/index.dart';

class QuickMeasureFormController extends GetxController {

  QuickMeasureFormController({
    this.quickMeasureParams,
  });


  late QuickMeasureFormService service;

  late JPFormBuilderController formBuilderController;

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isProductSectionExpanded = false; // used to manage/control expansion state of additional details section
  bool isOtherInfoSectionExpanded = false; // used to manage/control expansion state of reminder notification section

  final QuickMeasureParams? quickMeasureParams;

  final formKey = GlobalKey<FormState>(); // used to validate form

  JobModel? jobModel; // helps in retrieving job from previous page

  Function(dynamic val)? onUpdate;

  AddressModel? get selectedAddress => service.selectedAddress;

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    jobModel ??= quickMeasureParams?.jobModel ?? Get.arguments?[NavigationParams.jobModel];
    formBuilderController = JPFormBuilderController(initialAddress: jobModel?.address);
    onUpdate = quickMeasureParams?.onUpdate;

    // setting up service
    service = QuickMeasureFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      jobModel: jobModel,
    );

    service.controller = this;
    if (jobModel?.address == null) await LocationService.checkAndReRequestPermission();
    await service.initForm(); // setting up form data
  }

  void onAddressUpdate(AddressModel params, {bool? canUpdateMarker = false, bool? isPinUpdated = false}) {
    service.isDefaultLocation = !Helper.isTrue(isPinUpdated);
    service.selectedAddress = AddressModel.copy(addressModel: params);
    if(canUpdateMarker ?? false) {
      formBuilderController.collapsibleMapController?.updateAddress(params);
    }
    update();
  }

  // onProductSectionExpansionChanged(): toggles additional options section expansion state
  void onProductSectionExpansionChanged(bool val) {
    isProductSectionExpanded = val;
    service.onProductSectionExpansionChanged(val);
  }

  // onOtherInfoSectionExpansionChanged(): toggles additional options section expansion state
  void onOtherInfoSectionExpansionChanged(bool val) {
    isOtherInfoSectionExpanded = val;
    service.onOtherInfoSectionExpansionChanged(val);
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    if(formKey.currentState?.validate() ?? false) {
      return service.validateFormData();
    } else {
      return false;
    }
  }

  // createQuickMeasure() : will save form data on validations completed otherwise scroll to error field
  Future<void> createQuickMeasure() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    bool isValid = validateForm() && Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress));

    if (isValid) {
      bool isNewDataAdded = service.checkIfNewDataAdded();
      if(!isNewDataAdded) {
        Helper.showToastMessage('no_changes_made'.tr);
      } else if(Helper.isValueNullOrEmpty(selectedAddress?.address)) {
        Helper.showToastMessage('address_required'.tr);
        formBuilderController.collapsibleMapController?.showAddressDialogue(onAddressUpdate: onAddressUpdate);
      } else{
        showValidationDialogue(onUpdate: onUpdate);
      }
    } else {
      service.scrollToErrorField();
    }
  }

  void showValidationDialogue({Function(dynamic val)? onUpdate}) {
    showJPGeneralDialog(
        child:(controller) => QuickMeasureOrderVerificationDialogue(
          formData: service,
          isDefaultLocation: service.isDefaultLocation,
          onFinish: (bool result) => result ? Get.back(result: result) : null,
        )
    );
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false, FormFieldType? formFieldType }) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }

    if(doUpdate) update();
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {
    if(service.checkIfNewDataAdded()) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }
    return false;
  }

  @override
  void dispose() {
    service.productsController.controller.dispose();
    service.accountController.controller.dispose();
    service.emailController.controller.dispose();
    service.specialInfoController.controller.dispose();
    super.dispose();
  }
}