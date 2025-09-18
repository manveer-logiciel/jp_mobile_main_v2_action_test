import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';

void main() {
  group('AppointmentModel.fromJson should parse recurring ID properly', () {
    test("In case recurring ID is not available, it should be null", () {
      final result = AppointmentModel.fromJson({});
      expect(result.recurringId, null);
    });

    test("In case recurring ID is available, it should be parsed", () {
      final result = AppointmentModel.fromJson({
        "recurring_id": 1
      });
      expect(result.recurringId, 1);
    });

    test("In case recurring ID is available with other data type, it should be parsed", () {
      final result = AppointmentModel.fromJson({
        "recurring_id": "1"
      });
      expect(result.recurringId, 1);
    });

    test("In case recurring Id is available but is invalid, it should be null", () {
      final result = AppointmentModel.fromJson({
        "recurring_id": "invalid"
      });
      expect(result.recurringId, null);
    });

    test("In case recurring Id is available but is null, it should be null", () {
      final result = AppointmentModel.fromJson({
        "recurring_id": null
      });
      expect(result.recurringId, null);
    });
  });
}