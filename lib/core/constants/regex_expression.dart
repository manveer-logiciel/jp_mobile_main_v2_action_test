class RegexExpression {
  static const String amount = r'^\d*\.?\d{0,2}';
  static const String amountThreeDecimals = r'^\d*\.?\d{0,3}';
  static const String price = r'^-?\d*\.?\d{0,2}';
  static const String removeNumber = '[0-9]';
  static const String alphabet = "([a-z_])";
  static const String removeCharacters = '[a-z]';
  // converts R1C2 + R3C1 -> [ (0, 1), (2, 0)]
  static const String rowColumnToIndex = r'R(\d+)C(\d+)(?: ([+\-*/])|$)';
  static const String alphaNumeric = '[a-zA-Z0-9]';
  static const String caseSensitiveCharacters = r'[^/-/a-zA-Z]+';
  static const String caseSensitive = r'[a-zA-Z]+';
  static const String removeSpecialCharacters = r'[^0-9a-zA-Z]+';
  static const String textLinkExtractor = r'(\b[^\s]+)\((https?://[^\s]+)\)';
  static const String userMention = r'@\[([a-zA-Z0-9]+?):([^@[\]]+?)\]';
  static const String urlExtractor =  r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%.,_\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\,+.~#?&//=]*)";
  static const String mathExpression = r'^\s*[\d\w_()\.]+(\s*[+\-*/]\s*[\d\w_()\.]+)*\s*$';
  static const String amountTwentyDecimals = r'^\d*\.?\d{0,20}';
  static const String removeDecimalZeros = r'(?<=\d)\.0+$';
  static const String cookieExpirationTime = r'CloudFront-Expiration-Time=(\d+)';
}