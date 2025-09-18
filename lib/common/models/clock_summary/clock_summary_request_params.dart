import 'package:flutter/foundation.dart';
import 'package:jobprogress/common/enums/clock_summary.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class ClockSummaryRequestParams {

  String? endDate;
  late String group;
  String? includes;
  late int limit;
  int page;
  String? sortBy;
  String? sortOrder;
  String? startDate;
  int? jobId;
  List<JPMultiSelectModel>? users;
  List<JPMultiSelectModel>? tags;
  List<JPMultiSelectModel>? divisions;
  List<JPMultiSelectModel>? tradeTypes;
  late DurationType durationType;
  List<JPMultiSelectModel>? customerType;
  String? date;
  String? jobName;
  String? userName;
  String? title;
  int? withOutJobEntries;
  JobModel? jobModel;

  ClockSummaryRequestParams({
        this.endDate,
        this.group = 'job',
        this.includes,
        this.date,
        this.limit = PaginationConstants.pageLimit,
        this.page = 1,
        this.sortBy = 'job_id',
        this.sortOrder = 'asc',
        this.startDate,
        this.users,
        this.tags,
        this.divisions,
        this.tradeTypes,
        this.jobId,
        this.durationType = DurationType.mtd,
        this.customerType,
        this.title,
        this.withOutJobEntries = 0,
        this.userName,
        this.jobName,
        this.jobModel
      });

  /// ClockSummaryRequestParams.copy() is used to copy one instance for ClockSummaryRequestParams to other
  factory ClockSummaryRequestParams.copy(ClockSummaryRequestParams params) {
    return ClockSummaryRequestParams(
        limit: params.limit,
        jobId: params.jobId,
        date: params.date,
        userName: params.userName,
        tags: params.tags,
        jobName: params.jobName,
        title: params.title,
        divisions: params.divisions ?? [],
        durationType: params.durationType,
        endDate: params.endDate,
        group: params.group,
        page: 1,
        includes: params.includes,
        sortBy: params.sortBy,
        sortOrder: params.sortOrder,
        startDate: params.startDate,
        tradeTypes: params.tradeTypes ?? [],
        users: params.users ?? [],
        withOutJobEntries: params.withOutJobEntries,
        customerType: params.customerType ?? [],
        jobModel: params.jobModel
    );
  }

  static Map<String, dynamic> getParams(ClockSummaryRequestParams params, {bool isDurationParams = false}) {

    final selectedUsers = params.users?.where((element) => element.isSelect).toList() ?? [];
    final selectedDivisions = params.divisions?.where((element) => element.isSelect).toList() ?? [];
    final selectedTradeTypes = params.tradeTypes?.where((element) => element.isSelect).toList() ?? [];
    final selectedCustomerType = params.customerType?.where((element) => element.isSelect).toList() ?? [];


    return {
      if(params.date == null)...{
        'end_date': params.endDate,
        'start_date': params.startDate,
      }else...{
        'date' : params.date,
      },
      'group': params.group,
      'includes[0]': 'trades',
      'includes[1]': 'user',
      'includes[2]': 'customer',
      'includes[3]': 'job_address',
      'limit': params.limit,
      'page': params.page,
      if(!isDurationParams)...{
        'sort_by': params.sortBy,
        'sort_order': params.sortOrder,
      },
      if(params.jobId != null || params.jobModel?.id != null)
       'job_id[]' : params.jobId ?? params.jobModel?.id,
      'without_job_entries': params.withOutJobEntries,

      for(int i=0; i<selectedUsers.length; i++)
        'user_id[$i]': selectedUsers[i].id,

      for(int i=0; i<selectedDivisions.length; i++)
        'division_id[$i]': selectedDivisions[i].id,

      for(int i=0; i<selectedTradeTypes.length; i++)
        'trades[$i]': selectedTradeTypes[i].id,

      for(int i=0; i<selectedCustomerType.length; i++)
        'customer_type[$i]': selectedCustomerType[i].id,

    };
  }

  /// For comparing two ClockSummaryRequestParams objects
  @override
  bool operator == (other) {
    return (other is ClockSummaryRequestParams)
        && other.durationType == durationType
        && other.date == date
        && other.jobModel == jobModel
        && listEquals(other.users, users)
        && listEquals(other.divisions, divisions)
        && listEquals(other.tradeTypes, tradeTypes)
        && listEquals(other.customerType, customerType)
    ;
  }

  @override
  int get hashCode => 0;

}
