import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/global_widgets/forms/custom_fields/index.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../services/company_settings.dart';
import 'fields.dart';
import '../common/params.dart';

class CustomerFormData {

  JPInputBoxController firstNameController = JPInputBoxController();
  JPInputBoxController lastNameController = JPInputBoxController();
  JPInputBoxController secFirstNameController = JPInputBoxController();
  JPInputBoxController secLastNameController = JPInputBoxController();
  JPInputBoxController commercialCustomerNameController = JPInputBoxController();
  JPInputBoxController salesManCustomerRepController = JPInputBoxController();
  JPInputBoxController companyNameController = JPInputBoxController();
  JPInputBoxController managementCompanyController = JPInputBoxController();
  JPInputBoxController canvasserController = JPInputBoxController();
  JPInputBoxController otherCanvasserController = JPInputBoxController();
  JPInputBoxController propertyNameController = JPInputBoxController();
  JPInputBoxController callCenterRepController = JPInputBoxController();
  JPInputBoxController otherCallCenterRepController = JPInputBoxController();
  JPInputBoxController customerNoteController = JPInputBoxController();
  JPInputBoxController referralController = JPInputBoxController();
  JPInputBoxController otherReferralController = JPInputBoxController();
  JPInputBoxController customerReferralController = JPInputBoxController();

  bool isCommercial = false;
  bool isLoading = true;
  bool showSecondaryNameField = false;
  bool isReferredByDisabled = false;
  bool syncWithQBDesktop = false; // helps in enable/disable sync with QBD

  final Duration duration = const Duration(milliseconds: 500); // it is used to set initialJson because some data will take time to set

  // Form helpers
  AddressModel address = AddressModel(id: -1, countryId: (AuthService.userDetails?.companyDetails?.countryId ?? -1));
  AddressModel billingAddress = AddressModel(id: -1);

  List<CustomFormFieldsModel> customFormFields = [];
  List<EmailModel> emails = [];
  List<PhoneModel> phones = [];

  // Selection IDs
  String salesManCustomerRepId = '';
  String canvasserId = '';
  String callCenterRepId = '';
  String referralId = '';
  String referralCustomerId = '';
  String canvasserType = 'user';
  String callCenterRepType = 'user';
  String referralType = '';

  // Selection Lists
  List<JPSingleSelectModel> salesManCustomerRepList = [];
  List<JPSingleSelectModel> canvasserList = [];
  List<JPSingleSelectModel> callCenterRepList = [];
  List<JPSingleSelectModel> allUsers = [];
  List<JPSingleSelectModel> referralsList = [];
  List<JPMultiSelectModel> allFlags = [];
  List<StateModel?> stateList = [];
  List<CountryModel?> countryList = [];

  // Section separator helpers
  List<FormSectionModel> allSections = [];
  List<InputFieldParams> allFields = [];
  List<InputFieldParams> initialFieldsData = [];
  List<InputFieldParams> sectionFields = [];

  List<JPSingleSelectModel> phoneTypeList = [
    JPSingleSelectModel(label: 'cell'.tr.capitalizeFirst!, id: 'cell'),
    JPSingleSelectModel(label: 'phone'.tr.capitalizeFirst!, id: 'phone'),
    JPSingleSelectModel(label: 'office'.tr.capitalizeFirst!, id: 'office'),
    JPSingleSelectModel(label: 'fax'.tr.capitalizeFirst!, id: 'fax'),
    JPSingleSelectModel(label: 'home'.tr.capitalizeFirst!, id: 'home'),
    JPSingleSelectModel(label: 'others'.tr.capitalizeFirst!, id: 'others'),
  ];

  // keys for managing separate form section
  final emailFormKey = GlobalKey<EmailsFormState>();
  final customFieldsFormKey = GlobalKey<CustomFieldsFormState>();
  final addressFormKey = GlobalKey<AddressFormState>();
  final phoneFormKey = GlobalKey<PhoneFormState>();

  bool get isCustomerFieldNotEmpty => allFields.isNotEmpty;

  Map<String, dynamic> initialJson = {}; // holds initial json for comparison
  Map<String, bool> fieldsToAdd = {}; // holds fields which will be sent to server
  Map<String, Function(InputFieldParams)> validators = {}; // holds list of validators

  CustomerModel? customer; // holds customer data and helps in setting up fields

  VoidCallback update; // helps in updating data

  CustomerFormData({
    required this.update,
  });

