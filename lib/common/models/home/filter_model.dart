import 'package:flutter/foundation.dart';
import 'package:jobprogress/common/services/auth.dart';
import '../../../core/constants/company_seetings.dart';

class HomeFilterModel {
  int? settingId;
  String? settingName;
  String? settingKey;
  int? userId;
  int? companyId;

  List<int?>? divisionIds;
  List<int?>? users;
  List<int?>? trades;
  String? dateRangeType;
  String? duration;
  String? startDate;
  String? endDate;
  late bool insuranceJobsOnly;

  HomeFilterModel({
    this.settingId,
    this.settingName = CompanySettingConstants.workFlowFilters,
    this.settingKey = CompanySettingConstants.workFlowFilters,
    this.userId,
    this.companyId,
    this.divisionIds,
    this.users,
    this.trades,
    this.dateRangeType,
    this.duration,
    this.startDate,
    this.endDate,
    this.insuranceJobsOnly = false,
  });

  factory HomeFilterModel.copy(HomeFilterModel params) => HomeFilterModel(
    settingId: params.settingId,
    settingName: params.settingName,
    settingKey: params.settingKey,
    userId: params.userId,
    companyId: params.companyId,
    divisionIds: params.divisionIds,
    users: params.users,
    trades: params.trades,
    dateRangeType: params.dateRangeType,
    duration: params.duration,
    startDate: params.startDate,
    endDate: params.endDate,
    insuranceJobsOnly: params.insuranceJobsOnly,
  );

  @override
  bool operator ==(Object other) {
    return (other is HomeFilterModel)
        && other.settingId == settingId
        && other.settingName == settingName
        && other.settingKey == settingKey
        && other.userId == userId
        && other.companyId == companyId
        && listEquals(other.divisionIds, divisionIds)
        && listEquals(other.users, users)
        && listEquals(other.trades, trades)
        && other.dateRangeType == dateRangeType
        && other.duration == duration
        && other.startDate == startDate
        && other.endDate == endDate
        && other.insuranceJobsOnly == insuranceJobsOnly;
  }

  @override
  int get hashCode => 0;

  HomeFilterModel.fromJson(Map<String, dynamic> json) {

    settingId = int.tryParse(json['id']?.toString() ?? "");
    settingName = json['name']?.toString();
    settingKey = json['key']?.toString();
    userId = int.tryParse(json['user_id']?.toString() ?? "");
    companyId = int.tryParse(json['company_id']?.toString() ?? "");

    if (json["value"]?['division_ids'] != null && (json["value"]?['division_ids'] is List)) {
      divisionIds = [];
      json["value"]?['division_ids'].forEach((dynamic v) {
        divisionIds!.add(int.tryParse(v.toString()));
      });
    }
    if(AuthService.isStandardUser() && AuthService.isRestricted) {
      users = [AuthService.userDetails?.id];
    } else {
      if (json["value"]?['user_id'] != null && (json["value"]?['user_id'] is List)) {
        users = [];
        json["value"]?['user_id'].forEach((dynamic v) {
          users!.add(int.tryParse(v.toString()));
        });
      } 
    }
    
    if (json["value"]?['trade_ids'] != null && (json["value"]?['trade_ids'] is List)) {
      trades = [];
      json["value"]?['trade_ids'].forEach((dynamic v) {
        trades!.add(int.tryParse(v.toString()));
      });
    }
    if(json["value"]?['date'] is Map) {
      dateRangeType = json["value"]?['date']?['type']?.toString();
      duration = json["value"]?['date']?['duration']?.toString();
      startDate = json["value"]?['date']?['start']?.toString();
      endDate = json["value"]?['date']?['end']?.toString();
    }
    insuranceJobsOnly = (json["value"]?['insurance_only']?.toString() ?? false) == "1";
  }

  Map<String, dynamic> toJsonForStateAPI() {
    final data = <String, dynamic>{};
    data['date_range_type'] = dateRangeType;
    data['duration'] = duration;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['insurance_jobs_only'] = insuranceJobsOnly ? 1 : 0;
    for(int i = 0; i < (divisionIds?.length ?? 0) ; i++) {
      data.addEntries({"division_ids[$i]" : divisionIds![i]}.entries);
    }
    if(!((AuthService.isStandardUser() && AuthService.isRestricted))) {
      for(int i = 0; i < (users?.length ?? 0) ; i++) {
        data.addEntries({"user_id[$i]" : users![i]}.entries);
      }
    }
    
    for(int i = 0; i < (trades?.length ?? 0) ; i++) {
      data.addEntries({"trades[$i]" : trades![i]}.entries);
    }
    return data;
  }

  Map<String, dynamic> toJsonForSettingAPI() {
    final data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['user_id'] = userId ?? AuthService.userDetails?.id;
    data['key'] = settingKey;
    data['name'] = settingName;
    data['id'] = settingId;
    data['value'] = <String, dynamic>{};
    if (divisionIds?.isNotEmpty ?? false) {
      data['value[division_ids][]'] = divisionIds;
    }
    if ((users?.isNotEmpty ?? false) && !(AuthService.isStandardUser() && AuthService.isRestricted)) {
      data['value[user_id][]'] = users;
    }
    if (trades?.isNotEmpty ?? false) {
      data['value[trade_ids][]'] = trades;
    }
    data['value']['date'] = <String, dynamic>{};
    data['value']['date']['type'] = dateRangeType;
    data['value']['date']['duration'] = duration;
    data['value']['date']['start'] = startDate;
    data['value']['date']['end'] = endDate;
    data['value']['insurance_only'] = insuranceJobsOnly ? 1 : 0;
    return data;
  }

}