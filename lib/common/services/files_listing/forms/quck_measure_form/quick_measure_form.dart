import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/dropdown_list_constants.dart';
import '../../../../../core/utils/form/validators.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/single_select_helper.dart';
import '../../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../../global_widgets/search_location/address_dailogue/index.dart';
import '../../../../../modules/files_listing/forms/quick_measure/controller.dart';
import '../../../../enums/form_field_type.dart';
import '../../../../models/address/address.dart';
import '../../../../models/forms/quick_measure/index.dart';

class QuickMeasureFormService extends QuickMeasureFormData {

  QuickMeasureFormService({
    required super.update,
    required this.validateForm,
    super.jobModel,
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  QuickMeasureFormController? _controller; // helps in managing controller without passing object

  QuickMeasureFormController get controller => _controller ?? QuickMeasureFormController();

  set controller(QuickMeasureFormController value) => _controller = value;

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
      setFormData(); // filling form data
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }

  void onProductSectionExpansionChanged(bool val) => isProductSectionExpanded = val;

  void onOtherInfoSectionExpansionChanged(bool val) => isOtherInfoSectionExpanded = val;

  void selectProductType() {
    SingleSelectHelper.openSingleSelect(
        DropdownListConstants.productTypeList,
        selectedProduct?.id,
        'select_product'.tr, (value) {
      setProduct(value);
    });
  }

  void setProduct(String val) {
    selectedProduct = DropdownListConstants.productTypeList.firstWhereOrNull((element) => element.id == val);
    productsController.text = selectedProduct?.label ?? "";
    validateForm();
    update();
    Get.back();
  }

  void onEmailRecipientChange(String value) => validateForm();

  /// form field validators ----------------------------------------------------

  bool validateFormData() {
    if (!Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress))) {
      return false;
    } else if (FormValidator.requiredFieldValidator(productsController.text) != null) {
      return false;
    } else if ((emailController.text.isNotEmpty ? (FormValidator.validateEmail(emailController.text)) : null) != null) {
      return false;
    } else {
      return true;
    }
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() => initialJson.toString() != quickMeasureFormJson().toString();

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable(FormFieldType formFieldType) {

    if(controller.isSavingForm ||formFieldType == FormFieldType.accountId) {
      return false;
    }

    return true;
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    if(!Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress))) {
      openAddressDialogue();
    } else if (FormValidator.requiredFieldValidator(productsController.text) != null) {
      if (!controller.isProductSectionExpanded) {
        controller.onProductSectionExpansionChanged(true);
        update();
        // ignore: inference_failure_on_instance_creation
        await Future.delayed(const Duration(milliseconds: 200));
      }
      controller.formKey.currentState?.validate();
      productsController.scrollAndFocus();
    } else if (emailController.text.isNotEmpty) {
      if((FormValidator.validateEmail(emailController.text) != null) && !controller.isOtherInfoSectionExpanded){
        controller.onOtherInfoSectionExpansionChanged(true);
        update();
        // ignore: inference_failure_on_instance_creation
        await Future.delayed(const Duration(milliseconds: 200));
      }
      controller.formKey.currentState?.validate();
      emailController.scrollAndFocus();
    }
  }

  void openAddressDialogue() {
    showJPGeneralDialog(
      child: (dialogController) =>
        SearchedAddressDialogueView(
          addressModel: selectedAddress,
          onApply: (AddressModel addressModel) =>
            controller.onAddressUpdate(addressModel, canUpdateMarker: true)
        )
    );
  }
}