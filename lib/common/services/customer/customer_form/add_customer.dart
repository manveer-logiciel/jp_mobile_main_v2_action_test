import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/address.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/add_customer/data.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/referral_source/referral_source_param.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/sql/country.dart';
import 'package:jobprogress/common/repositories/sql/state.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/customer/customer_form/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/InputBox/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import '../../../models/custom_fields/custom_form_fields/index.dart';
import 'bind_validator.dart';

/// [CustomerFormService] used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class CustomerFormService extends CustomerFormData {

  CustomerFormService({
    required super.update,
    required this.validateForm,
    required this.onDataChange,
    this.customerId
  });

  int? customerId; // used to load customer data

  VoidCallback validateForm; // helps in performing validation in service

  CustomerFormController? _controller; // helps in managing controller without passing object

  CustomerFormController get controller => _controller ?? CustomerFormController();

  late CustomerFormBindValidator bindValidatorService;

  Function(String) onDataChange;

  set controller(CustomerFormController value) {
    _controller = value;
  }

  // initForm(): initializes form data
  Future<void> initForm() async {
    // delay to prevent navigation animation lags
    // because as soon as we enter form page a request to local DB is made
    // resulting in ui lag. This delay helps to avoid running both tasks in parallel
    await Future<void>.delayed(const Duration(milliseconds: 200));

    try {
      // loading customers from server
      await getCustomer();
      // setting up data from local DB
      await getLocalData();
      // fetching custom fields and setting them up
      await getCustomFields();

      // parsing dynamic fields
      setUpFields();

      // binding validators with fields
      bindValidatorService = CustomerFormBindValidator(this);
      bindValidatorService.bind();

      // filling form data
      setFormData();

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
      // additional delay for all widgets to get rendered and setup data
      await Future.delayed(const Duration(milliseconds: 500), setInitialJson);
    }
  }

  /// Fields Set-up -----------------------------------------------------------

  /// [updateFields] will update fields as soon as company settings update
  /// and rebind validators
  Future<void> updateFields() async {
    Get.back();

    showJPLoader();
    allFields.clear();
    sectionFields.clear();
    validators.clear();
    setUpFields();
    bindValidatorService.bind();
    initialFieldsData = getCompanySettingFields();

    // Fake delay
    await Future<void>.delayed(const Duration(milliseconds: 200));
    Get.back();
  }


  /// [getCustomFields] loads custom fields from server
  Future<void> getCustomFields() async {

    try {
      final params = {
        "model_type" : "customer",
        "limit" : 150,
        "includes[0]" : "options",
        "active" : 1,
      };

      List<CustomFormFieldsModel> tempCustomFormFields = await CustomerRepository.getCustomFields(params);
  
      setCustomFormFieldsData(tempCustomFormFields);
    } catch (e) {
      rethrow;
    }
  }

  void setCustomFormFieldsData(List<CustomFormFieldsModel> listOfCustomFields) {
    if (customFormFields.isNotEmpty) {
      for (final customField in customFormFields) {
        
        final index = listOfCustomFields.indexWhere((existingField) => existingField.id == customField.id);

        if (index != -1) {
          if (customField.isDropdown) {
            // Retain the options if customField has them; otherwise, take them from listOfCustomFields
            customField.options ??= [];
            listOfCustomFields[index].options?.forEach((option) {
              if (!customField.options!.any((element) => element.id == option.id)) {
                customField.options!.add(option);
              }
            });
          }
          // Update the field in listOfCustomFields with the updated customField
          listOfCustomFields[index] = customField;
        } else {
          // If customField doesn't exist in listOfCustomFields, add it
          listOfCustomFields.add(customField);
        }
      }
    }
    customFormFields = listOfCustomFields;
    
    // setting users list
    customFormFields.where((element) => element.isUserField).forEach((element) async {
      int? id = customer?.customFields?.firstWhereOrNull((customfield) => customfield?.id == element.id)?.id;
      List<String>? selectedUsersId = customer?.customFields?.firstWhereOrNull((customField) => customField?.id == id)?.usersList?.map((user) => user.id.toString()).toList();
      element.usersList = await FormsDBHelper.getAllUsers(selectedUsersId ?? [], withSubContractorPrime: true);
      element.controller = JPInputBoxController(text: element.usersList?.where((element) => element.isSelect).map((user) => user.label).join(', '));
      update();
    });
  }

  /// [setUpFields] loads fields from company settings & parse them to sections
  void setUpFields() {
    // reading
    final data = getCompanySettingFields();
    allFields.clear();

    for (InputFieldParams field in data) {
      // binding data listener with fields
      field.onDataChange = onDataChange;
      allFields.add(field);
    }

    // removing fields
    checkAndRemoveFields();

    // parsing fields
    parseToSections();
    update();
  }

  /// [checkAndRemoveFields] removes fields which are not to be displayed
  /// based on certain conditions
  void checkAndRemoveFields() {
    bool isMaskingEnabled = PermissionService.hasUserPermissions([PermissionConstants.enableMasking], isAllRequired: true);

    // Removing phone fields when user does not have masking
    // permission & is edit form
    if(isMaskingEnabled && customerId != null) {
      allFields.removeWhere((field) => field.key == CustomerFormConstants.phone);
    }
  }

  /// [parseToSections] parse fields to sections. Sections are in the order
  /// - Customer Information
  /// - Customer Address & Billing address
  /// - Other Information
  /// - Custom Fields
  void parseToSections() {

    // putting company name if it's not there to be shown in commercial section
    int companyFieldIndex = allFields.indexWhere((field) => field.key == CustomerFormConstants.companyName);
    if (companyFieldIndex >= 0 && !allFields[companyFieldIndex].showFieldValue) {
      allFields.insert(companyFieldIndex, InputFieldParams(
              key: CustomerFormConstants.commercialCompanyName,
              name: 'company_name'.tr,
              onDataChange: onDataChange,
              isRequired: true),
      );
    }

    allFields.removeWhere((field) => !field.showFieldValue);
    sectionFields.clear();
    sectionFields.addAll(allFields);

    // separating fields having separate sections
    FormSectionModel? customerAddressSection = getSectionAndRemoveField(CustomerFormConstants.customerAddress);
    FormSectionModel? customFieldsSection = getSectionAndRemoveField(CustomerFormConstants.customFields);
    FormSectionModel? qbSyncSection = getSectionAndRemoveField(CustomerFormConstants.qbOnline);

    // dividing fields on into basic & other information section
    int otherInformationIndex = sectionFields.indexWhere((field) => field.key == CustomerFormConstants.otherInformation);
    otherInformationIndex = otherInformationIndex == -1 ? (sectionFields.length - 1) : otherInformationIndex;

    // separated basic information fields
    final basicInformation = sectionFields.sublist(0, otherInformationIndex + 1);

    // separated other information fields
    final otherInformationSection = sectionFields.sublist(otherInformationIndex + 1);

    final sections = [
      // basic information section is always going to be there
      FormSectionModel(
          name: "customer_basic_information".tr.toUpperCase(),
          fields: basicInformation,
          isExpanded: true
      ),
      // customer address section
      if (customerAddressSection != null) customerAddressSection,
      // other information section depends whether there are any fields in it or not
      if (otherInformationSection.isNotEmpty)
        FormSectionModel(
            name: "other_information".tr.toUpperCase(),
            fields: otherInformationSection
        ),
      // custom fields section
      if (customFieldsSection != null && customFormFields.isNotEmpty) customFieldsSection,
    ];

    // Qb Section
    if(QuickBookService.isQBDConnected() || QuickBookService.isQuickBookConnected()) {
      syncWithQBDesktop = true;
      if(qbSyncSection != null) sections.add(qbSyncSection);
    }

    sections.removeWhere((section) => section.fields.isEmpty);

    allSections.clear();
    allSections.addAll(sections);
  }

  /// [getSectionAndRemoveField] will remove parse field to section and remove it from sections list
  FormSectionModel? getSectionAndRemoveField(String key) {
    FormSectionModel? section;
    final customerAddressIndex = sectionFields.indexWhere((field) => field.key == key);
    if(customerAddressIndex > 0) {
      section = FormSectionModel(
        name: "",
        fields: [sectionFields[customerAddressIndex]],
        wrapInExpansion: false,
      );
      sectionFields.removeAt(customerAddressIndex);
    }
    return section;
  }

  /// getters -----------------------------------------------------------------

  List<JPMultiSelectModel> get selectedFlags =>
      FormValueSelectorService.getSelectedMultiSelectValues(allFlags);

  Map<String, dynamic> getCustomerParams(int? customerId) => {
    'id': customerId,
    "includes[0]": "phones",
    "includes[1]": "address",
    "includes[2]": "billing",
    "includes[3]": "referred_by",
    "includes[4]": "rep",
    "includes[5]": "flags",
    "includes[6]": "flags.color",
    "includes[7]": "contacts",
    "includes[8]": "custom_fields",
    "includes[9]": "divisions",
    "includes[10]": "canvasser",
    "includes[11]": "call_center_rep",
    "includes[12]": "custom_fields.options.sub_options.linked_parent_options",
    "includes[13]": "custom_fields.users",
  };
  
  /// [getCustomer] loads customer from server
  Future<void> getCustomer() async {

    if(customerId == null) return;

    try {
      customer = await CustomerRepository.getCustomer(getCustomerParams(customerId));
      
      // setting up custom fields
      customer?.customFields?.forEach((CustomFieldsModel? field) {
        if (field != null) {
          customFormFields.add(CustomFormFieldsModel.fromCustomFieldsModel(field));
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  /// [getLocalData] loads data from local DB and set-up selection list
  Future<void> getLocalData() async {
    try {
      ReferralSourceParamModel referralParams = ReferralSourceParamModel(limit: PaginationConstants.noLimit);
      allUsers = await FormsDBHelper.getUsersToSingleSelect([], includeOtherOption: true);
      referralsList = await FormsDBHelper.getReferrals(referralParams: referralParams, includeOtherOption: true, includeCustomerOption: true, includeNoneOption: true);
      // setting up flags
      final selectedFlagIds = customer?.flags?.map((flag) => flag!.id.toString()).toList() ?? [];
      allFlags = await FormsDBHelper.getAllFlags(selectedFlagIds);

      await SqlStateRepository().get().then((states){
        stateList = states;
      });

      await SqlCountryRepository().get().then((countries){
        countryList = countries;
      });

      canvasserList.addAll(allUsers);
      callCenterRepList.addAll(allUsers);

      salesManCustomerRepList.addAll(allUsers);
      salesManCustomerRepList.removeWhere((rep) => rep.id == CommonConstants.otherOptionId);

    } catch (e) {
      rethrow;
    }
  }

  /// selectors to select form data (users, jobs etc) --------------------------

  void selectFlags() {
    FormValueSelectorService.openMultiSelect(
        title: "select_flags".tr,
        list: allFlags,
        onSelectionDone: () {
          update();
        }
    );
  }

  void selectSalesManCustomerRep(String name) {
    FormValueSelectorService.openSingleSelect(
        title: "${'select'.tr} $name",
        selectedItemId: salesManCustomerRepId,
        list: salesManCustomerRepList,
        controller: salesManCustomerRepController,
        onValueSelected: (val) {
          salesManCustomerRepId = val;
          validateForm();
        },
    );
  }

  void selectReferredBy(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      selectedItemId: referralId,
      list: referralsList,
      controller: referralController,
      onValueSelected: (val) {
        referralId = val;
        if(val == CommonConstants.otherOptionId) focusField(otherReferralController);
        update();
      },
    );
  }

  void selectReferredByCustomer() {
    FormValueSelectorService.selectCustomer(
        customerController: customerReferralController,
        customerModel: CustomerModel(),
        onSelectionDone: (customer) {
          referralCustomerId = customer.id.toString();
          customerReferralController.text = customer.fullName ?? "";
          update();
        },
    );
  }

  void removeCustomer() {
    referralCustomerId = '';
    customerReferralController.text = '';
    update();
  }

  void selectCanvasser(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      selectedItemId: canvasserId,
      list: canvasserList,
      controller: canvasserController,
      onValueSelected: (val) {
        canvasserId = val;
        update();
        if(val == CommonConstants.otherOptionId) focusField(otherCanvasserController);
      },
    );
  }

  void selectCallCenterRep(String name) {
    FormValueSelectorService.openSingleSelect(
      title: "${'select'.tr} $name",
      selectedItemId: callCenterRepId,
      list: callCenterRepList,
      controller: callCenterRepController,
      onValueSelected: (val) async{
        callCenterRepId = val;
        if(val == CommonConstants.otherOptionId) focusField(otherCallCenterRepController);
        update();
      },
    );
  }

  Future<void> changeFormType(dynamic val) async {
    isCommercial = val;
    Helper.hideKeyboard();
    update();
    // additional delay for ui to get updated
    await Future<void>.delayed(const Duration(milliseconds: 100));
    onDataChange("");
  }

  /// toggles to update form (checkboxes, radio-buttons, etc.) -----------------

  void toggleLoading(bool val) {
    isLoading = val;
    update();
  }

  void toggleSecondaryNameFields() {
    showSecondaryNameField = !showSecondaryNameField;
    update();
  }

  void toggleSyncWithQBDesktop(bool val) {
    syncWithQBDesktop = val;
    update();
  }

  /// form field validators ----------------------------------------------------

  String? validateFirstName(String val) {
    if(isCommercial) return "";
    return FormValidator.requiredFieldValidator(val,
        errorMsg: "first_name_is_required".tr);
  }

  String? validateLastName(String val) {
    if(isCommercial) return "";
    return FormValidator.requiredFieldValidator(val,
        errorMsg: "last_name_is_required".tr);
  }

  bool validateCustomerCompanyName(InputFieldParams field) {
    bool validationFailed = false;

    if(field.isRequired && !isCommercial) {
      bool isFirstNameError = validateFirstName(firstNameController.text) != null;
      bool isLastNameError = validateLastName(lastNameController.text) != null;

      if (isFirstNameError) {
        firstNameController.scrollAndFocus();
      } else if (isLastNameError) {
        lastNameController.scrollAndFocus();
      }

      validationFailed = isFirstNameError || isLastNameError;
    }

    return validationFailed;
  }

  bool validateCompanyName(InputFieldParams field) {
    bool validationFailed = false;
    if(field.isRequired && isCommercial) {
      validationFailed = FormValidator.requiredFieldValidator(companyNameController.text) != null;
      if(validationFailed) companyNameController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateSalesManCustomerRep(InputFieldParams field) {
    bool validationFailed = false;
    if(field.isRequired) {
      validationFailed = salesManCustomerRepId == UserModel.unAssignedUser.id.toString();
      if(validationFailed) salesManCustomerRepController.scrollAndFocus();
    }
    return validationFailed;
  }

  String? validatorSalesManCustomerRep(InputFieldParams field, String val) {
    bool isUnassigned = salesManCustomerRepId == UserModel.unAssignedUser.id.toString();
    if (field.isRequired && isUnassigned) {
      return FormValidator.requiredFieldValidator("", errorMsg: 'salesman_customer_rep_required'.tr);
    }
    return null;
  }

  bool validateEmail(InputFieldParams field) {
    bool validationFailed = false;
    validationFailed = emailFormKey.currentState
        ?.validate(scrollOnValidate: field.scrollOnValidate) ?? false;
    return validationFailed;
  }

  bool validateCustomFields(InputFieldParams field) {
    bool validationFailed = false;
    validationFailed = customFieldsFormKey.currentState
        ?.validate(scrollOnValidate: field.scrollOnValidate) ?? false;
    return validationFailed;
  }

  bool validateCustomerAddress(InputFieldParams field) {
    bool validationFailed = false;
    if(field.isRequired) {
      validationFailed = addressFormKey.currentState?.validate() ?? false;
    }
    return validationFailed;
  }

  bool validateReferredByNote(InputFieldParams field) {
    bool validationFailed = false;
    if(referralId == CommonConstants.customerOptionId) {
      bool isCustomerValidationFailed = FormValidator.requiredFieldValidator(customerReferralController.text) != null;
      bool isNoteValidationFailed = FormValidator.requiredFieldValidator(otherReferralController.text) != null;
      if (isCustomerValidationFailed) {
        customerReferralController.scrollAndFocus();
      } else if(isNoteValidationFailed) {
        otherReferralController.scrollAndFocus();
      }
      validationFailed = isCustomerValidationFailed || isNoteValidationFailed;
    }
    if(referralId == CommonConstants.otherOptionId && !validationFailed) {
      validationFailed = FormValidator.requiredFieldValidator(otherReferralController.text) != null;
      if (validationFailed) otherReferralController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateCanvasserNote(InputFieldParams field) {
    bool validationFailed = false;
    if(canvasserId == CommonConstants.otherOptionId) {
      validationFailed = FormValidator.requiredFieldValidator(otherCanvasserController.text) != null;
      if (validationFailed) otherCanvasserController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateCallCenterRepNote(InputFieldParams field) {
    bool validationFailed = false;
    if(callCenterRepId == CommonConstants.otherOptionId) {
      validationFailed = FormValidator.requiredFieldValidator(otherCallCenterRepController.text) != null;
      if (validationFailed) otherCallCenterRepController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validatePhone(InputFieldParams field) {
    bool validationFailed = false;
    validationFailed = !(phoneFormKey.currentState
        ?.validate(scrollOnValidate: field.scrollOnValidate) ?? true);
    return validationFailed;
  }

  /// [saveForm] helps in saving form
  Future<void> saveForm() async {
    try {
      final params = customerFormJson(addAllFields: false);
      bool isEditForm = customerId != null;
      
      final responseCustomer = await CustomerRepository.addCustomer(params, isRestricted: !doOpenCustomerDetails());
      if (!isEditForm) {
        Helper.showToastMessage("customer_add_success".tr);
        if(doOpenCustomerDetails()) {
          Get.back(result: true);
          Get.toNamed(Routes.customerDetailing, arguments: {NavigationParams.customerId: responseCustomer?.id});
          Get.toNamed(Routes.jobForm, arguments: {
            NavigationParams.type: JobFormType.add, 
            NavigationParams.customerId: responseCustomer?.id
          });
        } else {
          Get.back(result: responseCustomer);
        }
      } else {
        Helper.showToastMessage("customer_update_success".tr);
        Get.back(result: responseCustomer);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// helpers ------------------------------------------------------------------

  /// [doOpenCustomerDetails] helps to decide if customer details should be opened after saving a customer
  /// Customer details should be opened when:
  ///  1. User is not restricted
  ///  2. Logged In User is selected as salesman rep
  /// Customer details should not be opened when:
  ///  1. User is a restricted user and logged in user is not selected as salesman rep
  bool doOpenCustomerDetails() {
    return !AuthService.isRestricted || AuthService.userDetails?.id?.toString() == salesManCustomerRepId;
  }

  /// [showUpdateFieldConfirmation] displays confirmation dialog to take new changes
  void showUpdateFieldConfirmation() {

    if(!checkIfFieldDataChange()) return;

    showJPBottomSheet(child: (_) {
      return JPConfirmationDialog(
        title: 'confirmation'.tr,
        icon: Icons.info_outline,
        subTitle: "form_fields_refresh_desc".tr,
        suffixBtnText: "apply".tr,
        onTapPrefix: Get.back<void>,
        onTapSuffix: updateFields,
      );
    }, isDismissible: false);
  }

  /// [validateAllFields] validates all fields in a sequence manner
  Future<bool> validateAllFields() async {

    bool validationFailed = false;
    bool scrollOnValidate = false;
    FormSectionModel? errorSection;
    InputFieldParams? errorField;
    dynamic Function(InputFieldParams)? scrollAndFocus;

    validateForm(); // helps in displaying field error
    for (InputFieldParams field in allFields) {
      field.scrollOnValidate = scrollOnValidate;
      // validating individual fields
      final isNotValid = validators[field.key]?.call(field) ?? false;

      // This condition helps in only tracking details of very first failed section/field
      // Loop will validate all the fields but focus will be on error field only
      if(isNotValid && !validationFailed) {
        // setting up error field details
        scrollAndFocus ??= validators[field.key];
        validationFailed = isNotValid;
        scrollOnValidate = false;
        errorSection ??= allSections.firstWhereOrNull((section) => section.fields.contains(field));
        errorField ??= field;
      }
    }

    if(validationFailed && errorSection != null) {
      // helps in expanding section if not expanded
      await expandErrorSection(errorSection);
      errorField?.scrollOnValidate = true;
      scrollAndFocus?.call(errorField!);
    }

    return validationFailed;
  }

  /// [expandErrorSection] expands section of which field has error
  Future<void> expandErrorSection(FormSectionModel? section) async {
    // expanding section only if it's nt expanded before
    if(section == null || section.isExpanded || !section.wrapInExpansion) return;

    section.isExpanded = true;
    update();

    // additional delay for section to get expanded
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  /// [focusField] helps in focusing field (eg. referral note etc.)
  Future<void> focusField(JPInputBoxController controller) async {
    // additional detail for ui to get updated
    await Future<void>.delayed(const Duration(milliseconds: 500));
    controller.scrollAndFocus();
  }

  // getContactFromPhoneData(contactsFromPhoneDirectory): put data from phone directory
  void getContactFromPhoneData(Contact contactsFromPhoneDirectory) { 
    firstNameController.text = contactsFromPhoneDirectory.name.first;
    lastNameController.text = contactsFromPhoneDirectory.name.last;
    if(contactsFromPhoneDirectory.organizations.isNotEmpty){
      companyNameController.text = contactsFromPhoneDirectory.organizations.first.company;
    } else {
      companyNameController.text = '';
    }
    if(contactsFromPhoneDirectory.phones.isNotEmpty){
      phones.clear();
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
        phones.add(PhoneModel( number: formattedNumber, label: label));
        i++; 
      }
    } else {
      phones = [];
    }
    if(contactsFromPhoneDirectory.emails.isNotEmpty){
      emails.clear();
      emails.insert(0, EmailModel(email: contactsFromPhoneDirectory.emails.first.address, isPrimary: 1));
      for(int i = 1; i < contactsFromPhoneDirectory.emails.length; i++) {
        if(i >= 5) break;
        emails.add(EmailModel(email: contactsFromPhoneDirectory.emails[i].address, isPrimary: 0));
      }
    } else {
      emails = [EmailModel(email: "")];
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
                    stateId: state?.id,
                    countryId: country?.id,
                    city: add.city,
                    zip: add.postalCode
                );
      update();
      
    } else {
      address = AddressModel(
        id: 1,
        address: '',
        addressLine1: '',
        city: '',
        zip: ''
      );
    }
    Future.delayed(duration, () => controller.validateForm()); // validate form once data has been set on fields
  }
  void updateLoading() {
    isLoading = !isLoading;
    update();
  }

}