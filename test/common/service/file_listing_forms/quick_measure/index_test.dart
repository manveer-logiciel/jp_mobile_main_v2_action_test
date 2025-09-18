import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/files_listing/forms/quck_measure_form/quick_measure_form.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/modules/files_listing/forms/quick_measure/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  JobModel? tempJob = JobModel(
    id: 1,
    customerId: 2,
    name: 'Test Job',
    number: '123-456',
    altId: "112",
    customer: CustomerModel(
      id: 4584,
      companyName: "",
      addressId : 8123,
      billingAddressId:8821,
      firstName:"Apply Apply Apply",
      lastName:"Measurement Measurement Measurement",
      fullName:"Apply Apply Apply Measurement Measurement Measurement",
      fullNameMobile:"Apply Apply Apply Measurement Measurement Measurement",
      email:"raj.srivastava@logicielsolutions.co.in",
      additionalEmails:[
      "asd.asd@asd.asd"
      ],
    )
  );

  late Map<String, dynamic> tempInitialJson;

  group('In case of create quick measure order', () {
    QuickMeasureFormService service = QuickMeasureFormService(
      update: () {},
      validateForm: () {},
      jobModel: tempJob,
    );

    AddressModel? addressModel = AddressModel(
        id: 0,
        address: "Address Line 1",
        addressLine1: "Address Line 2",
        addressLine3: "Address Line 3",
        city: "City Line",
        state: StateModel(id: 0, name: "State", code: "ST", countryId: 0),
        country: CountryModel(id: 0, name: "Country", code: "CO", currencyName: "Currency", currencySymbol: "c", phoneCode: "PhoneCode", phoneFormat: "-- ------ ----- "),
        zip: "Zip Code"
    );

    setUpAll(() {
      tempInitialJson = service.quickMeasureFormJson();
      service.controller = QuickMeasureFormController();
    });

    group('QuickMeasureFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.productsController.text, "");
        expect(service.emailController.text, "");
        expect(service.accountController.text, "");
        expect(service.emailController.text, "");
        expect(service.specialInfoController.text, "");
      });

      test('Form expectations should be initialized with correct values', () {
        expect(service.isProductSectionExpanded, false);
        expect(service.isOtherInfoSectionExpanded, false);
      });

      test('Form data helpers should be initialized with correct values', () {
        expect(service.jobModel != null, true);
        expect(service.initialJson, <String, dynamic>{});
      });

      test('QuickMeasureFormService@setFormData() should set-up form values', () {
        service.setFormData();
        expect(service.initialJson, tempInitialJson);
      });

      group('QuickMeasureFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
        JPSingleSelectModel? initialSelectedProduct;
        test('When no changes in form are made', () {
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });

        test('When changes in form are made', () {
          service.selectedProduct = DropdownListConstants.productTypeList[0];
          final val = service.checkIfNewDataAdded();
          expect(val, true);
        });

        test('When changes are reverted', () {
          service.selectedProduct = initialSelectedProduct;
          final val = service.checkIfNewDataAdded();
          expect(val, false);
        });
      });

      group('QuickMeasureFormService@onProductSectionExpansionChanged should toggle product section expansion', () {

        test("Product section should be expanded", () {
          service.onProductSectionExpansionChanged(true);
          expect(service.isProductSectionExpanded, true);
        });

        test("Product section should be collapsed", () {
          service.onProductSectionExpansionChanged(false);
          expect(service.isProductSectionExpanded, false);
        });
      });

      group('QuickMeasureFormService@onOtherInfoSectionExpansionChanged should toggle other section expansion', () {

        test("Other section should be expanded", () {
          service.onOtherInfoSectionExpansionChanged(true);
          expect(service.isOtherInfoSectionExpanded, true);
        });

        test("Other section should be collapsed", () {
          service.onOtherInfoSectionExpansionChanged(false);
          expect(service.isOtherInfoSectionExpanded, false);
        });
      });

      group('QuickMeasureFormService@validateFormData() should validate form date', () {

        group('Address selection validation', () {
          test('Validation should fail when no address selected', () {
            expect(service.validateFormData(), false);
          });

          test('Validation should fail when selected address does not have address', () {
            service.selectedAddress = AddressModel.copy(addressModel: addressModel);
            service.selectedAddress?.address = null;
            expect(service.validateFormData(), false);
          });

          test('Validation should fail when selected address does not have city', () {
            service.selectedAddress?.city = null;
            expect(service.validateFormData(), false);
          });

          test('Validation should fail when selected address does not have country', () {
            service.selectedAddress?.country = null;
            expect(service.validateFormData(), false);
          });

          test('Validation should fail when selected address does not have zip', () {
            service.selectedAddress?.zip = null;
            expect(service.validateFormData(), false);
            service.selectedAddress = addressModel;
          });

        });

        group('Product selection validation', () {
          test('Validation should fail when selected product field is empty', () {
            expect(service.validateFormData(), false);
          });

          test('Validation should pass when selected product field is not empty', () {
            service.selectedProduct = DropdownListConstants.productTypeList[0];
            service.productsController.text = service.selectedProduct?.label ?? "";
            expect(service.validateFormData(), true);
          });
        });

        group('Email Recipient field validation', () {
          test('Validation should pass when email recipient field is empty', () {
            expect(service.validateFormData(), true);
          });

          test('Validation should fail when email format in email recipient field is incorrect', () {
            service.emailController.text = "test";
            expect(service.validateFormData(), false);
          });

          test('Validation should pass when email format in email recipient field is correct', () {
            service.emailController.text = "test@test.com";
            expect(service.validateFormData(), true);
          });
        });

        test('Validation should pass when selected address have complete address details', () {
          expect(service.validateFormData(), true);
        });

      });

    });
  });
}