  /// [setFormData] set-up initial data for form
  void setFormData() {

    PhoneMasking.maskPhoneNumber("");

    if (customer != null) {

      isCommercial = customer?.isCommercial ?? false;

      // Salesman customer rep
      salesManCustomerRepId = customer?.repId ?? salesManCustomerRepList.first.id;
      salesManCustomerRepController.text = FormValueSelectorService.getSelectedSingleSelectValue(salesManCustomerRepList, salesManCustomerRepId);

      // Emails
      customer?.additionalEmails ??= [];
      customer?.additionalEmails?.insert(0, customer?.email ?? "");
      for (int i = 0; i < customer!.additionalEmails!.length; i++) {
        emails.add(EmailModel(email: customer!.additionalEmails![i] ?? "", isPrimary: i == 0 ? 1 : 0));
      }

      // Other information
      companyNameController.text = customer?.companyName ?? "";
      managementCompanyController.text = customer?.managementCompany ?? "";
      propertyNameController.text = customer?.propertyName ?? "";
      customerNoteController.text = customer?.note ?? "";

      // Address
      address = customer?.address ?? address;
      billingAddress = customer?.billingAddress ?? billingAddress;
      billingAddress.name = customer?.billingName ?? "";
      billingAddress.sameAsDefault = address.id == billingAddress.id;

      // Customer company name
      if (isCommercial) {
        companyNameController.text = customer?.firstName ?? "";
        if (customer?.contacts?.isNotEmpty ?? false) {
          final contact = customer!.contacts!.first;
          firstNameController.text = contact.firstName ?? "";
          lastNameController.text = contact.lastName ?? "";
        }
      } else {
        firstNameController.text = customer?.firstName ?? "";
        lastNameController.text = customer?.lastName ?? "";
        if (customer?.contacts?.isNotEmpty ?? false) {
          final contact = customer!.contacts!.first;
          showSecondaryNameField = true;
          secFirstNameController.text = contact.firstName ?? "";
          secLastNameController.text = contact.lastName ?? "";
        }
      }

      // Call center rep
      callCenterRepType = customer?.callCenterRepType ?? 'user';
      callCenterRepId = (customer?.callCenterRep?.id ?? "").toString();
      callCenterRepId = callCenterRepType == 'user' ? callCenterRepId : CommonConstants.otherOptionId;
      callCenterRepController.text = FormValueSelectorService.getSelectedSingleSelectValue(callCenterRepList, callCenterRepId);
      otherCallCenterRepController.text = customer?.callCenterRepString ?? "";

      // Canvasser
      canvasserType = customer?.canvasserType ?? 'user';
      canvasserId = (customer?.canvasser?.id ?? "").toString();
      canvasserId = canvasserType == 'user' ? canvasserId : CommonConstants.otherOptionId;
      canvasserController.text = FormValueSelectorService.getSelectedSingleSelectValue(canvasserList, canvasserId);
      otherCanvasserController.text = customer?.canvasserString ?? "";

      // Referral
      if (customer?.referredByType == 'customer') {
        referralType = customer?.referredByType ?? "";
        referralId = CommonConstants.customerOptionId;
        referralCustomerId = customer?.referredBy?.id.toString() ?? "";
        customerReferralController.text = customer?.referredBy?.fullName ?? "";
        otherReferralController.text = customer?.referredByNote ?? "";
        referralController.text = FormValueSelectorService.getSelectedSingleSelectValue(referralsList, referralId);
      } else {
        referralType = customer?.referredByType ?? 'referral';
        referralId = (customer?.referredBy?.id ?? "").toString();
        referralId = referralType == 'other' ? CommonConstants.otherOptionId : referralId;
        referralController.text = FormValueSelectorService.getSelectedSingleSelectValue(referralsList, referralId);
        otherReferralController.text = customer?.referredByNote ?? "";
      }
      isReferredByDisabled = customer?.sourceType?.toLowerCase() == 'zapier';
      // custom fields
      for (CustomFieldsModel? field in customer?.customFields ?? []) {
        CustomFormFieldsModel? formField = customFormFields.firstWhereOrNull((formField) => formField.id == field?.id);

        if(formField == null || field == null) continue;

        formField.fromCustomFieldModel(field);
      }

      syncWithQBDesktop = !(customer?.disableQboFinancialSyncing ?? true);

      phones = customer?.phones ?? [];
    }

    // Setting up default values if not exist
    if (salesManCustomerRepId.isEmpty) {
      salesManCustomerRepId = getDefaultSalesRep();
      salesManCustomerRepController.text = FormValueSelectorService.getSelectedSingleSelectValue(salesManCustomerRepList, salesManCustomerRepId);
    }

    if (canvasserId.isEmpty) {
      canvasserId = canvasserList.first.id;
      canvasserController.text = FormValueSelectorService.getSelectedSingleSelectValue(canvasserList, canvasserId);
    }

    if (referralId.isEmpty) {
      referralId = referralsList.first.id;
      referralController.text = FormValueSelectorService.getSelectedSingleSelectValue(referralsList, referralId);
    }

    if (callCenterRepId.isEmpty) {
      callCenterRepId = callCenterRepList.first.id;
      callCenterRepController.text = FormValueSelectorService.getSelectedSingleSelectValue(callCenterRepList, callCenterRepId);
    }

    if (emails.isEmpty) {
      emails.add(EmailModel(email: "", isPrimary: 1));
    }
  }

