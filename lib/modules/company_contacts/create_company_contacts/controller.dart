import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/forms/create_company_contact/create_company_contact_form_param.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jobprogress/global_widgets/forms/email/index.dart';
import 'package:jobprogress/global_widgets/forms/phone/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/form_ui_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CreateCompanyContactFormController extends GetxController {

  CreateCompanyContactFormController({
    this.createCompanyContactFormParam,
  });
  
  final formKey = GlobalKey<FormState>(); // used to create form
  final key = GlobalKey<FormState>(); // used to validate form
  final scaffoldKey = GlobalKey<ScaffoldState>(); // used fro side drawer
  final phoneFormKey = GlobalKey<PhoneFormState>();
  final emailFormKey = GlobalKey<EmailsFormState>();
  final addressFormKey = GlobalKey<AddressFormState>();

  final FormUiHelper formUiHelper = JPAppTheme.formUiHelper; // provides necessary values for paddings, margins and form section spacing
  late CreateCompanyContactFormService service;

  bool isSavingForm = false; // used to disable user interaction with ui
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form
  bool isAdditionalDetailsExpanded = false; // used to manage/control expansion state of additional details section

  final CreateCompanyContactFormParam? createCompanyContactFormParam;
  CompanyContactFormType? pageType; // helps in manage form privileges

  String get pageTitle {
    switch (pageType) {
      case CompanyContactFormType.createForm:
        return 'add_company_contact'.tr.toUpperCase();
      case CompanyContactFormType.editForm:
        return (companyContactModel != null && companyContactModel!.fullName != null)
            ? (companyContactModel!.fullName!)
            : 'edit_company_contact'.tr.toUpperCase();
      case CompanyContactFormType.jobContactPersonCreateForm:
        return 'add_contact_person'.tr.toUpperCase();
      case CompanyContactFormType.jobContactPersonEditForm:
        return 'edit_contact_person'.tr.toUpperCase();
      default:
        return "";
    }
  }

  String get saveButtonText{ 
   switch (pageType) {
      case CompanyContactFormType.createForm:
      case CompanyContactFormType.jobContactPersonCreateForm:
        return 'save'.tr.toUpperCase();
      case CompanyContactFormType.editForm:
      case CompanyContactFormType.jobContactPersonEditForm:
      return 'update'.tr.toUpperCase();
      
      default:
        return "";
    }
  }

  Function(dynamic val)? onUpdate;

  CompanyContactListingModel? companyContactModel;



  @override
  void onInit() {
    init();
    super.onInit();
  }

  // init(): will set up form service and form data
  Future<void> init() async {
    pageType ??= createCompanyContactFormParam?.pageType ?? Get.arguments?[NavigationParams.pageType];
    onUpdate = createCompanyContactFormParam?.onUpdate;
    companyContactModel = createCompanyContactFormParam?.companyContactModel ?? Get.arguments?[NavigationParams.dataModel];
    
    // setting up service
    service = CreateCompanyContactFormService(
      update: update,
      pageType: pageType,
      companyContactModel : companyContactModel,
      validateForm: () => onDataChanged(''),
    );
    service.controller = this;
    await service.initForm(); // setting up form data
  }

  // openContactQuickBottomSheet(): show quick options bottom sheet to fetch contact
  void openContactQuickBottomSheet() {
    service.chooseFromContactQuickBottomSheet();
  }

  // fetchContactFromPhoneDirectory(): fetch contact from phone directory
  void fetchContactFromPhoneDirectory() async{
    await service.fetchContactFromPhone();
    if(service.checkIfNewDataAdded()){
      validateFormOnDataChange = true;
    }
  }

  // createCompanyContact() : will save form data on validations completed otherwise scroll to error field
  Future<void> createCompanyContact() async {
    validateFormOnDataChange = true; // setting up form validation as soon as user updates field data
    bool isValid = validateForm(); // validating form

    if (isValid) {
      saveForm(onUpdate: onUpdate);
    } else {
      service.scrollToErrorField();
    }
  }

  // onDataChanged() : will validate form as soon as data in input field changes
  void onDataChanged(dynamic val, {bool doUpdate = false}) {
    // realtime changes will take place only once after user tried to submit form
    if (validateFormOnDataChange) {
      validateForm();
    }
    if(doUpdate) update();
  }

  // validateForm(): validates form and returns result
  bool validateForm() {
    bool isValid =  key.currentState?.validate() ?? false;
    bool isValidPhone = phoneFormKey.currentState?.validate(scrollOnValidate: false) ?? false;
    bool isValidEmail = emailFormKey.currentState?.validate(scrollOnValidate: false) ?? true;

    if (!service.isFieldVisible()) {
      isValidPhone = true;
    }

    return  isValid && isValidPhone && !isValidEmail;
  }

  // onAdditionalOptionsExpansionChanged(): toggles additional options section expansion state
  void onAdditionalOptionsExpansionChanged(bool val) {
    isAdditionalDetailsExpanded = val;
    service.onAdditionalOptionsExpansionChanged(val);
  }
  // toggleIsSavingForm(): toggles form is saving or not
  void toggleIsSavingForm() {
    isSavingForm = !isSavingForm;
    update();
  }

  // saveForm(): will submit form only when changes in form are made
  Future<void> saveForm({Function(dynamic val)? onUpdate}) async {

   bool isNewDataAdded = service.checkIfNewDataAdded(); // checking for changes
    if(!isNewDataAdded) {
      Helper.showToastMessage('no_changes_made'.tr);
    } else {
      try {
        toggleIsSavingForm();
         await service.saveForm(onUpdate: onUpdate);
      } catch (e) {
        rethrow;
      } finally {
        toggleIsSavingForm();
      }
    }
  }

  // onWillPop(): will check if any new data is added to form and takes decisions
  //              accordingly whether to show confirmation or navigate back directly
  Future<bool> onWillPop() async {

    bool isNewDataAdded = service.checkIfNewDataAdded();

    if(isNewDataAdded) {
      Helper.showUnsavedChangesConfirmation();
    } else {
      Helper.hideKeyboard();
      Get.back();
    }
    return false;

  }
}
