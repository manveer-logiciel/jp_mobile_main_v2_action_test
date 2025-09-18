import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/company_contact_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/email.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/company_contact_listing/create_company_contact.dart';
import 'package:jobprogress/core/utils/form/validators.dart';

void main() {

  final tempAddress = AddressModel(
    id: 180175, 
    address: '2400 Aviation Drive', 
    addressLine1: '', 
    city: 'DFW Airport',
    zip: '75261', 
    state: StateModel(id: 133, name: 'Dunbartonshire', code: 'DNB', countryId: 5), 
    stateId: 133,
  );

  final tempEmails = [
    EmailModel(id: 1043, email: 'derf@gmail.com', isPrimary: 1),
    EmailModel(id: 1044, email: 'fsfsf@sdsdf.sdf', isPrimary: 0),
  ];

  final tempPhones = [
    PhoneModel(id: 118994, label: '', number: '', ext: '', isPrimary: 1),
    PhoneModel(id: 118995, label: 'home', number: '3434343434', ext: '', isPrimary: 0),
  ];

  final tempCompanyContact = CompanyContactListingModel(
    id: 708,
    firstName: 'comcontact',
    lastName: 'hurf',
    fullName: 'comcontact hurf',
    companyName: 'hrf',
    fullNameMobile: 'comcontact hurf',
    createdAt: '2023-04-12 14:53:12',
    updatedAt: '2023-04-12 14:53:12',
    isPrimary: true,
    address: tempAddress,
    emails: tempEmails,
    phones: tempPhones,
  );

  late Map<String, dynamic> tempInitialJson;

  group('In case of create company contact', () {
    
    CreateCompanyContactFormService service = CreateCompanyContactFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for logical testing
      pageType: CompanyContactFormType.createForm,
      companyContactModel: null,
    );
    
    setUpAll(() async {      
      service.setFormData();
      tempInitialJson = service.companyContactsFormJson();
      await Future.delayed(service.duration, () => {}); // it is used to set initialJson because some data will take time to set
    });

    group('CreateCompanyContactFormService should be initialized with correct data', () {

      test('Form fields should be initialized with correct values', () {
        expect(service.firstNameController.text, "");
        expect(service.lastNameController.text, "");
        expect(service.companyNameController.text, "");
        expect(service.cityController.text, "");
        expect(service.stateController.text, "None");
        expect(service.zipController.text, "");
        expect(service.countryController.text, "");
        expect(service.notesController.text, "");
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isAdditionalDetailsExpanded, false);
        expect(service.isLoading, false);
        expect(service.isPrimary, false);
        expect(service.isSaveAsCompanyContact, false);
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.states.length, 0);
        expect(service.countries.length, 0);
        expect(service.assignGroups.length, 0);
        expect(service.emailList.length, 0);
        expect(service.phoneList.length, 0);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.companyContactModel, null);
        expect(service.selectedCountry, null);
        expect(service.selectedState, null);
        expect(service.initialJson, tempInitialJson);
        expect(service.isPrimary, false);
        expect(service.id, '');
      });

    });

    test('CreateCompanyContactFormService@companyContactFormJson() should generate json from form-data', () {

      final tempJson = service.companyContactsFormJson();
      expect(tempInitialJson, tempJson);

    });

    group('CreateCompanyContactFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialTitle = service.firstNameController.text;

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.firstNameController.text = 'Amit';
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.firstNameController.text = initialTitle;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('CreateCompanyContactFormService@toggleIsSetAsPrimary should toggle Set as Primary', () {

      test('Set as Primary should be set true', () {
        service.toggleIsSetAsPrimary(true);
        expect(service.isPrimary, true);
      });

      test('Set as Primary should be set false', () {
        service.toggleIsSetAsPrimary(false);
        expect(service.isPrimary, false);
      });

    });

    group('CreateCompanyContactFormService@toggleIsSaveAsCompanyContact should toggle Save as Company Contact', () {

      test('Save as Company Contact should be set true', () {
        service.toggleIsSaveAsCompanyContact(true);
        expect(service.isSaveAsCompanyContact, true);
      });

      test('Save as Company Contact should be set false', () {
        service.toggleIsSaveAsCompanyContact(false);
        expect(service.isSaveAsCompanyContact, false);
      });

    });

    group('CreateCompanyContactFormService@validateFirstName() should validate first name', () {

      test('Validation should fail when company contact first name is empty', () {
        service.firstNameController.text = "";
        final val = service.validateFirstName(service.firstNameController.text);
        expect(val, 'first_name_cant_be_left_blank'.tr);
      });

      test('Validation should fail when company contact first name only contains empty spaces', () {
        service.firstNameController.text = "     ";
        final val = service.validateFirstName(service.firstNameController.text);
        expect(val, 'first_name_cant_be_left_blank'.tr);
      });

      test('Validation should pass when company contact first name contains special characters', () {
        service.firstNameController.text = "#kpl& - /";
        final val = service.validateFirstName(service.firstNameController.text);
        expect(val, null);
      });

      test('Validation should pass when company contact first name is not-empty', () {
        service.firstNameController.text = "Title";
        final val = service.validateFirstName(service.firstNameController.text);
        expect(val, null);
      });

    });

    group('CreateCompanyContactFormService@validateLastName() should validate last name', () {

      test('Validation should fail when company contact last is empty', () {
        service.lastNameController.text = "";
        final val = service.validateLastName(service.lastNameController.text);
        expect(val, 'last_name_cant_be_left_blank'.tr);
      });

      test('Validation should fail when company contact last name only contains empty spaces', () {
        service.lastNameController.text = "     ";
        final val = service.validateLastName(service.lastNameController.text);
        expect(val, 'last_name_cant_be_left_blank'.tr);
      });

      test('Validation should pass when last name contains special characters', () {
        service.lastNameController.text = "#kpl& - /";
        final val = service.validateLastName(service.lastNameController.text);
        expect(val, null);
      });

      test('Validation should pass when company contact last name is not-empty', () {
        service.lastNameController.text = "Title";
        final val = service.validateLastName(service.lastNameController.text);
        expect(val, null);
      });

    });
    
    test('Validation should pass when company contact phone number is empty', () {
      expect(service.phoneList.isEmpty, true);
    });

    test('Validation should pass when company contact email is empty', () {
      expect(service.emailList.isEmpty, true);
    });

  });

  group('In case of edit/update company contact', () {

    CreateCompanyContactFormService service = CreateCompanyContactFormService(
      update: () { }, // method used to update ui directly from service so empty function can be used in testing
      validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for logical testing
      companyContactModel: tempCompanyContact,
      pageType: CompanyContactFormType.editForm,
    );

    setUpAll(() async {
      service.setFormData();
      tempInitialJson = service.companyContactsFormJson();
      await Future.delayed(service.duration, () => {}); // it is used to set initialJson because some data will take time to set
    });

    group('CreateCompanyContactFormService should be initialized with correct data', () {

      test('Form fields should be filled with correct values', () {
        expect(service.firstNameController.text, tempCompanyContact.firstName);
        expect(service.lastNameController.text, tempCompanyContact.lastName);
        expect(service.companyNameController.text, tempCompanyContact.companyName);
        expect(service.addressController.text, tempCompanyContact.address?.address);
        expect(service.addressLine2Controller.text, tempCompanyContact.address?.addressLine1);
        expect(service.cityController.text, tempCompanyContact.address?.city);
        expect(service.zipController.text, tempCompanyContact.address?.zip);
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isLoading, false);
        expect(service.isPrimary, tempCompanyContact.isPrimary);
        expect(service.isSaveAsCompanyContact, tempCompanyContact.isCompanyContact ?? false);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.companyContactModel, tempCompanyContact);
        expect(service.initialJson, tempInitialJson);
        expect(service.selectedCountry, null);
        expect(service.selectedState, null);
        expect(service.id, tempCompanyContact.id!.toString());
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.states.length, 0);
        expect(service.countries.length, 0);
        expect(service.assignGroups.length, 0);
        expect(service.assignGroup.length, 0);
        expect(service.emailList.length, 2);
        expect(service.phoneList.length, 2);
      });

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    
    });

    group('validatePhoneNumber() should validate phone number fields', () {

      test('Validation should fail when company contact phone number is empty', () {
        service.phoneList[0].number = '';
        expect(FormValidator.validatePhoneNumber(service.phoneList[0].number ?? ''), 'this_field_is_required'.tr);
      });

      test('Validation should fail when company contact phone number is not-empty & invaild', () {
        service.phoneList[0].number = '000';
        expect(FormValidator.validatePhoneNumber(service.phoneList[0].number ?? ''), 'phone_number_must_be_between_range'.tr);
      });

      test('Validation should pass when company contact phone number is not-empty & valid', () {
        service.phoneList[0].number = '(999) 999-999';
        expect(FormValidator.validatePhoneNumber(service.phoneList[0].number ?? ''), null);
      });

    });
    
    group('validateEmail() should validate email fields', () {

      test('Validation should pass when company contact email is empty', () {
        service.emailList[0].email = '';
        expect(FormValidator.validateEmail(service.emailList[0].email), null);
      });

      test('Validation should fail when company contact email is not-empty & invalid', () {
        service.emailList[0].email = 'adit@gmail';
        expect(FormValidator.validateEmail(service.emailList[0].email, isRequired: true), 'please_enter_valid_email'.tr);
      });

      test('Validation should pass when company contact email is not-empty & valid', () {
        service.emailList[0].email = 'ajay@gmail.com';
        expect(FormValidator.validateEmail(service.emailList[0].email, isRequired: true), null);
      });

    });

  });

  group('Form field edit ability', () {

    test('In case page type is create form or edit form, then all fields should be editable', () {
      CreateCompanyContactFormService service = CreateCompanyContactFormService(
        update: () {  },
        validateForm: () { },
        pageType: CompanyContactFormType.createForm,
        companyContactModel: tempCompanyContact
      );
      expect(service.isFieldEditable(), true);
    });

  });

}