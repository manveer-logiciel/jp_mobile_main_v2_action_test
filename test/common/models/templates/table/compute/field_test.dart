import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/field.dart';

void main() {
  group("TemplateTableComputeField.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeField.fromJson(null);
      expect(result.tdIndex, isNull);
      expect(result.heading, isNull);
      expect(result.col, false);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeField.fromJson({});
      expect(result.tdIndex, isNull);
      expect(result.heading, isNull);
      expect(result.col, false);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeField.fromJson({
        "tdIndex": "12",
        "heading": 1
      });
      expect(result.tdIndex, 12);
      expect(result.heading, "1");
      expect(result.col, false);
    });

    test("When data is valid, values should be set from data", () {
      final result = TemplateTableComputeField.fromJson({
        "tdIndex": 1,
        "heading": "test",
        "col": true
      });
      expect(result.tdIndex, 1);
      expect(result.heading, "test");
      expect(result.col, true);
    });
  });
}