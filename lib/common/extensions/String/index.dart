import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:math_expressions/math_expressions.dart';

extension TrimEnter on String {
  String trim() {
    return this.trim().replaceAll('\n', '').replaceAll('  ', '');
  }

  String digitsOnly() {
    return this.trim().replaceAll(RegExp(r'[^\d.-]'), '');
  }

  double evaluate() {
    ContextModel cm = ContextModel();
    Parser p = Parser();
    Expression exp = p.parse(this);
    double result = exp.evaluate(EvaluationType.REAL, cm);
    return result;
  }

  String removeTrailingZero() {
    String string = this;
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }

  // [TODO] - improving this functions logic
  String roundToDecimalPlaces(int decimalPlaces, {
    bool forceTrim = false
  }) {

    if (forceTrim) {
      // Get the string representation of the number.
      String numberString = toString();

      // Split the string into two parts, the integer part and the decimal part.
      List<String> parts = numberString.split(".");

      if (parts.length <= 1) {
        return numberString;
      }

      // Get the integer part of the number.
      String integerPart = parts[0];

      // Get the decimal part of the number, up to 2 decimal places.
      String decimalPart = ("${parts[1]}00").substring(0, 2);

      // Combine the integer part and the decimal part to get the new number.
      String newNumberString = "$integerPart.$decimalPart";

      // Convert the new number string back to a double.
      double newNumber = double.parse(newNumberString);

      return newNumber.toString();
    } else {
      double number = double.tryParse(toString()) ?? 0.0;

      // Calculate the multiplier to shift the decimal point to the desired position
      double multiplier = 1.0;
      for (int i = 0; i < decimalPlaces; i++) {
        multiplier *= 10;
      }

      // Multiply the number by the multiplier to move the decimal point to the right position
      double roundedNumber = (number * multiplier).round().toDouble();

      // Divide the rounded number by the multiplier to move the decimal point back
      roundedNumber /= multiplier;

      return roundedNumber.toString();
    }
  }

  bool isValidMathExpression() {
    // Regular expression to match valid mathematical and algebraic characters
    final validCharacters = RegExp(RegexExpression.mathExpression);

    // Check if the expression contains only valid characters
    if (!validCharacters.hasMatch(this)) {
      return false;
    }

    // Check for balanced parentheses
    int openParentheses = 0;
    for (String character in split('')) {
      if (character == '(') {
        openParentheses++;
      } else if (character == ')') {
        openParentheses--;
        if (openParentheses < 0) {
          return false; // More closing parentheses than opening ones
        }
      }
    }

    // If there are unclosed parentheses, the expression is invalid
    if (openParentheses != 0) {
      return false;
    }

    // Additional checks can be added here (e.g., valid operator placement)
    try {
      Parser().parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool containsArithmeticOperators() {
    // Define a regular expression pattern to match arithmetic operators
    RegExp regex = RegExp(r'[-+*/%]'); // You can add more operators inside the square brackets

    // Use the hasMatch method to check if the input string contains any arithmetic operators
    return regex.hasMatch(this);
  }

  String removeFirstAndLastBraces() {
    if (isEmpty || !startsWith('(') || !endsWith(')')) {
      // If the string is empty or does not start and end with braces, return the original string
      return this;
    }

    // Remove the first and last characters (braces)
    String stringWithoutFirstAndLastBraces = substring(1, length - 1);
    return stringWithoutFirstAndLastBraces;
  }
}