import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/field.dart';
import 'package:jobprogress/common/models/templates/table/compute/fields.dart';
import 'package:jobprogress/common/models/templates/table/compute/result.dart';

void main() {
  group("TemplateTableComputeFields.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeFields.fromJson(null);
      expect(result.first, isNull);
      expect(result.second, isNull);
      expect(result.result, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeFields.fromJson({});
      expect(result.first, isNull);
      expect(result.second, isNull);
      expect(result.result, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeFields.fromJson({
        "first": "12",
        "second": 1
      });
      expect(result.first, isNull);
      expect(result.second, isNull);
      expect(result.result, isNull);
    });

    test("When data is valid, values should be set from data", () {
      final result = TemplateTableComputeFields.fromJson({
        "first": {
          "tdIndex": 1,
          "heading": "test",
          "col": true
        },
        "second": {
          "tdIndex": 1,
          "heading": "test",
          "col": true
        },
        "result": {
          "compute": 1
        }
      });
      expect(result.first, isA<TemplateTableComputeField>());
      expect(result.second, isA<TemplateTableComputeField>());
      expect(result.result, isA<TemplateTableComputeResult>());
    });
  });
}