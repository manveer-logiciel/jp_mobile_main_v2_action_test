import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/enums/permission_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/forms/create_company_contact/index.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/repositories/company_contacts.dart';
import 'package:jobprogress/common/repositories/sql/country.dart';
import 'package:jobprogress/common/repositories/sql/state.dart';
import 'package:jobprogress/common/repositories/tag.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/platform_permissions.dart';
import 'package:jobprogress/core/constants/mix_panel/event/add_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/edit_events.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/company_contacts/create_company_contacts/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:permission_handler/permission_handler.dart';

/// CreateCompanyContactFormService used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class CreateCompanyContactFormService extends CreateCompanyContactFormData {
  CreateCompanyContactFormService(
      {required super.update,
      required this.validateForm,
      super.companyContactModel,
      super.pageType});

  final VoidCallback validateForm; // helps in validating form when form data updates
  CreateCompanyContactFormController? _controller; // helps in managing controller without passing object

  CreateCompanyContactFormController get controller => _controller ?? CreateCompanyContactFormController();

  set controller(CreateCompanyContactFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
              
    await Future<void>.delayed(const Duration(milliseconds: 200));
    showJPLoader();
    try {
      await getTagList();
      await setAllListData(); // setting states,countries,assign group list
      setFormData(); // filling form data
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }
  }

  // setAllListData(): loads states,countries from local DB & also set assign group list
  Future<void> setAllListData() async {
  // setting assign group list
    for(var e in assignGroup){
      assignGroups.add(JPMultiSelectModel(id: e.id.toString(), label: e.name, isSelect: false));
    }
    companyContactModel?.tags?.forEach((tags) { 
      for (var element in assignGroups) {
        if(tags.id.toString() == element.id) {
          element.isSelect = true;
        }
      }
    });
    await SqlStateRepository().get().then((states){
      states = states;
    });

    await SqlCountryRepository().get().then((countries){
      countries = countries;
    });
  }

  bool get isPhoneFieldEditable => PermissionService.hasUserPermissions([PermissionConstants.enableMasking]);

  /// selectors to select form data  --------------------------
  // selectAssignGroups(): used to select assign group from multiselect list.
  void selectAssignGroups() {
    FormValueSelectorService.openMultiSelect(
      list: assignGroups,
      title: 'assign_groups'.tr,
      controller: assignGroupsController,
      onSelectionDone: () {
        update();
      },
    );
  }

  void toggleIsSetAsPrimary(bool val) {
    isPrimary = val;
    update();
  }

  void toggleIsSaveAsCompanyContact(bool val) {
    isSaveAsCompanyContact = val;
    update();
  }

  void chooseFromContactQuickBottomSheet() {
    showJPBottomSheet(
      child: (_) => JPQuickAction(
        title: 'choose_from'.tr,
        mainList: [
          JPQuickActionModel(
            id: "company_contacts",
            child: const JPIcon(Icons.person_2_outlined, size: 18),
            label: 'company_contacts'.tr.capitalize!,
          ),
          JPQuickActionModel(
            id: "phonebook",
            child: const JPIcon(Icons.contacts_rounded, size: 18),
            label: 'phonebook'.tr.capitalize!,
          ),
        ],
        onItemSelect: (value) {
          Get.back();
          if (value == 'phonebook') {
            fetchContactFromPhone();
          } else if (value == 'company_contacts') {
            getContactPersonFromCompanyContacts();
          }
        },
      ),
      isScrollControlled: true,
    );
  }

  // getContactPersonFromCompanyContacts(): navigate to company contacts list and contact selection fill up data to form
  void getContactPersonFromCompanyContacts() async {
    final result = await Get.toNamed(Routes.companyContacts, 
      arguments: { NavigationParams.isForJobContactFormSelection: true }
    );
    if (result != null && result is CompanyContactListingModel) {
      result.isCompanyContact = true;
      companyContactModel = result;
      setFormData(isSetInitialJson: false);
      controller.emailFormKey.currentState?.updateFields(emailList);
      controller.phoneFormKey.currentState?.updateFields(phoneList);
      Future.delayed(duration, () => controller.validateForm()); // validate form once data has been set on fields
      update();
    }
  }

    // fetchContactFromPhone(): fetch contact from phone directory
  Future<void> fetchContactFromPhone() async {
    updateLoading();
    try {
      PermissionStatus status = await Permission.contacts.request();
      if (status == PermissionStatus.granted) {
      final contactsFromPhoneDirectory = await FlutterContacts.openExternalPick();
        if(contactsFromPhoneDirectory != null) {
          getContactFromPhoneData(contactsFromPhoneDirectory);
        }
      } else if(status == PermissionStatus.permanentlyDenied) {
        PlatformPermissionService.showRequestPermissionDialog(PermissionRequestType.contact);
      }
    } catch (e) {
      rethrow;
    } finally {
      updateLoading();
    }
  }
    // getContactFromPhoneData(contactsFromPhoneDirectory): put data from phone directory
  void getContactFromPhoneData(Contact contactsFromPhoneDirectory) {
      isSaveAsCompanyContact = false;
      companyContactModel?.isCompanyContact = false;
      firstNameController.text = contactsFromPhoneDirectory.name.first;
      lastNameController.text = contactsFromPhoneDirectory.name.last;
      if(contactsFromPhoneDirectory.organizations.isNotEmpty){
        companyNameController.text = contactsFromPhoneDirectory.organizations.first.company;
      } else {
        companyNameController.text = '';
      }
      if(contactsFromPhoneDirectory.phones.isNotEmpty){
        phoneList.clear();
        String label = '';
        int i = 0;
        for (var contactsPhone in contactsFromPhoneDirectory.phones) {
          String numberToFormat = Helper.isValueNullOrEmpty(contactsPhone.normalizedNumber) ? contactsPhone.number : contactsPhone.normalizedNumber;
          String formattedNumber = Helper.removeCountryCodes(numberToFormat);
          if(i >= 5) break;
          for (var element in phoneTypeList) { 
            if(contactsPhone.label.name == element.id) {
              label = element.id;
              break;
            } else {
              label = 'other';
            }
          }
         phoneList.add(
            PhoneModel( number: formattedNumber, label: label)
            );
          i++; 
        }
      } else {
        phoneList = [];
      }
      if(contactsFromPhoneDirectory.emails.isNotEmpty){
        emailList.clear();
        for(int i = 0; i < contactsFromPhoneDirectory.emails.length; i++) {
          if(i >= 5) break;
          emailList.add(EmailModel(email: contactsFromPhoneDirectory.emails[i].address,isPrimary: 0));
        }
      } else {
        emailList = [EmailModel(email: "")];
      }
      if(contactsFromPhoneDirectory.addresses.isNotEmpty && contactsFromPhoneDirectory.addresses.first.address.isNotEmpty) {
        Address add = contactsFromPhoneDirectory.addresses.first;
        String formattedAddress = add.street.replaceAll("\n", " ");
        StateModel? state = stateList.firstWhereOrNull((element) => element?.name.toLowerCase() == add.state);
        CountryModel? country = countryList.firstWhereOrNull((element) => element?.name.toLowerCase() == add.country);
        address = AddressModel(
                      id: 1,
                      address: formattedAddress,
                      addressLine1: add.subAdminArea,
                      city: add.city,
                      stateId: state?.id,
                      countryId: country?.id,
                      zip: add.postalCode
                  );
        addressLine2Controller.text = add.address;
      } else {
        address = AddressModel(
          id: 1,
          address: '',
          addressLine1: '',
          city: '',
          zip: ''
        );
        addressLine2Controller.text = '';
      }
      Future.delayed(duration, () => controller.validateForm()); // validate form once data has been set on fields
  }

  void updateLoading() {
    isLoading = !isLoading;
    update();
  }

    // getTagList(): fetch tag list to store in assign group list to get assign groups
  Future<void> getTagList() async{
    final tagsParams = <String, dynamic>{
      'includes[0]': ['counts'],
      'includes[1]': ['users'],
      'limit': 0,
      'type': 'contact'
    };
    var response = await TagRepository().fetchTagsList(tagsParams);
    assignGroup.addAll(response['list']);
    update();
  }

  

  /// toggles to update form  -----------------

  void onAdditionalOptionsExpansionChanged(bool val) {
    isAdditionalDetailsExpanded = val;
  }

  /// form field validators ----------------------------------------------------

  String? validateFirstName(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'first_name_cant_be_left_blank'.tr);
  }

  String? validateLastName(String val) {
    return FormValidator.requiredFieldValidator(val,
        errorMsg: 'last_name_cant_be_left_blank'.tr);
  }

  // isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable({bool val = true}) {
    if ((companyContactModel?.isCompanyContact ?? false) && companyContactModel?.id != null && val) {
      return false;
    }

    if(controller.isSavingForm) {
      return false;
    }
    return true;
  }

  // isFeldVisible(): to handle visiblity of form fields
  bool isFieldVisible() {
    return !(isPhoneFieldEditable && controller.pageType != CompanyContactFormType.createForm && controller.pageType != CompanyContactFormType.jobContactPersonCreateForm);
  }

  bool get isJobContactPersonForm {
    return controller.pageType == CompanyContactFormType.jobContactPersonCreateForm || controller.pageType == CompanyContactFormType.jobContactPersonEditForm;
  }

  // scrollToErrorField(): confirms which validation is failed and scrolls to that field in view & focuses it
  Future<void> scrollToErrorField() async {
    bool isFirstNameError = validateFirstName(firstNameController.text) != null;
    bool isLastNameError = validateLastName(lastNameController.text) != null;
    controller.phoneFormKey.currentState?.validate(scrollOnValidate: true) ?? false;
    controller.emailFormKey.currentState?.validate(scrollOnValidate: true) ?? false; 

    if (isFirstNameError) {
      firstNameController.scrollAndFocus();
    } else if (isLastNameError) {
      lastNameController.scrollAndFocus();
    } 
  }

  // saveForm():  makes a network call to save/update form
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {
    try {
      final params = companyContactsFormJson();
      switch(pageType) {
        case CompanyContactFormType.createForm:
          await createCompanyContactAPICall(params);
          break;
        case CompanyContactFormType.editForm:
          await updateCompanyContactAPICall(params);
          break;
        case CompanyContactFormType.jobContactPersonCreateForm:
        case CompanyContactFormType.jobContactPersonEditForm:
          Get.back(result: params);
          break;
        default:
          break;
      }
    } catch (e) {
      rethrow;
    }
  }

// createCompanyContactAPICall(): create company contact
  Future<void> createCompanyContactAPICall(Map<String, dynamic> params) async {
    final result = await CompanyContactsListingRepository().createCompanyContact(params);
    if (result["status"]) {
      MixPanelService.trackEvent(event: MixPanelAddEvent.form);
      Helper.showToastMessage('company_contact_created'.tr);
      Get.back(result: result);
    }
  }
// updateCompanyContactAPICall(): update company contact
  Future<void> updateCompanyContactAPICall(Map<String, dynamic> params) async {
   final result = await CompanyContactsListingRepository().updateCompanyContact(params);
    if (result["status"]) {
      MixPanelService.trackEvent(event: MixPanelEditEvent.form);
      Helper.showToastMessage('company_contact_updated'.tr);
      Get.back(result: result);
    }
  }
}