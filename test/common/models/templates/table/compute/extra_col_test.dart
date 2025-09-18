import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/extra_col.dart';

void main() {
  group("TemplateTableComputeExtraCol.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeExtraCol.fromJson(null);
      expect(result.sign, isNull);
      expect(result.field, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeExtraCol.fromJson({});
      expect(result.sign, isNull);
      expect(result.field, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeExtraCol.fromJson({
        "sign": 1,
        "field": "test"
      });
      expect(result.sign, "1");
      expect(result.field, isNull);
    });

    test("When data is valid, default values should be set", () {
      final result = TemplateTableComputeExtraCol.fromJson({
        "field": 1,
        "sign": "+"
      });
      expect(result.sign, "+");
      expect(result.field, 1);
    });
  });
}