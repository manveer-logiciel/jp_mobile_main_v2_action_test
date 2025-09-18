import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/global_widgets/search_location/address_dailogue/controller.dart';

void main() {
  late SearchedAddressDialogueController controller;

  AddressModel addressModel = AddressModel(
    id: 1,
    address: "Bestech Business Tower",
    addressLine1: "Parkview Residence Colony, Sector 66",
    city: "Sahibzada Ajit Singh Nagar",
    state: StateModel(id: 1, name: "Punjab", code: "PB", countryId: 91),
    country: CountryModel(id: 91, name: "India", code: "IN", currencyName: '', currencySymbol: ''),
    zip: "160062",
  );

  group('In case of no pre-selected address', () {
    test('SearchedAddressDialogueController should be initialized with correct data', () {
      controller = SearchedAddressDialogueController();
      expect(controller.addressTextController.text, "");
      expect(controller.addressLine1TextController.text, "");
      expect(controller.cityTextController.text, "");
      expect(controller.stateTextController.text, "");
      expect(controller.countryTextController.text, "");
      expect(controller.zipTextController.text, "");
      expect(controller.addressModel?.id, null);
      expect(controller.allCountries.isNotEmpty, false);
      expect(controller.countryId, null);
      expect(controller.allStates.isNotEmpty, false);
      expect(controller.isLoading, false);
    });
  });

  group('In case of pre-selected address', () {
    test('SearchedAddressDialogueController should be initialized with pre-selected address', () {
      controller = SearchedAddressDialogueController(addressModel: addressModel);
      expect(controller.addressModel?.address, addressModel.address);
      expect(controller.addressModel?.addressLine1, addressModel.addressLine1);
      expect(controller.addressModel?.city, addressModel.city);
      expect(controller.addressModel?.state?.name, addressModel.state?.name);
      expect(controller.addressModel?.country?.name, addressModel.country?.name);
      expect(controller.addressModel?.zip, addressModel.zip);
      expect(controller.addressModel?.id, addressModel.id);
      expect(controller.isLoading, false);
    });

    test('SearchedAddressDialogueController@initData should be initialized with pre-selected address', () {
      controller.initData();
      expect(controller.addressTextController.text, addressModel.address);
      expect(controller.addressLine1TextController.text, addressModel.addressLine1);
      expect(controller.cityTextController.text, addressModel.city);
      expect(controller.stateTextController.text, "");
      expect(controller.countryTextController.text, "");
      expect(controller.zipTextController.text, addressModel.zip);
      expect(controller.addressModel?.id, addressModel.id);
      expect(controller.allCountries.isNotEmpty, false);
      expect(controller.countryId, null);
      expect(controller.allStates.isNotEmpty, false);
      expect(controller.isLoading, false);
    });
  });
}