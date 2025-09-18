import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/details.dart';

void main() {
  
  group("TemplateTableComputeDetail.fromJson should handle all possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeDetail.fromJson(null);
      expect(result.operation, isNull);
      expect(result.fields, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeDetail.fromJson({});
      expect(result.operation, isNull);
      expect(result.fields, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeDetail.fromJson({
        "operation": "test",
        "fields": "test"
      });
      expect(result.operation, isNull);
      expect(result.fields, isNull);
    });

    test("When data is valid, default values should be set", () {
      final result = TemplateTableComputeDetail.fromJson({
        "operation": {
          "sign": "+"
        },
        "fields": {
          "first": {
            "tdIndex": 1
          },
          "second": {
            "tdIndex": 3
          }
        }
      });
      expect(result.operation?.sign, "+");
      expect(result.fields?.first?.tdIndex, 1);
      expect(result.fields?.second?.tdIndex, 3);
    });
  });
}