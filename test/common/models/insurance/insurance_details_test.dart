import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';

void main() {

  final tempInsuranceDetails = InsuranceModel();

  group("InsuranceModel@toJson should unmask phone number before preparing api payload", () {
    test("Valid masked phone number be unmasked", () {
      tempInsuranceDetails.phone = "(123)4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['phone'], '1234567890');
    });

    test("Invalid masked phone number not be unmasked", () {
      tempInsuranceDetails.phone = "(-123)#4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['phone'], '-123#4567890');
    });

    test("Empty phone number case should be handled", () {
      tempInsuranceDetails.phone = "";
      final result = tempInsuranceDetails.toJson();
      expect(result['phone'], '');
    });

    test("In case phone number is null, phone number should be empty", () {
      tempInsuranceDetails.phone = null;
      final result = tempInsuranceDetails.toJson();
      expect(result['phone'], '');
    });

    test("Valid masked fax number be unmasked", () {
      tempInsuranceDetails.fax = "(123)4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['fax'], '1234567890');
    });

    test("Invalid masked fax number not be unmasked", () {
      tempInsuranceDetails.fax = "(-123)#4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['fax'], '-123#4567890');
    });

    test("Empty fax number case should be handled", () {
      tempInsuranceDetails.fax = "";
      final result = tempInsuranceDetails.toJson();
      expect(result['fax'], '');
    });

    test("In case fax number is null, phone number should be empty", () {
      tempInsuranceDetails.phone = null;
      final result = tempInsuranceDetails.toJson();
      expect(result['fax'], '');
    });

    test("Valid masked adjuster number be unmasked", () {
      tempInsuranceDetails.adjusterPhone = "(123)4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['adjuster_phone'], '1234567890');
    });

    test("Invalid masked adjuster number not be unmasked", () {
      tempInsuranceDetails.adjusterPhone = "(-123)#4567890";
      final result = tempInsuranceDetails.toJson();
      expect(result['adjuster_phone'], '-123#4567890');
    });

    test("Empty adjuster number case should be handled", () {
      tempInsuranceDetails.adjusterPhone = "";
      final result = tempInsuranceDetails.toJson();
      expect(result['adjuster_phone'], '');
    });

    test("In case adjuster number is null, phone number should be empty", () {
      tempInsuranceDetails.adjusterPhone = null;
      final result = tempInsuranceDetails.toJson();
      expect(result['adjuster_phone'], '');
    });
  });
}