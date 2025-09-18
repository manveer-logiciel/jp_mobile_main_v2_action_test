import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CompanyTradesModel {
  int? id;
  String? name;
  String? color;
  /// [isScheduled] is used to set trade as it is scheduled
  /// It is helps in identifying trades scheduled or not as the time of parsing
  bool? isScheduled;
  int? thirdPartyToolsCount;

  CompanyTradesModel({this.id, this.name, this.color, this.thirdPartyToolsCount});

  CompanyTradesModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    name = json['name'];
    color = json['color'];
    if(json['third_party_tools_count'] != null) {
      thirdPartyToolsCount = json['third_party_tools_count']['third_party_tool'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    return data;
  }

  JPSingleSelectModel toSingleSelect() {
    return JPSingleSelectModel(
        label: name ?? "",
        id: id.toString()
    );
  }

  CompanyTradesModel.fromSingleSelect(JPSingleSelectModel data) {
    id = int.tryParse(data.id);
    name = data.label;
  }
}
