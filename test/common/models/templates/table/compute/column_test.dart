import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/templates/table/compute/column.dart';
import 'package:jobprogress/common/models/templates/table/compute/details.dart';
import 'package:jobprogress/common/models/templates/table/compute/extra_col.dart';
import 'package:jobprogress/common/models/templates/table/compute/field.dart';
import 'package:jobprogress/common/models/templates/table/compute/fields.dart';
import 'package:jobprogress/common/models/templates/table/compute/operation.dart';

void main() {

  TemplateTableComputeCol computeColumnModel = TemplateTableComputeCol.fromJson(null);

  final tempJson = {
    'compute': 1,
    'computeDetail': {
      'fields': [
        {
          'tdIndex': 1
        },
        {
          'tdIndex': 2
        }
      ]
    },
  };

  void setupData() {
    computeColumnModel = TemplateTableComputeCol(
        computeDetail: TemplateTableComputeDetail(
          operation: TemplateTableComputeOperation(
              sign: "+"
          ),
          fields: TemplateTableComputeFields(
            first: TemplateTableComputeField(tdIndex: 1),
            second: TemplateTableComputeField(tdIndex: 3),
          ),
        ),
        compute: 1
    );
    computeColumnModel.extraCols = [
      TemplateTableComputeExtraCol(sign: '+', field: 6),
      TemplateTableComputeExtraCol(sign: '-', field: 8),
    ];
  }

  group("TemplateTableComputeCol.fromJson should handle all the possibilities of data", () {
    test("When data in null, default values should be set", () {
      final result = TemplateTableComputeCol.fromJson(null);

      expect(result.compute, isNull);
      expect(result.computeDetail, isNull);
      expect(result.extraCols, isNull);
    });

    test("When data is empty, default values should be set", () {
      final result = TemplateTableComputeCol.fromJson({});

      expect(result.compute, isNull);
      expect(result.computeDetail, isNull);
      expect(result.extraCols, isNull);
    });

    test("When data is invalid, default values should be set", () {
      final result = TemplateTableComputeCol.fromJson({
        'compute': 'test',
        'computeDetail': 'test',
        'extraCols': 'test'
      });

      expect(result.compute, isNull);
      expect(result.computeDetail, isNull);
      expect(result.extraCols, isNull);
    });

    test("When data is valid, values from data should be set", () {
      final result = TemplateTableComputeCol.fromJson(tempJson);

      expect(result.compute, 1);
      expect(result.computeDetail, isNotNull);
      expect(result.extraCols, isNull);
    });
  });

  group("TemplateTableComputeCol@setExtraCols should populate extra columns for computing", () {
    test("When extra columns list is empty, extra columns should be empty", () {
      computeColumnModel.setExtraCols([]);
      expect(computeColumnModel.extraCols, isNotNull);
      expect(computeColumnModel.extraCols, isEmpty);
    });

    test("When extra columns list is not empty, extra columns should be populated", () {
      computeColumnModel.setExtraCols([
        {"sign": "+", "field": 3},
        {"sign": "-", "field": 5}
      ]);
      expect(computeColumnModel.extraCols, hasLength(2));
      expect(computeColumnModel.extraCols![0].sign, equals('+'));
      expect(computeColumnModel.extraCols![0].field, equals(3));
      expect(computeColumnModel.extraCols![1].sign, equals('-'));
      expect(computeColumnModel.extraCols![1].field, equals(5));
    });

    test('When extra columns list is null, extra columns should be populated', () {
      // Start with extraCols being null
      computeColumnModel.extraCols = null;
      List<dynamic> sampleJson = [
        {"sign": "*", "field": 4}
      ];
      computeColumnModel.setExtraCols(sampleJson);
      expect(computeColumnModel.extraCols, isNotNull);
      expect(computeColumnModel.extraCols, hasLength(1));
      expect(computeColumnModel.extraCols![0].sign, equals('*'));
      expect(computeColumnModel.extraCols![0].field, equals(4));
    });
  });

  group("TemplateTableComputeCol@checkIfComputeColumn should check if a given cell falls under compute cell", () {
    setUp(() {
      setupData();
    });

    test('Field in compute details should be identified for compute cell', () {
      expect(computeColumnModel.checkIfComputeColumn(1), isTrue);
      expect(computeColumnModel.checkIfComputeColumn(3), isTrue);
    });

    test('Field in Extra Column should be identified for compute cell', () {
      expect(computeColumnModel.checkIfComputeColumn(6), isTrue);
      expect(computeColumnModel.checkIfComputeColumn(8), isTrue);
    });

    test('Field that not fall under compute cell should not be identified', () {
      expect(computeColumnModel.checkIfComputeColumn(0), isFalse);
      expect(computeColumnModel.checkIfComputeColumn(2), isFalse);
    });
  });

  group("TemplateTableComputeCol@getComputeOperation", () {
    setUp(() {
      setupData();
    });

    test("When compute details are not available operation list should not be set", () {
      computeColumnModel.computeDetail = null;
      expect(computeColumnModel.getComputeOperation(), <dynamic>[]);
    });

    test("When compute details with extra columns are available operation list should be set", () {
      final operation = computeColumnModel.getComputeOperation();
      expect(operation, [1, '+', 3, '+', 6, '-', 8]);
    });

    test("When compute details without extra columns are available operation list should be set for compute details only", () {
      computeColumnModel.extraCols = [];
      final operation = computeColumnModel.getComputeOperation();
      expect(operation, [1, '+', 3]);
    });
  });
}