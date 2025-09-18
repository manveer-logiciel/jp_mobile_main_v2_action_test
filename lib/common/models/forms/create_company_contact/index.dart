import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/tag/tag.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// CreateCompanyContactFormData is responsible for providing data to be used by form
/// - Helps in setting up form data
/// - Helps in proving json to be used while making api request
/// - Helps in comparing form data
class CreateCompanyContactFormData {


  CreateCompanyContactFormData({
    required this.update,
    this.pageType, 
    this.companyContactModel});

  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  final CompanyContactFormType? pageType;
  CompanyContactListingModel? companyContactModel;
  AddressModel address = AddressModel(id: -1);

  // form field controllers
   JPInputBoxController firstNameController = JPInputBoxController();
   JPInputBoxController lastNameController = JPInputBoxController();
   JPInputBoxController companyNameController = JPInputBoxController();
   JPInputBoxController addressController = JPInputBoxController(); 
   JPInputBoxController addressLine2Controller = JPInputBoxController();
   JPInputBoxController assignGroupsController = JPInputBoxController();
   JPInputBoxController cityController = JPInputBoxController();
   JPInputBoxController stateController = JPInputBoxController(text:'None');
   JPInputBoxController zipController = JPInputBoxController();
   JPInputBoxController countryController = JPInputBoxController();
   JPInputBoxController notesController = JPInputBoxController();

  // form toggles
   bool isAdditionalDetailsExpanded = false;
   bool isLoading = true;
   bool isPrimary = false; // used to set as primary or not
   bool isSaveAsCompanyContact = false; // used to save in company contact list or not

  List<JPSingleSelectModel> states = []; // used to store states
  List<JPSingleSelectModel> countries = []; // used to store countries
  List<JPMultiSelectModel> assignGroups = []; // used to store tags in jpMultiSelectModel
  List<EmailModel> emailList = []; // used to store email fields
  List<PhoneModel> phoneList = []; // used to store phone fields
  List<TagModel> assignGroup = []; // used to store tags list comming from api :: asign groups
  List<JPSingleSelectModel> phoneTypeList = [
    JPSingleSelectModel(label: 'cell'.tr.capitalizeFirst!, id: 'cell'),
    JPSingleSelectModel(label: 'phone'.tr.capitalizeFirst!, id: 'phone'),
    JPSingleSelectModel(label: 'office'.tr.capitalizeFirst!, id: 'office'),
    JPSingleSelectModel(label: 'fax'.tr.capitalizeFirst!, id: 'fax'),
    JPSingleSelectModel(label: 'home'.tr.capitalizeFirst!, id: 'home'),
    JPSingleSelectModel(label: 'others'.tr.capitalizeFirst!, id: 'others'),
  ];

  List<StateModel?> stateList = [];
  List<CountryModel?> countryList = [];

  JPSingleSelectModel? selectedCountry; // used to store selected country
  JPSingleSelectModel? selectedState; // used to store selected state
  String id = ''; // used to store id of contact
  final Duration duration = const Duration(milliseconds: 500); // it is used to set initialJson because some data will take time to set

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // setFormData(): set-up form data to be pre-filled in form
  void setFormData({bool isSetInitialJson = true}) {
    if (companyContactModel != null) {
      address = companyContactModel?.address ?? address;
      emailList = companyContactModel?.emails ?? [];
      if (emailList.isEmpty) {
        emailList = [EmailModel(email: "")];
      }
      phoneList = companyContactModel?.phones ?? [];
      id = companyContactModel?.id.toString() ?? '';
      firstNameController.text = companyContactModel?.firstName ?? '';
      lastNameController.text = companyContactModel?.lastName ?? '';
      companyNameController.text = companyContactModel?.companyName ?? '';
      FormValueSelectorService.parseMultiSelectData(assignGroups, assignGroupsController);
      addressController.text = companyContactModel?.address?.address ?? "";
      addressLine2Controller.text = companyContactModel?.address?.addressLine1 ?? '';
      cityController.text = companyContactModel?.address?.city ?? '';
      zipController.text = companyContactModel?.address?.zip ?? '';
      selectedState = states.firstWhereOrNull((element) => element.id == companyContactModel?.address?.state?.id.toString());
      stateController.text = selectedState?.label ?? '';
      selectedCountry = countries.firstWhereOrNull((element) => element.id == companyContactModel?.address?.country?.id.toString());
      countryController.text = selectedCountry?.label ?? '';
      isPrimary = companyContactModel?.isPrimary ?? false;
      isSaveAsCompanyContact = companyContactModel?.isCompanyContact ?? false;
    }
    if (isSetInitialJson) {
      // Future delayed is used because country id will take time to set from AddressFormData
      Future.delayed(duration, () {
        initialJson = companyContactsFormJson();
      });
    }
    isLoading = false;
  }

  // companyContactsFormJson(): provides json to stores on server while submitting form
  Map<String, dynamic> companyContactsFormJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['first_name'] = firstNameController.text;
    data['last_name'] = lastNameController.text;
    data['full_name'] = '${firstNameController.text} ${lastNameController.text}';
    data['full_name_mobile'] = '${firstNameController.text} ${lastNameController.text}';
    data['company_name'] = companyNameController.text;
    data['address'] = address.address;
    data['address_line_1'] = address.addressLine1;
    data['tag_ids[]'] = FormValueParser.multiSelectToSelectedIds(assignGroups);
    data['city'] = address.city;
    data['state_id']= address.stateId ?? address.state?.id;
    data['country_id'] = address.countryId ?? address.country?.id;
    data['zip'] = address.zip;
    data['note'] = notesController.text;
    data['is_primary'] = isPrimary ? 1 : 0;

    if (pageType == CompanyContactFormType.jobContactPersonCreateForm || pageType == CompanyContactFormType.jobContactPersonEditForm) {
      data['is_company_contact'] = isSaveAsCompanyContact ? 1 : 0;
    }

    if(emailList.isNotEmpty) { 
      emailList.first.isPrimary = 1;
      List<Map<String, dynamic>> emailJsonList = [];
      for (EmailModel emailModel in emailList) {
        if (emailModel.email.trim().isNotEmpty) {
          emailJsonList.add(emailModel.toJson());
        }
      }
      data['emails'] = emailJsonList;
    }
    
    if(phoneList.isNotEmpty) {
      phoneList.first.isPrimary = 1;
      List<Map<String, dynamic>> phoneJsonList = [];
      for (PhoneModel phoneModel in phoneList) {
        if (phoneModel.number?.trim().isNotEmpty ?? false) {
          phoneJsonList.add(phoneModel.toJson(withUnmaskNumber: true));
        }
      }
      data['phones'] = phoneJsonList;
    }

    return data;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = companyContactsFormJson();
    return initialJson.toString() != currentJson.toString();
  }
}