import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AddressFormData {

  JPInputBoxController addressController = JPInputBoxController();
  JPInputBoxController addressLine2Controller = JPInputBoxController();
  JPInputBoxController addressLine3Controller = JPInputBoxController();
  JPInputBoxController cityController = JPInputBoxController();
  JPInputBoxController stateController = JPInputBoxController();
  JPInputBoxController zipController = JPInputBoxController();
  JPInputBoxController countryController = JPInputBoxController();
  JPInputBoxController nameController = JPInputBoxController();

  bool showBillingAddressToggle = false;
  bool showBillingAddress = false;
  bool isSectionExpanded = false;
  bool sameAsCustomerAddress = true;

  String selectedStateId = '';
  String selectedCountryId = '';

  bool isBillingAddress;

  AddressModel? address;

  List<JPSingleSelectModel> allStates;
  List<JPSingleSelectModel> allCountries;

  bool get doShowStateSelect => allStates.length > 1;
  bool get doShowCountrySelect => allCountries.length > 1;

  AddressFormData({
    this.isBillingAddress = false,
    this.showBillingAddressToggle = false,
    this.sameAsCustomerAddress = true,
    this.address,
    required this.allStates,
    required this.allCountries,
  }) {
    setFormData();
  }

  void setFormData() {

    addressController.text = address?.address ?? "";
    addressLine2Controller.text = address?.addressLine1 ?? "";
    addressLine3Controller.text = address?.addressLine3 ?? "";
    cityController.text = address?.city ?? "";
    zipController.text = address?.zip ?? "";
    nameController.text = address?.name ?? "";
    if(address?.stateId == 0) {
      if(!Helper.isValueNullOrEmpty(allStates)) {
        if(allStates.first.additionalData is StateModel) {
          address?.state = allStates.first.additionalData as StateModel;
        }
        selectedStateId = allStates.first.id.toString();
      }
    } else {
      selectedStateId = (address?.stateId ?? "").toString();
    }

    selectedCountryId = (AuthService.userDetails?.companyDetails?.countryId ?? "").toString();

    address?.countryId = int.tryParse(selectedCountryId);

    stateController.text = FormValueSelectorService.getSelectedSingleSelectValue(allStates, selectedStateId);

    CompanyModel? companyModel = AuthService.userDetails?.companyDetails;
    if(Helper.isValueNullOrEmpty(address?.country) && companyModel != null) {
      address?.country = CountryModel(
          id: companyModel.countryId ?? 0,
          name: companyModel.countryName ?? '',
          code: companyModel.countryCode ?? '',
          currencyName: '',
          currencySymbol: companyModel.currencySymbol ?? '');
      countryController.text = companyModel.countryName ?? "";
    } else {
      countryController.text = address?.country?.name ?? '';
    }
  }

  String? validateAddress() {
    return FormValidator.requiredFieldValidator(addressController.text,
        errorMsg: "address_is_required".tr);
  }

  String? validateCity() {
    return FormValidator.requiredFieldValidator(
      cityController.text,
      errorMsg: "city_is_required".tr
    );
  }

  String? validateZip() {
    return FormValidator.requiredFieldValidator(
      zipController.text,
      errorMsg: "zip_code_is_required".tr
    );
  }

  String? validateState() {
    return FormValidator.requiredFieldValidator(
      stateController.text,
      errorMsg: "state_is_required".tr
    );
  }

  StateModel? get selectedState {
    return allStates.firstWhereOrNull((state) {
      final stateCode = (state.additionalData as StateModel).code;
      return stateCode == address?.state?.code;
    })?.additionalData as StateModel?;
  }

  AddressModel? toAddressModel({AddressModel? data}) {
    // filling address form as of location selected
    if (data != null) {
      // updating selected state
      final state = allStates.firstWhereOrNull((state) {
        final stateCode = (state.additionalData as StateModel).code;
        return stateCode == data.state?.code;
      });
      cityController.text = data.city ?? "";
      zipController.text = data.zip ?? "";
      addressLine2Controller.text = data.addressLine1 ?? "";
      addressLine3Controller.text = data.addressLine3 ?? "";
      selectedStateId = state?.id ?? "";
      stateController.text = state?.label ?? "";
    }

    return address
      ?..city = cityController.text
      ..zip = zipController.text
      ..state = data?.state ?? selectedState
      ..stateId = int.tryParse(selectedStateId)
      ..addressLine1 = addressLine2Controller.text
      ..addressLine3 = addressLine3Controller.text
      ..address = addressController.text
      ..lat = data?.lat
      ..long = data?.long
      .. name = nameController.text;
  }

}