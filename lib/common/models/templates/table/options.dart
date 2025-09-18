import 'package:jobprogress/core/utils/helpers.dart';

class TemplateFormTableRowOptions {

  String? depPrice;
  int? hideColumnText;

  TemplateFormTableRowOptions({
    this.depPrice,
    this.hideColumnText
  });

  TemplateFormTableRowOptions.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;
    depPrice = json['depPrice'];
    if (json['hideColumnText'] is List) {
      hideColumnText = json['hideColumnText'].first;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['depPrice'] = depPrice;
    if (hideColumnText != null) {
      data['hideColumnText'] = [hideColumnText];
    }
    return data;
  }

  @override
  String toString() {
    return Helper.encodeToHTMLString(toJson());
  }
}