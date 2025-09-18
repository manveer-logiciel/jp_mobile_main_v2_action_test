
import 'package:get/get.dart';

class EmailHelpers {

  static String getEmailToName(List<String> val) {
    String firstName = '';
    String secondLastName = '';
    String lastName = '';

    if (val.isNotEmpty) {
      firstName = val.first;
      firstName = filterString(firstName);

      if (val.length > 2) {
        secondLastName = val[val.length - 2];
        secondLastName = filterString(secondLastName);
      }
      if (val.isNotEmpty) {
        lastName = val.last;
        lastName = filterString(lastName);
      }
    }

    if (secondLastName.isNotEmpty && lastName.isNotEmpty) {
      return 'To: ' '$firstName '.capitalize.toString() + '... ' '$secondLastName'.capitalize.toString() + ', ' '$lastName'.capitalize.toString();
    } else if (secondLastName.isNotEmpty) {
      return 'To: ' '$firstName' ', ' '$secondLastName';
    } else {
      return 'To: $firstName';
    }
  }

  static String filterString(String value) {
    int index = value.indexOf('@');
    if (index > -1) {
      final exp = RegExp('/[-_.]+/g');
      value = value.substring(0, index).replaceAll(exp, "");
    }
    return value.replaceAll(RegExp('\\.'), ' ');
  }

}