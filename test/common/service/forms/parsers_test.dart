
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/services/forms/parsers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {

  List<JPMultiSelectModel> tempUserList = [
    JPMultiSelectModel(label: 'User 1', id: '1', isSelect: true),
    JPMultiSelectModel(label: 'User 2', id: '2', isSelect: true),
    JPMultiSelectModel(label: 'User 3', id: '3', isSelect: false),
    JPMultiSelectModel(label: 'User 4', id: '4', isSelect: false),
    JPMultiSelectModel(label: 'User 5', id: '5', isSelect: false),
    JPMultiSelectModel(label: 'User 6', id: '6', isSelect: false),
  ];

  group('FormValueParser@multiSelectToSelectedIds should fetch and return id\'s from multi-select list', () {

    test('When list has selected values', () {
      final result = FormValueParser.multiSelectToSelectedIds(tempUserList);
      expect(result, [1, 2]);
    });

    test('When list has no selected values', () {
      tempUserList[0].isSelect = false;
      tempUserList[1].isSelect = false;
      final result = FormValueParser.multiSelectToSelectedIds(tempUserList);
      expect(result, <int?>[]);
    });

    test('When list is empty', () {
      final result = FormValueParser.multiSelectToSelectedIds([]);
      expect(result, null);
    });

  });

  group('FormValueParser@multiSelectToUserTypeIds should fetch and return user type ids from multi-select list', () {
  test('should return null for empty input list', () {
    final result = FormValueParser.multiSelectToUserTypeIds([]);
    expect(result, null);
  });

  test('should return empty list for list without selected items', () {
    final result = FormValueParser.multiSelectToUserTypeIds([
      JPMultiSelectModel(id: '-1', label: '0', isSelect: false),
    ]);
    expect(result, isEmpty);
  });

  test('should return empty list for list with selected items with invalid ids', () {
    final result = FormValueParser.multiSelectToUserTypeIds([
      JPMultiSelectModel(id: '1', label: '0', isSelect: true),
    ]);
    expect(result, isEmpty);
  });

  test('should return correct list of  selected user type for valid input list', () {
    final result = FormValueParser.multiSelectToUserTypeIds([
      JPMultiSelectModel(id: '-1', label: '1', isSelect: true),
      JPMultiSelectModel(id: '-2', label: '2', isSelect: true),
      JPMultiSelectModel(id: '-3', label: '3', isSelect: false),
    ]);
    expect(result, ['customer_rep', 'estimators']);
  });
});

}