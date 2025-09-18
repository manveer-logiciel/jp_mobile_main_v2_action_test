import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/result.dart';

void main() {
  group("TemplateTableComputeResult.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeResult.fromJson(null);
      expect(result.compute, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeResult.fromJson({});
      expect(result.compute, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeResult.fromJson({
        "compute": "1"
      });
      expect(result.compute, 1);
    });

    test("When data is valid, values should be set from data", () {
      final result = TemplateTableComputeResult.fromJson({
        "compute": 1
      });
      expect(result.compute, 1);
    });
  });
}