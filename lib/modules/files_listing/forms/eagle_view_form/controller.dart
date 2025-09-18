import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/location/loaction_service.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../common/enums/eagle_view_form_type.dart';
import '../../../../common/enums/form_field_type.dart';
import '../../../../common/models/address/address.dart';
import '../../../../common/models/forms/eagleview_order/eagle_view_form_param.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import '../../../../core/constants/navigation_parms_constants.dart';
import '../../../../core/utils/form/validators.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../global_widgets/form_builder/controller.dart';
import 'order_verification_dialogue/index.dart';

class EagleViewFormController extends GetxController {

  EagleViewFormController({this.eagleViewFormParam});

  final EagleViewFormParam? eagleViewFormParam;
  late EagleViewFormService service;

  late JPFormBuilderController formBuilderController;

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isProductSectionExpanded = false; // used to manage/control expansion state of additional details section
  bool isInstructionSectionExpanded = false; // used to manage/control expansion state of additional details section
  bool isClaimSectionExpanded = false; // used to manage/control expansion state of additional details section
  bool isOtherInfoSectionExpanded = false; // used to manage/control expansion state of reminder notification section

  final formKey = GlobalKey<FormState>(); // used to validate form

  JobModel? jobModel; // helps in retrieving job from previous page
  EagleViewFormType? pageType; // helps in manage form privileges

  Function(dynamic val)? onUpdate;

  String get pageTitle {
    switch (pageType) {
      case EagleViewFormType.createForm:
        return 'eagle_view_order'.tr.toUpperCase();
      case EagleViewFormType.editForm:
        return 'update_eagle_view_order'.tr.toUpperCase();
      default:
        return 'eagle_view_order'.tr.toUpperCase();
    }
  }

  String get saveButtonText {
    switch (pageType) {
      case EagleViewFormType.createForm:
        return 'place_order'.tr.toUpperCase();
      case EagleViewFormType.editForm:
        return 'update_order'.tr.toUpperCase();
      default:
        return 'place_order'.tr.toUpperCase();
    }
  }

  get selectedAddress => service.selectedAddress;

  @override
  void onInit() async {
    await init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    jobModel ??= eagleViewFormParam?.jobModel ?? Get.arguments?[NavigationParams.jobModel];
    pageType ??= eagleViewFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType];
    onUpdate = eagleViewFormParam?.onUpdate;
    formBuilderController = JPFormBuilderController(initialAddress: jobModel?.address);

    // setting up service
    service = EagleViewFormService(
      update: update,
      validateForm: () => onDataChanged(''),
      jobModel: jobModel,
      pageType: pageType,
    );

    service.controller = this;
    if (jobModel?.address == null) await LocationService.checkAndReRequestPermission();
    await service.initForm(); // setting up form data
  }

  // onProductSectionExpansionChanged(): toggles additional options section expansion state
  void onProductSectionExpansionChanged(bool val) {
    isProductSectionExpanded = val;
    service.onProductSectionExpansionChanged(val);
  }

  // onProductSectionExpansionChanged(): toggles additional options section expansion state
  void onInsuranceSectionExpansionChanged(bool val) {
    isInstructionSectionExpanded = val;
    service.onInsuranceSectionExpansionChanged(val);
  }

  // onProductSectionExpansionChanged(): toggles additional options section expansion state
  void onClaimSectionExpansionChanged(bool val) {
    isClaimSectionExpanded = val;
    service.onClaimSectionExpansionChanged(val);
  }

  // onOtherInfoSectionExpansionChanged(): toggles additional options section expansion state
  void onOtherInfoSectionExpansionChanged(bool val) {
    isOtherInfoSectionExpanded = val;
    service.onOtherInfoSectionExpansionChanged(val);
  }

  void onAddressUpdate(AddressModel params, {bool? canUpdateMarker = false, bool? isPinUpdated = false}) {
    service.isDefaultLocation = !Helper.isTrue(isPinUpdated);
    service.selectedAddress = AddressModel.copy(addressModel: params);
    if(canUpdateMarker ?? false) {
      formBuilderController.collapsibleMapController?.updateAddress(params);
    }
    update();
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    if(formKey.currentState?.validate() ?? false) {
      return service.validateFormData();
    } else {
      return false;
    }
  }

  // createEagleViewOrder() : will save form data on validations completed otherwise scroll to error field
  Future<void> createEagleViewOrder() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data

    bool isValid = validateForm() && Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress));

    if (isValid) {
      bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
      if(!isNewDataAdded) {
        Helper.showToastMessage('no_changes_made'.tr);
      } else if(Helper.isValueNullOrEmpty(service.selectedAddress?.address)) {
        Helper.showToastMessage('address_required'.tr);
        formBuilderController.collapsibleMapController?.showAddressDialogue(onAddressUpdate: onAddressUpdate);
      } else {
        showValidationDialogue(onUpdate: onUpdate);
      }
    } else {
      service.scrollToErrorField();
    }
  }

  void showValidationDialogue({Function(dynamic val)? onUpdate}) {
    showJPGeneralDialog(
      child:(controller) => EagleViewOrderVerificationDialogue(
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
    formBuilderController.dispose();
    service.productsController.controller.dispose();
    service.deliveryController.controller.dispose();
    service.addOnProductsController.controller.dispose();
    service.measurementController.controller.dispose();
    service.promoCodeController.controller.dispose();
    service.insuredNameController.controller.dispose();
    service.referenceIdController.controller.dispose();
    service.batchIdController.controller.dispose();
    service.policyNoController.controller.dispose();
    service.claimNumberController.controller.dispose();
    service.claimInfoController.controller.dispose();
    service.poNumberController.controller.dispose();
    service.catIdController.controller.dispose();
    service.dateOfLossController.controller.dispose();
    service.sendCopyToController.controller.dispose();
    service.commentController.controller.dispose();
    super.dispose();
  }
}