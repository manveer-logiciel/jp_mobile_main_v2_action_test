import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';

void main() {

  group("SubscriberDetailsModel.fromJson should set [companyName] properly", () {
    test("In case [companyName] is not available", () {
      final subscriberDetails = SubscriberDetailsModel.fromJson({});
      expect(subscriberDetails.companyName, isNull);
    });

    test("In case [companyName] is available but value is null", () {
      final subscriberDetails = SubscriberDetailsModel.fromJson({
        'company_name': null
      });
      expect(subscriberDetails.companyName, isNull);
    });

    test("In case [companyName] is available but value is empty", () {
      final subscriberDetails = SubscriberDetailsModel.fromJson({
        'company_name': ""
      });
      expect(subscriberDetails.companyName, isEmpty);
    });

    test("In case [companyName] is available and has valid value", () {
      final subscriberDetails = SubscriberDetailsModel.fromJson({
        'company_name': 'Test Company'
      });
      expect(subscriberDetails.companyName, 'Test Company');
    });

    test("In case [companyName] is available and has invalid value", () {
      final subscriberDetails = SubscriberDetailsModel.fromJson({
        'company_name': 123
      });
      expect(subscriberDetails.companyName, '123');
    });
  });
}