import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/beacon_client_model.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  group('AuthService@isUserBeaconConnected should check', () {
    setUpAll(() {
      tz.initializeTimeZones();
      DateTimeHelper.userTimeZone = tz.getLocation(DateTimeHelper.defaultLocation.trim());
      AuthService.userDetails = UserModel(
          id: 1,
          firstName: 'firstName',
          fullName: 'fullName',
          email: 'email'
      );
    });
    test('When beacon client is connected and refreshExpiryDateTime is in the past', () {
      final pastDateTime = DateTimeHelper.format(DateTime.now().subtract(const Duration(days: 1)), 'yyyy-MM-dd');
      AuthService.userDetails?.beaconClient = BeaconClientModel(refreshExpiryDateTime: pastDateTime);
      expect(AuthService.isUserBeaconConnected(), isFalse);
    });

    test('When beacon client is connected and refreshExpiryDateTime is in the future', () {
      final futureDateTime = DateTimeHelper.format(DateTime.now().add(const Duration(days: 1)), 'yyyy-MM-dd');
      AuthService.userDetails?.beaconClient = BeaconClientModel(refreshExpiryDateTime: futureDateTime);
      expect(AuthService.isUserBeaconConnected(), isTrue);
    });

    test('When beacon client is not connected', () {
      AuthService.userDetails?.beaconClient = null;
      expect(AuthService.isUserBeaconConnected(), isFalse);
    });
  });
}