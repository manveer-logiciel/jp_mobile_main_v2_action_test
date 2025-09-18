import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/date_formats.dart';
import '../../../../../core/utils/date_time_helpers.dart';
import '../../../../../core/utils/form/validators.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../../core/utils/single_select_helper.dart';
import '../../../../../global_widgets/bottom_sheet/index.dart';
import '../../../../../global_widgets/loader/index.dart';
import '../../../../../global_widgets/search_location/address_dailogue/index.dart';
import '../../../../../modules/files_listing/forms/eagle_view_form/controller.dart';
import '../../../../enums/eagle_view_form_type.dart';
import '../../../../enums/form_field_type.dart';
import '../../../../models/address/address.dart';
import '../../../../models/forms/eagleview_order/index.dart';
import '../../../../repositories/eagle_view_order_form.dart';
import '../../../forms/value_selector.dart';

class EagleViewFormService extends EagleViewFormData {

  EagleViewFormService({
    required super.update,
    required this.validateForm,
    super.jobModel,
    super.pageType
  });

  final VoidCallback validateForm; // helps in validating form when form data updates

  EagleViewFormController? _controller; // helps in managing controller without passing object

  EagleViewFormController get controller => _controller ?? EagleViewFormController();

  set controller(EagleViewFormController value) => _controller = value;

  void onProductSectionExpansionChanged(bool val) => isProductSectionExpanded = val;

  void onInsuranceSectionExpansionChanged(bool val) => isInstructionSectionExpanded = val;

  void onClaimSectionExpansionChanged(bool val) => isClaimSectionExpanded = val;

  void onOtherInfoSectionExpansionChanged(bool val) => isOtherInfoSectionExpanded = val;

  /// getters

  List<JPMultiSelectModel> get selectedAddOns => FormValueSelectorService.getSelectedMultiSelectValues(addOnProductList);

  // initForm(): initializes form data
  Future<void> initForm() async {
    selectedAddress = AddressModel.copy(addressModel: jobModel?.address);
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    showJPLoader();

    try {
      await setUpAPIData(); // loading form data from server
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      Get.back();
      update();
    }
  }


  // setAllUsers(): loads users from local DB & also fill fields with selected users
  Future<void> setUpAPIData() async {
    initialJson = eagleViewFormJson();

    // loading from API
    allMeasurementsList = await EagleViewOrderFormRepository.getMeasurementList();
    try {
      final Map<String, dynamic> param = {'ignoreToast' : true};
      allProductsList = await EagleViewOrderFormRepository.getProducts(param);
    } on DioException catch (e) {
      MeasurementHelper.handleEagleViewError(e, eagleViewAuthenticated: () {
        initForm();
      });
    }

    if(allProductsList.isNotEmpty) {
      productList = [];
      for (var allProducts in allProductsList) {
        productList.add(JPSingleSelectModel(
          id: allProducts.productID?.toString() ?? "",
          label: allProducts.name ?? ""
      ));
      }
    }
    update();
  }

  void selectProduct() {
    SingleSelectHelper.openSingleSelect(
      productList,
      selectedProduct?.id,
      'select_product'.tr,
      setProduct
    );
  }

  void setProduct(String value) {
    selectedProduct = productList.firstWhereOrNull((element) => element.id == value);
    productsController.text = SingleSelectHelper.getSelectedSingleSelectValue(productList, selectedProduct?.id);
    if(selectedProduct != null) {
      ///   Set delivery list
      selectedDelivery = null;
      deliveryList = [];
      allProductsList.firstWhereOrNull((product) => product.productID.toString() == selectedProduct?.id)?.deliveryProducts?.
          forEach((delivery) => deliveryList.add(JPSingleSelectModel(
              id: delivery?.productID?.toString() ?? "",
              label: delivery?.name ?? ""
            )
          )
        );

      ///   Set add-on products list
      addOnProductList = [];
      allProductsList.firstWhereOrNull((product) => product.productID.toString() == selectedProduct?.id)?.addOnProducts?.
        forEach((addOnProduct) => addOnProductList.add(JPMultiSelectModel(
            id: addOnProduct?.productID?.toString() ?? "",
            label: addOnProduct?.name ?? "",
            isSelect: false,
          )
        )
      );

      ///   Set measurement list
      selectedDelivery = null;
      measurementsList = [];
      allProductsList.firstWhereOrNull((product) => product.productID.toString() == selectedProduct?.id)?.measurementInstructionTypes?.
          forEach((measurementId) => measurementsList.add(
              allMeasurementsList.firstWhere((element) =>
              element.id == measurementId.toString())));
    }
    Get.back();
    validateForm();
    update();
  }

