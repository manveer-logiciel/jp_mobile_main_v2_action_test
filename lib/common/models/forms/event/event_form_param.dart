import '../../../../modules/calendar/event/controller.dart';
import '../../../enums/event_form_type.dart';
import '../../job/job.dart';
import '../../schedules/schedules.dart';

class EventFormParams {
  final EventFormController? controller;
  final SchedulesModel? schedulesModel;
  final JobModel? jobModel;
  final EventFormType? pageType;
  final Function(dynamic val)? onUpdate;

  List<int?>? repIds;
  List<int?>? subContractorIds;
  String? title;
  bool? isFullDay;
  List<int?>? workOrderIds;
  List<int?>? materialListIds;
  String? date;
  String? type;
  bool? isSubjectEdited;

  EventFormParams({
    this.controller,
    this.schedulesModel,
    this.jobModel,
    this.pageType,
    this.onUpdate,

    this.repIds,
    this.subContractorIds,
    this.title,
    this.isFullDay,
    this.workOrderIds,
    this.materialListIds,
    this.date,
    this.type,
    this.isSubjectEdited,
  });

  EventFormParams.fromJson(Map<String, dynamic> json, {
    this.controller, this.schedulesModel, this.jobModel,
    this.pageType, this.onUpdate}) {
    if (json['rep_ids'] != null && (json['rep_ids'] is List)) {
      repIds = <int>[];
      json['rep_ids'].forEach((dynamic data) {
        repIds?.add(int.tryParse(data.toString()));
      });
    }
    if (json['sub_contractor_ids'] != null && (json['sub_contractor_ids'] is List)) {
      subContractorIds = <int>[];
      json['sub_contractor_ids'].forEach((dynamic data) {
        subContractorIds?.add(int.tryParse(data.toString()));
      });
    }
    title = json['title']?.toString();
    isFullDay = json['full_day'] == 1;
    if (json['work_order_ids'] != null && (json['work_order_ids'] is List)) {
      workOrderIds = <int>[];
      json['work_order_ids'].forEach((dynamic data) {
        workOrderIds?.add(int.tryParse(data.toString()));
      });
    }
    if (json['material_list_ids'] != null && (json['material_list_ids'] is List)) {
      materialListIds = <int>[];
      json['material_list_ids'].forEach((dynamic data) {
        materialListIds?.add(int.tryParse(data.toString()));
      });
    }
    date = json['date']?.toString();
    type = json['type']?.toString();
    isSubjectEdited = json['subject_edited'] == 1;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (repIds != null) {
      data['rep_ids'] = <int>[];
      for (var repId in repIds!) {
        data['rep_ids'].add(repId);
      }
    }
    if (subContractorIds != null) {
      data['sub_contractor_ids'] = <int>[];
      for (var subContractorId in subContractorIds!) {
        data['sub_contractor_ids'].add(subContractorId);
      }
    }
    data['title'] = title;
    data['full_day'] = isFullDay ?? false ? 1 : 0;
    if (workOrderIds != null) {
      data['work_order_ids'] = <int>[];
      for (var workOrderId in workOrderIds!) {
        data['work_order_ids'].add(workOrderId);
      }
    }
    if (materialListIds != null) {
      data['material_list_ids'] = <int>[];
      for (var materialListId in materialListIds!) {
        data['material_list_ids'].add(materialListId);
      }
    }
    data['date'] = date;
    data['type'] = type;
    data['subject_edited'] = isSubjectEdited ?? false ? 1 : 0;
    return data;
  }
}