  void setInitialJson() {
    initialJson = customerFormJson();
    initialFieldsData = getCompanySettingFields();
  }

  Map<String, dynamic> customerFormJson({bool addAllFields = true}) {
    Map<String, dynamic> json = {};
    fieldsToAdd = fieldsToAddData(addAllFields: addAllFields);

    // customer company name
    json['id'] = customer?.id;
    json["is_commercial"] = isCommercial ? 1 : 0;
    json["first_name"] = isCommercial ? companyNameController.text : firstNameController.text;
    json["last_name"] = isCommercial ? "" : lastNameController.text;
    json['billing_name'] = billingAddress.name;

    if (showSecondaryNameField || isCommercial) {
      final secondaryNameDetails = {
        "first_name" : isCommercial ? firstNameController.text : secFirstNameController.text,
        "last_name" : isCommercial ? lastNameController.text : secLastNameController.text
      };
     if(firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty){
       json["customer_contacts"] = [secondaryNameDetails];
     }
    }

    // Company Name
    if(doAddField(CustomerFormConstants.companyName)) {
      json["company_name"] = isCommercial ? "" : companyNameController.text;
    }

    // Flags
    json['flag_ids[]'] = FormValueParser.multiSelectToSelectedIds(allFlags);

    // Emails
    if (doAddField(CustomerFormConstants.email)) {
      List<String> additionalEmails = [];
      for (int i = 0; i< emails.length; i++) {
        if (emails[i].isPrimary == 1) {
          json["email"] = emails[i].email.trim();
        } else {
          additionalEmails.add(emails[i].email.trim());
        }
      }
      additionalEmails.removeWhere((email) => email.trim().isEmpty);
      json["additional_emails[]"] = additionalEmails;
    }

    // Phone
    for(int i = 0; i < phones.length; i++) {
      json['phones[$i][id]'] = i.toString();
      json['phones[$i][label]'] = phones[i].label.toString().toLowerCase();
      json['phones[$i][number]'] = PhoneMasking.maskPhoneNumber(phones[i].number ?? "");
      json['phones[$i][ext]'] = phones[i].ext.toString();
      if(i == 0){
        json['phones[$i][is_primary]'] = '1';
      } else {
        json['phones[$i][is_primary]'] = '0';
      }
    }

    // Other Information
    if (doAddField(CustomerFormConstants.managementCompany)) {
      json["management_company"] = managementCompanyController.text;
    }

    if (doAddField(CustomerFormConstants.propertyName)) {
      json["property_name"] = propertyNameController.text;
    }

    if (doAddField(CustomerFormConstants.customerNote)) {
      json["note"] = customerNoteController.text;
    }

    if (doAddField(CustomerFormConstants.qbOnline)) {
      json["disable_qbo_financial_syncing"] = syncWithQBDesktop ? 0 : 1;
    }

    // Customer Address
    if (doAddField(CustomerFormConstants.customerAddress)) {
      json["address"] = address.toFormJson();
      json["billing[same_as_customer_address]"] = billingAddress.sameAsDefault! ? 1 : 0;
      if (!billingAddress.sameAsDefault!) {
        json["billing"] = billingAddress.toFormJson();
      }
    }

    // Canvasser
    if (doAddField(CustomerFormConstants.canvasser)) {
      json["canvasser"] = otherCanvasserController.text;
      json["canvasser_id"] = canvasserId == CommonConstants.otherOptionId ? "" : int.tryParse(canvasserId);
      json["canvasser_type"] = canvasserId == CommonConstants.otherOptionId ? "other" : "user";
    }

    // Call center rep
    if (doAddField(CustomerFormConstants.callCenterRep)) {
      json["call_center_rep"] = otherCallCenterRepController.text;
      json["call_center_rep_id"] = callCenterRepId == CommonConstants.otherOptionId ? "" : int.tryParse(callCenterRepId);
      json["call_center_rep_type"] = callCenterRepId == CommonConstants.otherOptionId ? "other" : "user";
    }

    // Custom fields
    if (doAddField(CustomerFormConstants.customFields)) {
      List<Map<String, dynamic>> customFieldJson = [];
      for (var field in customFormFields) {
        customFieldJson.add(field.toJson());
      }
      customFieldJson.removeWhere((element) => element.isEmpty);
      json['custom_fields'] = customFieldJson;
    }

    json["onlySaveJobs"] = 0;

    if (doAddField(CustomerFormConstants.salesManCustomerRep)) {
      json["rep_id"] = int.tryParse(salesManCustomerRepId);
    }

    if (doAddField(CustomerFormConstants.referredBy)) {
      if (referralId != CommonConstants.noneId) {
        if (referralId == CommonConstants.customerOptionId) {
          json["referred_by_type"] = 'customer';
          json["referred_by_id"] = referralCustomerId;
          json["referred_by_note"] = otherReferralController.text;
        } else {
          json["referred_by_type"] = referralId == CommonConstants.otherOptionId ? "other" : "referral";
          json["referred_by_id"] = referralId == CommonConstants.otherOptionId ? "" : referralId;
          json["referred_by_note"] = referralId == CommonConstants.otherOptionId ? otherReferralController.text : "";
        }
      }
    }

    return json;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    if (initialJson.isEmpty) return false;
    final currentJson = customerFormJson();
    return initialJson.toString() != currentJson.toString();
  }


