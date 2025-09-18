import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/job/job_count.dart';

void main() {
  group("JobCountModel.fromJson should set correct values", () {
    group("[contacts] count should be set correctly", () {
      test("In case json data is empty, count should be 0", () {
        final result = JobCountModel.fromJson({});
        expect(result.contracts, 0);
      });

      test("In case json data is not empty, count should be set", () {
        final result = JobCountModel.fromJson({"contracts": 1});
        expect(result.contracts, 1);
      });

      test("In case json data is null, count should be 0", () {
        final result = JobCountModel.fromJson({"contracts": null});
        expect(result.contracts, 0);
      });

      test("In case json data is not empty but invalid", () {
        final result = JobCountModel.fromJson({"contracts": "1"});
        expect(result.contracts, 1);
      });
    });
  });
}