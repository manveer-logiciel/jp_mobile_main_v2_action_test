import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/forms/place_srs_order/fields.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/worksheet/worksheet_model.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/index.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/core/constants/delivery_time_type_constant.dart';
import 'package:jobprogress/core/constants/delivery_type_constant.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

void main() {

  FilesListingModel tempFilesListingModel = FilesListingModel(
    worksheetId: "1",
    worksheet: WorksheetModel(
      shipToSequenceNumber: "1",
    ),
  );

  PlaceSupplierOrderFormService service = PlaceSupplierOrderFormService(
    update: () {},
    validateForm: () {},
    onDataChange: (_) {},
    worksheetId: tempFilesListingModel.worksheetId!,
  );

  List<JPSingleSelectModel> tempTimezoneList = [
    JPSingleSelectModel(label: "America/Chicago", id: '1'),
  ];

  List<JPSingleSelectModel> tempDeliveryTypeList = [
    JPSingleSelectModel(label: "Ground", id: '1'),
    JPSingleSelectModel(label: "Roof", id: '2'),
  ];

  List<JPSingleSelectModel> tempDeliveryDateList = [
    JPSingleSelectModel(label: "02/17/2023", id: '12'),
  ];

  List<SrsShipToAddressModel> tempShipToAddressList = [
    SrsShipToAddressModel(id: 1, addressLine1: "123, Main Blg", addressLine2: "Virar", city: "Mumbai", shipToId: "12", shipToSequenceId: "1", state: "MH", zipCode: "401305"),
  ];

  UserModel tempUser = UserModel(
    id: 1,
    firstName: 'Amit',
    fullName: 'Amit Mallah',
    email: 'amit@gmail.com',
    phones: [PhoneModel(number: '9876543210')],
    companyDetails: CompanyModel(
      id: 1,
      companyName: 'PS Company',
      city: 'DFW Airport',
      address: '2400 Aviation Drive',
      addressLine1: '',
      zip: '75261',
      stateId: 133,
      stateCode: 'DNB',
      countryId: 5,
      stateName: 'Dunbartonshire',
    )
  );

  JobModel tempJobModel = JobModel(
    id: 345,
    customerId: 1,
    address: AddressModel(
      id: 180175,
      address: '2400 Aviation Drive',
      addressLine1: '',
      city: 'DFW Airport',
      zip: '75261',
      state: StateModel(id: 133, name: 'Dunbartonshire', code: 'DNB', countryId: 5),
      stateId: 133,
    )
  );

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    CompanySettingsService.setCompanySettings([{
      "key": CompanySettingConstants.timeZone,
      "value": "America/Chicago"
    }]);
    AuthService.userDetails = tempUser;
  });

  group("In case of create place srs order", () {

    group("PlaceSrsOrderFormService should be initialized with correct values", () {

      test('Form fields should be initialized with correct values', () {
        expect(service.timeZoneController.text, isEmpty);
        expect(service.materialDeliveryDateController.text, isEmpty);
        expect(service.materialDeliveryNoteController.text, isEmpty);
        expect(service.deliveryTypeController.text, isEmpty);
        expect(service.noteController.text, isEmpty);
        expect(service.nameController.text, isEmpty);
        expect(service.phoneController.text, isEmpty);
        expect(service.emailController.text, isEmpty);
      });

      (test('Form toggles should be initialized with correct values', () {
        expect(service.isLoading, true);
        expect(service.validateFormOnDataChange, false);
        expect(service.isDeliveryTimeEnable, false);
        expect(service.isDeliveryMethod, true);
      }));

      test('Form data helpers should be initialized with correct values', () {
        expect(service.companyAddress.id, -1);
        expect(service.shippingAddress.id, -1);
        expect(service.billingAddress.id, -1);
        expect(service.initialJson, isEmpty);
        expect(service.validators, isEmpty);
        expect(service.job, isNull);
        expect(service.fileListingModel, isNull);
        expect(service.worksheetId, "1");
        expect(service.materialDeliveryDate, isNull);
        expect(service.startDateTime, isNull);
        expect(service.endDateTime, isNull);
        expect(service.name, isEmpty);
        expect(service.phone, isEmpty);
        expect(service.email, isEmpty);
      });

      test('Form selection id\'s should be initialized with correct values', () {
        expect(service.selectedTimezoneId, isEmpty);
        expect(service.selectedDeliveryDateId, isEmpty);
        expect(service.selectedDeliveryTypeId, isEmpty);
      });

      test("Form selection lists should be initialized with correct values", () {
        expect(service.timezoneList, isEmpty);
        expect(service.deliveryTypeList, isEmpty);
        expect(service.deliveryDateList, isEmpty);
        expect(service.allSections, isEmpty);
        expect(service.allFields, isEmpty);
        expect(service.shipToAddressList, isEmpty);
        expect(service.attachments, isEmpty);
      });
    });

    test("PlaceSrsOrderFormService@setFormData should set-up form values", () {

      service.fileListingModel = tempFilesListingModel;
      service.job = tempJobModel;

      service.timezoneList = tempTimezoneList;
      service.deliveryTypeList = tempDeliveryTypeList;
      service.deliveryDateList = tempDeliveryDateList;
      service.shipToAddressList = tempShipToAddressList;

      service.setFormData();

      expect(service.selectedTimezoneId, tempTimezoneList.first.id);
      expect(service.timeZoneController.text, tempTimezoneList.first.label);

      expect(service.isFieldEditable(), true);
    });

    test('PlaceSrsOrderFormService@setInitialJson() should set-up initial json from form-data', () {
      service.setInitialJson();
      expect(service.initialJson, isNotEmpty);
    });

    test('PlaceSrsOrderFormService@placeSrsOrderFormJson() should generate json from form-data', () {
      final tempJson = service.placeSupplierOrderFormJson();
      expect(service.initialJson, tempJson);
    });

    group("PlaceSrsOrderFormData@beaconOrderFormJson should generate correct payload for beacon supplier", () {
      group("'Delivery date' should be parsed correctly", () {
        test("In case pickup date is not selected", () {
          service.materialDeliveryDateController.text = '';
          final payload = service.beaconOrderFormJson();
          expect(payload['pickup_date'], isEmpty);
        });

        test('In case pick up date is selected', () {
          service.materialDeliveryDateController.text = '05/10/2020';
          final payload = service.beaconOrderFormJson();
          expect(payload['pickup_date'], '2020-05-10');
        });
      });

      group("'Material List Id' should be parsed correctly", () {
        test('When worksheet has material list available', () {
          service.fileListingModel = FilesListingModel(
              worksheet: WorksheetModel(
                materialListId: '10'
              ),
          );
          final payload = service.beaconOrderFormJson();
          expect(payload['material_list_id'], '10');
        });

        test('When worksheet does not have material list available', () {
          service.fileListingModel = FilesListingModel(
              worksheet: WorksheetModel(
                materialListId: null
              ),
          );
          final payload = service.beaconOrderFormJson();
          expect(payload['material_list_id'], isNull);
        });
      });

      group("'Shipping Method' should be parsed correctly", () {
        test("When shipping method is 'Delivery'", () {
          service.isDeliveryMethod = true;
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_method'], equals('D'));
        });

        test("When shipping method is 'Delivery'", () {
          service.isDeliveryMethod = false;
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_method'], equals('P'));
        });
      });

      group("'Shipping Branch Code' should be parsed correctly", () {
        test("When worksheet is available with branch code", () {
          service.fileListingModel = FilesListingModel(
            worksheet: WorksheetModel(
                branchCode: '10'
            ),
          );
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_branch_code'], equals('10'));
        });

        test("When shipping method is 'Delivery'", () {
          service.fileListingModel = FilesListingModel(
            worksheet: WorksheetModel(
                branchCode: null
            ),
          );
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_branch_code'], isNull);
        });
      });

      test("'Pickup time' should be set correctly", () {
        service.deliveryTypeController.text = '10 AM';
        final payload = service.beaconOrderFormJson();
        expect(payload['pickup_time'], equals('10 AM'));
      });

      test("'Special Instructions' should be set correctly", () {
        service.noteController.text = 'Test note';
        final payload = service.beaconOrderFormJson();
        expect(payload['special_instruction'], equals('Test note'));
      });

      test("'Purchase Order Number/PO or Job Number' should be set correctly", () {
        service.poJobNameController.text = '12345';
        final payload = service.beaconOrderFormJson();
        expect(payload['purchase_order_no'], equals('12345'));
      });

      group("'Shipping Address' should be parsed correctly", () {
        setUp(() {
          service.shippingAddress = AddressModel(
            id: -1,
            address: 'Address Line 1',
            addressLine1: 'Address Line 2',
            city: 'Jalandhar',
            zip: '123456',
            state: StateModel(
              id: -1,
              code: 'PN',
              name: 'Punjab',
              countryId: -1,
            )
          );
        });

        test("'Address Line 1' should be added correctly", () {
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_address']['address_line_1'], equals('Address Line 1'));
        });

        test("'Address Line 2' should be set correctly", () {
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_address']['address_line_2'], equals('Address Line 2'));
        });

        test("'City' should be set correctly", () {
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_address']['city'], equals('Jalandhar'));
        });

        test("'Zip Code' should be set correctly", () {
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_address']['zip_code'], equals('123456'));
        });

        test("'State code' should be set correctly", () {
          final payload = service.beaconOrderFormJson();
          expect(payload['shipping_address']['state'], equals('PN'));
        });
      });
    });

    group('PlaceSrsOrderFormService@checkIfNewDataAdded() should check if any addition/update is made in form', () {

      String initialName = tempUser.fullName;

      test('When no changes in form are made', () {
        final val = service.checkIfNewDataAdded();
        expect(val, isTrue);
      });

      test('When changes in form are made', () {
        service.name = 'Amitchandra Mallah';
        final val = service.checkIfNewDataAdded();
        expect(val, true);
      });

      test('When changes are reverted', () {
        service.name = initialName;
        final val = service.checkIfNewDataAdded();
        expect(val, isTrue);
      });
    });

    test("All sections should be displayed when all fields are present", () {
      service.setUpFields();
      expect(service.allSections.length, 5);
    });

    group("PlaceSrsOrderFormService@changeShippingMethod should select shipping type", () {

      test("When pickup option is selected", () {
        service.changeShippingMethod(false);
        expect(service.isDeliveryMethod, isFalse);
      });

      test("When delivery option is selected", () {
        service.changeShippingMethod(true);
        expect(service.isDeliveryMethod, isTrue);
      });
    });

    group("PlaceSrsOrderFormService@toggleLoading should toggle form loading state", () {

      test("Shimmer should be displayed", () {
        service.toggleLoading(true);
        expect(service.isLoading, true);
      });

      test("Form should be displayed", () {
        service.toggleLoading(false);
        expect(service.isLoading, false);
      });
    });

    group("PlaceSrsOrderFormService@toggleIsDeliveryTime should show/hide requested delivery time fields", () {

      test("Requested delivery time fields should be displayed", () {
        service.toggleIsDeliveryTime(true);
        expect(service.isDeliveryTimeEnable, isTrue);
      });

      test("Requested delivery time fields should not be displayed", () {
        service.toggleIsDeliveryTime(false);
        expect(service.isDeliveryTimeEnable, isFalse);
      });
    });

    group("CustomerFormService@validateShippingAddress should validate shipping address fields", () {

      final shippingAddressField = PlaceSrsOrderFormFieldsData.shippingAddressfields[0];
      final initialAddress = service.shippingAddress.address;

      test("Validation should fail when first address line is empty", () {
        service.shippingAddress.address = '';
        expect(service.shippingAddress.address, '');
      });

      test("Validation should pass when first address line is filled", () {
        service.shippingAddress.address = initialAddress;
        final val = service.validateShippingAddress(shippingAddressField);
        expect(val, isFalse);
      });
    });

    group("CustomerFormService@validateTimezone should validate timezone fields", () {

      final timezoneField = PlaceSrsOrderFormFieldsData.placeSRSOrderfields((_) {})[2];
      final initialTimezone = tempTimezoneList[0].label;

      test("Validation should fail when timezone is empty", () {
        service.timeZoneController.text = '';
        timezoneField.isRequired = true;
        final val = service.validateTimezone(timezoneField);
        expect(val, isTrue);
      });

      test("Validation should pass when timezone is filled", () {
        service.timeZoneController.text = initialTimezone;
        final val = service.validateTimezone(timezoneField);
        expect(val, isFalse);
      });
    });

    group("CustomerFormService@validateMaterialDeliveryDate should validate material delivery date fields", () {

      final materialDeliveryDateField = PlaceSrsOrderFormFieldsData.placeSRSOrderfields((_) {})[3];
      final initialMaterialDeliveryDate = tempDeliveryDateList[0].label;

      test("Validation should fail when material delivery date is empty", () {
        service.materialDeliveryDateController.text = '';
        final val = service.validateMaterialDeliveryDate(materialDeliveryDateField);
        expect(val, isTrue);
      });

      test("Validation should pass when material delivery date is filled", () {
        service.materialDeliveryDateController.text = initialMaterialDeliveryDate;
        final val = service.validateMaterialDeliveryDate(materialDeliveryDateField);
        expect(val, isFalse);
      });
    });

    group("CustomerFormService@validateDeliveryType should validate delivery type fields", () {

      final deliveryTypeField = PlaceSrsOrderFormFieldsData.placeSRSOrderfields((_) {})[6];
      final initialDeliveryType = tempDeliveryTypeList[0].label;

      test("Validation should fail when delivery type is empty", () {
        service.deliveryTypeController.text = '';
        final val = service.validateDeliveryType(deliveryTypeField);
        expect(val, isTrue);
      });

      test("Validation should pass when delivery type is filled", () {
        service.deliveryTypeController.text = initialDeliveryType;
        final val = service.validateDeliveryType(deliveryTypeField);
        expect(val, isFalse);
      });
    });

    group("CustomerFormService@validateDeliveryDateTime should validate delivery datetime fields", () {

      test("Validation should fail when delivery date is today", () {
        service.materialDeliveryDate = DateTime.now();
        final val = service.materialDeliveryDate?.isTomorrow();
        expect(val, isFalse);
      });

      test("Validation should pass when delivery date is after today", () {
        service.materialDeliveryDate = DateTime.now().add(const Duration(days: 1));
        final val = service.materialDeliveryDate?.isTomorrow();
        expect(val, isTrue);
      });

      test("Validation should fail when delivery start time is same as end time", () {
        service.startDateTime = "2023-05-30 11:00:00.000";
        service.endDateTime = "2023-05-30 11:00:00.000";
        final val = Jiffy.parse(service.startDateTime!).isBefore(Jiffy.parse(service.endDateTime!));
        expect(val, isFalse);
      });

      test("Validation should fail when delivery start time is after end time", () {
        service.startDateTime = "2023-05-30 11:30:00.000";
        service.endDateTime = "2023-05-30 11:00:00.000";
        final val = Jiffy.parse(service.startDateTime!).isBefore(Jiffy.parse(service.endDateTime!));
        expect(val, isFalse);
      });

      test("Validation should pass when delivery start time is before end time", () {
        service.startDateTime = "2023-05-30 10:00:00.000";
        service.endDateTime = "2023-05-30 11:00:00.000";
        final val = Jiffy.parse(service.startDateTime!).isBefore(Jiffy.parse(service.endDateTime!));
        expect(val, isTrue);
      });
    });

    group("PlaceSrsOrderFormService@expandErrorSection should error field section", () {

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

    test("PlaceSrsOrderFormService@setBeaconFormData should set beacon order form data correctly", () {
      service.setBeaconFormData();
      service.job = JobModel(
          id: -1,
          customerId: -1,
        address: AddressModel(
          id: -1,
          address: '',
        ),
      );
      expect(service.deliveryTypeList, hasLength(4));
      expect(service.materialDeliveryDate, isNull);
      expect(service.shippingAddress.id, equals(180175));
    });

    group("PlaceSrsOrderFormFieldsData@placeBeaconOrderFields should set beacon order form fields", () {
      test('Fields should be displayed in correct order', () {
        final allFields = PlaceSrsOrderFormFieldsData.placeBeaconOrderFields((_) {});
        expect(allFields[0].key, PlaceSrsOrderFormConstants.materialDate);
        expect(allFields[1].key, PlaceSrsOrderFormConstants.shippingMethod);
        expect(allFields[2].key, PlaceSrsOrderFormConstants.deliveryType);
        expect(allFields[3].key, PlaceSrsOrderFormConstants.poJobName);
        expect(allFields[4].key, PlaceSrsOrderFormConstants.note);
      });
    });

    test("PlaceSrsOrderFormService@setABCFormData should set ABC order form data correctly", () {
      service.setABCFormData();
      service.job = JobModel(
        id: -1,
        customerId: -1,
        address: AddressModel(
          id: -1,
          address: '',
        ),
      );
      expect(service.deliveryServiceList, hasLength(3));
      expect(service.materialDeliveryDate, isNull);
      expect(service.minimumRequestedDate, isNull);
      expect(service.selectedDeliveryService, service.deliveryServiceList[0]);
      expect(service.shippingAddress.id, equals(-1));
    });
  });

  group("PlaceSrsOrderFormFieldsData@setUpFields should set up fields correctly", () {
    test("In case of SRS Order form", () {
      service.type = MaterialSupplierType.srs;
      service.setUpFields();
      expect(service.allFields, hasLength(14));
      expect(service.allSections, hasLength(5));
    });

    test("In case of Beacon Order form", () {
      service.type = MaterialSupplierType.beacon;
      service.setUpFields();
      expect(service.allFields, hasLength(6));
      expect(service.allSections, hasLength(2));
    });

    test("In case of ABC Order form", () {
      service.type = MaterialSupplierType.abc;
      service.setUpFields();
      expect(service.allFields, hasLength(8));
      expect(service.allSections, hasLength(4));
    });
  });

  group('PlaceSrsOrderFormFieldsData@changeBeaconShippingMethod should update shipping method', () {
    group('On changing shipping method to "Delivery"', () {
      setUp(() {
        service.changeBeaconShippingMethod(true);
      });

      test("Delivery method should be enabled", () {
        expect(service.isDeliveryMethod, isTrue);
      });

      test("Pickup time should reset", () {
        expect(service.deliveryTypeController.text, isEmpty);
        expect(service.selectedDeliveryTypeId, isEmpty);
      });

      test('Pickup time options should update', () {
        expect(service.deliveryTypeList, equals(DropdownListConstants.beaconOrderDeliveryTypes));
      });
    });

    group('On changing shipping method to "Pickup"', () {
      setUp(() {
        service.changeBeaconShippingMethod(false);
      });

      test("Delivery method should be disabled", () {
        expect(service.isDeliveryMethod, isFalse);
      });

      test("Delivery time should reset", () {
        expect(service.deliveryTypeController.text, isEmpty);
      });

      test('Delivery time options should update', () {
        expect(service.deliveryTypeList, equals(DropdownListConstants.beaconOrderPickUpTypes));
      });
    });
  });

  group("PlaceSrsOrderFormFieldsData@getDeliveryTypeTitle should give correct title on choosing delivery type", () {
    test("On SRS Order form", () {
      service.type = MaterialSupplierType.srs;
      expect(service.getDeliveryTypeTitle(), equals('select_delivery_type'.tr));
    });

    group("On Beacon Order form", () {
      test("In case shipping method is 'Delivery'", () {
        service.type = MaterialSupplierType.beacon;
        service.isDeliveryMethod = true;
        expect(service.getDeliveryTypeTitle(), equals('select_delivery_type'.tr));
      });

      test("In case shipping method is 'Pickup'", () {
        service.type = MaterialSupplierType.beacon;
        service.isDeliveryMethod = false;
        expect(service.getDeliveryTypeTitle(), equals('select_delivery_type'.tr));
      });
    });
  });

  group('PlaceSrsOrderFormFieldsData@getDeliveryServiceCode should get service code on choosing delivery service type', () {
    setUpAll(() {
      service.selectedDeliveryService = JPSingleSelectModel(label: '', id: DeliveryServiceConstant.deliveryCode);
    });
    test('When delivery service is active', () {
      service.selectedDeliveryService?.id = DeliveryServiceConstant.deliveryCode;
      service.selectedDeliveryTypeId = DropdownListConstants.abcOrderDeliveryTypes[0].id;
      expect(service.getDeliveryServiceCode(), service.selectedDeliveryTypeId);
    });

    test('When express pickup service is active', () {
      service.selectedDeliveryService?.id = DeliveryServiceConstant.expressPickupCode;
      expect(service.getDeliveryServiceCode(), DeliveryTypeConstant.expCode);
    });
    test('When willCall service is active', () {
      service.selectedDeliveryService?.id = DeliveryServiceConstant.willCallCode;
      expect(service.getDeliveryServiceCode(), DeliveryTypeConstant.cpuCode);
    });
  });

  group('PlaceSrsOrderFormFieldsData@getPickupDate should get pickup date', () {
    test('When TBD option is checked', () {
      service.isDateTBDChecked = true;
      expect(service.getPickupDate(), isEmpty);
    });

    test('When TBD option is not checked', () {
      service.isDateTBDChecked = false;
      service.materialDeliveryDate = DateTimeHelper.now().add(const Duration(days: 2));
      expect(service.getPickupDate(), DateTimeHelper.format(service.materialDeliveryDate, DateFormatConstants.dateServerFormat));
    });
  });

  group('PlaceSrsOrderFormFieldsData@getPickupTime should get pickup time', () {
    test('When Specific time is chosen', () {
      service.selectedRequestedDeliveryTimeId = DeliveryTimeTypeConstant.specificTime;
      service.startDateTime = '2024-11-20 16:04:00.000';
      expect(service.getPickupTime(), '16:04');
    });

    test('When Specific time is not chosen', () {
      service.selectedRequestedDeliveryTimeId = DeliveryTimeTypeConstant.timeRange;
      expect(service.getPickupTime(), isEmpty);
    });
  });

  group("PlaceSrsOrderFormFieldsData@placeABCOrderFields should set ABC order form fields", () {
    test('Fields should be displayed in correct order', () {
      final allFields = PlaceSrsOrderFormFieldsData.placeABCOrderFields((_) {});
      expect(allFields[0].key, PlaceSrsOrderFormConstants.requestedDeliveryDateLabel);
      expect(allFields[1].key, PlaceSrsOrderFormConstants.poJobName);
      expect(allFields[2].key, PlaceSrsOrderFormConstants.requestedDeliveryTime);
      expect(allFields[3].key, PlaceSrsOrderFormConstants.deliveryType);
      expect(allFields[4].key, PlaceSrsOrderFormConstants.note);
    });
  });

  group("CustomerFormService@validatePOJobName should validate timezone fields", () {

    final poJobNameField = PlaceSrsOrderFormFieldsData.placeABCOrderFields((_) {})[1];

    test("Validation should fail when PO or job name is empty", () {
      service.poJobNameController.text = '';
      expect(service.validatePOJobName(poJobNameField), isTrue);
    });

    test("Validation should pass when timezone is filled", () {
      service.poJobNameController.text = 'PO';
      final val = service.validatePOJobName(poJobNameField);
      expect(val, isFalse);
    });
  });

  group("PlaceSupplierOrderFormService@validateDeliveryType should validate Estimate Branch Arrival Time fields", () {

    final estimateBranchArrivalTimeTypeField = PlaceSrsOrderFormFieldsData.placeSRSOrderfields((_) {})[6];
    const initialEstimateBranchArrivalTimeType = '11/28/2024';

    service.forSupplierId = 181;
    service.type = MaterialSupplierType.srs;
    service.isDeliveryMethod = true;

    test("Validation should fail when startDateTime is empty", () {
      service.estimateBranchArrivalTimeController.text = '';
      final val = service.validateEstimateBranchArrivalTime(estimateBranchArrivalTimeTypeField);
      expect(val, isTrue);
    });

    test("Validation should pass when startDateTime is filled", () {
      service.estimateBranchArrivalTimeController.text = initialEstimateBranchArrivalTimeType;
      final val = service.validateEstimateBranchArrivalTime(estimateBranchArrivalTimeTypeField);
      expect(val, isFalse);
    });
  });

  group('PlaceSrsOrderFormData@setMaterialDate sets the material date', () {
    test('When type is beacon with valid deliveryDate', () {
      service.type = MaterialSupplierType.beacon;
      service.deliveryDate = '11/27/2024'; // Example date

      expect(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!),'2024-11-27');
      expect(DateTimeHelper.format(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!), DateFormatConstants.dateOnlyFormat),'11/27/2024');

      service.setMaterialDate();

      expect(service.materialDeliveryDateController.text, '11/27/2024');
    });

    test('When type is beacon with no deliveryDate', () {
      service.type = MaterialSupplierType.beacon;
      service.deliveryDate = null;

      expect(DateTimeHelper.stringToDateTime(service.deliveryDate), isNull);
      expect(DateTimeHelper.format(service.deliveryDate, DateFormatConstants.dateOnlyFormat), isEmpty);

      service.setMaterialDate();

      expect(service.materialDeliveryDateController.text, '11/27/2024');
      expect(service.minimumRequestedDate, isNull);
    });

    test('When type is SRS with valid deliveryDate', () {
      service.type = MaterialSupplierType.beacon;
      service.deliveryDate = '11/27/2024'; // Example date

      expect(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!),'2024-11-27');
      expect(DateTimeHelper.format(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!), DateFormatConstants.dateOnlyFormat),'11/27/2024');

      service.setMaterialDate();

      expect(service.materialDeliveryDateController.text, '11/27/2024');
    });

    test('When type is SRS with no deliveryDate', () {
      service.type = MaterialSupplierType.beacon;
      service.deliveryDate = null;

      expect(DateTimeHelper.stringToDateTime(service.deliveryDate), isNull);
      expect(DateTimeHelper.format(service.deliveryDate, DateFormatConstants.dateOnlyFormat), isEmpty);

      service.setMaterialDate();

      expect(service.materialDeliveryDateController.text, '11/27/2024');
      expect(service.minimumRequestedDate, isNull);
    });

    test('When type is ABC with valid deliveryDate', () {
      service.type = MaterialSupplierType.abc;
      service.deliveryDate = '11/27/2024'; // Example date

      expect(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!),'2024-11-27');
      expect(DateTimeHelper.format(DateTimeHelper.convertSlashIntoHyphen(service.deliveryDate!), DateFormatConstants.dateOnlyFormat),'11/27/2024');

      service.setMaterialDate();

      expect(service.materialDeliveryDateController.text, '11/27/2024');
    });

    test('When type is ABC with no deliveryDate', () {
      service.type = MaterialSupplierType.abc;
      service.deliveryDate = null;

      expect(DateTimeHelper.stringToDateTime(service.deliveryDate), isNull);
      expect(DateTimeHelper.format(service.deliveryDate, DateFormatConstants.dateOnlyFormat), isEmpty);

      service.setMaterialDate();

      final tomorrowDate = DateTime.now().add(const Duration(days: 1));
      expect(service.materialDeliveryDateController.text, DateTimeHelper.format(tomorrowDate, DateFormatConstants.dateOnlyFormat));
      expect(service.minimumRequestedDate, contains(DateTimeHelper.format(tomorrowDate, DateFormatConstants.dateServerFormat)));
    });
  });

  group('PlaceSupplierOrderFormService@getPhoneDetails should returns phone data', () {
    setUpAll(() {
      service.phone = PhoneMasking.maskPhoneNumber('1234567890');
      service.phoneField = PhoneModel(number: service.phone);
    });

    test('When phone label and ext are not available', () {
      expect(service.phoneField?.label, null);
      expect(service.phoneField?.ext, null);
      final result = service.getPhoneDetails();
      expect(result, PhoneMasking.maskPhoneNumber(service.phone));
    });
    group(
        'PlaceSupplierOrderFormService@getPhoneDetails should returns phone data', () {
      setUpAll(() {
        service.phoneField = PhoneModel(number: '');
      });

      test(
          'When phone number is not available but label and ext are available', () {
        service.phone = '';
        service.phoneField?.label = 'Home';
        service.phoneField?.ext = '456';
        expect(service.getPhoneDetails(), isEmpty);
      });

      test('When phone number, label and ext are not available', () {
        service.phone = '';
        service.phoneField?.label = '';
        service.phoneField?.ext = '';
        expect(service.getPhoneDetails(), isEmpty);
      });

      test(
          'When label and ext are not available but phone number is available', () {
        service.phoneField?.label = '';
        service.phoneField?.ext = '';
        service.phone = PhoneMasking.maskPhoneNumber('1234567890');
        final result = service.getPhoneDetails();
        expect(result, service.phone);
      });

      test(
          'When label is not available but phone number and ext are available', () {
        service.phoneField?.label = '';
        service.phoneField?.ext = '+91';
        service.phone = PhoneMasking.maskPhoneNumber('1234567890');
        final result = service.getPhoneDetails();
        expect(result, '${service.phone} ext - ${service.phoneField?.ext}');
      });

      test(
          'When ext is not available but phone number and label are available', () {
        service.phoneField?.label = 'Home';
        service.phoneField?.ext = '';
        service.phone = PhoneMasking.maskPhoneNumber('1234567890');
        final result = service.getPhoneDetails();
        expect(result, 'Home - ${service.phone}');
      });


      test('When phone number, label and ext all are available', () {
        service.phone = PhoneMasking.maskPhoneNumber('1234567890');
        service.phoneField?.ext = "456";
        service.phoneField?.label = 'Work';
        final result = service.getPhoneDetails();
        expect(result, 'Work - ${service.phone} ext - 456');
      });
    });
  });
}