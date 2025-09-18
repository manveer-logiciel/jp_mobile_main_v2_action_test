import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/company_contacts.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/custom_fields/custom_fields.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job/job_meta.dart';
import 'package:jobprogress/common/models/job/job_production_board.dart';
import 'package:jobprogress/common/models/job_financial/tax_model.dart';
import 'package:jobprogress/common/models/phone_consents.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/workflow/project_stage_status.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';
import '../../enums/cj_list_type.dart';
import '../insurance/insurance_model.dart';
import '../job_financial/financial_details.dart';
import '../../../core/utils/date_time_helpers.dart';
import '../../../core/utils/helpers.dart';
import '../customer/appointments.dart';
import '../progress_board/progress_board_entries.dart';
import '../sql/flag/flag.dart';
import 'job_change_order.dart';
import 'job_count.dart';
import 'job_follow_up_status.dart';
import 'job_invoices.dart';
import 'job_type.dart';
import 'job_work_flow_history.dart';
import 'job_workflow.dart';

class JobModel {
  late int id;
  late int  customerId;
  WorkFlowStageModel? currentStage;
  String? number;
  String? phoneNumber;
  String? name;
  String? divisionCode;
  String? altId;
  String? leadNumber;
  String? amount;
  int? taxable;
  String? taxRate;
  JobMetaModel? meta;
  String? duration;
  String? quickbookId;
  String? createdAt;
  String? origin;
  String? quickbookSyncStatus;
  String? qbDesktopId;
  String? updatedAt;
  int? bidCustomer;
  int? isPmi;
  String? pmiId;
  int? pmiSyncStatus;
  late bool isMultiJob;
  CustomerModel? customer;
  AddressModel? address;
  AppointmentModel? upcomingAppointment;
  SchedulesModel? upcomingSchedules;
  DivisionModel? division;
  String? addressString;
  String? fullJobAddress;
  List<CompanyTradesModel>? trades;
  late String tradesString;
  List<WorkFlowStageModel>? stages;
  /// Division-specific workflow stages loaded when division context is changed
  /// This allows for different workflow configurations per division
  List<WorkFlowStageModel>? stagesByDivision;
  List<UserLimitedModel>? subContractors;
  List<UserLimitedModel>? labours;
  List<UserLimitedModel>? reps;
  List<UserLimitedModel>? estimators;
  List<UserLimitedModel>? workCrew;
  FinancialDetailModel? financialDetails;
  JobCountModel? count;
  int? jobNoteCount;
  int? jobTaskCount;
  bool? isAppointmentRequired;
  bool? isArchived;
  bool? jobAmountApprovedBy;
  String? archived;
  String? archivedCwp;
  bool? isCallRequired;
  String? completionDate;
  String? contractSignedDate;
  int? createdBy;
  String? createdDate;
  String? deletedAt;
  String? description;
  String? distance;
  String? ghostJob;
  String? homeAdvisorJobId;
  int? insurance;
  int? isAllScheduleCompleted;
  String? materialDeliveryDate;
  String? movedToPb;
  String? otherTradeTypeDescription;
  String? pmiSyncMessage;
  String? pmiSyncType;
  String? purchaseOrderNumber;
  int? sameAsCustomerAddress;
  int? scheduleCount;
  String? scheduled;
  String? shareUrl;
  String? sourceType;
  String? spotioLeadId;
  String? stageChangedDate;
  String? toBeScheduled;
  int? wpJob;
  String? stageLastModified;
  CustomerAppointments? appointments;
  JobFollowUpStatus? followUpStatus;
  InsuranceModel ? insuranceDetails;
  List<FlagModel?>? flags;
  List<JobTypeModel?>? jobTypes;
  String? jobTypesString;
  List<JobTypeModel?>? workTypes;
  String? workTypesString;
  List<JobProductionBoardModel>? productionBoards;
  num? paymentReceivedTotalAmount;
  List<CompanyContactListingModel>? contactPerson;
  List<DeliveryDateModel>? deliveryDates;
  List<CustomFieldsModel?>? customFields;
  int? parentId;
  JobModel? parent;
  List<JobWorkFlowHistoryModel>? jobWorkFlowHistory;
  JobWorkFlow? jobWorkflow;
  bool? isContactSameAsCustomer;
  ProjectStatusModel? projectStatus;
  bool? isAwarded;
  int? appointmentCount;
  int? jobMessageCount;
  int? jobTextCount;
  TaxModel? customTax;
  List<JobInvoices>? jobInvoices;
  int? hasProfitLossWorksheet;
  int? hasSellingPriceWorksheet;
  ChangeOrderModel? changeOrder;
  bool? isProject;
  int? recurringEmailCount;
  int? projectCount;
  CJListType? listType;
  int? order;
  List<ProgressBoardEntriesModel?>? pbEntries;
  bool? isExpended;
  String? soldOutDate;
  HoverJob? hoverJob;
  bool? syncOnHover;
  bool? isOldTrade;
  String? appointmentDate;
  bool? lostJob;
  List<int>? scheduledTradeIds;
  List<PhoneConsentModel>? phoneConsents;
  String? workCrewNames; 
  String? canvasserType;
  UserLimitedModel? canvasser;
  String? canvasserString;
  String? jobLostDate;

