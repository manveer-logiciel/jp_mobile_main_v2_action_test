import 'package:easy_mask/easy_mask.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';

class PhoneMasking {

  static MagicMask? mask;
  static String defaultMask = '(999)9999999';
  static String maskedPlaceHolder = "";

  static void setUp() {
    mask = MagicMask.buildMask(getMask());
    maskPhoneNumber("999");
  }

  static String maskPhoneNumber(String number) {

    if(mask == null) setUp();

    if(number.contains('(***) ***-****')){
      return number;
    } else {
      return mask!.getMaskedString(number);
    }
  }

  static unmaskPhoneNumber(String number) {
    if(mask == null) setUp();
    return mask!.clearMask(number);
  }

  static String getMask() {
    final companyPhoneFormat = AuthService.userDetails
        ?.companyDetails?.phoneFormat ?? "";
    defaultMask = companyPhoneFormat.isEmpty ? defaultMask : companyPhoneFormat;
    maskedPlaceHolder = getPlaceHolder();
    return defaultMask;
  }

  static String getPlaceHolder() {
    return defaultMask.replaceAll(RegExp(RegexExpression.removeNumber), "_");
  }

  static TextInputMask inputFieldMask() {
    return TextInputMask(mask: defaultMask, placeholder: defaultMask);
  }
}
