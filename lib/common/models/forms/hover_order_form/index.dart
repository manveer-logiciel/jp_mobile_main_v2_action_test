
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/hover.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/files_listing/hover/user.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HoverOrderFormData {

  // form field controllers
  JPInputBoxController usersController = JPInputBoxController();
  JPInputBoxController deliverableController = JPInputBoxController();
  JPInputBoxController requestForController = JPInputBoxController();
  JPInputBoxController phoneController = JPInputBoxController();
  JPInputBoxController emailController = JPInputBoxController();
  JPInputBoxController addressController = JPInputBoxController();
  JPInputBoxController addressLineTwoController = JPInputBoxController();
  JPInputBoxController cityController = JPInputBoxController();
  JPInputBoxController stateController = JPInputBoxController();
  JPInputBoxController zipCodeController = JPInputBoxController();
  JPInputBoxController countryController = JPInputBoxController();

  // selection lists
  List<JPSingleSelectModel> allStates = [];
  List<JPSingleSelectModel> allCountries = [];
  List<JPSingleSelectModel> customerPhones = [];
  List<JPSingleSelectModel> customerEmails = [];

  List<JPSingleSelectModel> hoverDeliverables = DropdownListConstants.hoverDeliverables;

  List<JPSingleSelectModel> requestForType = [
    JPSingleSelectModel(id: 'customer', label: 'customer'.tr.capitalizeFirst!),
    JPSingleSelectModel(id: 'other', label: 'other'.tr.capitalizeFirst!),
  ];

  // selectors
  String selectedHoverDeliverableId = '';
  String selectedHoverUserId = '';
  String requestForTypeId = '';
  String selectedStateId = '';
  String selectedPhoneId = '';
  String selectedEmailId = '';
  String selectedCountryId = '';

  //form toggles
  bool withCaptureRequest = false;

  final VoidCallback update;

  CustomerModel? customer;
  int? jobId;
  HoverUserModel? jobHoverUser;
  HoverFormType formType;
  HoverJob? hoverJob;

  Map<String, dynamic> initialJson = {};

  HoverOrderFormData(this.update, {
    this.customer,
    this.jobId,
    this.jobHoverUser,
    this.hoverJob,
    this.formType = HoverFormType.add
  }); // update method from respective controller to refresh ui from service itself

  void setFormData() {
    selectedHoverDeliverableId = hoverDeliverables.first.id;
    deliverableController.text = hoverDeliverables.first.label;
    requestForTypeId = requestForType.first.id;

    final customerAddress = customer?.address;

    countryController.text = AuthService.userDetails?.companyDetails?.countryName ?? "";

    if(customer != null) {
      requestForController.text = customer?.fullName ?? "";

      if(customer?.phones?.isNotEmpty ?? false) {
        for(PhoneModel phone in customer?.phones ?? []) {

          if(phone.number == null) continue;

          customerPhones.add(
              JPSingleSelectModel(
                  label: PhoneMasking.maskPhoneNumber(phone.number ?? ""),
                  id: phone.number!.toString(),
              ),
          );
        }

        if(customerPhones.isNotEmpty) selectedPhoneId = customerPhones.first.id;
      }

      customer?.additionalEmails ??= [];

      if(customer?.email?.isNotEmpty ?? false) {
        customer?.additionalEmails?.add(customer?.email);
      }

      for (String? email in customer?.additionalEmails ?? []) {
        if(email == null || customerEmails.any((tempEmail) => tempEmail.label == email)) continue;
        customerEmails.add(JPSingleSelectModel(label: email, id: email));
      }

      if(customerEmails.isNotEmpty) selectedEmailId = customerEmails.first.id;

      addressController.text = customer?.address?.address ?? "";

      if(customerAddress != null) {
        cityController.text = customerAddress.city ?? "";
        stateController.text = customerAddress.state?.name ?? "";
        zipCodeController.text = customerAddress.zip ?? "";
        addressLineTwoController.text = customerAddress.addressLine1 ?? "";
        countryController.text = customerAddress.country?.name ?? countryController.text;
        if(customerAddress.state != null) {
          selectedStateId = customerAddress.state!.id.toString();
          if(!allStates.any((state) => state.id == customerAddress.state!.id.toString())) {
            allStates.add(
              JPSingleSelectModel(
                label: customerAddress.state!.name,
                id: selectedStateId,
              ),
            );
          }
        }

        if(customerAddress.country != null) {
          selectedCountryId = customerAddress.country!.id.toString();
          if(!allCountries.any((country) => country.id == customerAddress.country!.id.toString())) {
            allCountries.add(
              JPSingleSelectModel(
                label: customerAddress.country!.name,
                id: selectedCountryId,
              ),
            );
          }
        }
      }

      phoneController.text =
          FormValueSelectorService.getSelectedSingleSelectValue(customerPhones, selectedPhoneId);
      emailController.text =
          FormValueSelectorService.getSelectedSingleSelectValue(customerEmails, selectedEmailId);

    }

    if (hoverJob != null) {
      requestForTypeId = (hoverJob?.requestForType ?? "");
      withCaptureRequest = hoverJob?.isCaptureRequest ?? false;
      selectedHoverUserId = (hoverJob?.hoverUser?.id ?? "").toString();
      usersController.text = hoverJob?.hoverUser?.fullName ?? "";
      selectedHoverDeliverableId = (hoverJob?.deliverableId ?? "").toString();
      deliverableController.text = hoverJob?.deliverableType ?? "";
      requestForController.text = hoverJob?.customerName ?? "";
      phoneController.text = hoverJob?.customerPhone ?? "";
      emailController.text = hoverJob?.customerEmail ?? "";
      addressController.text = hoverJob?.jobAddress ?? "";
      addressLineTwoController.text = hoverJob?.jobAddressLine2 ?? "";
      cityController.text = hoverJob?.jobCity ?? "";
      countryController.text = hoverJob?.jobCountry ?? "";
      zipCodeController.text = hoverJob?.jobZipCode ?? "";
      stateController.text = hoverJob?.state ?? "";
      selectedStateId = (hoverJob?.stateId ?? "").toString();
      selectedCountryId = (hoverJob?.countryId ?? "").toString();
    }

    initialJson = hoverFormJson();

  }

  Map<String, dynamic> hoverFormJson() {
    Map<String, dynamic> data = {};

    data["hover_user_id"] = int.tryParse(selectedHoverUserId);
    data["hover_deliverable_id"] = int.tryParse(selectedHoverDeliverableId);
    data["job_id"] = jobId;

    if(withCaptureRequest) {
      data["type"] = requestForTypeId;
      data["customer_name"] = requestForController.text;
      data["customer_phone"] = PhoneMasking.unmaskPhoneNumber(phoneController.text);
      data["customer_email"] = emailController.text;
      data["country_id"] = AuthService.userDetails!.companyDetails!.countryId;
      data["job_address"] = addressController.text;
      data["job_address_line_2"] = addressLineTwoController.text;
      data["job_city"] = cityController.text;
      data["state_id"] = int.tryParse(selectedStateId);
      data["job_zip_code"] = zipCodeController.text;
      data["deliverable_id"] = int.tryParse(selectedHoverDeliverableId);
      data["hover_user_email"] = jobHoverUser?.email;
    }

    return data;
  }

  HoverJob toHoverModel() {

    return HoverJob(
      jobId: jobId,
      hoverUser: HoverUserModel(
          id: int.tryParse(selectedHoverUserId),
          firstName: usersController.text,
          fullName: usersController.text,
      ),
      deliverableId: int.tryParse(selectedHoverDeliverableId),
      deliverableType: deliverableController.text,
      customerName: requestForController.text,
      customerPhone: PhoneMasking.unmaskPhoneNumber(phoneController.text),
      customerEmail: emailController.text,
      isCaptureRequest: withCaptureRequest,
      jobAddress: addressController.text,
      jobAddressLine2: addressLineTwoController.text,
      state: stateController.text,
      stateId: int.tryParse(selectedStateId),
      jobZipCode: zipCodeController.text,
      jobCity: cityController.text,
      jobCountry: countryController.text,
      countryId: int.tryParse(selectedCountryId),
      requestForType: requestForTypeId
    );
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = hoverFormJson();
    return initialJson.toString() != currentJson.toString();
  }

}