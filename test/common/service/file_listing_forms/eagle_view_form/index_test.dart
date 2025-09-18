import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/eagle_view_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/files_listing/forms/eagle_view_form/eagle_view_form.dart';
import 'package:jobprogress/modules/files_listing/forms/eagle_view_form/controller.dart';
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
      ),
    address: AddressModel.fromJson({
      "id":8123,
      "address":"West 34th Street",
      "address_line_1":"Dsdfsdfsdfsdf",
      "city":"New York",
      "state":{
        "id":61,
        "name":"Ontario",
        "code":"ON",
        "country_id":4
      },
      "country":{
        "id":4,
        "name":"Canada",
        "code":"CA",
        "currency_name":"Doller",
        "currency_symbol":"\$",
        "phone_code":"+91"
      },
      "zip":"12354",
      "lat":40.749901,
      "long":-73.988602,
    })
  );

  List<JPSingleSelectModel> tempProductList = [
    JPSingleSelectModel(id: "31", label: "Premium - Residential"),
    JPSingleSelectModel(id: "11", label: "EagleView Inform Essentials+"),
    JPSingleSelectModel(id: "34", label: "Residential - Walls Only"),
    JPSingleSelectModel(id: "44", label: "QuickSquares - Residential"),
    JPSingleSelectModel(id: "51", label: "WallsLite"),
    JPSingleSelectModel(id: "57", label: "Blueprint - Residential"),
  ];

  List<JPSingleSelectModel> tempDeliveryList = [
    JPSingleSelectModel(id: "8", label: "Regular"),
    JPSingleSelectModel(id: "4", label: "Express"),
    JPSingleSelectModel(id: "7", label: "3 Hour"),
  ];

  List<JPSingleSelectModel> tempMeasurementsList = [
    JPSingleSelectModel(id: "1", label: "Primary Structure + Detached Garage"),
    JPSingleSelectModel(id: "2", label: "Primary Structure Only"),
    JPSingleSelectModel(id: "3", label: "All Structures on Parcel"),
    JPSingleSelectModel(id: "4", label: "Commercial Complex"),
    JPSingleSelectModel(id: "5", label: "Other (please provide instructions)"),
  ];

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

  late Map<String, dynamic> tempInitialJson;

  group('In case of create eagle-view order', () {
    EagleViewFormService service = EagleViewFormService(
      update: () {},
      validateForm: () {},
      jobModel: tempJob,
      pageType: EagleViewFormType.createForm,
    );

    setUpAll(() {
      tempInitialJson = service.eagleViewFormJson();
      service.productList = tempProductList;
      service.deliveryList = tempDeliveryList;
      service.measurementsList = tempMeasurementsList;
      service.controller = EagleViewFormController();
    });

    group('EagleViewFormService should be initialized with correct data', () {
      test('Form fields should be initialized with correct values', () {
        expect(service.productsController.text, "");
        expect(service.deliveryController.text, "");
        expect(service.addOnProductsController.text, "");
        expect(service.measurementController.text, "");
        expect(service.insuredNameController.text, "");
        expect(service.referenceIdController.text, "");
        expect(service.batchIdController.text, "");
        expect(service.policyNoController.text, "");
        expect(service.claimNumberController.text, "");
        expect(service.claimInfoController.text, "");
        expect(service.poNumberController.text, "");
        expect(service.catIdController.text, "");
        expect(service.dateOfLossController.text, "");
        expect(service.sendCopyToController.text, "");
        expect(service.commentController.text, "");
        expect(service.havePromoCode, false);
        expect(service.havePreviousChanges, false);
      });
    });

    test('Form expectations should be initialized with correct values', () {
      expect(service.isProductSectionExpanded, false);
      expect(service.isInstructionSectionExpanded, false);
      expect(service.isClaimSectionExpanded, false);
      expect(service.isOtherInfoSectionExpanded, false);
    });

    test('Form data helpers should be initialized with correct values', () {
      expect(service.jobModel != null, true);
      expect(service.initialJson, <String, dynamic>{});
    });

    test('EagleViewFormService@setUpAPIData() should set-up form values', () {
      service.setUpAPIData();
      expect(service.initialJson, tempInitialJson);
    });

    group('EagleViewFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {
      JPSingleSelectModel? initialSelectedDelivery = service.selectedDelivery;
      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });

      test('When changes in form are made', () {
        service.selectedDelivery = tempDeliveryList[0];
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.selectedDelivery = initialSelectedDelivery;
        final val = service.checkIfNewDataAdded();
        expect(val, false);
      });
    });

    group('EagleViewFormService@onProductSectionExpansionChanged should toggle product section expansion', () {
      test("Product section should be expanded", () {
        service.onProductSectionExpansionChanged(true);
        expect(service.isProductSectionExpanded, true);
      });
      test("Product section should be collapsed", () {
        service.onProductSectionExpansionChanged(false);
        expect(service.isProductSectionExpanded, false);
      });
    });

    group('EagleViewFormService@onInsuranceSectionExpansionChanged should toggle insurance section expansion', () {
      test('insurance section should be expanded', () {
        service.onInsuranceSectionExpansionChanged(true);
        expect(service.isInstructionSectionExpanded, true);
      });
      test('insurance section should be collapsed', () {
        service.onInsuranceSectionExpansionChanged(false);
        expect(service.isInstructionSectionExpanded, false);
      });
    });

    group('EagleViewFormService@onClaimSectionExpansionChanged should toggle claim section expansion', () {
      test('claim section should be expanded', () {
        service.onClaimSectionExpansionChanged(true);
        expect(service.isClaimSectionExpanded, true);
      });
      test('claim section should be collapsed', () {
        service.onClaimSectionExpansionChanged(false);
        expect(service.isClaimSectionExpanded, false);
      });
    });

    group('EagleViewFormService@onOtherInfoSectionExpansionChanged should toggle other section expansion', () {
      test('other section should be expanded', () {
        service.onOtherInfoSectionExpansionChanged(true);
        expect(service.isOtherInfoSectionExpanded, true);
      });
      test('other section should be collapsed', () {
        service.onOtherInfoSectionExpansionChanged(false);
        expect(service.isOtherInfoSectionExpanded, false);
      });
    });


    group('EagleViewFormService@validateFormData() should validate form date', () {

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
          service.selectedProduct = tempProductList[0];
          service.productsController.text = service.selectedProduct?.label ?? "";
          service.deliveryController.text = "productsController test";
          service.measurementController.text = "productsController test";
          expect(service.validateFormData(), true);
        });
      });

      group('Delivery selection validation', () {
        test('Validation should fail when selected delivery field is empty', () {
          service.deliveryController.text = "";
          service.measurementController.text = "";
          expect(service.validateFormData(), false);
        });

        test('Validation should pass when selected delivery field is not empty', () {
          service.selectedDelivery = tempDeliveryList[0];
          service.deliveryController.text = service.selectedDelivery?.label ?? "";
          service.measurementController.text = "deliveryController test";
          expect(service.validateFormData(), true);
        });
      });

      group('Measurement selection validation', () {
        test('Validation should fail when selected measurement field is empty', () {
          service.measurementController.text = "";
          expect(service.validateFormData(), false);
        });

        test('Validation should pass when selected measurement field is not empty', () {
          service.selectedMeasurements = tempMeasurementsList[0];
          service.measurementController.text = service.selectedMeasurements?.label ?? "";
          expect(service.validateFormData(), true);
        });
      });

      group('Email Recipient field validation', () {
        test('Validation should pass when email recipient field is empty', () {
          expect(service.validateFormData(), true);
        });

        test('Validation should fail when email format in email recipient field is incorrect', () {
          service.sendCopyToController.text = "test";
          expect(service.validateFormData(), false);
        });

        test('Validation should pass when email format in email recipient field is correct', () {
          service.sendCopyToController.text = "test@test.com";
          expect(service.validateFormData(), true);
        });
      });

      test('Validation should pass when selected address have complete address details', () {
        expect(service.validateFormData(), true);
      });
    });

  });
}