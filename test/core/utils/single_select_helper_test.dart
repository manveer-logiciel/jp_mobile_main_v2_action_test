import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

void main() {
  test('SingleSelectHelper is selected lable according to id in given list,', () {
    List<JPSingleSelectModel> list = [JPSingleSelectModel(label: 'label', id: '1'), JPSingleSelectModel(label: 'label 2', id: '2')];
    String selected = list[0].id;
    final selecteValue = SingleSelectHelper.getSelectedSingleSelectValue(list, selected);
    expect(selecteValue, list[0].label);
  });
}
