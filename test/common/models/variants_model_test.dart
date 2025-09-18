import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/financial_product/variants_model.dart';

void main() {
  group("VariantModel.fromJson should handle all the possibilities of data", () {
    test("Case 1: In case of no data", () {
      final result = VariantModel.fromJson(null);
      expect(result.id, isNull);
      expect(result.branchId, isNull);
      expect(result.branchCode, isNull);
      expect(result.name, isNull);
      expect(result.code, isNull);
      expect(result.unit, isNull);
      expect(result.uom, isNull);
    });

    test("Case 2: In case of empty json", () {
      final result = VariantModel.fromJson(<String, dynamic>{});
      expect(result.id, isNull);
      expect(result.branchId, isNull);
      expect(result.branchCode, isEmpty);
      expect(result.name, isEmpty);
      expect(result.code, isEmpty);
      expect(result.unit, isNull);
      expect(result.uom, isNull);
    });

    test("Case 3: In case of Invalid json values", () {
      final result = VariantModel.fromJson({
        "id": "2",
        "branch_id": "12",
        "branch_code": 12,
        "name": 12,
        "code": 12,
        "uom": <String, dynamic>{}
      });

      expect(result.id, equals(2));
      expect(result.branchId, equals(12));
      expect(result.branchCode, equals("12"));
      expect(result.name, equals("12"));
      expect(result.code, equals("12"));
      expect(result.unit, isNull);
      expect(result.uom, isEmpty);
    });

    test("Case 4: In case of nullable json", () {
      final result = VariantModel.fromJson({
        "id": null,
        "branch_id": null,
        "branch_code": null,
        "name": null,
        "code": null,
        "uom": null
      });

      expect(result.id, isNull);
      expect(result.branchId, isNull);
      expect(result.branchCode, isEmpty);
      expect(result.name, isEmpty);
      expect(result.code, isEmpty);
      expect(result.unit, isNull);
      expect(result.uom, isNull);
    });

    test("Case 5: In case of valid json", () {
      final result = VariantModel.fromJson({
        "id": 2,
        "branch_id": 12,
        "branch_code": "12",
        "name": "12",
        "code": "12",
        "uom": ['LF', 'AC', 'BC']
      });

      expect(result.id, equals(2));
      expect(result.branchId, equals(12));
      expect(result.branchCode, equals("12"));
      expect(result.name, equals("12"));
      expect(result.code, equals("12"));
      expect(result.unit, isNull);
      expect(result.uom, equals(['LF', 'AC', 'BC']));
    });

    test("Case 6: In case of valid json, but uom(Unit of measurement) is a single option", () {
      final result = VariantModel.fromJson({
        "id": 2,
        "branch_id": 12,
        "branch_code": "12",
        "name": "12",
        "code": "12",
        "uom": 'LF'
      });

      expect(result.id, equals(2));
      expect(result.branchId, equals(12));
      expect(result.branchCode, equals("12"));
      expect(result.name, equals("12"));
      expect(result.code, equals("12"));
      expect(result.unit, isNull);
      expect(result.uom, equals(['LF']));
    });
  });

  test('VariantModel.toLimitedJson should convert data to limited json for payload', () {
    final result = VariantModel(
      id: 1,
      branchId: 1,
      branchCode: "BR",
      name: "Name",
      code: "Code",
      unit: "Unit",
      uom: ['LF', 'AC', 'BC']
    );

    expect(result.toLimitedJson(), equals({
      "name": "Name",
      "code": "Code"
    }));
  });
}