  void selectDelivery() {
    SingleSelectHelper.openSingleSelect(
      deliveryList,
      selectedDelivery?.id,
      'select_delivery'.tr,
      setDelivery
    );
  }

  void setDelivery(String value) {
    selectedDelivery = deliveryList.firstWhereOrNull((element) => element.id == value);
    deliveryController.text = SingleSelectHelper.getSelectedSingleSelectValue(deliveryList, selectedDelivery?.id);
    Get.back();
    validateForm();
  }

  void selectAddOnProducts() {
    FormValueSelectorService.openMultiSelect(
      list: addOnProductList,
      tags: selectedAddOnProductsList,
      title: 'other_products'.tr,
      controller: addOnProductsController,
      onSelectionDone: () {
        validateForm();
        update();
      },
    );
  }

  void selectMeasurement() {
    SingleSelectHelper.openSingleSelect(
      measurementsList,
      selectedMeasurements?.id,
      'select_measurement'.tr,
      setMeasurement
    );
  }

  void setMeasurement(String value) {
    selectedMeasurements = measurementsList.firstWhereOrNull((element) => element.id == value);
    measurementController.text = SingleSelectHelper.getSelectedSingleSelectValue(measurementsList, selectedMeasurements?.id);
    Get.back();
    validateForm();
  }

  void selectDate() {
    DateTimeHelper.openDatePicker(
        initialDate: selectedDateOfLoss,
        helpText: "select_date".tr).then((dateTime) {
      if(dateTime != null) {
        selectedDateOfLoss = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateServerFormat);
        dateOfLossController.text = DateTimeHelper.format(dateTime.toString(), DateFormatConstants.dateOnlyFormat);
      }
      validateForm();
      update();
    });
  }

  void toggleHavePromoCode(bool val) {
    havePromoCode = !val;
    validateForm();
    update();
  }

  void toggleHavePreviousChanges(bool val) {
    havePreviousChanges = !val;
    validateForm();
    update();
  }

  void onSendCopyEmailChange(String s) => validateForm();

  /// form field validators ----------------------------------------------------

  bool validateFormData() {
    if (!Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress))) {
      return false;
    } else if (FormValidator.requiredFieldValidator(productsController.text) != null) {
      return false;
    } else if (FormValidator.requiredFieldValidator(deliveryController.text) != null) {
      return false;
    } else if (FormValidator.requiredFieldValidator(measurementController.text) != null) {
      return false;
    } else if ((sendCopyToController.text.isNotEmpty ? (FormValidator.validateEmail(sendCopyToController.text)) : null) != null) {
      return false;
    } else {
      return true;
    }
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() => initialJson.toString() != eagleViewFormJson().toString();

  //   isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable(dynamic formFieldType) {

    if(controller.isSavingForm) {
      return false;
    }

    switch (pageType) {
      case EagleViewFormType.createForm:
        switch (formFieldType) {
          case FormFieldType.delivery:
          case FormFieldType.addOnProducts:
          case FormFieldType.measurement:
            return selectedProduct != null;
          default:
            return true;
        }
      case EagleViewFormType.editForm:
        switch (formFieldType) {
          case FormFieldType.delivery:
          case FormFieldType.addOnProducts:
          case FormFieldType.measurement:
            return selectedProduct != null;
          default:
            return true;
        }
      default:
        return true;
    }
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    if(!Helper.isValueNullOrEmpty(FormValidator.validateAddressForm(selectedAddress))) {
      openAddressDialogue();
    } else if (FormValidator.requiredFieldValidator(productsController.text) != null) {
      await expandProductSection();
      validateForm();
      productsController.scrollAndFocus();
    } else if (FormValidator.requiredFieldValidator(deliveryController.text) != null) {
      await expandProductSection();
      validateForm();
      deliveryController.scrollAndFocus();
    } else if (FormValidator.requiredFieldValidator(measurementController.text) != null) {
      await expandProductSection();
      validateForm();
      measurementController.scrollAndFocus();
    } else if (sendCopyToController.text.isNotEmpty) {
      if((FormValidator.validateEmail(sendCopyToController.text) != null) && !controller.isOtherInfoSectionExpanded){
        controller.onOtherInfoSectionExpansionChanged(true);
        update();
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      validateForm();
      sendCopyToController.scrollAndFocus();
    }
  }

  Future<bool> expandProductSection() async {
    if (!controller.isProductSectionExpanded) {
      controller.onProductSectionExpansionChanged(true);
      update();
      return await Future.delayed(const Duration(milliseconds: 200), () => true);
    } else {
      return true;
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