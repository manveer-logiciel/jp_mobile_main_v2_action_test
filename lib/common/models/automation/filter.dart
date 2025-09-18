import 'package:flutter/foundation.dart';

class AutomationFilterModel {

  List<int?>? divisionIds;
  String? duration;
  String? startDate;
  String? endDate;

  AutomationFilterModel({
    this.divisionIds,
    this.duration = "YTD",
    this.startDate,
    this.endDate,
  });

  factory AutomationFilterModel.copy(AutomationFilterModel params) => AutomationFilterModel(
    divisionIds: params.divisionIds,
    duration: params.duration,
    startDate: params.startDate,
    endDate: params.endDate,
  );

  @override
  bool operator ==(Object other) {
    return (other is AutomationFilterModel)
        && listEquals(other.divisionIds, divisionIds)
        && other.duration == duration
        && other.startDate == startDate
        && other.endDate == endDate;
  }

  @override
  int get hashCode => 0;

  AutomationFilterModel.fromJson(Map<String, dynamic> json) {
    if (json["value"]?['division_ids'] != null && (json["value"]?['division_ids'] is List)) {
      divisionIds = [];
      json["value"]?['division_ids'].forEach((dynamic id) {
        divisionIds!.add(int.tryParse(id.toString()));
      });
    }
    if(json["value"]?['date'] is Map) {
      duration = json["value"]?['date']?['duration']?.toString();
      startDate = json["value"]?['date']?['start']?.toString();
      endDate = json["value"]?['date']?['end']?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    for(int i = 0; i < (divisionIds?.length ?? 0) ; i++) {
      data.addEntries({"division_ids[$i]" : divisionIds![i]}.entries);
    }
    return data;
  
  }
}