import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/measurement_type.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_attribute.dart';
import 'package:jobprogress/common/models/forms/measurement/measurement_data.dart';
import 'package:jobprogress/common/models/sheet_line_item/measurement_formula_model.dart';
import 'package:jobprogress/common/models/sheet_line_item/sheet_line_item_model.dart';
import 'package:jobprogress/core/constants/measurement_constant.dart';
import 'package:jobprogress/core/utils/measurement_helper.dart';
import 'package:jp_mobile_flutter_ui/SingleSelect/model.dart';

void main() {
  MeasurementDataModel measurement1 = MeasurementDataModel(
    id: 1,
    attributes: [
      MeasurementAttributeModel(
        id: 1,
        slug: 'name',
      ),
      MeasurementAttributeModel(
        id: 2,
        slug: 'other',
      )
    ]
  );

  MeasurementModel measurementModel = MeasurementModel();

   String wasteFactor = '0.2';

  group('MeasurementHelper@isNameField show check whether given field is name field or not', () {
    test('Should return true when slug is "name"', () {
      bool result = MeasurementHelper.isNameField(slug: 'name');
      expect(result, true);
    });

    test('Should return true when slug is "trade_id_{measurementId}_slug_name"', () {
      bool result = MeasurementHelper.isNameField(measurementId: 1, slug: 'trade_id_1_slug_name');
      expect(result, true);
    });

    test('Should return false when slug is any other than "trade_id_{measurementId}_slug_name" or "name"', () {
      bool result = MeasurementHelper.isNameField(slug: 'other_slug');
      expect(result, false);
    });
  });

  group('MeasurementHelper@getAttributeHintText should return correct hint text', () {

    test('when field is a name field', () {
      final hintText = MeasurementHelper.getAttributeHintText(measurement: measurement1, index: 0);
      expect(hintText, equals('name'));
    });

    test('when field is not a name field', () {
      final hintText = MeasurementHelper.getAttributeHintText(measurement: measurement1, index: 1);
      expect(hintText, equals('0.0'));
    });
  });

  group('MeasurementHelper@getAttributeKeyBoardType should return correct keyboard type', () {

    test('when field is not a name field', () {
      final result = MeasurementHelper.getAttributeKeyBoardType(measurement: measurement1, index: 1);
      expect(result, equals(const TextInputType.numberWithOptions(decimal: true)));
    });

    test('when field is a name field', () {
      final result = MeasurementHelper.getAttributeKeyBoardType(measurement: measurement1, index: 0);
      expect(result, equals(TextInputType.text));
    });
  });

  group('Measurement@formulaUnnormalization should return correct formula after unnormalization', () {
    test('should returns empty string when input is empty', () {
      expect(MeasurementHelper.formulaUnnormalization('', false), '');
    });

    test('should adds spaces around mathematical operators', () {
      expect(MeasurementHelper.formulaUnnormalization('a+b', false), ' a + b ');
      expect(MeasurementHelper.formulaUnnormalization('a-b', false), ' a - b ');
      expect(MeasurementHelper.formulaUnnormalization('a*b', false), ' a * b ');
      expect(MeasurementHelper.formulaUnnormalization('a/b', false), ' a / b ');
      expect(MeasurementHelper.formulaUnnormalization('a\\b', false), ' a \\ b ');
      expect(MeasurementHelper.formulaUnnormalization('a(b)', false), ' a ( b )  ');
    });

    test('should adds escaped prefix and spaces around mathematical operators when forRegex is true', () {
      expect(MeasurementHelper.formulaUnnormalization('a+b', true), ' a \\+ b ');
      expect(MeasurementHelper.formulaUnnormalization('a-b', true), ' a \\- b ');
      expect(MeasurementHelper.formulaUnnormalization('a*b', true), ' a \\* b ');
      expect(MeasurementHelper.formulaUnnormalization('a/b', true), ' a \\/ b ');
      expect(MeasurementHelper.formulaUnnormalization('a\\b', true), ' a \\\\ b ');
      expect(MeasurementHelper.formulaUnnormalization('a(b)', true), ' a \\( b \\)  ');
    });

    test('should handles mixed content correctly', () {
      expect(MeasurementHelper.formulaUnnormalization('a+b*c/d-e(f)', false), ' a + b * c / d - e ( f )  ');
      expect(MeasurementHelper.formulaUnnormalization('a+b*c/d-e(f)', true), ' a \\+ b \\* c \\/ d \\- e \\( f \\)  ');
    });

    test('does not affect non-operator characters when forRegex is true', () {
      expect(MeasurementHelper.formulaUnnormalization('abc', true), ' abc ');
    });

    test('should handles strings containing only operators', () {
      expect(MeasurementHelper.formulaUnnormalization('+-*/', false), '  +  -  *  /  ');
      expect(MeasurementHelper.formulaUnnormalization('+-*/', true), '  \\+  \\-  \\*  \\/  ');
    });

    test('should handles multiple consecutive operators correctly', () {
      expect(MeasurementHelper.formulaUnnormalization('a++b', false), ' a +  + b ');
      expect(MeasurementHelper.formulaUnnormalization('a--b', false), ' a -  - b ');
      expect(MeasurementHelper.formulaUnnormalization('a**b', false), ' a *  * b ');
      expect(MeasurementHelper.formulaUnnormalization('a//b', false), ' a /  / b ');
    });

    test('should handles long formulas', () {
      String longFormula = 'a+b-c*d/e+f-g*h/i+j-k*l/m+n-o*p/q+r-s*t/u+v-w*x/y+z';
      expect(MeasurementHelper.formulaUnnormalization(longFormula, false), 
        ' a + b - c * d / e + f - g * h / i + j - k * l / m + n - o * p / q + r - s * t / u + v - w * x / y + z ');
    });

    test('should handles numeric values', () {
      expect(MeasurementHelper.formulaUnnormalization('1+2-3*4/5', false), ' 1 + 2 - 3 * 4 / 5 ');
    });
  });

  group('MeasurementHelper@getWasteFactorAttributeId', () {

    group('When measurement type is hover', () {
      setUpAll(() {
        measurementModel.type = MeasurementType.hover.name;
      });

      group('Measurement list is not empty', () {
        setUpAll(() {
          measurementModel.measurements = [
            MeasurementDataModel()
          ];
        });

        group('Measurement name is roofing', () {
          setUpAll(() {
            measurementModel.measurements?[0].name = MeasurementConstant.roofing;
          });

          group('Measurement values are not empty', () {
            setUpAll(() {
              measurementModel.measurements?[0].values = [[
                MeasurementAttributeModel(id: 1)
              ]];
            });

            test('Third party attribute edit is enabled', () {
              measurementModel.measurements?[0].values?[0][0].thirdPartyAttributeEditable = true;
              expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), 1);
            });

            test('Third party attribute edit is not enabled', () {
              measurementModel.measurements?[0].values?[0][0].thirdPartyAttributeEditable = false;
              expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), isNull);
            });

          });

          test('Measurement values are empty', () {
            measurementModel.measurements?[0].values = [];
            expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), isNull);
          });
        });

        test('Measurement name is not roofing', () {
          measurementModel.measurements?[0].name = '';
          expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), isNull);
        });
      });

      test('Measurement list is empty', () {
        measurementModel.measurements = [];
        expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), isNull);
      });
    });

    test('When measurement type is not hover', () {
      measurementModel.type = MeasurementType.eagleView.name;
      expect(MeasurementHelper.getWasteFactorAttributeId(measurementModel), isNull);
    });
  });

  group('MeasurementHelper@setHoverWasteFactor', () {

    test('Should set wasteFactor when conditions are met', () {
      final attribute = MeasurementAttributeModel(value: null, thirdPartyAttributeEditable: true);
      final measurement = MeasurementDataModel(
        name: MeasurementConstant.roofing,
        attributes: [attribute],
      );
      measurementModel.type = MeasurementType.hover.name;
      measurementModel.measurements = [measurement];

      MeasurementHelper.setHoverWasteFactor(wasteFactor, measurementModel);

      expect(attribute.value, wasteFactor);
    });

    test('Should not set wasteFactor when measurement type is not hover', () {
      final attribute = MeasurementAttributeModel(value: null, thirdPartyAttributeEditable: true);
      final measurement = MeasurementDataModel(
        name: MeasurementConstant.roofing,
        attributes: [attribute],
      );
      measurementModel.type = '';
      measurementModel.measurements = [measurement];

      MeasurementHelper.setHoverWasteFactor(wasteFactor, measurementModel);

      expect(attribute.value, isNull);
    });

    test('Should not set wasteFactor when measurement name is not roofing', () {
      final attribute = MeasurementAttributeModel(value: null, thirdPartyAttributeEditable: true);
      final measurement = MeasurementDataModel(
        name: 'non-roofing',
        attributes: [attribute],
      );
      measurementModel.type = '';
      measurementModel.measurements = [measurement];

      MeasurementHelper.setHoverWasteFactor(wasteFactor, measurementModel);

      expect(attribute.value, isNull);
    });

    test('Should not set wasteFactor when thirdPartyAttributeEditable is false', () {
      final attribute = MeasurementAttributeModel(value: null, thirdPartyAttributeEditable: false);
      final measurement = MeasurementDataModel(
        name: MeasurementConstant.roofing,
        attributes: [attribute],
      );
      measurementModel.type = '';
      measurementModel.measurements = [measurement];

      MeasurementHelper.setHoverWasteFactor(wasteFactor, measurementModel);

      expect(attribute.value, isNull);
    });
  });

  group('MeasurementHelper.getProductQuantity helps to calculate the quantity when formula is applied', () {
    late MeasurementModel measurement;
    late SheetLineItemModel item;

    setUp(() {
      measurement = MeasurementModel();
      item = SheetLineItemModel(
        productId: '1',
        title: 'Test Item',
        price: '100',
        totalPrice: '100',
        tradeType: JPSingleSelectModel(id: "1", label: 'ROOFING'),
        formula: '',
        qty: '10',
      );
    });

    test('Should give the item qty when formula is empty', () {
      expect(MeasurementHelper.getProductQuantity(measurement, item), '10');
    });

    test('Quantity should be calculated from Measurement Attributes', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 1,
          attributes: [
            MeasurementAttributeModel(slug: 'length', value: "10"),
            MeasurementAttributeModel(slug: 'width', value: "5"),
          ],
        ),
      ];
      item.formula = 'length*width';
      item.qty = '0';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '50.0');
    });

    test('Quantity should be 0 when formula is invalid', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 1,
          attributes: [
            MeasurementAttributeModel(slug: 'length', value: "10"),
          ],
        ),
      ];
      item.formula = 'length/'; // Invalid formula

      expect(MeasurementHelper.getProductQuantity(measurement, item), '0');
    });

    test('Quantity should be calculated from sub attributes', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 1,
          attributes: [
            MeasurementAttributeModel(
              slug: 'parent',
              subAttributes: [
                MeasurementAttributeModel(slug: 'child1', value: "10"),
                MeasurementAttributeModel(slug: 'child2', value: "5"),
              ],
            ),
          ],
        ),
      ];
      item.formula = 'parent_child1*parent_child2';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '50.0');
    });

    test('Quantity should be 0 when measurement ID does not match trade type ID', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 2, // Different from trade type ID
          attributes: [
            MeasurementAttributeModel(slug: 'length', value: "10"),
          ],
        ),
      ];
      item.formula = 'length*10';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '10');
    });

    test('Quantity should be calculated for complex mathematical expressions', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 1,
          attributes: [
            MeasurementAttributeModel(slug: 'a', value: "10"),
            MeasurementAttributeModel(slug: 'b', value: "5"),
            MeasurementAttributeModel(slug: 'c', value: "2"),
          ],
        ),
      ];
      item.formula = '(a+b)*c/2';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '15.0');
    });

    test('Attributes missing values should be handled properly', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 1,
          attributes: [
            MeasurementAttributeModel(slug: 'length', value: null),
            MeasurementAttributeModel(slug: 'width', value: "5"),
          ],
        ),
      ];
      item.formula = 'length*width';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '0.0');
    });

    test('In case measurement is empty, existing quantity should be preserved', () {
      measurement.measurements = [];
      item.formula = 'length*width';
      item.qty = '20';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '20');
    });

    test('In case measurement is not available, exiting quantity should be preserved', () {
      measurement.measurements = null;
      item.formula = 'length*width';
      item.qty = '30';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '30');
    });

    test('Quantity should be calculated for complex plumbing vent formula', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 8,
          attributes: [
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_2in_plumbing_vent_pipe_slug_eaves',
              value: "20",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_2in_plumbing_vent_pipe_slug_valleys',
              value: "3",
            ),
            MeasurementAttributeModel(
              slug: 'trade_id_8_slug_bathroom_exhaust',
              value: "10",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_2in_plumbing_vent_pipe',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_3in_plumbing_vent_pipe',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_4in_plumbing_vent_pipe',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_4in_plumbing_vent_boot_kit',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_3_in_1_pipe_flashings',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug: 'trade_id_8_slug_skylights',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug: 'trade_id_8_slug_solar_skylights',
              value: "1",
            ),
            MeasurementAttributeModel(
              slug: 'trade_id_8_slug_new_crickets_needed',
              value: "1",
            ),
          ],
        ),
      ];
      item.tradeType = JPSingleSelectModel(id: "8", label: 'ROOFING');
      item.formula =
      '(((parent_slug_trade_id_8_slug_2in_plumbing_vent_pipe_slug_eaves+parent_slug_trade_id_8_slug_2in_plumbing_vent_pipe_slug_valleys)+(trade_id_8_slug_bathroom_exhaust*10)+((parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_2in_plumbing_vent_pipe+parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_3in_plumbing_vent_pipe+parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_4in_plumbing_vent_pipe+parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_4in_plumbing_vent_boot_kit+parent_slug_trade_id_8_slug_3in_plumbing_vent_pipe_slug_3_in_1_pipe_flashings)*3)+(trade_id_8_slug_skylights+trade_id_8_slug_solar_skylights+trade_id_8_slug_new_crickets_needed)*12)/66.7)*1.1';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '2.87');
    });

    test('Quantity should be calculated for complex chimney formula', () {
      measurement.measurements = [
        MeasurementDataModel(
          id: 8,
          attributes: [
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_half_chimney_slug_nonwalkable_(between_8_and_12_pitch',
              value: "10",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_half_chimney_slug_steep_(above_12_pitch',
              value: "50",
            ),
            MeasurementAttributeModel(
              slug:
              'parent_slug_trade_id_8_slug_half_chimney_slug_very_steep_(above_12_pitch',
              value: "30",
            ),
          ],
        ),
      ];
      item.tradeType = JPSingleSelectModel(id: "8", label: 'ROOFING');
      item.formula =
      '((parent_slug_trade_id_8_slug_half_chimney_slug_nonwalkable_(between_8_and_12_pitch+parent_slug_trade_id_8_slug_half_chimney_slug_steep_(above_12_pitch+parent_slug_trade_id_8_slug_half_chimney_slug_very_steep_(above_12_pitch))/9.5';

      expect(MeasurementHelper.getProductQuantity(measurement, item), '9.47');
    });
  });

  group('MeasurementHelper.findFormulaByTradeId finds the correct formula based on trade ID', () {
    test('Should return null when formulas list is empty', () {
      expect(MeasurementHelper.findFormulaByTradeId([], '1'), isNull);
    });

    test('Should return null when tradeId is empty', () {
      final formulas = [
        MeasurementFormulaModel(id: 1, productId: 1, tradeId: 1, formula: 'L*W')
      ];
      expect(MeasurementHelper.findFormulaByTradeId(formulas, ''), isNull);
    });

    test('Should return matching formula when trade ID exists', () {
      final formulas = [
        MeasurementFormulaModel(
            id: 1, productId: 1, tradeId: 1, formula: 'L*W'),
        MeasurementFormulaModel(
            id: 2, productId: 2, tradeId: 2, formula: 'L*W*H')
      ];
      expect(MeasurementHelper.findFormulaByTradeId(formulas, '2'),
          equals('L*W*H'));
    });

    test('Should handle string and integer trade IDs correctly', () {
      final formulas = [
        MeasurementFormulaModel(id: 1, productId: 1, tradeId: 1, formula: 'L*W')
      ];
      expect(
          MeasurementHelper.findFormulaByTradeId(formulas, '1'), equals('L*W'));
      expect(MeasurementHelper.findFormulaByTradeId(formulas, 1.toString()),
          equals('L*W'));
    });

    test('Should return null when no matching trade ID is found', () {
      final formulas = [
        MeasurementFormulaModel(id: 1, productId: 1, tradeId: 1, formula: 'L*W')
      ];
      expect(MeasurementHelper.findFormulaByTradeId(formulas, '2'), isNull);
    });
  });

  group('MeasurementHelper.setFormulaToItem assigns the correct formula to line items based on trade type', () {
    test('Should not set formula when trade type is null', () {
      final item = SheetLineItemModel(
          productId: '1',
          title: 'Test',
          price: '10',
          qty: '1',
          totalPrice: '10',
          measurementFormulas: [
            MeasurementFormulaModel(
                id: 1, productId: 1, tradeId: 1, formula: 'L*W')
          ]);
      MeasurementHelper.setFormulaToItem(item);
      expect(item.formula, isNull);
    });

    test('Should not set formula when measurement formulas are empty', () {
      final item = SheetLineItemModel(
          productId: '1',
          title: 'Test',
          price: '10',
          qty: '1',
          totalPrice: '10',
          tradeType: JPSingleSelectModel(id: '1', label: 'Trade 1'),
          measurementFormulas: []);
      MeasurementHelper.setFormulaToItem(item);
      expect(item.formula, isNull);
    });

    test('Should set matching formula when trade type and formulas exist', () {
      final item = SheetLineItemModel(
          productId: '1',
          title: 'Test',
          price: '10',
          qty: '1',
          totalPrice: '10',
          tradeType: JPSingleSelectModel(id: '1', label: 'Trade 1'),
          measurementFormulas: [
            MeasurementFormulaModel(
                id: 1, productId: 1, tradeId: 1, formula: 'L*W'),
            MeasurementFormulaModel(
                id: 2, productId: 2, tradeId: 2, formula: 'L*W*H')
          ]);
      MeasurementHelper.setFormulaToItem(item);
      expect(item.formula, equals('L*W'));
    });

    test('Should not set formula when no matching trade ID is found', () {
      final item = SheetLineItemModel(
          productId: '1',
          title: 'Test',
          price: '10',
          qty: '1',
          totalPrice: '10',
          tradeType: JPSingleSelectModel(id: '3', label: 'Trade 3'),
          measurementFormulas: [
            MeasurementFormulaModel(
                id: 1, productId: 1, tradeId: 1, formula: 'L*W'),
            MeasurementFormulaModel(
                id: 2, productId: 2, tradeId: 2, formula: 'L*W*H')
          ]);
      MeasurementHelper.setFormulaToItem(item);
      expect(item.formula, isNull);
    });
  });
}

 
