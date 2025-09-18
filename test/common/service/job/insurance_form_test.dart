import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/services/job/insurance_form/add_insurance.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/form/validators.dart';

void main() {
  final tempInsuranceDetails = InsuranceModel(
    id: 10,
    insuranceCompany: 'Testily',
    insuranceNumber: 'PKJ79BH7878',
    policyNumber: 'PKJ79BH7878',
    phone: '(666)6666666',
    fax: '(777)7777777',
    email: 'avinash@gmail.com',
    adjusterName: 'adit',
    adjusterPhone: '(888)8888888',
    adjusterPhoneExt: '12',
    adjusterEmail: 'adit@gmail.com',
    contingencyContractSignedDate: '2023-04-05',
    dateOfLoss: '2023-04-06',
    claimFiledDate: '2023-04-07',
    acv: '100',
    deductibleAmount: '7.55',
    netClaim: '92.45',
    depreciation: '4',
    rcv: '104',
    upgrade: '12.5',
    supplement: '6',
    total: '122.5',
  );

  late Map<String, dynamic> tempInitialJson;
  
  group('In case of create insurance details', () {
    InsuranceDetailsFormService service = InsuranceDetailsFormService(
      validateForm: () {},
      insuranceModel: null,
    );
    String initialInsuranceCompany = service.insuranceCompanyController.text;

    setUpAll(() {        
      service.setFormData();
      tempInitialJson = service.insuranceDetailsFormJson();
    });

    group('InsuranceDetailsFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {  
        expect(service.insuranceCompanyController.text, "");
        expect(service.claimController.text, "");
        expect(service.policyController.text, "");
        expect(service.phoneController.text, "");
        expect(service.faxController.text, "");
        expect(service.emailController.text, "");
        expect(service.adjusterNameController.text, "");
        expect(service.adjusterEmailController.text, "");
        expect(service.acvController.text, "");
        expect(service.deductibleAmountController.text, "");
        expect(service.netClaimAmountController.text, "");
        expect(service.depreciationController.text, "");
        expect(service.rcvController.text, "");
        expect(service.upgradesController.text, "");
        expect(service.supplementsController.text, "");
        expect(service.totalController.text, "");
        expect(service.contingencyContractSignedController.text, "");
        expect(service.dateOfLossController.text, "");
        expect(service.claimFiledController.text, "");
      });

      test('Form data helper lists should be filled with correct data', () {
        expect(service.adjusterPhoneField.length, 1);
      });

      test('Form data helper values should be filled with correct data', () {
        expect(service.contingencyContractSignedDate, null);
        expect(service.dateOfLoss, null);
        expect(service.claimFiledDate, null);
      });
    });

    test('InsuranceDetailsFormService@insuranceDetailsFormJson() should generate json from form-data', () {
      final tempJson = service.insuranceDetailsFormJson();
      expect(tempInitialJson, tempJson);
    });

    test('When no changes in form are made', () {
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, false);
    });

    test('When changes in form are made', () {
      service.insuranceCompanyController.text = 'Testily';
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, true);
    });

    test('When changes are reverted', () {
      service.insuranceCompanyController.text = initialInsuranceCompany;
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, false);
    });

    group('validatePhoneNumber() should validate phone number fields', () {
       test('Validation should pass when phone number is empty', () {        
        expect(FormValidator.validatePhoneNumber(service.phoneController.text, isRequired: false), null);
        expect(FormValidator.validatePhoneNumber(service.faxController.text, isRequired: false), null);
        expect(FormValidator.validatePhoneNumber(service.adjusterPhoneField[0].number!, isRequired: false), null);
      });

      test('Validation should fail when phone number is not-empty & invaild', () {
        service.phoneController.text = '123';
        expect(FormValidator.validatePhoneNumber(service.phoneController.text), 'phone_number_must_be_between_range'.tr);
        service.faxController.text = '345';
        expect(FormValidator.validatePhoneNumber(service.faxController.text), 'phone_number_must_be_between_range'.tr);
        service.adjusterPhoneField[0].number = '000';
        expect(FormValidator.validatePhoneNumber(service.adjusterPhoneField[0].number ?? ''), 'phone_number_must_be_between_range'.tr);
      });

       test('Validation should pass when phone number is not-empty & valid', () {
        service.phoneController.text = '(888) 888-8888';
        expect(FormValidator.validatePhoneNumber(service.phoneController.text), null);
        service.faxController.text = '(777) 777-7777';
        expect(FormValidator.validatePhoneNumber(service.faxController.text), null);
         service.adjusterPhoneField[0].number = '(999) 999-999';
        expect(FormValidator.validatePhoneNumber(service.adjusterPhoneField[0].number ?? ''), null);
      });
    });

    group('validateEmail() should validate email fields', () {
      test('Validation should pass when email is empty', () {
        expect(FormValidator.validateEmail(service.emailController.text), null);
        expect(FormValidator.validateEmail(service.adjusterEmailController.text), null);
      });

      test('Validation should fail when email is not-empty & invalid', () {
        service.emailController.text = 'adit@gmailcom';
        expect(FormValidator.validateEmail(service.emailController.text, isRequired: true), 'please_enter_valid_email'.tr);
        service.adjusterEmailController.text = 'ajay@gmail';
        expect(FormValidator.validateEmail(service.adjusterEmailController.text, isRequired: true), 'please_enter_valid_email'.tr);
      });

      test('Validation should pass when email is not-empty & valid', () {
        service.emailController.text = 'adit@gmail.com';
        expect(FormValidator.validateEmail(service.emailController.text, isRequired: true), null);
        service.adjusterEmailController.text = 'ajay@gmail.com';
        expect(FormValidator.validateEmail(service.adjusterEmailController.text, isRequired: true), null);
      });
    });

    group('InsuranceDetailsFormService@calculateAmount should calculate insurance amounts', () { 

      group('InsuranceDetailsFormService@calculateAmount should calculate properly while modifying amounts fields', () { 
        test('InsuranceDetailsFormService.calculateNetClaimAmount() should calculate properly after modified acv amount', () {
          service.acvController.text = '100';
          expect(service.calculateNetClaimAmount(), '100');
        });

        test('InsuranceDetailsFormService.calculateNetClaimAmount() should calculate properly after modified deductible amount', () {
          service.deductibleAmountController.text = '7.5';
          expect(service.calculateNetClaimAmount(), '92.5');
        });

        test('InsuranceDetailsFormService.calculateRcvAmount() should calculate properly after modified depreciation amount', () {
          service.depreciationController.text = '12';
          expect(service.calculateRcvAmount(), '112');
        });

        test('InsuranceDetailsFormService.calculateTotalAmount() should calculate properly after modified upgrades amount', () {
          service.upgradesController.text = '8';
          expect(service.calculateTotalAmount(), '120');
        });

        test('InsuranceDetailsFormService.calculateTotalAmount() should calculate properly after modified supplements amount', () {
          service.supplementsController.text = '20';
          expect(service.calculateTotalAmount(), '140');
        });
      });

      group('InsuranceDetailsFormService@calculateAmount should calculate properly while reverting amounts fields', () { 
        test('InsuranceDetailsFormService.calculateTotalAmount() should calculate properly after reverted upgrades amount', () {
          service.upgradesController.text = '';
          expect(service.calculateTotalAmount(), '132');
        });

        test('InsuranceDetailsFormService.calculateRcvAmount() should calculate properly after reverted depreciation amount', () {
          service.depreciationController.text = '';
          expect(service.calculateRcvAmount(), '100');
        });

        test('InsuranceDetailsFormService.calculateNetClaimAmount() should calculate properly after reverted deductible amount', () {
          service.deductibleAmountController.text = '';
          expect(service.calculateNetClaimAmount(), '100');
        });

        test('InsuranceDetailsFormService@calculateAmount should calculate properly after reverted acv amount', () {
          service.acvController.text = '';
          expect(service.calculateTotalAmount(), '');
          expect(service.calculateRcvAmount(), '');
          expect(service.calculateNetClaimAmount(), '');
        });
      });
    });

  });

  group('In case of edit/update insurance details', () { 
    InsuranceDetailsFormService service = InsuranceDetailsFormService(
      validateForm: () {},
      insuranceModel: tempInsuranceDetails,
    );

    setUpAll(() {
      service.setFormData();
      tempInitialJson = service.insuranceDetailsFormJson();
    });

    test('When no changes in form are made', () {
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, false);
    });

    test('When changes in form are made', () {
      service.insuranceCompanyController.text = 'Testily Company';
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, true);
    });

    test('When changes are reverted', () {
      service.insuranceCompanyController.text = tempInsuranceDetails.insuranceCompany ?? '';
      bool isNewDataAdded = service.checkIfNewDataAdded();
      expect(isNewDataAdded, false);
    });

    test('validatePhoneNumber() should pass when phone number fields is not empty', () {
      expect(FormValidator.validatePhoneNumber(tempInsuranceDetails.phone!, isRequired: true), null);
      expect(FormValidator.validatePhoneNumber(tempInsuranceDetails.fax!, isRequired: true), null);
      expect(FormValidator.validatePhoneNumber(tempInsuranceDetails.adjusterPhone!, isRequired: true), null);
    });

    test('validateEmail() should pass when email fields is not empty', () {
      expect(FormValidator.validateEmail(tempInsuranceDetails.email!, isRequired: true), null);
      expect(FormValidator.validateEmail(tempInsuranceDetails.adjusterEmail!, isRequired: true), null);
    });

    group("Contingency Contract Signed date should be set properly", () {
      setUp(() {
        service.contingencyContractSignedDate = null;
        service.contingencyContractSignedController.text = '';
      });

      test("In case date is zero, Contingency Contract Signed date should not be set", () {
        tempInsuranceDetails.contingencyContractSignedDate = '0000-00-00';
        service.setFormData();
        expect(service.contingencyContractSignedDate, null);
        expect(service.contingencyContractSignedController.text, isEmpty);
      });

      test("In case date is empty, Contingency Contract Signed date should be set empty", () {
        tempInsuranceDetails.contingencyContractSignedDate = '';
        service.setFormData();
        expect(service.contingencyContractSignedDate, null);
        expect(service.contingencyContractSignedController.text, isEmpty);
      });

      test("In case date not exists, Contingency Contract Signed date should be set empty", () {
        tempInsuranceDetails.contingencyContractSignedDate = null;
        service.setFormData();
        expect(service.contingencyContractSignedDate, null);
        expect(service.contingencyContractSignedController.text, isEmpty);
      });

      test("In case date is not empty, Contingency Contract Signed date should be set properly", () {
        tempInsuranceDetails.contingencyContractSignedDate = '2023-10-10';
        service.setFormData();
        expect(service.contingencyContractSignedDate, DateTime.parse(tempInsuranceDetails.contingencyContractSignedDate.toString()));
        expect(service.contingencyContractSignedController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.contingencyContractSignedDate ?? ''));
      });
    });

    group("Date of Loss should be set properly", () {
      setUp(() {
        service.dateOfLoss = null;
        service.dateOfLossController.text = '';
      });

      test("In case date is zero, Date of Loss should not be set", () {
        tempInsuranceDetails.dateOfLoss = '0000-00-00';
        service.setFormData();
        expect(service.dateOfLoss, null);
        expect(service.dateOfLossController.text, isEmpty);
      });

      test("In case date is empty, Date of Loss should be set empty", () {
        tempInsuranceDetails.dateOfLoss = '';
        service.setFormData();
        expect(service.dateOfLoss, null);
        expect(service.dateOfLossController.text, isEmpty);
      });

      test("In case date not exists, Date of Loss should be set empty", () {
        tempInsuranceDetails.dateOfLoss = null;
        service.setFormData();
        expect(service.dateOfLoss, null);
        expect(service.dateOfLossController.text, isEmpty);
      });

      test("In case date is not empty, Date of Loss should be set properly", () {
        tempInsuranceDetails.dateOfLoss = '2023-10-10';
        service.setFormData();
        expect(service.dateOfLoss, DateTime.parse(tempInsuranceDetails.dateOfLoss.toString()));
        expect(service.dateOfLossController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.dateOfLoss ?? ''));
      });
    });

    group("Claim Filed date should be set properly", () {
      setUp(() {
        service.claimFiledDate = null;
        service.claimFiledController.text = '';
      });

      test("In case date is zero, Claim Filed date should not be set", () {
        tempInsuranceDetails.claimFiledDate = '0000-00-00';
        service.setFormData();
        expect(service.claimFiledDate, null);
        expect(service.claimFiledController.text, isEmpty);
      });

      test("In case date is empty, Claim Filed date should be set empty", () {
        tempInsuranceDetails.claimFiledDate = '';
        service.setFormData();
        expect(service.claimFiledDate, null);
        expect(service.claimFiledController.text, isEmpty);
      });

      test("In case date not exists, Claim Filed date should be set empty", () {
        tempInsuranceDetails.claimFiledDate = null;
        service.setFormData();
        expect(service.claimFiledDate, null);
        expect(service.claimFiledController.text, isEmpty);
      });

      test("In case date is not empty, Claim Filed date should be set properly", () {
        tempInsuranceDetails.claimFiledDate = '2023-10-10';
        service.setFormData();
        expect(service.claimFiledDate, DateTime.parse(tempInsuranceDetails.claimFiledDate.toString()));
        expect(service.claimFiledController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.claimFiledDate ?? ''));
      });
    });

    test('convertHyphenIntoSlash() should pass when date fields is not empty', () {
      expect(service.contingencyContractSignedController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.contingencyContractSignedDate ?? ''));
      expect(service.contingencyContractSignedDate, DateTime.parse(tempInsuranceDetails.contingencyContractSignedDate.toString()));

      expect(service.dateOfLossController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.dateOfLoss ?? ''));
      expect(service.dateOfLoss, DateTime.parse(tempInsuranceDetails.dateOfLoss.toString()));

      expect(service.claimFiledController.text, DateTimeHelper.convertHyphenIntoSlash(tempInsuranceDetails.claimFiledDate ?? ''));
      expect(service.claimFiledDate, DateTime.parse(tempInsuranceDetails.claimFiledDate.toString()));
    });

    group('InsuranceDetailsFormService@calculateAmount should calculate properly calculation of insurance amounts', () { 
      test('InsuranceDetailsFormService@calculateNetClaimAmount() should calculate properly sum of (acv - deductible)', () {
        expect(service.calculateNetClaimAmount(), tempInsuranceDetails.netClaim!);
      });

      test('InsuranceDetailsFormService@calculateRcvAmount() should calculate properly sum of (acv + depreciation)', () {
        expect(service.calculateRcvAmount(), tempInsuranceDetails.rcv!);
      });

      test('InsuranceDetailsFormService@calculateTotalAmount() should calculate properly sum of (rcv + supplements + upgrades)', () {
        expect(service.calculateTotalAmount(), tempInsuranceDetails.total!);
      });
    });
  });

  group("Phone Numbers should be masked before filling in input fields", () {
    InsuranceDetailsFormService service = InsuranceDetailsFormService(
      validateForm: () {},
      insuranceModel: tempInsuranceDetails,
    );

    test("In case of valid phone number", () {
      service.insuranceModel?.phone = "1234567890";
      service.setFormData();
      expect(service.phoneController.text, "(123)4567890");
    });

    test("In case of invalid phone number", () {
      service.insuranceModel?.phone = "123456789123";
      service.setFormData();
      expect(service.phoneController.text, "(123)4567891");
    });

    test("In case of invalid empty phone number", () {
      service.insuranceModel?.phone = "";
      service.setFormData();
      expect(service.phoneController.text, "");
    });

    test("In case of invalid null phone number", () {
      service.insuranceModel?.phone = null;
      service.setFormData();
      expect(service.phoneController.text, "");
    });

    test("In case of invalid phone number with spaces", () {
      service.insuranceModel?.phone = "123 456 7890";
      service.setFormData();
      expect(service.phoneController.text, "(123)4567890");
    });

    test("In case of valid fax number", () {
      service.insuranceModel?.fax = "1234567890";
      service.setFormData();
      expect(service.faxController.text, "(123)4567890");
    });

    test("In case of invalid fax number", () {
      service.insuranceModel?.fax = "123456789123";
      service.setFormData();
      expect(service.faxController.text, "(123)4567891");
    });

    test("In case of invalid empty fax number", () {
      service.insuranceModel?.fax = "";
      service.setFormData();
      expect(service.faxController.text, "");
    });

    test("In case of invalid null fax number", () {
      service.insuranceModel?.fax = null;
      service.setFormData();
      expect(service.faxController.text, "");
    });

    test("In case of invalid fax number with spaces", () {
      service.insuranceModel?.fax = "123 456 7890";
      service.setFormData();
      expect(service.faxController.text, "(123)4567890");
    });

    test("In case of valid adjuster phone number", () {
      service.insuranceModel?.adjusterPhone = "1234567890";
      service.setFormData();
      expect(service.adjusterPhoneField[0].number, "(123)4567890");
    });

    test("In case of invalid adjuster phone number", () {
      service.insuranceModel?.adjusterPhone = "123456789123";
      service.setFormData();
      expect(service.adjusterPhoneField[0].number, "(123)4567891");
    });

    test("In case of invalid empty adjuster phone number", () {
      service.insuranceModel?.adjusterPhone = "";
      service.setFormData();
      expect(service.adjusterPhoneField[0].number, "");
    });

    test("In case of invalid null adjuster phone number", () {
      service.insuranceModel?.adjusterPhone = null;
      service.setFormData();
      expect(service.adjusterPhoneField[0].number, "");
    });

    test("In case of invalid adjuster phone number with spaces", () {
      service.insuranceModel?.adjusterPhone = "123 456 7890";
      service.setFormData();
      expect(service.adjusterPhoneField[0].number, "(123)4567890");
    });
  });
}