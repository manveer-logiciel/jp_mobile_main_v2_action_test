
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/extensions/String/index.dart';

void main() {

  group('String@isValidMathExpression should validate is the given string is a valid math expression', () {
    test('Valid Math Expression', () {
      expect("2+3*5".isValidMathExpression(), isTrue);
    });

    test('Invalid Math Expression', () {
      expect("2+3*".isValidMathExpression(), isFalse);
    });
    test('Invalid Math Expression', () {
      expect("+parent_slug_trade_id_104_slug_roofline_slug_3".isValidMathExpression(), isFalse);
    });
  });

  group('String@containsArithmeticOperators should validate is the given string contains arithmetic operator', () {
    test('Contains Arithmetic Operators', () {
      expect("2+3*5".containsArithmeticOperators(), isTrue);
    });

    test('Does Not Contain Arithmetic Operators', () {
      expect("234567".containsArithmeticOperators(), isFalse);
    });
  });

  group('String@removeFirstAndLastBraces() should remove first and last braces from a given string', () {
    test('Remove First and Last Braces', () {
      expect("(2+3*5)".removeFirstAndLastBraces(), equals("2+3*5"));
    });

    test('String Without Braces', () {
      expect("2+3*5".removeFirstAndLastBraces(), equals("2+3*5"));
    });

    test('Empty String', () {
      expect("".removeFirstAndLastBraces(), equals(""));
    });

    test('String Without First Brace', () {
      expect("2+3*5)".removeFirstAndLastBraces(), equals("2+3*5)"));
    });

    test('String Without Last Brace', () {
      expect("(2+3*5".removeFirstAndLastBraces(), equals("(2+3*5"));
    });
  });
}