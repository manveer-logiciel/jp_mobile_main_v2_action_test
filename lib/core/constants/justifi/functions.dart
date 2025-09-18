class JustifiFunctionConstants {
  static String setContent(bool isCardForm) => 'setContent($isCardForm)';
  static String unFocus = 'unFocus()';
  static String validateAndTokenize(bool isCardForm, bool isOtherFieldsValid, {
    required String data,
    bool doTokenize = true
  }) => 'validateAndTokenize($isCardForm, $isOtherFieldsValid, $data, $doTokenize)';
}