import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/operation.dart';

void main() {
  group("TemplateTableComputeOperation.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeOperation.fromJson(null);
      expect(result.sign, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeOperation.fromJson({});
      expect(result.sign, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeOperation.fromJson({
        "sign": 1
      });
      expect(result.sign, "1");
    });

    test("When data is valid, values should be set from data", () {
      final result = TemplateTableComputeOperation.fromJson({
        "sign": "+"
      });
      expect(result.sign, "+");
    });
  });
}