import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/models/address/address.dart';
import '../../../common/models/google_maps/place_details.dart';
import '../../../common/models/sql/state/state.dart';
import '../../../common/repositories/google_maps.dart';
import '../../../common/services/auth.dart';
import '../../../core/utils/form/db_helper.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/single_select_helper.dart';

class SearchedAddressDialogueController extends GetxController {

  bool isLoading = false;
  bool isInfoVisible = false;

  JPInputBoxController addressTextController = JPInputBoxController();
  JPInputBoxController addressLine1TextController = JPInputBoxController();
  JPInputBoxController cityTextController = JPInputBoxController();
  JPInputBoxController stateTextController = JPInputBoxController();
  JPInputBoxController countryTextController = JPInputBoxController();
  JPInputBoxController zipTextController = JPInputBoxController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<JPSingleSelectModel> allCountries = []; // used to store country
  List<JPSingleSelectModel> allStates = []; // used to store states

  AddressModel? addressModel = AddressModel(id: 0);

  int? countryId;
  JPSingleSelectModel? selectedState;
  JPSingleSelectModel? selectedCountry;

  bool validateFormOnDataChange = false;

  SearchedAddressDialogueController({this.addressModel});

  @override
  void onInit() {
    super.onInit();
    try {
      initDBElements().whenComplete(() => initData());
    } catch (e) {
      rethrow;
    } finally{
      update();
    }
  }

  Future<void> initDBElements() async {
    countryId = AuthService.userDetails?.companyDetails?.countryId;
    allStates = await FormsDBHelper.getAllStates(labelSameAsCode: false);
    allCountries = await FormsDBHelper.getAllCountries(labelSameAsCode: false);
    selectedState = allStates.firstWhereOrNull((element){
      return element.additionalData.code == addressModel?.state?.code.toString();
    });
    selectedCountry = allCountries.firstWhereOrNull((element) => element.id == countryId.toString());
  }

  void initData() async {
    addressTextController.text = addressModel?.address ?? "";
    addressLine1TextController.text = addressModel?.addressLine1 ?? "";
    cityTextController.text = addressModel?.city ?? "";
    stateTextController.text = selectedState?.label ?? "";
    countryTextController.text = selectedCountry?.label ?? "";
    zipTextController.text = addressModel?.zip ?? "";
  }
  
  void selectState() {
    SingleSelectHelper.openSingleSelect(
      allStates,
      selectedState?.id.toString(),
      "select_state".tr,
      (value) {
        selectedState = allStates.firstWhereOrNull((element) => element.id == value);
        stateTextController.text = allStates.firstWhereOrNull((element) => element.id == value)?.label ?? "";
        Get.back();
        onDataChanged(value);
        update();
      },
      isFilterSheet: true);
  }

  void validateAddress(void Function(AddressModel params) onApply) {
    validateFormOnDataChange = true;
    if(validateForm()) {
      addressModel!.address = addressTextController.text;
      addressModel!.addressLine1 = addressLine1TextController.text;
      addressModel!.city = cityTextController.text;
      addressModel!.state = StateModel(
          id: int.tryParse(selectedState?.id ?? "0") ?? 0,
          name: selectedState?.label ?? "",
          code: selectedState?.additionalData.code ?? "",
          countryId: int.tryParse(selectedCountry?.id ?? "0") ?? 0);
      addressModel!.country = CountryModel(
          id: int.tryParse(selectedCountry?.id ?? "0") ?? 0,
          name: selectedCountry?.label ?? "",
          code: "", currencyName: "", currencySymbol: "");
      addressModel!.zip = zipTextController.text;
      fetchAddressId(Helper.convertAddress(addressModel), onApply);
    } else {
      scrollToErrorField();
    }
  }

   // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    if (FormValidator.requiredFieldValidator(addressLine1TextController.text) != null) {
      addressLine1TextController.scrollAndFocus();
    } else if(FormValidator.requiredFieldValidator(addressTextController.text) != null) {
      addressTextController.scrollAndFocus();
    } else if(FormValidator.requiredFieldValidator(cityTextController.text) != null) {
      cityTextController.scrollAndFocus();
    } else if(FormValidator.requiredFieldValidator(zipTextController.text) != null) {
      zipTextController.scrollAndFocus();
    } else if(FormValidator.requiredFieldValidator(countryTextController.text) != null) {
      countryTextController.scrollAndFocus();
    } else if(FormValidator.requiredFieldValidator(stateTextController.text) != null) {
      stateTextController.scrollAndFocus();
    }
  }

  ////////////////////////   FETCH ADDRESS DETAILS    //////////////////////////

  Future<void> fetchAddressId(String val, void Function(AddressModel params) onApply) async {
    try {
      toggleLoading();
      Map<String, dynamic> response = await GoogleMapRepository().fetchSimilarPlaces(val);
      if((response["list"] is List) && response["list"]?.isNotEmpty) {
        fetchAddressDetails(response["list"][0]?.placeId ?? "", onApply);
      } else {
        Helper.showToastMessage("no_location_found".tr);
      }
    } catch (e) {
      rethrow;
    } finally {
      update();
      toggleLoading();
    }
  }

  void onDataChanged(dynamic val) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
  }

  bool validateForm() => formKey.currentState?.validate() ?? false;

  Future<void> fetchAddressDetails(String placeId, void Function(AddressModel params) onApply) async {
    try {
      PlaceDetailsModel response = await GoogleMapRepository().fetchPlaceDetails(placeId);
      addressModel?.lat = response.geometry?.lat;
      addressModel?.long = response.geometry?.lng;
      Get.back();
      onApply(addressModel!);
    } catch (e) {
      rethrow;
    }
  }

  void toggleLoading() {
    isLoading = !isLoading;
    update();
  }

  @override
  void dispose() {
    addressTextController.controller.dispose();
    addressLine1TextController.controller.dispose();
    cityTextController.controller.dispose();
    stateTextController.controller.dispose();
    countryTextController.controller.dispose();
    zipTextController.controller.dispose();
    super.dispose();
  }

}