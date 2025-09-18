
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CustomFormFieldOption {

  late int id;
  late List<JPMultiSelectModel> items;
  late JPInputBoxController controller;
  String? name;
  List<int>? linkedOptions;

  /// [selectedItems] returns list of selected items
  List<JPMultiSelectModel> get selectedItems =>
      FormValueSelectorService.getSelectedMultiSelectValues(items);

  CustomFormFieldOption({
    required this.id,
    this.name,
    this.items = const [],
    required this.controller,
  });

  CustomFormFieldOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    items = [];
    controller = JPInputBoxController();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    List<Map<String, dynamic>> subOptions = [];
    for (var item in selectedItems) {
      subOptions.add({
        "name" : item.label,
        "id" : int.tryParse(item.id),
      });
    }
    if(subOptions.isNotEmpty) {
      data['sub_options'] = subOptions;
    }
    return data;
  }

  /// [fromCustomFieldModel] helps in setting up data in options
  /// and in sub options
  CustomFormFieldOption.fromCustomFieldModel(CustomFieldsModel? data) {
    // if data is null no parsing is required
    if (data == null) return;
    id = data.id ?? 0;
    name = data.name;
    items = [];
    data.subOptions?.forEach((subOption) {
      if (subOption != null) {
        items.add(JPMultiSelectModel(
          label: subOption.name ?? "",
          id: subOption.id.toString(),
          isSelect: true,
          additionData: subOption.linkedParentOptions?.map((e) => e.id).toList(),
        ));
      }
    });
    controller = JPInputBoxController();
  }
}
