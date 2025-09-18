import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job_estimators.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/note_list/note_listing.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import '../customer/customer.dart';
import '../sql/work_type/work_type.dart';

class SchedulesModel {
  int? id;
  int? jobId;
  String? title;
  String? description;
  String? startDateTime;
  String? endDateTime;
  String? createdAt;
  String? updatedAt;
  int? customerId;
  late bool isAllDay;
  bool? subjectEdited;
  String? repeat;
  int? occurence;
  late bool isRecurring;
  String? type;
  late bool fullday;
  late bool iscompleted;
  CustomerModel? customer;
  JobModel? job;
  UserModel? createdBy;
  String? scheduleTimeString;
  List<UserLimitedModel>? reps;
  List<UserLimitedModel>? subContractors;
  List<PhoneModel>? phones;
  List<NoteListModel>? workCrewNote;
  List<CompanyTradesModel>? trades;
  List<AttachmentResourceModel>? attachments;
  List<AttachmentResourceModel>? materialList;
  List<AttachmentResourceModel>? workOrder;
  List<ReminderModel>? remainder;
  List<UserLimitedModel>? workCrew;
  List<JobEstimatorsModel>? jobEstimators;
  List<WorkTypeModel>? workTypes;
  int? seriesId;
  String? formattedStartDateTime;
  String? formattedEndDateTime;
  String? tradesString;
  int? confirmedCount;
  int? declinedCount;
  int? pendingCount;
  bool? doShowNotification;

  SchedulesModel({
    this.id,
    this.jobId,
    this.title,
    this.description,
    this.startDateTime,
    this.endDateTime,
    this.createdAt,
    this.updatedAt,
    this.customerId,
    this.subjectEdited,
    this.repeat,
    this.occurence,
    this.isRecurring = false,
    this.type,
    this.fullday = false,
    this.iscompleted = false,
    this.job,
    this.createdBy,
    this.customer,
    this.reps,
    this.subContractors,
    this.workCrewNote,
    this.trades,
    this.attachments,
    this.materialList,
    this.workOrder,
    this.phones,
    this.remainder,
    this.workCrew,
    this.scheduleTimeString,
    this.jobEstimators,
    this.workTypes,
    this.seriesId,
  });