  /// [checkIfFieldDataChange] will helps in identifying when field data is
  /// actually changed
  bool checkIfFieldDataChange() {
    final data = getCompanySettingFields();
    // if length is not matching then data is changed
    if (data.length != initialFieldsData.length) {
      return true;
    }

    for (int i=0; i<initialFieldsData.length; i++) {
      // if any of the field value isn't matching then data is changed
      if (data[i] != initialFieldsData[i]) {
        return true;
      }
    }

    return false;
  }

  /// [getCompanySettingFields] is a helper which will return fields from company settings
  /// if present otherwise, it will return customized list of fields
  List<InputFieldParams> getCompanySettingFields() {

    List<InputFieldParams> fields = [];

    final data = CompanySettingsService
        .getCompanySettingByKey(CompanySettingConstants.prospectCustomize);

    if(data is Map && data['CUSTOMER'] != null) {
      for (dynamic field in (data['CUSTOMER'] ?? [])) {
        final rawField = InputFieldParams.fromJson(field);
        fields.add(rawField);
      }
      bool isCustomFieldRequired = customFormFields.any((customField) => customField.isRequired ?? false);
      // adding custom fields
      if(isCustomFieldRequired) {
        fields.firstWhere((field) => field.key == CustomerFormConstants.customFields).showFieldValue = true;
      }
      return fields;
    }

    return CustomerFormFieldsData.fields;
  }

  /// [doAddField] will check if data for a field is to be send in json or not
  bool doAddField(String key) {
    return fieldsToAdd[key] ?? false;
  }

  /// [fieldsToAddData] returns the list of field with [true/false] value
  /// so to decide whether to include a field or not
  Map<String, bool> fieldsToAddData({bool addAllFields = true}) {

    final fields = getCompanySettingFields();

    Map<String, bool> data = {};

    for (InputFieldParams field in fields) {
      data.putIfAbsent(field.key, () => addAllFields ? true : field.showFieldValue);
    }

    return data;
  }

  /// [getDefaultSalesRep] Returns the default sales representative ID.
  /// If the company setting `customerSalesRepDefaultToCurrentUser` is true,
  /// it returns the current user's ID. Otherwise, it returns the first sales rep ID from the list.
  ///
  /// Returns:
  /// - A [String] containing the ID of the default sales representative.
  String getDefaultSalesRep() {
    // Retrieve the company setting for defaulting sales rep to current user
    final defaultToCurrentUser = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.customerSalesRepDefaultToCurrentUser);

    // Check if the setting is true
    if (Helper.isTrue(defaultToCurrentUser)) {
      // Return the current user's ID or the first sales rep ID if user ID is null
      return AuthService.userDetails?.id.toString() ?? salesManCustomerRepList.first.id;
    }

    // Return the first sales rep ID from the list
    return salesManCustomerRepList.first.id;
  }

}