  JobModel({
    required this.id,
    required this.customerId,
    this.currentStage,
    this.number,
    this.recurringEmailCount,
    this.phoneNumber,
    this.name,
    this.divisionCode,
    this.altId,
    this.leadNumber,
    this.amount,
    this.taxable,
    this.taxRate,
    this.meta,
    this.paymentReceivedTotalAmount,
    this.duration,
    this.quickbookId,
    this.createdAt,
    this.origin,
    this.quickbookSyncStatus,
    this.qbDesktopId,
    this.labours,
    this.updatedAt,
    this.bidCustomer,
    this.isPmi,
    this.pmiId,
    this.pmiSyncStatus,
    this.jobAmountApprovedBy,
    this.isMultiJob = false,
    this.customer,
    this.address,
    this.upcomingAppointment,
    this.upcomingSchedules,
    this.trades,
    this.tradesString = "",
    this.stages,
    this.count,
    this.jobNoteCount,
    this.jobTaskCount,
    this.parentId,
    this.parent,
    this.subContractors,
    this.financialDetails,
    this.reps,
    this.isAppointmentRequired,
    this.archived,
    this.archivedCwp,
    this.isCallRequired,
    this.completionDate,
    this.contractSignedDate,
    this.createdBy,
    this.createdDate,
    this.deletedAt,
    this.description,
    this.distance,
    this.ghostJob,
    this.homeAdvisorJobId,
    this.insurance,
    this.isAllScheduleCompleted,
    this.materialDeliveryDate,
    this.movedToPb,
    this.otherTradeTypeDescription,
    this.pmiSyncMessage,
    this.pmiSyncType,
    this.purchaseOrderNumber,
    this.sameAsCustomerAddress,
    this.scheduleCount,
    this.scheduled,
    this.shareUrl,
    this.sourceType,
    this.spotioLeadId,
    this.stageChangedDate,
    this.toBeScheduled,
    this.wpJob,
    this.appointments,
    this.division,
    this.estimators,
    this.flags,
    this.followUpStatus,
    this.insuranceDetails,
    this.jobTypes,
    this.jobTypesString,
    this.workCrew,
    this.workTypes,
    this.workTypesString,
    this.stageLastModified,
    this.productionBoards,
    this.contactPerson,
    this.deliveryDates,
    this.customFields,
    this.jobWorkFlowHistory,
    this.jobWorkflow,
    this.isContactSameAsCustomer = false,
    this.projectStatus,
    this.isAwarded,
    this.appointmentCount,
    this.jobMessageCount,
    this.isProject = false,
    this.projectCount,
    this.customTax,
    this.jobInvoices,
    this.hasProfitLossWorksheet,
    this.changeOrder,
    this.order,
    this.isArchived,
    this.pbEntries,
    this.isExpended = false,
    this.soldOutDate,
    this.hoverJob,
    this.isOldTrade = false,
    this.hasSellingPriceWorksheet,
    this.lostJob,
    this.scheduledTradeIds,
    this.fullJobAddress,
    this.phoneConsents,
    this.workCrewNames,
    this.canvasserType,
    this.canvasser,
    this.jobLostDate,
    this.stagesByDivision,
  });
  
  /// Returns the full job address if available, otherwise returns the address string
  String? get jobAddress => fullJobAddress ?? addressString;