  SchedulesModel.fromApiJson(Map<String, dynamic> json) {
    id = json['id'];
    jobId = json['job_id'];
    title = json['title'];
    description = json['description'];
    startDateTime = json['start_date_time'];
    endDateTime = json['end_date_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customerId = json['customer_id'];
    subjectEdited = (json['subject_edited'] == true || json['subject_edited'] == 1);
    repeat = json['repeat'];
    occurence = json['occurence'];
    isRecurring = json['is_recurring'] ?? false;
    type = json['type'];
    isAllDay = json['full_day'] == 1 ? true : false;
    fullday = json['full_day'] == 1 ? true : false;
    iscompleted = json['is_completed'] ?? false;
    if(json['customer'] != null) {
      json['job']['customer'] = json['customer']; 
    }
    job = json['job'] != null ? JobModel.fromJson(json['job']) : null;
    createdBy = json['created_by'] != null && json['created_by'] is Map<dynamic, dynamic> ? UserModel.fromJson(json['created_by'])
        : null;
    customer = json['customer'] != null
        ? CustomerModel.fromJson(json['customer'])
        : null;
    scheduleTimeString = getTimeString();
    if (json['reps'] != null) {
      reps = <UserLimitedModel>[];
      json['reps']['data'].forEach((dynamic v) {
        reps!.add(UserLimitedModel.fromJson(v));
      });
    }
    if (json['sub_contractors'] != null) {
      subContractors = <UserLimitedModel>[];
      json['sub_contractors']['data'].forEach((dynamic v) {
        subContractors!.add(UserLimitedModel.fromJson(v));
      });
    }
    if (json['phones'] != null) {
      phones = <PhoneModel>[];
      json['phones']['data'].forEach((dynamic v) {
        phones!.add(PhoneModel.fromJson(v));
      });
    }
    if (json['work_crew_notes'] != null) {
      workCrewNote = <NoteListModel>[];
      json['work_crew_notes']['data'].forEach((dynamic v) {
        workCrewNote!.add(NoteListModel.fromJson(v));
      });
    }
    if (json['trades'] != null) {
      trades = <CompanyTradesModel>[];
      json['trades']['data'].forEach((dynamic v) {
        trades!.add(CompanyTradesModel.fromJson(v));
      });
      tradesString = trades?.map((trade) => trade.name).join(", ");
    }

    if (json['attachments'] != null) {
      attachments = <AttachmentResourceModel>[];
      json['attachments']['data'].forEach((dynamic v) {
        attachments!.add(AttachmentResourceModel.fromJson(v));
      });
    }
    if (json['material_lists'] != null) {
      materialList = <AttachmentResourceModel>[];
      json['material_lists']['data'].forEach((dynamic v) {
        materialList!.add(AttachmentResourceModel.fromMaterialListJson(v));
      });
    }
    if (json['work_orders'] != null) {
      workOrder = <AttachmentResourceModel>[];
      json['work_orders']['data'].forEach((dynamic v) {
        workOrder!.add(AttachmentResourceModel.fromMaterialListJson(v));
      });
    }
    if (json['reminders'] != null) {

      remainder = <ReminderModel>[];
      json['reminders']['data'].forEach((dynamic v) {
        remainder!.add(ReminderModel.fromJson(v));
      });
    }

    if(reps != null || subContractors != null) {
      workCrew =  [...reps!, ...subContractors!];
    }

    if(json['job_estimators']?['data'] != null) {
      jobEstimators = <JobEstimatorsModel>[];
      json['job_estimators']['data'].forEach((dynamic estimator) {
        jobEstimators!.add(JobEstimatorsModel.fromJson(estimator));
      });
    }

    if(json['work_types']?['data'] != null) {
      workTypes = <WorkTypeModel>[];
      json['work_types']['data'].forEach((dynamic estimator) {
        workTypes!.add(WorkTypeModel.fromApiJson(estimator));
      });
    }

    seriesId = int.tryParse(json['series_id'] ?? '');

    if (startDateTime != null) {
      formattedStartDateTime = DateTimeHelper.formatDate(startDateTime!, DateFormatConstants.dateTimeFormatWithoutSeconds);
    }

    if (endDateTime != null) {
      formattedEndDateTime = DateTimeHelper.formatDate(endDateTime!, DateFormatConstants.dateTimeFormatWithoutSeconds);
    }

    confirmedCount = getConfirmationCounts('accept');
    declinedCount = getConfirmationCounts('decline');
    pendingCount = getConfirmationCounts('pending');
    doShowNotification = getDoShowNotification();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_id'] = jobId;
    data['title'] = title;
    data['description'] = description;
    data['start_date_time'] = startDateTime;
    data['end_date_time'] = endDateTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['customer_id'] = customerId;
    data['subject_edited'] = subjectEdited;
    data['repeat'] = repeat;
    data['occurence'] = occurence;
    data['is_recurring'] = isRecurring;
    data['type'] = type;
    data['full_day'] = isAllDay;
    data['is_completed'] = iscompleted;
    if (job != null) {
      data['job'] = job!.toJson();
    }
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (reps != null) {
      data['reps'] = reps!.map((v) => v.toJson()).toList();
    }
    if (subContractors != null) {
      data['sub_contractors'] = subContractors!.map((v) => v.toJson()).toList();
    }
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    if (workCrewNote != null) {
      data['work_crew_notes'] = workCrewNote!.map((v) => v.toJson()).toList();
    }
    if (trades != null) {
      data['trades'] = trades!.map((v) => v.toJson()).toList();
    }
    if (attachments != null) {
      data['attachments'] = attachments!.map((v) => v.toJson()).toList();
    }

    if (materialList != null) {
      data['material_lists'] =
          materialList!.map((v) => v.toMaterialListJson()).toList();
    }
    if (workOrder != null) {
      data['work_orders'] =
          workOrder!.map((v) => v.toMaterialListJson()).toList();
    }
    if (remainder != null) {
      data['reminders'] = remainder!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  String getTimeString() {
    if(isAllDay) {
      return '${'all_day_on'.tr} ${DateTimeHelper.convertHyphenIntoSlash(startDateTime!.substring(0, 10).toString())}';
    }

    if(startDateTime == null || endDateTime == null) {
      return "";
    }


    final formattedStartDate = DateTime.parse(startDateTime!);
    final formattedEndDate = DateTime.parse(endDateTime!);

    if(formattedEndDate.difference(formattedStartDate).inDays == 0) {
      return "${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.timeOnlyFormat)} - ${DateTimeHelper.formatDate(endDateTime.toString(), DateFormatConstants.timeOnlyFormat)}" ;
    } else {
      return "${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}"
          " - ${DateTimeHelper.formatDate(endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}" ;
    }
  }

  /// [getDates] gives a formatted string of schedule dates based on
  /// whether schedule is all day or not
  String getDates() {
    if (isAllDay) {
      return DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat);
    } else {
     return '${DateTimeHelper.formatDate(startDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)} - ${DateTimeHelper.formatDate(endDateTime.toString(), DateFormatConstants.dateMonthLetterFormat)}';
    }
  }

  /// [getConfirmationCounts] gives the count as per the status of the reps
  /// that belong to this current schedule
  int getConfirmationCounts(String status) {
    return workCrew?.where((user) => user.status == status).length ?? 0;
  }

  bool isStatusNotAvailable() {
    return (workCrew?.where((user) => user.status == null).length ?? 0) == workCrew?.length;
  }

  bool getDoShowNotification() {
    UserLimitedModel? user = workCrew?.firstWhereOrNull((crew) => crew.id == AuthService.userDetails?.id);
    return user?.status == 'pending';
  }

}
