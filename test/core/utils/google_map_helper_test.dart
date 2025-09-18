import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/google_maps/address_components.dart';
import 'package:jobprogress/common/models/google_maps/address_geometry.dart';
import 'package:jobprogress/common/models/google_maps/place_details.dart';
import 'package:jobprogress/common/models/sql/country/country.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/map_helper/google_map_helper.dart';

void main() {
  
  group('GoogleMapHelper@convertPlaceDetailsModelToAddressModel should convert PlaceDetails model into Address model', () {
    group('Address should be correctly filled', () {

      test('In case street number is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['route'],
              longName: 'Main Street',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );
        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.address, 'Main Street');
      });

      test('In case route is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['street_number'],
              longName: '123',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );
        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.address, '123 ');
      });

      test('In case street number and route is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['street_number'],
              longName: '123',
            ),
            AddressComponentsModel(
              types: ['route'],
              longName: 'Main Street',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );
        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.address, '123 Main Street');
      });

      test('If case street number and route is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['postal_code'],
              longName: '12345',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );
        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.address, '');
      });

    });
    
    group('City should be correctly filled', () {

      test('In case locality is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['locality'],
              longName: 'City',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );

        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.city, 'City');
      });

      test('In case sub-locality is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['sublocality_level_1'],
              longName: 'Sub-City',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );

        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.city, 'Sub-City');
      });

      test('In case sub-locality and locality both are coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['sublocality_level_1'],
              longName: 'Sub-City',
            ),
            AddressComponentsModel(
              types: ['locality'],
              longName: 'City',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );

        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.city, 'City');
      });

      test('In case sub-locality and locality both are not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['country'],
              longName: 'Sub-City',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );

        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.city, '');
      });

    });

    group('State should be correctly filled', () {

      test('In case administrative area level 1 is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['administrative_area_level_1'],
              longName: 'State',
              shortName: 'ST',
              id: '1',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.state?.code, 'ST');
        expect(convertedAddressModel.state?.name, 'State');
      });

      test('In case administrative area level 1 is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['street_number'],
              longName: '123',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.state?.code, null);
        expect(convertedAddressModel.state?.name, null);
      });

    });

    group('Country should be correctly filled', () {

      test('In case country is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['country'],
              longName: 'Country',
              shortName: 'CT',
              id: '2',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.country?.code, 'CT');
        expect(convertedAddressModel.country?.name, 'Country');
      });

      test('In case country is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['street_number'],
              longName: '123',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.country?.code, null);
        expect(convertedAddressModel.country?.name, null);
      });

    });

    group('Zip should be correctly filled', () {

      test('In case postal code is coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['postal_code'],
              longName: '12345',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.zip, '12345');
      });

      test('In case postal code is not coming', () {
        PlaceDetailsModel placeDetails = PlaceDetailsModel(
          addressComponents: [
            AddressComponentsModel(
              types: ['street_number'],
              longName: '123',
            ),
          ],
          geometry: AddressGeometryModel(
            lat: 123.456,
            lng: 789.012,
          ),
        );


        AddressModel convertedAddressModel = GoogleMapHelper.convertPlaceDetailsModelToAddressModel(placeDetails);
        expect(convertedAddressModel.zip, '');
      });

    });
    
  });

  group('GoogleMapHelper@convertAddressModelToPlaceDetailsModel should convert Address model into PlaceDetails model', () {

    test('When AddressModel is not null', () {
      AddressModel addressModel = AddressModel(
        id: -1,
        address: '123 Main Street',
        city: 'City',
        state: StateModel(
          id: 1,
          name: 'State',
          code: 'ST',
          countryId: 2,
        ),
        country: CountryModel(
          id: 2,
          name: 'Country',
          code: 'CT',
          currencyName: '',
          currencySymbol: 'CT',
        ),
        zip: '12345',
        lat: 123.456,
        long: 789.012,
      );

      // Call the function to convert the AddressModel to PlaceDetailsModel
      PlaceDetailsModel placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(addressModel);

      // Assert the expected values
      expect(placeDetailsModel.name, '');
      expect(placeDetailsModel.formattedAddress, Helper.convertAddress(addressModel).trim());
      expect(placeDetailsModel.geometry?.lat, 123.456);
      expect(placeDetailsModel.geometry?.lng, 789.012);
      expect(placeDetailsModel.addressComponents?.length, 5);
      expect(placeDetailsModel.addressComponents?[0]?.longName, '123 Main Street');
      expect(placeDetailsModel.addressComponents?[0]?.types, ['premise', 'route']);
      expect(placeDetailsModel.addressComponents?[1]?.longName, 'City');
      expect(placeDetailsModel.addressComponents?[1]?.types, ['locality']);
      expect(placeDetailsModel.addressComponents?[2]?.id, '1');
      expect(placeDetailsModel.addressComponents?[2]?.longName, 'State');
      expect(placeDetailsModel.addressComponents?[2]?.shortName, 'ST');
      expect(placeDetailsModel.addressComponents?[2]?.types, ['administrative_area_level_1']);
      expect(placeDetailsModel.addressComponents?[3]?.id, '2');
      expect(placeDetailsModel.addressComponents?[3]?.longName, 'Country');
      expect(placeDetailsModel.addressComponents?[3]?.shortName, 'CT');
      expect(placeDetailsModel.addressComponents?[3]?.types, ['country']);
      expect(placeDetailsModel.addressComponents?[4]?.longName, '12345');
      expect(placeDetailsModel.addressComponents?[4]?.types, ['postal_code']);
    });

    test('When AddressModel has missing data', () {
      AddressModel addressModel = AddressModel(
        id: -1,
        address: '',
        city: 'City',
        state: null,
        country: null,
        zip: '',
        lat: 123.456,
        long: 789.012,
      );

      // Call the function to convert the AddressModel to PlaceDetailsModel
      PlaceDetailsModel placeDetailsModel = GoogleMapHelper.convertAddressModelToPlaceDetailsModel(addressModel);

      // Assert the expected values
      expect(placeDetailsModel.name, '');
      expect(placeDetailsModel.formattedAddress, Helper.convertAddress(addressModel).trim());
      expect(placeDetailsModel.geometry?.lat, 123.456);
      expect(placeDetailsModel.geometry?.lng, 789.012);
      expect(placeDetailsModel.addressComponents?[0]?.longName, '');
    });
  });
}