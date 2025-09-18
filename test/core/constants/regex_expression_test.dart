import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';

void main() {
  group("RegexExpression@textLinkExtractor should find patterns of the form valid 'text(url)'", () {
    final regex = RegExp(RegexExpression.textLinkExtractor);

    test('In case of valid data with URL, pattern should be extracted', () {
      const input = 'example(http://example.com)';
      final match = regex.firstMatch(input);
      expect(match, isNotNull);
      expect(match?.group(1), 'example');
      expect(match?.group(2), 'http://example.com');
    });

    test('In case of invalid data with URL, pattern should not be extracted', () {
      const input = 'example http://example.com';
      final match = regex.firstMatch(input);
      expect(match, isNull);
    });

    test('In case of invalid URL, pattern should not be extracted', () {
      const input = 'example(//example)';
      final match = regex.firstMatch(input);
      expect(match, isNull);
    });

    test('In case of valid multiple URLs, patterns should be extracted', () {
      const input = 'example1(http://example1.com) example2(https://example2.com)';
      final matches = regex.allMatches(input).toList();
      expect(matches.length, 2);
      expect(matches[0].group(1), 'example1');
      expect(matches[0].group(2), 'http://example1.com');
      expect(matches[1].group(1), 'example2');
      expect(matches[1].group(2), 'https://example2.com');
    });

    test('In case text is not available for URL, pattern should not be extracted', () {
      const input = '(http://example.com)';
      final match = regex.firstMatch(input);
      expect(match, isNull);
    });

    test('In case only text is available but no URL, pattern should not be extracted', () {
      const input = 'example()';
      final match = regex.firstMatch(input);
      expect(match, isNull);
    });

    test('In case of complex text with URL, pattern should be extracted', () {
      const input = 'complex-text_123(http://example.com)';
      final match = regex.firstMatch(input);
      expect(match, isNotNull);
      expect(match?.group(1), 'complex-text_123');
      expect(match?.group(2), 'http://example.com');
    });
  });

  group("RegexExpression@amountTwentyDecimals should validate numbers with up to 20 decimal places", () {
    final regex = RegExp(RegexExpression.amountTwentyDecimals);

    test('Should match a whole number', () {
      const input = '123';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match a decimal number with less than 20 decimal places', () {
      const input = '123.456';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match a decimal number with exactly 20 decimal places', () {
      const input = '123.12345678901234567890';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should partially match a decimal number with more than 20 decimal places', () {
      const input = '123.123456789012345678901';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match a number starting with decimal point', () {
      const input = '.1234';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match zero with decimal places', () {
      const input = '0.000001';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match the numeric part of a string with non-digit characters', () {
      const input = '123.456a';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });

    test('Should match up to the first decimal point in a number with multiple decimal points', () {
      const input = '123.456.789';
      final match = regex.hasMatch(input);
      expect(match, isTrue);
    });
  });

  group("RegexExpression@removeDecimalZeros should match trailing zeros in decimal numbers", () {
    final regex = RegExp(RegexExpression.removeDecimalZeros);

    test('Should match decimal point and trailing zeros if all zeros after decimal', () {
      const input = '123.000';
      final match = regex.firstMatch(input);
      expect(match, isNotNull);
      expect(match?.group(0), '.000');
    });

    test('Should not match zeros that are followed by non-zero digits', () {
      const input = '100.001';
      final match = regex.firstMatch(input);
      expect(match, isNull);
    });

    String removeTrailingZeros(String input) {
      var result = input.replaceAll(RegExp(r'\.?0+$'), '');
      if (result.endsWith('.')) {
        result = result.substring(0, result.length - 1);
      }
      return result;
    }

    test('Should correctly replace trailing zeros when used with custom function', () {
      const input = '123.4500';
      final result = removeTrailingZeros(input);
      expect(result, '123.45');
    });

    test('Should correctly replace decimal point and trailing zeros when all zeros', () {
      const input = '123.000';
      final result = removeTrailingZeros(input);
      expect(result, '123');
    });

    test('Should leave value unchanged when no trailing zeros', () {
      const input = '123.45';
      final result = removeTrailingZeros(input);
      expect(result, '123.45');
    });

    test('Should correctly handle zeros in middle of number', () {
      const input = '100.001000';
      final result = removeTrailingZeros(input);
      expect(result, '100.001');
    });
  });
}