  JobModel.fromNotificationJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    number = json['number'];
    name = json['name'];
    altId = json['alt_id'];
    customer = CustomerModel.fromNotificationJson(json);
  }

  JobModel.fromFinancialJson(Map<String, dynamic> json) {
    altId = json['alt_id'];
    id = json['id'];
    number = json['number'];
    name = json['name'];
  }

  JobModel.fromFirestoreJson(Map<String, dynamic> data) {
    id = int.parse(data['id']);
    altId = data['alt_id'];
    name = data['name'];
    customerId = int.parse(data['customer_id']);
    parentId = data['parent_id'].toString().isEmpty
        ? null
        : int.parse(data['parent_id'].toString());
    number = data['number'];
    if (data['customer'] != null) {
      customer = CustomerModel.fromFirestoreJson(data['customer']);
    }
  }

  JobModel.fromJson(Map<String, dynamic> json, {int? jobId}) {
    id = json['id'] ?? json["job_id"];
    customerId = json['customer_id'] ?? -1;

    if (json['payment_receive'] != null) {
      paymentReceivedTotalAmount = json['payment_receive']['total_amount'];
    }

    if(json['phone_consents'] != null) {
      phoneConsents = [];
      json['phone_consents'].forEach((dynamic v) {
        phoneConsents!.add(PhoneConsentModel.fromJson(v));
      }); 
    }
    number = json['number'];
    name = json['name'];
    divisionCode = json['division_code'];
    altId = !Helper.isValueNullOrEmpty(divisionCode) && !Helper.isValueNullOrEmpty(json['alt_id'])
        ? "${divisionCode!}-" + json['alt_id']
        : json['alt_id'];
    leadNumber = json['lead_number'];
    amount = json['amount'] ?? '0.0';
    taxable = json['taxable'];
    taxRate = json['tax_rate'];
    meta = (json['meta'] != null ? JobMetaModel.fromJson(json['meta']) : null);
    currentStage = (json['current_stage'] != null
        ? WorkFlowStageModel.fromJson(json['current_stage'])
        : null);
    duration = json['duration'];
    isContactSameAsCustomer = json["contact_same_as_customer"] == 1;
    meta = (json['meta'] != null ? JobMetaModel.fromJson(json['meta']) : null);
    currentStage = (json['current_stage'] != null
        ? WorkFlowStageModel.fromJson(json['current_stage'])
        : null);
    quickbookId = json['quickbook_id'] != null && json['quickbook_id'] is String
        ? json['quickbook_id']
        : null;
    List<String> temp = (json['duration']?.toString() ?? "").split(':');
    if (temp.isNotEmpty) {
      duration = "";
      for (int i = 0; i < temp.length; i++) {
        if (temp[i] != "0" && temp.isNotEmpty && temp[i] != '') {
          if (i == 0) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "day".tr : "days".tr} ";
          }
          if (i == 1) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "hour".tr : "hours".tr} ";
          }
          if (i == 2) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "minute".tr : "minutes".tr} ";
          }
        }
      }
    }
    createdAt = json['created_at'];
    origin = json['origin'];
    quickbookSyncStatus = json['quickbook_sync_status']?.toString();
    qbDesktopId = json['qb_desktop_id'];
    updatedAt = json['updated_at'];
    bidCustomer = json['bid_customer'];
    isPmi = json['is_pmi'];
    pmiId = json['pmi_id'];
    pmiSyncStatus = json['pmi_sync_status'];
    jobNoteCount =
        json['Job_note_count'] != null ? json['Job_note_count']['count'] : null;
    jobTaskCount =
        json['job_task_count'] != null ? json['job_task_count']['count'] : null;
    isMultiJob = json['multi_job'] == 1;
    customer = (json['customer'] != null
        ? CustomerModel.fromJson(json['customer'])
        : null);
    address = (json['address'] != null
        ? AddressModel.fromJson(json['address'])
        : null);
    upcomingAppointment = (json['upcoming_appointment'] != null
        ? AppointmentModel.fromJson(json['upcoming_appointment'])
        : null);
    upcomingSchedules = (json['upcoming_schedule'] != null
        ? SchedulesModel.fromApiJson(json['upcoming_schedule'])
        : null);
    division = (json['division'] != null
        ? DivisionModel.fromJson(json['division'])
        : null);

    addressString = Helper.convertAddress(address).trim();

    if (json['workflow'] != null && json['workflow']['stages'] != null) {
      stages = <WorkFlowStageModel>[];
      json['workflow']['stages'].forEach((dynamic stage) {
        stages!.add(WorkFlowStageModel.fromJson(stage));
      });
    }
    tradesString = "";
    if (json['trades'] != null) {
      trades = <CompanyTradesModel>[];
      json['trades'].forEach((dynamic v) {
        trades!.add(CompanyTradesModel.fromJson(v));
      });

      if (trades!.isNotEmpty) {
        tradesString = trades!.map((e) => e.name).join(', ');
      }
    }

    count =
        json['count'] != null ? JobCountModel.fromJson(json['count']) : null;
    isAppointmentRequired = json['appointment_required'];
    isArchived =
        (json['archived']?.toString().isNotEmpty ?? false) ? true : false;
    jobAmountApprovedBy = json['job_amount_approved_by'] == null ? false: true;
    archived = json['archived'];
    archivedCwp = json['archived_cwp']?.toString();
    isCallRequired = json['call_required'];
    completionDate = json['completion_date'] != null
        ? DateTimeHelper.convertHyphenIntoSlash(
            (json['completion_date']?.toString() ?? ""))
        : null;
    contractSignedDate = json['contract_signed_date'] != null
        ? DateTimeHelper.convertHyphenIntoSlash(
            (json['contract_signed_date']?.toString() ?? ""))
        : null;
    stageLastModified = json['stage_last_modified'] != null
        ? DateTimeHelper.formatDate(
            json['stage_last_modified'].toString(), 'am_time_ago')
        : null;
    createdBy = int.tryParse(json['created_by']?.toString() ?? '');
    createdDate = json['created_date']?.toString();
    deletedAt = json['deleted_at']?.toString();
    description = json['description']?.toString();
    distance = json['distance']?.toString();
    ghostJob = json['ghost_job']?.toString();
    homeAdvisorJobId = json['home_advisor_job_id']?.toString();
    insurance = int.tryParse(json['insurance']?.toString() ?? '');
    isAllScheduleCompleted =
        int.tryParse(json['is_all_schedule_completed']?.toString() ?? '');
    materialDeliveryDate = json['material_delivery_date']?.toString();
    movedToPb = json['moved_to_pb']?.toString();
    otherTradeTypeDescription =
        json['other_trade_type_description']?.toString();
    pmiSyncMessage = json['pmi_sync_message']?.toString();
    pmiSyncType = json['pmi_sync_type']?.toString();
    purchaseOrderNumber = json['purchase_order_number']?.toString();
    sameAsCustomerAddress =
        int.tryParse(json['same_as_customer_address']?.toString() ?? '');
    scheduleCount = int.tryParse(json['schedule_count']?.toString() ?? json['schedule_details']?['schedule_count']?.toString() ?? '');
    scheduled = json['scheduled']?.toString() ??
        json['schedule_details']?["scheduled"]?.toString();
    shareUrl = json['share_url']?.toString();
    sourceType = json['source_type']?.toString();
    spotioLeadId = json['spotio_lead_id']?.toString();
    stageChangedDate = json['stage_changed_date']?.toString();
    toBeScheduled = json['to_be_scheduled']?.toString();
    wpJob = int.tryParse(json['wp_job']?.toString() ?? '');
    if(json['appointment_details'] != null) {
      appointments =
      (json['appointment_details'] is Map)
          ? CustomerAppointments.fromJson(json['appointment_details'])
          : null;
    } else {
      appointments = (json['appointments'] != null && (json['appointments'] is Map))
          ? CustomerAppointments.fromJson(json['appointments'])
          : null;
    }
    if((appointments?.today ?? 0) > 0) {
      appointmentDate = 'today'.tr;
    } else if((appointments?.today ?? 0) < 1 && (appointments?.upcoming ?? 0) > 0) {
      appointmentDate = appointments?.upcomingFirst?.startDate;
    } else {
      appointmentDate = '';
    }
    division = (json['division'] != null && (json['division'] is Map))
        ? DivisionModel.fromJson(json['division'])
        : null;
    followUpStatus =
        (json['follow_up_status'] != null && (json['follow_up_status'] is Map))
            ? JobFollowUpStatus.fromJson(json['follow_up_status'])
            : null;
    insuranceDetails = (json['insurance_details'] != null && (json['insurance_details'] is Map))
      ? InsuranceModel.fromJson(json['insurance_details'])
      : null;

    if (json['flags']?['data'] != null) {
      flags = [];
      
      if(isCallRequired != null && isCallRequired!) {
          flags!.add(FlagModel.callRequiredFlag);
      }
      if(isAppointmentRequired != null && isAppointmentRequired!) {
        flags!.add(FlagModel.appointmentRequiredFlag);
      }

      json['flags']['data'].forEach((dynamic v) {
        flags!.add(FlagModel.fromApiJson(v));
      });
    }

    if (json['job_types'] != null) {
      jobTypes = [];
      json['job_types'].forEach((dynamic v) {
        jobTypes!.add(JobTypeModel.fromJson(v));
      });
      jobTypesString = jobTypes!.map((e) => e?.name ?? "").join(', ');
    }
    if (json['work_types'] != null) {
      workTypes = [];
      (json['work_types'] is Map
              ? json['work_types']["data"]
              : json['work_types'])
          .forEach((dynamic v) {
        workTypes!.add(JobTypeModel.fromJson(v));
      });
      if (workTypes!.isNotEmpty) {
        workTypesString = workTypes!.map((e) => e?.name).join(', ');
      }
    }
    if (json['production_boards'] != null &&
        (json['production_boards'] is Map)) {
      productionBoards = [];
      json['production_boards']["data"].forEach((dynamic v) {
        productionBoards!.add(JobProductionBoardModel.fromJson(v));
      });
    }

    parentId = json['parent_id'];
    jobWorkflow = json['job_workflow'] != null
        ? JobWorkFlow.fromJson(json['job_workflow'])
        : null;

    if (json['sub_contractors'] != null) {
      subContractors = <UserLimitedModel>[];
      json['sub_contractors']['data'].forEach((dynamic v) {
        subContractors!.add(UserLimitedModel.fromJson(v));
      });
    } else if(json['sub_ids'] != null) {
      subContractors = <UserLimitedModel>[];
      json['sub_ids'].forEach((dynamic subId) {
        subContractors!.add(UserLimitedModel.fromJson({'id': subId}));
      });
    }

    contactPerson = [];
    if (isContactSameAsCustomer ?? false) {
      contactPerson!
          .add(CompanyContactListingModel.fromApiJson(json['customer']));
      phoneNumber = contactPerson?[0].phones?[0].number ?? "";
    } else if (json['contacts'] != null) {
      json['contacts']["data"].forEach((dynamic v) {
        contactPerson!.add(CompanyContactListingModel.fromApiJson(v));
      });
      if (!Helper.isValueNullOrEmpty(contactPerson) && !Helper.isValueNullOrEmpty(contactPerson?[0].phones)) {
        phoneNumber = contactPerson!
                .firstWhereOrNull((element) => element.isPrimary)
                ?.phones?.firstWhereOrNull((element) => element.isPrimary == 1)
                ?.number ??
            (contactPerson?[0].phones?[0].number ?? "");
      }
    }

    if (json['delivery_dates'] != null) {
      deliveryDates = [];
      json['delivery_dates']["data"].forEach((dynamic v) {
        deliveryDates!.add(DeliveryDateModel.fromJson(v));
      });
    }
    if (json['custom_fields']?['data'] != null) {
      customFields = [];
      json['custom_fields']['data'].forEach((dynamic v) {
        customFields!.add(CustomFieldsModel.fromJson(v));
      });
    }
    reps = <UserLimitedModel>[];

    if (json['reps'] != null && json['reps']['data'] != null) {
      json['reps']['data'].forEach((dynamic v) {
        reps!.add(UserLimitedModel.fromJson(v));
      });
    } else if(json['rep_ids'] != null) {
      json['rep_ids'].forEach((dynamic repId) {
        reps!.add(UserLimitedModel.fromJson({'id': repId}));
      });
    }

    estimators = <UserLimitedModel>[];
    if (json['estimators'] != null && json['estimators']['data'] != null) {
      json['estimators']['data'].forEach((dynamic v) {
        estimators!.add(UserLimitedModel.fromJson(v));
      });
    } else if(json['estimator_ids'] != null) {
      json['estimator_ids'].forEach((dynamic estimatorId) {
        estimators!.add(UserLimitedModel.fromJson({'id': estimatorId}));
      });
    }

    labours = <UserLimitedModel>[];
    if (json['labours'] != null && json['labours']['data'] != null) {
      json['labours']['data'].forEach((dynamic v) {
        labours!.add(UserLimitedModel.fromJson(v));
      });
    }

    if (reps != null ||
        subContractors != null ||
        estimators != null ||
        (customer != null && customer!.rep != null)) {
      workCrew = [];

      if (reps != null) workCrew!.addAll(reps!);

      if (subContractors != null && subContractors!.isNotEmpty) {
        for (UserLimitedModel user in subContractors!) {
          user.roleName = AuthConstant.subContractorPrime;
        }
        workCrew!.addAll(subContractors!);
      }

      var seen = <String>{};
      workCrew = workCrew!
          .where((element) => seen.add(element.id.toString()))
          .toList();

      if (workCrew?.isEmpty ?? true) {
        workCrew!.add(UserLimitedModel(
          id: 0,
          firstName: 'unassigned'.tr,
          fullName: 'unassigned'.tr,
          email: 'unassigned'.tr,
          intial: 'un',
          groupId: 0,
        ));
      }

      List<String> workCrewName = workCrew!.map((crew) =>
        Helper.getWorkCrewName(crew, byRoleName: true)).toList();
  
      workCrewNames = workCrewName.join(', ');
    }

    if (json['financial_details'] != null) {
      financialDetails =
          FinancialDetailModel.fromJson(json['financial_details']);
    }

    if (json['job_workflow_history']?['data'] != null) {
      jobWorkFlowHistory = [];
      json['job_workflow_history']['data'].forEach((dynamic historyJson) {
        jobWorkFlowHistory!.add(JobWorkFlowHistoryModel.fromJson(historyJson));
      });
    }

    if (!Helper.isValueNullOrEmpty(json['projects']?['data'])) {
      json['projects']['data'].forEach((dynamic projectStatusJson) {
        if(projectStatusJson['id'] == jobId) {
          projectStatus = ProjectStatusModel.fromJson(projectStatusJson);
        }
      });
    }

    isAwarded = json['awarded'] == 0;

    if (json['upcoming_appointment_count']?['count'] != null) {
      appointmentCount = json['upcoming_appointment_count']?['count'];
    }

    if (json['job_message_count']?['count'] != null) {
      jobMessageCount = json['job_message_count']?['count'];
    }

    customTax = (json["custom_tax"] != null && (json["custom_tax"] is Map))
        ? TaxModel.fromJson(json["custom_tax"])
        : null;
    if (json['job_invoices']?['data'] != null) {
      jobInvoices = [];
      json['job_invoices']['data'].forEach((dynamic invoiceJson) {
        jobInvoices!.add(JobInvoices.fromJson(invoiceJson));
      });
    }
    hasProfitLossWorksheet =
        int.tryParse(json['has_profit_loss_worksheet']?.toString() ?? '');
    changeOrder =
        (json['change_order'] != null && (json['change_order'] is Map))
            ? ChangeOrderModel.fromJson(json['change_order'])
            : null;

    isProject = parentId != null;

    projectCount = int.tryParse(json['projects_count']?.toString() ?? '');

    soldOutDate = json['sold_out_date']?.toString();

    hoverJob = HoverJob.fromJson(json['hover_job']);
    syncOnHover = Helper.isTrue(json['sync_on_hover']);
    isOldTrade = Helper.isTrue(json['is_old_trade']);
    if (json['has_selling_price_worksheet'] is int) {
      hasSellingPriceWorksheet = json['has_selling_price_worksheet'];
    }
    if(json['scheduled_trade_ids'] != null) {
      if(json['scheduled_trade_ids']['data'] != null) {
        scheduledTradeIds = [];
        json['scheduled_trade_ids']['data'].forEach((dynamic tradeId) {
          scheduledTradeIds?.add(tradeId);
          // updating available trades to scheduled
          // comparison is made by comparing the trade id with the scheduled trade id
          trades?.firstWhereOrNull((trade) => trade.id == tradeId)?.isScheduled = true;
        });
      }
    }
    parent = json['parent'] != null ? JobModel.fromJson(json['parent'], jobId: id) : null;
    canvasserType = json['canvasser_type']?.toString();
    canvasser = (json['canvasser'] != null && (json['canvasser'] is Map)) ? UserLimitedModel.fromJson(json['canvasser']) : null;
    canvasserString = (json['canvasser'] is String) ? json['canvasser'] : null;
    jobLostDate = json['job_lost_date']?.toString();

    // Parse division-specific workflow stages when available
    // This provides alternative workflow configuration based on selected division
    if (json['workflow_by_division'] != null && json['workflow_by_division']?['stages'] != null) {
      stagesByDivision = <WorkFlowStageModel>[];
      json['workflow_by_division']['stages'].forEach((dynamic stage) {
        stagesByDivision!.add(WorkFlowStageModel.fromJson(stage));
      });
    }
  }

  JobModel.fromSearchJson(Map<String, dynamic> json) {
    id = json['job_id'];
    customerId = int.parse(json['id']);
    number = json['number'];
    name = json['job_name'];
    divisionCode = json['division_code'];
    altId = altId = !Helper.isValueNullOrEmpty(divisionCode) && !Helper.isValueNullOrEmpty(json['alt_id'])
        ? "${divisionCode!}-" + json['alt_id']
        : json['alt_id'];
    leadNumber = json['lead_number'];
    amount = json['amount'];
    taxable = json['taxable'];
    taxRate = json['tax_rate'];
    meta = (json['meta'] != null ? JobMetaModel.fromJson(json['meta']) : null);
    currentStage = (json['current_stage'] != null
        ? WorkFlowStageModel.fromJson(json['current_stage'])
        : null)!;
    List<String> temp = (json['duration']?.toString() ?? "").split(':');
    if (temp.isNotEmpty) {
      duration = "";
      for (int i = 0; i < temp.length; i++) {
        if (temp[i] != "0") {
          if (i == 0) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "day".tr : "days".tr} ";
          }
          if (i == 1) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "hour".tr : "hours".tr} ";
          }
          if (i == 2) {
            duration = "${duration!}${temp[i]} ${temp[i] == "1" ? "minute".tr : "minutes".tr} ";
          }
        }
      }
    }
    quickbookId = json['quickbook_id'];
    createdAt = json['created_at'];
    origin = json['origin'];
    quickbookSyncStatus = json['quickbook_sync_status'];
    qbDesktopId = json['qb_desktop_id'];
    updatedAt = json['updated_at'];
    bidCustomer = json['bid_customer'] is bool
        ? json['bid_customer']
            ? 1
            : 0
        : json['bid_customer'];
    isPmi = json['is_pmi'];
    pmiId = json['pmi_id'];
    pmiSyncStatus = json['pmi_sync_status'];
    isMultiJob = json['multi_job'] == 1;
    jobNoteCount =
        json['Job_note_count'] != null ? json['Job_note_count']['count'] : null;
    jobTaskCount =
        json['job_task_count'] != null ? json['job_task_count']['count'] : null;
    customer = CustomerModel.fromJson({
      "full_name": json['full_name'],
      "first_name": json['first_name'],
      "last_name": json['last_name'],
      "full_name_mobile": json['full_name_mobile'],
      "phones": {"data": json["phones"]},
    });

    address = (json['job_address'] != null
        ? AddressModel(
            id: -1,
            address: json['job_address']['address'] ?? "",
            addressLine1: json['job_address']['address_line_1'] ?? "",
            city: json['job_address']['city'] ?? "",
            state: StateModel(
                id: -1,
                name: json['job_address']['address'] ?? "",
                code: "",
                countryId: -1),
            zip: json['job_address']['zip'] ?? "",
          )
        : null);

    addressString = Helper.convertAddress(address).trim();

    fullJobAddress = json['full_job_address'];

    if (json['workflow'] != null && json['workflow']['stages'] != null) {
      stages = <WorkFlowStageModel>[];
      json['workflow']['stages'].forEach((dynamic stage) {
        stages!.add(WorkFlowStageModel.fromJson(stage));
      });
    }
    count =
        json['count'] != null ? JobCountModel.fromJson(json['count']) : null;
    isAppointmentRequired = json['appointment_required'] ?? false;
    archived = json['archived'] ? "true" : null;
    archivedCwp = json['archived_cwp']?.toString();
    isCallRequired = json['call_required'] ?? false;
    completionDate = json['completion_date']?.toString();
    contractSignedDate = json['contract_signed_date']?.toString();
    createdBy = int.tryParse(json['created_by']?.toString() ?? '');
    createdDate = json['created_date']?.toString();
    deletedAt = json['deleted_at']?.toString();
    description = json['description']?.toString();
    distance = json['distance']?.toString();
    ghostJob = json['ghost_job']?.toString();
    homeAdvisorJobId = json['home_advisor_job_id']?.toString();
    insurance = int.tryParse(json['insurance']?.toString() ?? '');
    isAllScheduleCompleted =
        int.tryParse(json['is_all_schedule_completed']?.toString() ?? '');
    materialDeliveryDate = json['material_delivery_date']?.toString();
    movedToPb = json['moved_to_pb']?.toString();
    otherTradeTypeDescription =
        json['other_trade_type_description']?.toString();
    pmiSyncMessage = json['pmi_sync_message']?.toString();
    pmiSyncType = json['pmi_sync_type']?.toString();
    purchaseOrderNumber = json['purchase_order_number']?.toString();
    sameAsCustomerAddress =
        int.tryParse(json['same_as_customer_address']?.toString() ?? '');
    scheduleCount = int.tryParse(json['schedule_count']?.toString() ?? '');
    scheduled = json['scheduled']?.toString();
    shareUrl = json['share_url']?.toString();
    sourceType = json['source_type']?.toString();
    spotioLeadId = json['spotio_lead_id']?.toString();
    stageChangedDate = json['stage_changed_date']?.toString();
    toBeScheduled = json['to_be_scheduled']?.toString();
    wpJob = int.tryParse(json['wp_job']?.toString() ?? '');
    appointments =
        (json['appointments'] != null && (json['appointments'] is Map))
            ? CustomerAppointments.fromJson(json['appointments'])
            : null;
    division = (json['division'] != null && (json['division'] is Map))
        ? DivisionModel.fromJson(json['division'])
        : null;
    followUpStatus =
        (json['follow_up_status'] != null && (json['follow_up_status'] is Map))
            ? JobFollowUpStatus.fromJson(json['follow_up_status'])
            : null;
    tradesString = "";
    if (json['trades'] != null) {
      trades = <CompanyTradesModel>[];
      json['trades'].forEach((dynamic v) {
        trades!.add(CompanyTradesModel(name: v));
      });
      if (trades!.isNotEmpty) {
        tradesString = trades!.map((e) => e.name).join(', ');
      }
    }
    projectCount = int.tryParse(json['projects_count']?.toString() ?? '');
    soldOutDate = json['sold_out_date']?.toString();
    parentId = json['parent_id'].toString().isEmpty
        ? null
        : int.parse(json['parent_id'].toString());
    isProject = parentId != null;
    isContactSameAsCustomer = json["contact_same_as_customer"] == 1;
    lostJob = json['lost_job'];
    jobLostDate = json['job_lost_date']?.toString();
    if(json['scheduled_trade_ids'] != null) {
      if(json['scheduled_trade_ids']['data'] != null) {
        scheduledTradeIds = [];
        json['scheduled_trade_ids']['data'].forEach((dynamic tradeId) {
          scheduledTradeIds?.add(tradeId);
        });
      }
    }
  }

  JobModel.fromProgressBoardJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number']?.toString();
    altId = json['alt_id']?.toString();
    name = json['name']?.toString();
    movedToPb = json['moved_to_pb']?.toString();
    archived = json['archived']?.toString();
    order = int.tryParse(json['order']?.toString() ?? '');
    isArchived = (json['job_archived']?.toString().isNotEmpty ?? false);
    isMultiJob = json['multi_job'] == 1;
    jobLostDate = json['job_lost_date']?.toString();
    customer = (json['customer'] != null && (json['customer'] is Map))
        ? CustomerModel.fromJson(json['customer'])
        : null;
    address = (json['address'] != null && (json['address'] is Map))
        ? AddressModel.fromJson(json['address'])
        : null;
    addressString = Helper.convertAddress(address).trim();
    currentStage =
        (json['current_stage'] != null && (json['current_stage'] is Map))
            ? WorkFlowStageModel.fromJson(json['current_stage'])
            : null;
    meta = (json['job_meta'] != null
        ? JobMetaModel.fromJson(json['job_meta'])
        : null);
    tradesString = "";
    if (json['trades'] != null && (json['trades'] is List)) {
      jobTypes = <JobTypeModel>[];
      json['trades'].forEach((dynamic trade) {
        jobTypes?.add(JobTypeModel.fromJson(trade));
      });
      jobTypesString = jobTypes!.map((e) => e?.name ?? "").join(', ');
    }
    if (json['work_types'] != null && (json['work_types'] is List)) {
      workTypes = [];
      (json['work_types'] is Map
              ? json['work_types']["data"]
              : json['work_types'])
          .forEach((dynamic v) {
        workTypes!.add(JobTypeModel.fromJson(v));
      });
      if (workTypes!.isNotEmpty) {
        workTypesString = workTypes!.map((e) => e?.name).join(', ');
      }
    }
    if (json['pb_entries']?["data"] != null &&
        (json['pb_entries']?["data"] is List)) {
      pbEntries = [];
      json['pb_entries']?["data"].forEach((dynamic progressBoardEntriesModel) {
        pbEntries?.add(
            ProgressBoardEntriesModel.fromJson(progressBoardEntriesModel));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['payment_receive']['total_amount'] = paymentReceivedTotalAmount;
    data['customer_id'] = customerId;
    data['number'] = number;
    data['name'] = name;
    data['division_code'] = divisionCode;
    data['alt_id'] = altId;
    data['lead_number'] = leadNumber;
    data['amount'] = amount;
    data['taxable'] = taxable;
    data['tax_rate'] = taxRate;
    data['meta'] = meta!.toJson();
    data['current_stage'] = currentStage?.toJson();
    data['duration'] = duration;
    data['quickbook_id'] = quickbookId;
    data['created_at'] = createdAt;
    data['origin'] = origin;
    data['quickbook_sync_status'] = quickbookSyncStatus;
    data['qb_desktop_id'] = qbDesktopId;
    data['updated_at'] = updatedAt;
    data['bid_customer'] = bidCustomer;
    data['is_pmi'] = isPmi;
    data['pmi_id'] = pmiId;
    data['pmi_sync_status'] = pmiSyncStatus;
    data['multi_job'] = isMultiJob;
    data['Job_note_count']['count'] = jobNoteCount;
    data['job_task_count']['count'] = jobTaskCount;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if(upcomingAppointment != null) {
      data['upcoming_appointment'] = upcomingAppointment!.toJson();
    }
    if(upcomingSchedules != null){
      data['upcoming_schedule'] = upcomingSchedules!.toJson();
    }
    if (count != null) {
      data['count'] = count!.toJson();
    }
    if (financialDetails != null) {
      data['financial_details'] = financialDetails!.toJson();
    }

    data['appointment_required'] = isAppointmentRequired;
    data['archived'] = isArchived ?? false ? 1 : 0;
    data['job_amount_approved_by'] = jobAmountApprovedBy == true ? 1 : 0;
    data['archived'] = archived;
    data['archived_cwp'] = archivedCwp;
    data['call_required'] = isCallRequired;
    data['completion_date'] = completionDate;
    data['contract_signed_date'] = contractSignedDate;
    data['created_by'] = createdBy;
    data['created_date'] = createdDate;
    data['deleted_at'] = deletedAt;
    data['description'] = description;
    data['distance'] = distance;
    data['ghost_job'] = ghostJob;
    data['home_advisor_job_id'] = homeAdvisorJobId;
    data['insurance'] = insurance;
    data['is_all_schedule_completed'] = isAllScheduleCompleted;
    data['material_delivery_date'] = materialDeliveryDate;
    data['moved_to_pb'] = movedToPb;
    data['other_trade_type_description'] = otherTradeTypeDescription;
    data['pmi_sync_message'] = pmiSyncMessage;
    data['pmi_sync_type'] = pmiSyncType;
    data['purchase_order_number'] = purchaseOrderNumber;
    data['same_as_customer_address'] = sameAsCustomerAddress;
    data['schedule_count'] = scheduleCount;
    data['scheduled'] = scheduled;
    data['share_url'] = shareUrl;
    data['source_type'] = sourceType;
    data['spotio_lead_id'] = spotioLeadId;
    data['stage_changed_date'] = stageChangedDate;
    data['to_be_scheduled'] = toBeScheduled;
    data['wp_job'] = wpJob;
    data['stage_last_modified'] = stageLastModified;
    data['has_profit_loss_worksheet'] = hasProfitLossWorksheet;

    if (appointments != null) {
      data['appointments'] = appointments!.toJson();
      data['appointment_date'] = appointmentDate;
    }
    if (division != null) {
      data['division'] = division!.toJson();
    }
    if (followUpStatus != null) {
      data['follow_up_status'] = followUpStatus!.toJson();
    }
    if(insuranceDetails != null){
      data['insurance_details'] = insuranceDetails!.toJson();
    }

    if (reps != null) {
      for (var v in reps!) {
        data['reps']['data'].add(v.toJson());
      }
    }
    if (flags != null) {
      for (var v in flags!) {
        data['flags']['data'].add(v!.toJson());
      }
    }
    if (estimators != null) {
      for (var v in estimators!) {
        data['estimators']['data'].add(v.toJson());
      }
    }
    if (labours != null) {
      for (var v in labours!) {
        data['labours']['data'].add(v.toJson());
      }
    }
    if (jobTypes != null) {
      for (var v in jobTypes!) {
        data['job_types'].add(v!.toJson());
      }
    }
    if (workTypes != null) {
      for (var v in workTypes!) {
        data['work_types'].add(v!.toJson());
      }
    }

    data['parent_id'] = parentId;

    if (contactPerson != null) {
      for (var v in contactPerson!) {
        data['contacts']["data"].add(v.toJson());
      }
    }
    if (deliveryDates != null) {
      for (var v in deliveryDates!) {
        data['delivery_dates']["data"].add(v.toJson());
      }
    }
    if (customFields != null) {
      for (var v in customFields!) {
        data['custom_fields']['data'].add(v!.toJson());
      }
    }
    if (changeOrder != null) {
      data['change_order'] = changeOrder!.toJson();
    }

    if(lostJob != null) {
      data['lost_job'] = lostJob;
    }

    data['canvasser_type'] = canvasserType;
    data['canvasser'] = canvasser;

    return data;
  }
}
