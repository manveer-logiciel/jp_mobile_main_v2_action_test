import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/custom_fields/custom_form_fields/index.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/forms/add_customer/fields.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/customer/customer_form/add_customer.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'mocked_data.dart';

void main() {

  CustomerFormService service = CustomerFormService(
    update: () { }, // method used to update ui directly from service so empty function can be used in testing
    validateForm: () { }, // method used to validate form using form key with is ui based, so can be passes empty for unit testing
    onDataChange: (_) { } // this method is called when data in dynamic field changes
  );

  UserModel tempUser = UserModel(
      id: 0,
      firstName: 'User 1',
      fullName: 'User 1',
      email: '1@gmail.com'); // helps in mocking user data

  List<CustomFieldsModel> tempCustomFields = [
    CustomFieldsModel(id: 0, name: 'Field 1', type: 'text'),
    CustomFieldsModel(id: 1, name: 'Field 2', type: 'text'),
    CustomFieldsModel(id: 2, name: 'Field 3', type: 'dropdown'),
  ]; // helps in mocking custom fields data

  List<CustomFormFieldsModel> tempCustomFormFields = [
    CustomFormFieldsModel(id: 0, name: 'Field 1', controller: JPInputBoxController()),
    CustomFormFieldsModel(id: 1, name: 'Field 2', controller: JPInputBoxController()),
  ]; // helps in mocking custom fields data

  List<PhoneModel> tempPhones = [
    PhoneModel(id: 0, number: "1122334455"),
    PhoneModel(id: 1, number: "1122234455"),
  ]; // helps in mocking phone fields data

  AddressModel tempAddress = AddressModel(id: 0, address: "Test Address");

  CustomerModel tempCustomer = CustomerModel(
    id: 0,
    fullName: "Test Customer",
    address: tempAddress,
    email: "1@gmail.com",
    additionalEmails: ['2@gmail.com', '3@gmail.com'],
    callCenterRep: tempUser,
    canvasser: tempUser,
    companyName: 'Company Name',
    firstName: 'Test Name',
    lastName: 'Test',
    customFields: tempCustomFields,
    phones: tempPhones,
    managementCompany: "Management Company",
    propertyName: "Property Name",
    note: "Customer Note",
    contacts: [
      CompanyContactListingModel(id: 0, firstName: "Test", lastName: "Test")
    ]
  ); // helps in mocking customer data

  List<JPSingleSelectModel> tempSelectionList = [
    JPSingleSelectModel(label: "Item 1", id: CommonConstants.unAssignedUserId),
    JPSingleSelectModel(label: "Item 2", id: CommonConstants.otherOptionId),
    JPSingleSelectModel(label: "Item 3", id: CommonConstants.customerOptionId),
    JPSingleSelectModel(label: "Item 4", id: CommonConstants.noneId),
    JPSingleSelectModel(label: "User 1", id: '0'),
    JPSingleSelectModel(label: "Item 5", id: '123'),
  ];
  
  List<JPSingleSelectModel> tempReferrelSelectionList = [
    JPSingleSelectModel(label: "Item 1", id: CommonConstants.noneId),
    JPSingleSelectModel(label: "Item 2", id: CommonConstants.otherOptionId),
    JPSingleSelectModel(label: "Item 3", id: CommonConstants.customerOptionId),
    JPSingleSelectModel(label: "Item 4", id: "12"),
    JPSingleSelectModel(label: "User 1", id: '0'),
    JPSingleSelectModel(label: "Item 5", id: '123'),
  ]; // used to mock data coming from local db

  CustomerFormMockedData mock = CustomerFormMockedData();

  setUpAll(() {
    PhoneMasking.setUp();
    TestWidgetsFlutterBinding.ensureInitialized();
    mock.companySettingModifier();
  });

  void setEditFormData() {
    service.customer = tempCustomer;
    service.emails.clear();
    service.salesManCustomerRepList = tempSelectionList;
    service.callCenterRepList = tempSelectionList;
    service.canvasserList = tempSelectionList;
    service.setFormData();
  }

  group("In case of create customer", () {

    test('CustomerFormService@getCustomerParams should return correct query parameters map for given ID', () {
    int customerId = 123;
    
    Map<String, dynamic> result = service.getCustomerParams(customerId);

    Map<String, dynamic> expected = {
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

    expect(result, equals(expected));
  });
    
    group("CustomerFormService should be initialized with correct values", () {

      test('Form fields should be initialized with correct values', () {
        expect(service.firstNameController.text, isEmpty);
        expect(service.lastNameController.text, isEmpty);
        expect(service.secFirstNameController.text, isEmpty);
        expect(service.secLastNameController.text, isEmpty);
        expect(service.commercialCustomerNameController.text, isEmpty);
        expect(service.salesManCustomerRepController.text, isEmpty);
        expect(service.companyNameController.text, isEmpty);
        expect(service.managementCompanyController.text, isEmpty);
        expect(service.canvasserController.text, isEmpty);
        expect(service.otherCanvasserController.text, isEmpty);
        expect(service.propertyNameController.text, isEmpty);
        expect(service.callCenterRepController.text, isEmpty);
        expect(service.otherCallCenterRepController.text, isEmpty);
        expect(service.customerNoteController.text, isEmpty);
        expect(service.referralController.text, isEmpty);
        expect(service.otherReferralController.text, isEmpty);
        expect(service.customerReferralController.text, isEmpty);
      });

      test('Form toggles should be initialized with correct values', () {
        expect(service.isCommercial, false);
        expect(service.isLoading, true);
        expect(service.showSecondaryNameField, false);
        expect(service.isReferredByDisabled, false);
        expect(service.syncWithQBDesktop, false);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.address.id, -1);
        expect(service.billingAddress.id, -1);
        expect(service.emails, isEmpty);
        expect(service.phones, isEmpty);
        expect(service.initialJson, isEmpty);
        expect(service.fieldsToAdd, isEmpty);
        expect(service.validators, isEmpty);
        expect(service.customer, isNull);
      });

      test('Form selection id\'s should be initialized with correct values', () {
        expect(service.salesManCustomerRepId, isEmpty);
        expect(service.canvasserId, isEmpty);
        expect(service.callCenterRepId, isEmpty);
        expect(service.referralId, isEmpty);
        expect(service.referralCustomerId, isEmpty);
        expect(service.referralType, isEmpty);
        expect(service.canvasserType, 'user');
        expect(service.callCenterRepType, 'user');
      });

      test("Form selection lists should be initialized with correct values", () {
        expect(service.salesManCustomerRepList, isEmpty);
        expect(service.canvasserList, isEmpty);
        expect(service.callCenterRepList, isEmpty);
        expect(service.allUsers, isEmpty);
        expect(service.referralsList, isEmpty);
        expect(service.allFlags, isEmpty);
      });
    });

    test("CustomerFormService@setFormData should set-up form values", () {

      service.salesManCustomerRepList = tempSelectionList;
      service.canvasserList = tempSelectionList;
      service.callCenterRepList = tempSelectionList;
      service.referralsList = tempReferrelSelectionList;

      final firstItemId = tempSelectionList.first.id;
      final firstItemLabel = tempSelectionList.first.label;

      final firstReferrelItemId = tempReferrelSelectionList.first.id;
      final firstReferrelLabel = tempReferrelSelectionList.first.label;

      service.setFormData();

      expect(service.salesManCustomerRepId, firstItemId);
      expect(service.canvasserId, firstItemId);
      expect(service.callCenterRepId, firstItemId);
      expect(service.referralId, firstReferrelItemId);

      expect(service.salesManCustomerRepController.text, firstItemLabel);
      expect(service.canvasserController.text, firstItemLabel);
      expect(service.callCenterRepController.text, firstItemLabel);
      expect(service.referralController.text, firstReferrelLabel);

      expect(service.emails, isNotEmpty);
    });

    test('CustomerFormService@setInitialJson() should set-up initial json from form-data', () {
      service.setInitialJson();
      expect(service.initialJson, isNotEmpty);
      expect(service.initialFieldsData, isNotEmpty);
    });

    test('CustomerFormService@customerFormJson() should generate json from form-data', () {
      final tempJson = service.customerFormJson();
      expect(service.initialJson, tempJson);
    });

    group('CustomerFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialTitle = service.firstNameController.text;

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.firstNameController.text = tempCustomer.fullName!;
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.firstNameController.text = initialTitle;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('CustomerFormService@checkIfFieldDataChange() should check whether to display form update confirmation', () {

      test("When no changes are made confirmation should not be displayed", () {
        final val = service.checkIfFieldDataChange();
        expect(val, false);
      });

      test("When visibility of field is changed confirmation should be displayed", () {
        mock.companySettingModifier(action: 'visibility');
        final val = service.checkIfFieldDataChange();
        expect(val, true);
      });

      test("When order of field is changed confirmation should be displayed", () {
        mock.companySettingModifier(action: 'reorder');
        final val = service.checkIfFieldDataChange();
        expect(val, true);
      });

      test("When field is removed confirmation should be displayed", () {
        mock.companySettingModifier(action: 'remove');
        final val = service.checkIfFieldDataChange();
        expect(val, true);
      });
    });

    group('CustomerFormService@getCompanySettingFields should return form-fields to be displayed', () {

      test("When user has company settings available", () {
        final fields = service.getCompanySettingFields();
        expect(fields, isNotEmpty);
      });

      test("When user has no company settings", () {
        mock.companySettingModifier(action: 'delete');
        final fields = service.getCompanySettingFields();
        expect(fields.length, CustomerFormFieldsData.fields.length);
      });

      test("When company setting's data is null", () {
        final fields = service.getCompanySettingFields();
        expect(fields.length, CustomerFormFieldsData.fields.length);
      });
    });

    group('CustomerFormService@fieldsToAddData should return fields to be included while saving data', () {

      test("While creating initial json all fields should be included", () {
        mock.companySettingModifier();
        final json = service.customerFormJson(addAllFields: true);
        bool hasEmail = json['email'] != null;
        expect(hasEmail, true);
      });

      test("While sending data to server, non-accessible fields should be removed", () {
        mock.companySettingModifier(action: 'visibility');
        final json = service.customerFormJson(addAllFields: false);
        bool hasEmail = json['email'] != null;
        expect(hasEmail, false);
      });
    });

    group("CustomerFormService@doAddField should check whether to include fields data", () {

      test("When field is accessible", () {
        final val = service.doAddField(CustomerFormConstants.customerName);
        expect(val, true);
      });

      test("When field is not accessible", () {
        final val = service.doAddField(CustomerFormConstants.email);
        expect(val, false);
      });
    });

    // Fields setup
    group("CustomerFormService should loads fields from company settings & parse them to sections", () {

      test("CustomerFormService@setUpFields should set-up raw data to work with", () {
        expect(service.allFields, isNotEmpty);
      });

      group("CustomerFormService@checkAndRemoveFields should remove non-accessible fields", () {

        service.setUpFields();
        final initialSize = service.allFields.length;

        test("When phone masking is enabled, field should not be removed", () {
          PermissionService.permissionList.add(PermissionConstants.enableMasking);
          service.checkAndRemoveFields();
          expect(service.allFields.length, initialSize);
        });

        test("When phone masking is not enabled, field should not be removed", () {
          PermissionService.permissionList.remove(PermissionConstants.enableMasking);
          service.checkAndRemoveFields();
          expect(service.allFields.length, initialSize);
        });
      });

      group("CustomerFormService@getSectionAndRemoveField should return independent section and remove field from raw data", () {

        test("When field doesn't exists", () {
          final section = service.getSectionAndRemoveField(CustomerFormConstants.customerAddress);
          bool hasCustomerAddress = service.sectionFields.any((field) => field.key == CustomerFormConstants.customerAddress);
          expect(hasCustomerAddress, isFalse);
          expect(section, isNull);
        });

        test("When field exists", () {
          service.sectionFields.add(InputFieldParams(key: CustomerFormConstants.customerAddress, name: ''));
          final section = service.getSectionAndRemoveField(CustomerFormConstants.customerAddress);
          bool hasCustomerAddress = service.sectionFields.any((field) => field.key == CustomerFormConstants.customerAddress);
          expect(hasCustomerAddress, isFalse);
          expect(section, isNotNull);
        });
      });

      group("CustomerFormService@parseToSections should parse raw data fields to sections", () {

        test("All sections should be displayed when all fields are present", () {
          service.customFormFields.addAll(tempCustomFormFields);
          service.setUpFields();
          expect(service.allSections.length, 4);
        });

        test("Customer Address section should not be displayed when customer address field is not present", () {
          mock.formFieldsJson.remove(mock.customerAddressField);
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 3);
        });

        test("Custom Fields section should not be displayed when custom field is not present", () {
          mock.formFieldsJson.remove(mock.customFields);
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 2);
        });

        test("Other Information section should not be displayed when there is no field in it", () {
          for (var field in mock.otherInformationSection) {
            mock.formFieldsJson.remove(field);
          }
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 1);
        });

        test("Custom Basic Information section should be displayed even when there is no field in it", () {
          for (var field in mock.customerBasicInformation) {
            mock.formFieldsJson.remove(field);
          }
          mock.companySettingModifier();
          service.setUpFields();
          expect(service.allSections.length, 1);
        });

        group("Commercial company name field should be", () {

          test("Inserted when company field is hidden", () {
            mock.formFieldsJson = mock.formFieldJsonData();
            mock.companyNameField['showField'] = 'false';
            mock.companySettingModifier();
            service.setUpFields();
            bool hasCommercialCompanyName = service.allFields.any((field) => field.key == CustomerFormConstants.commercialCompanyName);
            expect(hasCommercialCompanyName, isTrue);
          });

          test("Not inserted when company field is present", () {
            mock.formFieldsJson = mock.formFieldJsonData();
            mock.companyNameField['showField'] = 'true';
            mock.companySettingModifier();
            service.setUpFields();
            bool hasCommercialCompanyName = service.allFields.any((field) => field.key == CustomerFormConstants.commercialCompanyName);
            expect(hasCommercialCompanyName, isFalse);
          });
        });
      });
    });

    // Toggles
    group("CustomerFormService@changeFormType should select form type", () {

      test("When residential option is selected", () {
        service.changeFormType(false);
        expect(service.isCommercial, isFalse);
      });

      test("When commercial option is selected", () {
        service.changeFormType(true);
        expect(service.isCommercial, isTrue);
      });
    });

    group("CustomerFormService@toggleLoading should toggle form loading state", () {

      test("Shimmer should be displayed", () {
        service.toggleLoading(true);
        expect(service.isLoading, true);
      });

      test("Form should be displayed", () {
        service.toggleLoading(false);
        expect(service.isLoading, false);
      });
    });

    group("CustomerFormService@toggleSecondaryNameFields should show/hide secondary name fields", () {

      test("Secondary name fields should be displayed", () {
        service.toggleSecondaryNameFields();
        expect(service.showSecondaryNameField, isTrue);
      });

      test("Secondary name fields should not be displayed", () {
        service.toggleSecondaryNameFields();
        expect(service.showSecondaryNameField, isFalse);
      });
    });

    group("CustomerFormService@toggleSyncWithQBDesktop should enable/disable QBD sync", () {

      test("QBD sync should be enabled", () {
        service.toggleSyncWithQBDesktop(true);
        expect(service.syncWithQBDesktop, isTrue);
      });

      test("QBD sync should be disabled", () {
        service.toggleSyncWithQBDesktop(false);
        expect(service.syncWithQBDesktop, isFalse);
      });
    });

    // Validators
    group("CustomerFormService@validateFirstName should validate first name", () {

      group("When residential type is selected", () {

        test("Validation should fail when first name is empty", () {
          service.changeFormType(false);
          service.firstNameController.text = "";
          final val = service.validateFirstName(service.firstNameController.text);
          expect(val, "first_name_is_required".tr);
        });

        test("Validation should pass when first name is filled", () {
          service.changeFormType(false);
          service.firstNameController.text = tempCustomer.fullName!;
          final val = service.validateFirstName(service.firstNameController.text);
          expect(val, null);
        });
      });

      group("When commercial type is selected", () {

        test("Validation should pass when first name is empty", () {
          service.changeFormType(true);
          service.firstNameController.text = "";
          final val = service.validateFirstName(service.firstNameController.text);
          expect(val, "");
        });

        test("Validation should pass when first name is filled", () {
          service.changeFormType(false);
          service.firstNameController.text = tempCustomer.fullName!;
          final val = service.validateFirstName(service.firstNameController.text);
          expect(val, null);
        });
      });
    });

    group("CustomerFormService@validateLastName should validate last name", () {

      group("When residential type is selected", () {

        test("Validation should fail when last name is empty", () {
          service.changeFormType(false);
          service.lastNameController.text = "";
          final val = service.validateLastName(service.lastNameController.text);
          expect(val, "last_name_is_required".tr);
        });

        test("Validation should pass when last name is filled", () {
          service.changeFormType(false);
          service.lastNameController.text = tempCustomer.fullName!;
          final val = service.validateLastName(service.lastNameController.text);
          expect(val, null);
        });
      });

      group("When commercial type is selected", () {

        test("Validation should pass when last name is empty", () {
          service.changeFormType(true);
          service.lastNameController.text = "";
          final val = service.validateLastName(service.lastNameController.text);
          expect(val, "");
        });

        test("Validation should pass when last name is filled", () {
          service.changeFormType(false);
          service.lastNameController.text = tempCustomer.fullName!;
          final val = service.validateLastName(service.lastNameController.text);
          expect(val, null);
        });
      });

    });

    group("CustomerFormService@validateCompanyName should validate company name", () {

      group("When residential type is selected", () {

        final companyField = InputFieldParams.fromJson(mock.companyNameField);

        test("Validation should pass when company name is empty", () {
          service.changeFormType(false);
          service.companyNameController.text = "";
          final val = service.validateCompanyName(companyField);
          expect(val, isFalse);
        });

        test("Validation should pass when company name is filled", () {
          service.changeFormType(false);
          service.companyNameController.text = "Test";
          final val = service.validateCompanyName(companyField);
          expect(val, isFalse);
        });
      });

      group("When commercial type is selected", () {

        final companyField = InputFieldParams.fromJson(mock.companyNameField);
        companyField.isRequired = true;

        test("Validation should fail when company name is empty", () {
          service.changeFormType(true);
          service.companyNameController.text = "";
          final val = service.validateCompanyName(companyField);
          expect(val, isTrue);
        });

        test("Validation should pass when company name is filled", () {
          service.companyNameController.text = "Test";
          final val = service.validateCompanyName(companyField);
          expect(val, isFalse);
        });
      });

    });

    group("CustomerFormService@validateReferredByNote should validate referred by", () {

      final referredByField = InputFieldParams(
          key: CustomerFormConstants.referredBy,
          name: 'Referred by',
      );

      group("When any option is selected than 'other' & 'existing customer'", () {

        test("Validation should pass referred by is empty", () {
          service.referralId = "";
          service.referralController.text = "";
          final val = service.validateReferredByNote(referredByField);
          expect(val, isFalse);
        });

        test("Validation should pass referred by is filled", () {
          service.referralId = tempSelectionList[4].id;
          service.referralController.text = tempSelectionList[4].label;
          final val = service.validateReferredByNote(referredByField);
          expect(val, isFalse);
        });
      });

      group("When 'other' option is selected", () {

        test("Validation should fail when Referred By Note is empty", () {
          service.referralId = tempSelectionList[1].id;
          service.referralController.text = "";
          service.otherReferralController.text = "";
          final val = service.validateReferredByNote(referredByField);
          expect(val, isTrue);
        });

        test("Validation should pass when Referred By Note is filled", () {
          service.referralId = tempSelectionList[1].id;
          service.referralController.text = tempSelectionList[1].label;
          service.otherReferralController.text = tempSelectionList[1].label;
          final val = service.validateReferredByNote(referredByField);
          expect(val, isFalse);
        });
      });

      group("When 'existing customer' option is selected", () {

        test("Validation should fail when Customer is empty", () {
          service.referralId = tempSelectionList[2].id;
          service.referralController.text = "";
          service.customerReferralController.text = "";
          final val = service.validateReferredByNote(referredByField);
          expect(val, isTrue);
        });

        test("Validation should fail when Referred By Note is empty", () {
          service.referralController.text = "";
          service.otherReferralController.text = "";
          final val = service.validateReferredByNote(referredByField);
          expect(val, isTrue);
        });

        test("Validation should fail when Referred By Note is filled and Customer is empty", () {
          service.referralController.text = tempSelectionList[1].label;
          service.otherReferralController.text = tempSelectionList[1].label;
          service.customerReferralController.text = "";
          final val = service.validateReferredByNote(referredByField);
          expect(val, isTrue);
        });

        test("Validation should pass when Referred By Note is filled and Customer is filled", () {
          service.referralController.text = tempSelectionList[1].label;
          service.otherReferralController.text = tempSelectionList[1].label;
          service.customerReferralController.text = tempSelectionList[1].label;
          final val = service.validateReferredByNote(referredByField);
          expect(val, isFalse);
        });

      });
    });

    group("CustomerFormService@validateCanvasserNote should validate canvasser note", () {

      final canvasserField = InputFieldParams(
          key: CustomerFormConstants.canvasser,
          name: 'Canvasser',
      );

      group("When any option than 'other' is selected", () {

        test("Validation should pass when canvasser note is empty", () {
          service.canvasserId = "";
          service.canvasserController.text = "";
          service.otherCanvasserController.text = "";
          final val = service.validateCanvasserNote(canvasserField);
          expect(val, isFalse);
        });

        test("Validation should pass when canvasser note is filled", () {
          service.canvasserId = tempSelectionList.first.id;
          service.canvasserController.text = tempSelectionList.first.label;
          service.otherCanvasserController.text = tempSelectionList.first.label;
          final val = service.validateCanvasserNote(canvasserField);
          expect(val, isFalse);
        });

      });

      group("When 'other' option is selected", () {

        test("Validation should fail when canvasser note is empty", () {
          service.canvasserId = tempSelectionList[1].id;
          service.canvasserController.text = tempSelectionList[1].label;
          service.otherCanvasserController.text = "";
          final val = service.validateCanvasserNote(canvasserField);
          expect(val, isTrue);
        });

        test("Validation should pass when canvasser note is filled", () {
          service.canvasserId = tempSelectionList[1].id;
          service.canvasserController.text = tempSelectionList[1].label;
          service.otherCanvasserController.text = tempSelectionList[1].label;
          final val = service.validateCanvasserNote(canvasserField);
          expect(val, isFalse);
        });
      });

    });

    group("CustomerFormService@validateCallCenterRepNote should validate Call Center Note", () {

      final callCenterRepField = InputFieldParams(
          key: CustomerFormConstants.callCenterRep,
          name: 'Call Center Rep',
      );

      group("When any option than 'other' is selected", () {

        test("Validation should pass when call center rep note is empty", () {
          service.callCenterRepId = "";
          service.callCenterRepController.text = "";
          service.otherCallCenterRepController.text = "";
          final val = service.validateCallCenterRepNote(callCenterRepField);
          expect(val, isFalse);
        });

        test("Validation should pass when call center rep note is filled", () {
          service.callCenterRepId = tempSelectionList.first.id;
          service.callCenterRepController.text = tempSelectionList.first.label;
          service.otherCallCenterRepController.text = tempSelectionList.first.label;
          final val = service.validateCallCenterRepNote(callCenterRepField);
          expect(val, isFalse);
        });

      });

      group("When 'other' option is selected", () {

        test("Validation should fail when call center rep note is empty", () {
          service.callCenterRepId = tempSelectionList[1].id;
          service.callCenterRepController.text = tempSelectionList[1].label;
          service.otherCallCenterRepController.text = "";
          final val = service.validateCallCenterRepNote(callCenterRepField);
          expect(val, isTrue);
        });

        test("Validation should pass when call center rep note is filled", () {
          service.callCenterRepId = tempSelectionList.first.id;
          service.callCenterRepController.text = tempSelectionList.first.label;
          service.otherCallCenterRepController.text = tempSelectionList.first.label;
          final val = service.validateCallCenterRepNote(callCenterRepField);
          expect(val, isFalse);
        });
      });
    });

    group("CustomerFormService@expandErrorSection should error field section", () {

      final testSection = FormSectionModel(name: 'Test', fields: [], isExpanded: false);

      test("Section should be expanded if it's collapsed", () {
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isTrue);
      });

      test("Section should not collapse if it's already expanded", () {
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isTrue);
      });

      test("Section should not be expanded if is non-expandable section", () {
        testSection.isExpanded = false;
        testSection.wrapInExpansion = false;
        service.expandErrorSection(testSection);
        expect(testSection.isExpanded, isFalse);
      });
    });
  });

  group("In case of edit customer", () {

    group("CustomerFormService@setFormData should set-up form values", () {

      group("Form should be displayed according to customer type", () {

        test("Residential form should be displayed", () {
          tempCustomer.isCommercial = false;
          setEditFormData();
          expect(service.isCommercial, isFalse);
        });

        test("Commercial form should be displayed", () {
          tempCustomer.isCommercial = true;
          setEditFormData();
          expect(service.isCommercial, isTrue);
        });

      });

      group("Salesman Customer Rep field should be properly initialised", () {

        test("When Salesman Customer Rep doesn't exists", () {
          tempCustomer.repId = null;
          setEditFormData();
          expect(service.salesManCustomerRepId, tempSelectionList.first.id);
          expect(service.salesManCustomerRepController.text, tempSelectionList.first.label);
        });

        test("When Salesman Customer Rep exists", () {
          tempCustomer.repId = tempSelectionList[3].id;
          setEditFormData();
          expect(service.salesManCustomerRepId, tempSelectionList[3].id);
          expect(service.salesManCustomerRepController.text, tempSelectionList[3].label);
        });
      });

      test("Other information should be properly initialized", () {
        tempCustomer.isCommercial = false;
        setEditFormData();
        expect(service.companyNameController.text, tempCustomer.companyName);
        expect(service.managementCompanyController.text, tempCustomer.managementCompany);
        expect(service.propertyNameController.text, tempCustomer.propertyName);
        expect(service.customerNoteController.text, tempCustomer.note);
      });

      group("Company name field should be properly initialized", () {

        test("When customer is of commercial type", () {
          tempCustomer.isCommercial = true;
          setEditFormData();
          expect(service.companyNameController.text, tempCustomer.firstName);
        });

        test("When customer is of residential type", () {
          tempCustomer.isCommercial = false;
          setEditFormData();
          expect(service.companyNameController.text, tempCustomer.companyName);
        });
      });

      group("Customer Address should be properly initialised", () {

        test("When customer address doesn't exist", () {
          tempCustomer.address = null;
          setEditFormData();
          expect(service.address.id, 0);
        });

        test("When customer address exists", () {
          tempCustomer.address = tempAddress;
          setEditFormData();
          expect(service.address.id, tempAddress.id);
        });

        test("When customer billing address doesn't exists", () {
          tempCustomer.billingAddress = null;
          setEditFormData();
          expect(service.billingAddress.id, -1);
        });

        test("When customer billing address exists", () {
          tempCustomer.billingAddress = tempAddress;
          setEditFormData();
          expect(service.billingAddress.id, tempAddress.id);
        });

        test("When billing address is same as customer address", () {
          expect(service.billingAddress.sameAsDefault, true);
        });
      });

      group("Customer Company Name should be properly initialized", () {

        test("When customer is of commercial type", () {
          tempCustomer.isCommercial = true;
          setEditFormData();
          expect(service.companyNameController.text, tempCustomer.firstName);
          expect(service.firstNameController.text, tempCustomer.contacts!.first.firstName);
          expect(service.lastNameController.text, tempCustomer.contacts!.first.lastName);
        });

        test("When customer is of residential type", () {
          tempCustomer.isCommercial = false;
          setEditFormData();
          expect(service.firstNameController.text, tempCustomer.firstName);
          expect(service.lastNameController.text, tempCustomer.lastName);
          expect(service.secFirstNameController.text, tempCustomer.contacts!.first.firstName);
          expect(service.secLastNameController.text, tempCustomer.contacts!.first.lastName);
        });
      });

      group("Call Center Rep should be properly initialized", () {

        test("When customer doesn't have call center rep", () {
          tempCustomer.callCenterRepType = null;
          tempCustomer.callCenterRep = null;
          setEditFormData();
          expect(service.callCenterRepType, 'user');
          expect(service.callCenterRepId, tempSelectionList.first.id);
          expect(service.callCenterRepController.text, tempSelectionList.first.label);
          expect(service.otherCallCenterRepController.text, isEmpty);
        });

        group("When customer have call center rep", () {

          test("User should be prefilled in call center rep", () {
            tempCustomer.callCenterRepType = 'user';
            tempCustomer.callCenterRep = tempUser;
            setEditFormData();
            expect(service.callCenterRepType, 'user');
            expect(service.callCenterRepId, tempUser.id.toString());
            expect(service.callCenterRepController.text, tempUser.firstName);
            expect(service.otherCallCenterRepController.text, isEmpty);
          });

          test("Call Center Rep note should be displayed and filled", () {
            tempCustomer.callCenterRepType = CommonConstants.otherOptionId;
            tempCustomer.callCenterRep = tempUser;
            tempCustomer.callCenterRepString = tempUser.fullName;
            setEditFormData();
            expect(service.callCenterRepType, 'other');
            expect(service.callCenterRepId, CommonConstants.otherOptionId);
            expect(service.callCenterRepController.text, tempSelectionList[1].label);
            expect(service.otherCallCenterRepController.text, tempUser.fullName);
          });
        });
      });

      group("Canvasser should be properly initialized", () {

        test("When customer doesn't have canvasser", () {
          tempCustomer.canvasser = null;
          tempCustomer.canvasserType = null;
          setEditFormData();
          expect(service.canvasserType, 'user');
          expect(service.canvasserId, tempSelectionList.first.id);
          expect(service.canvasserController.text, tempSelectionList.first.label);
          expect(service.otherCanvasserController.text, isEmpty);
        });

        group("When customer has canvasser", () {

          test("User should be prefilled in canvasser", () {
            tempCustomer.canvasserType = 'user';
            tempCustomer.canvasser = tempUser;
            setEditFormData();
            expect(service.canvasserType, 'user');
            expect(service.canvasserId, tempUser.id.toString());
            expect(service.canvasserController.text, tempUser.firstName);
            expect(service.otherCanvasserController.text, isEmpty);
          });

          test("Canvasser note should be displayed and filled", () {
            tempCustomer.canvasserType = CommonConstants.otherOptionId;
            tempCustomer.canvasser = tempUser;
            tempCustomer.canvasserString = tempUser.fullName;
            setEditFormData();
            expect(service.canvasserType, 'other');
            expect(service.canvasserId, CommonConstants.otherOptionId);
            expect(service.canvasserController.text, tempSelectionList[1].label);
            expect(service.otherCanvasserController.text, tempUser.fullName);
          });
        });
      });

      group("Referred by field should be conditionally disabled", () {

        test("Referred by should be disabled", () {
          tempCustomer.sourceType = 'zapier';
          setEditFormData();
          expect(service.isReferredByDisabled, isTrue);
        });

        test("Referred by should be enabled", () {
          tempCustomer.sourceType = null;
          setEditFormData();
          expect(service.isReferredByDisabled, isFalse);
        });
      });
    });

    group("CustomerFormService@checkAndRemoveFields should remove non-accessible fields", () {

      test("When phone masking is enabled, field should be removed", () {
        service.setUpFields();
        service.customerId = tempCustomer.id;
        final initialSize = service.allFields.length;
        PermissionService.permissionList.add(PermissionConstants.enableMasking);
        service.checkAndRemoveFields();
        expect(service.allFields.length, initialSize - 1);
      });

      test("When phone masking is not enabled, field should not be removed", () {
        service.setUpFields();
        service.customerId = tempCustomer.id;
        final initialSize = service.allFields.length;
        PermissionService.permissionList.remove(PermissionConstants.enableMasking);
        service.checkAndRemoveFields();
        expect(service.allFields.length, initialSize);
      });
    });
  });

  group("CustomerFormService@doOpenCustomerDetails should decide whether to open Customer Details after saving customer", () {
    test("Customer details should be opened, When customer is not restricted", () {
      AuthService.isRestricted = false;
      final result = service.doOpenCustomerDetails();
      expect(result, isTrue);
    });

    test("Customer details should be opened, When salesman rep is same as logged in user", () {
      AuthService.isRestricted = false;
      service.salesManCustomerRepId = AuthService.userDetails?.id?.toString() ?? "";
      final result = service.doOpenCustomerDetails();
      expect(result, isTrue);
    });

    test("Customer details should not be opened, When salesman rep is different as logged in user and user is restricted", () {
      AuthService.isRestricted = true;
      service.salesManCustomerRepId = "abc";
      final result = service.doOpenCustomerDetails();
      expect(result, isFalse);
    });
  });

  group('CustomerFormData@getDefaultSalesRep should decide and fill in Sales Rep on initial load', () {
    setUp(() {
      service.salesManCustomerRepList = [
        JPSingleSelectModel(id: '1', label: 'Rep 1'),
        JPSingleSelectModel(id: '2', label: 'Rep 2'),
      ];
    });

    group("When Customer SalesRep Default To Current User setting is enabled", () {
      setUp(() {
        CompanySettingsService.companySettings = {
          CompanySettingConstants.customerSalesRepDefaultToCurrentUser: {"value": 1},
        };
      });

      test('Logged In user should be filled in as Salesman/Rep if user is available', () {
        AuthService.userDetails = tempUser..id = 123;
        final result = service.getDefaultSalesRep();
        expect(result, '123');
      });

      test('First Salesman/Rep should be filled in as Salesman/Rep if user is not available', () {
        AuthService.userDetails = null;
        final result = service.getDefaultSalesRep();
        expect(result, '1');
      });
    });

    group("When Customer SalesRep Default To Current User setting is disabled", () {
      setUp(() {
        CompanySettingsService.companySettings = {
          CompanySettingConstants.customerSalesRepDefaultToCurrentUser: {"value": 0},
        };
      });

      test('First Salesman/Rep should be filled in as Salesman/Rep', () {
        final result = service.getDefaultSalesRep();
        expect(result, '1');
      });
    });
  });

}

