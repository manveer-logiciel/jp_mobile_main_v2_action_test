import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/firebase/firestore/chat_group.dart';

void main() {
  group("ChatGroupModel.fromApiJson should parse phone number properly", () {
    test("In case data is not available phone number should be empty", () {
      final result = ChatGroupModel.fromApiJson({});
      expect(result.phoneNumber, isEmpty);
    });

    test("In case null data is available phone number should be empty", () {
      final result = ChatGroupModel.fromApiJson({
        "phone_number": null
      });
      expect(result.phoneNumber, isEmpty);
    });

    test("In case data is available phone number should be parsed", () {
      final result = ChatGroupModel.fromApiJson({
        "phone_number": "1234567890"
      });
      expect(result.phoneNumber, equals("1234567890"));
    });

    test("In case phone number has country code it, should be parsed", () {
      final result = ChatGroupModel.fromApiJson({
        "phone_number": "+1234567890"
      });
      expect(result.phoneNumber, equals("234567890"));
    });
  });
}