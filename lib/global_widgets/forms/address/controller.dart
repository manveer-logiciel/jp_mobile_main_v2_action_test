import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/forms/address/index.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AddressFormController extends GetxController {

  AddressFormController({
    required this.address,
    this.isRequired = false,
    this.billingAddress,
    required this.isInitialSectionExpanded,
  });

  final formUiHelper = FormUiHelper(); // helps in building ui
  final formKey = GlobalKey<FormState>(); // used to validate form

  final bool isRequired; // decides whether fields are required and performs validations accordingly

  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  AddressModel address; // holds address data
  AddressModel? billingAddress; // holds billing address data
  AddressFormData? addressData; // holds address form data
  AddressFormData? billingAddressData; // holds billing address form data

  List<JPSingleSelectModel> allStates = []; // holds all states
  List<JPSingleSelectModel> allCountries = []; // holds all countries

  final bool isInitialSectionExpanded; // helps in section to expandable on initial rendering

  @override
  void onInit() {
    init();
    super.onInit();
  }

  /// [init] helps in initialing data
  Future<void> init() async {
    try {
      // setting up country & states
      allStates = await FormsDBHelper.getAllStates();
      allCountries = await FormsDBHelper.getAllCountries();

      // setting up form-data
      addressData = AddressFormData(
        showBillingAddressToggle: billingAddress != null,
        address: address,
        allCountries: allCountries,
        allStates: allStates,
        sameAsCustomerAddress: address.sameAsDefault ?? false
      );

      addressData?.isSectionExpanded = isInitialSectionExpanded;

      // setting up billing address only if it is different from default address
      if (!(billingAddress?.sameAsDefault ?? true)) {
        addressData?.showBillingAddress = true;
        addBillingAddress(expandSection: false);
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
    }
  }

  // onExpansionChanged() : helps in managing expansion state of section
  void onExpansionChanged(AddressFormData data, bool val) {
    data.isSectionExpanded = val;
  }

  // validateForm(): validates form and returns result
  bool validateForm({bool scrollOnValidation = false}) {
    bool isValid = formKey.currentState?.validate() ?? false;

    if(!isValid && scrollOnValidation) {
      addressData?.isSectionExpanded = scrollOnValidation;
      scrollToErrorField();
      update();
    }
    return isValid;
  }

  Future<void> scrollToErrorField() async {
    bool isAddressError = addressData?.validateAddress() != null;
    bool isCityError = addressData?.validateCity() != null;
    bool isStateError = addressData?.validateState() != null;
    bool isZipError = addressData?.validateZip() != null;

    if(isAddressError) {
      addressData?.addressController.scrollAndFocus();
    } else if(isCityError) {
      addressData?.cityController.scrollAndFocus();
    } else if(isZipError) {
      addressData?.zipController.scrollAndFocus();
    } else if(isStateError) {
      addressData?.stateController.scrollAndFocus();
    } 
  }

  // selectState(): helps in selecting state
  void selectState({required AddressFormData data}) {
    FormValueSelectorService.openSingleSelect(
      title: 'select_state'.tr,
      list: allStates,
      selectedItemId: data.selectedStateId,
      controller: data.stateController,
      onValueSelected: (val) {
        validateForm();
        data.selectedStateId = val;
        data.address?.stateId = int.tryParse(val);
        JPSingleSelectModel selectedStateModel = FormValueSelectorService.getSelectedSingleSelect(allStates, val);
        if (selectedStateModel.additionalData is StateModel) {
          StateModel stateModel = selectedStateModel.additionalData;
          data.address?.state = stateModel;
        }
      },
    );
  }

  // selectCountry():  helps in selecting country
  void selectCountry({required AddressFormData data}) {
    FormValueSelectorService.openSingleSelect(
      title: 'select_country'.tr,
      list: allCountries,
      selectedItemId: data.selectedCountryId,
      controller: data.countryController,
      onValueSelected: (val) {
        data.selectedCountryId = val;
        data.address?.countryId = int.tryParse(val);
      },
    );
  }

  // selectAddress(): helps in selecting address
  void selectAddress({required AddressFormData data}) {
    FormValueSelectorService.selectAddress(
        controller: data.addressController,
        onDone: (response) {
          data.address = data.toAddressModel(data: response);
          if(validateFormOnDataChange){
            validateForm();
          }
        }
    );
  }

  // toggleBillingAddress(): helps in show/hide billing address section
  void toggleBillingAddress({required AddressFormData data, bool val = false}) {
    data.showBillingAddress = val;
    if(!val) {
      removeName();
    }
    data.showBillingAddress ? addBillingAddress() : removeBillingAddress();
    update();
  }

  // addBillingAddress(): set-up billing address
  // expandSection - [true] : section will be displayed and expanded automatically
  // expandSection - [false] : section will not be expanded
  void addBillingAddress({bool expandSection = true}) {
    billingAddress?.sameAsDefault = false;
    billingAddressData = AddressFormData(
      isBillingAddress: true,
      address: billingAddress,
      allCountries: allCountries,
      allStates: allStates
    );
    billingAddressData?.isSectionExpanded = expandSection;
  }

  // removeBillingAddress(): removes billing address
  void removeBillingAddress() {
    billingAddress?.sameAsDefault = true;
    billingAddressData = null;
  }

  // removeName - removes  billing name
  void removeName() {
    billingAddressData?.nameController.text = '';
    billingAddress?.name = '';
  }

  // onValueChanged(): tracks realtime changes and update address
  void onValueChanged(AddressFormData data) {
    if(validateFormOnDataChange){
      validateForm();
    }
    data.address = data.toAddressModel();
  }

  void toggleSameAsCustomerAddress(AddressFormData data, bool val) {
    data.sameAsCustomerAddress = !val;
    address.sameAsDefault = data.sameAsCustomerAddress;
    update();
  }

  void didUpdateAddress(AddressModel? oldAddress, AddressModel newAddress) {
    if (oldAddress != newAddress) {
      address = newAddress;
      addressData?.address = address;
      addressData?.setFormData();
      update();
    }
  }
}