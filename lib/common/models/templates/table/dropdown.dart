import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TemplateTableDropdownModel {
  bool? isDropdown;
  String? selectedText;
  String? selectedOptionId;
  List<JPSingleSelectModel>? options;

  TemplateTableDropdownModel({
    this.isDropdown,
    this.options,
    this.selectedText,
    this.selectedOptionId,
  });

  TemplateTableDropdownModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    isDropdown = json['isDropdown'];

    if (json['options'] != null) {
      options = [];
      json['options'].forEach((dynamic val) {
        options!.add(toSingleSelect(val));
      });
    }

    selectedText = json['selectedText'];
    selectedOptionId = options?.indexWhere((option) => option.label == selectedText).toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDropdown'] = isDropdown;
    data['options'] = options;
    data['selectedText'] = selectedText;
    return data;
  }

  JPSingleSelectModel toSingleSelect(String val) {
    return JPSingleSelectModel(
      label: val,
      id: options!.length.toString(),
    );
  }

  void setDataFromSingleSelect(List<JPSingleSelectModel> list, JPSingleSelectModel data) {
    options = list;
    selectedText = data.label;
    selectedOptionId = data.id;
  }

  List<String> toOptionsString() {
    List<String> allOptions = options?.map((option) => option.label).toList() ?? [];
    return allOptions;
  }

  @override
  String toString() {
    Map<String, dynamic> json = {
      "isDropdown": isDropdown,
      "options": toOptionsString(),
      "selectedText": selectedText,
    };

    return Helper.encodeToHTMLString(json);
  }
}
