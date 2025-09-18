import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/eagle_view_form_type.dart';
import 'package:jobprogress/common/enums/run_mode.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/global_widgets/search_location/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/eagle_view_form/controller.dart';

void main() {
  EagleViewFormController controller = EagleViewFormController();

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
    TestWidgetsFlutterBinding.ensureInitialized();
    RunModeService.setRunMode(RunMode.unitTesting);
    Get.testMode = true;
    controller.init();
  });

  group('In case of create EagleView order', () {
    test('EagleViewFormController should be initialized with correct values', () {
      controller.pageType = EagleViewFormType.createForm;
      expect(controller.isSavingForm, false);
      expect(controller.validateFormOnDataChange, false);
      expect(controller.isProductSectionExpanded, false);
      expect(controller.isInstructionSectionExpanded, false);
      expect(controller.isClaimSectionExpanded, false);
      expect(controller.isOtherInfoSectionExpanded, false);
      expect(controller.jobModel != null, false);
      expect(controller.pageType, EagleViewFormType.createForm);
      expect(controller.pageTitle, 'eagle_view_order'.tr.toUpperCase());
      expect(controller.saveButtonText, 'place_order'.tr.toUpperCase());
    });

    group('EagleViewFormController@onProductSectionExpansionChanged should toggle product section expansion', () {
      test('product section should be expanded', () {
        controller.onProductSectionExpansionChanged(true);
        expect(controller.isProductSectionExpanded, true);
      });
      test('product section should be collapsed', () {
        controller.onProductSectionExpansionChanged(false);
        expect(controller.isProductSectionExpanded, false);
      });
    });

    group('EagleViewFormController@onInsuranceSectionExpansionChanged should toggle insurance section expansion', () {
      test('insurance section should be expanded', () {
        controller.onInsuranceSectionExpansionChanged(true);
        expect(controller.isInstructionSectionExpanded, true);
      });
      test('insurance section should be collapsed', () {
        controller.onInsuranceSectionExpansionChanged(false);
        expect(controller.isInstructionSectionExpanded, false);
      });
    });

    group('EagleViewFormController@onClaimSectionExpansionChanged should toggle claim section expansion', () {
      test('claim section should be expanded', () {
        controller.onClaimSectionExpansionChanged(true);
        expect(controller.isClaimSectionExpanded, true);
      });
      test('claim section should be collapsed', () {
        controller.onClaimSectionExpansionChanged(false);
        expect(controller.isClaimSectionExpanded, false);
      });
    });

    group('EagleViewFormController@onOtherInfoSectionExpansionChanged should toggle other section expansion', () {
      test('other section should be expanded', () {
        controller.onOtherInfoSectionExpansionChanged(true);
        expect(controller.isOtherInfoSectionExpanded, true);
      });
      test('other section should be collapsed', () {
        controller.onOtherInfoSectionExpansionChanged(false);
        expect(controller.isOtherInfoSectionExpanded, false);
      });
    });

    group("EagleViewFormController@onAddressUpdate should update selected address and perform different actions based on it", () {
      test("EagleViewFormController@onAddressUpdate should set selected address", () {
        controller.onAddressUpdate(addressModel);
        expect(controller.selectedAddress?.address, addressModel.address);
        expect(controller.selectedAddress?.addressLine1, addressModel.addressLine1);
        expect(controller.selectedAddress?.addressLine3, addressModel.addressLine3);
        expect(controller.selectedAddress?.city, addressModel.city);
        expect(controller.selectedAddress?.zip, addressModel.zip);
      });

      group("EagleViewFormController@onAddressUpdate should toggle isDefaultLocation", () {
        test("should set default location", () {
          controller.onAddressUpdate(addressModel, isPinUpdated: false);
          expect(controller.service.isDefaultLocation, true);
        });
        test("should de-set default location", () {
          controller.onAddressUpdate(addressModel, isPinUpdated: true);
          expect(controller.service.isDefaultLocation, false);
        });
      });

      group("EagleViewFormController@onAddressUpdate should set selected address in map view", () {
        test("should de-set selected location", () {
          controller.onAddressUpdate(addressModel, canUpdateMarker: false);
          controller.formBuilderController.collapsibleMapController = JPCollapsibleMapController(initialAddress: null, mapDragDetector: (isMapScrolling){});
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.address, null);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.addressLine1, null);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.addressLine3, null);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.city, null);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.zip, null);
        });
        test("should set selected location", () {
          controller.onAddressUpdate(addressModel, canUpdateMarker: true);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.address, addressModel.address);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.addressLine1, addressModel.addressLine1);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.addressLine3, addressModel.addressLine3);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.city, addressModel.city);
          expect(controller.formBuilderController.collapsibleMapController?.initialAddress?.zip, addressModel.zip);
        });
      });
    });
  });
}