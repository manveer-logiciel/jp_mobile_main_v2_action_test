
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';

void main() {
  group("ConnectedThirdPartyService@isBeaconConnected should decide whether beacon is connected or not", () {
    group("Beacon should not be considered as connected", () {
      test("When beacon key does not exists in third party services", () {
        ConnectedThirdPartyService.connectedThirdParty = {};
        expect(ConnectedThirdPartyService.isBeaconConnected(), isFalse);
      });

      test("When beacon key exists but is disabled", () {
        ConnectedThirdPartyService.connectedThirdParty = {
          ConnectedThirdPartyConstants.beacon: false
        };
        expect(ConnectedThirdPartyService.isBeaconConnected(), isFalse);
      });
    });

    test("Beacon should be considered as connected, when key exists and is enabled", () {
      ConnectedThirdPartyService.connectedThirdParty = {
        ConnectedThirdPartyConstants.beacon: true
      };
      expect(ConnectedThirdPartyService.isBeaconConnected(), isTrue);
    });
  });
}