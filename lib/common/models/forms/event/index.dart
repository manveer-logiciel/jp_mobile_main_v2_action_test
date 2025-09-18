import 'dart:ui';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/reminder.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/constants/date_formats.dart';
import '../../../../core/constants/dropdown_list_constants.dart';
import '../../../../core/utils/date_time_helpers.dart';
import '../../../../core/utils/single_select_helper.dart';
import '../../../enums/event_form_type.dart';
import '../../../services/forms/parsers.dart';
import '../../../services/forms/value_selector.dart';
import '../../attachment.dart';
import '../../job/job.dart';
import '../../schedules/schedules.dart';

class EventFormData {

  EventFormData({
    required this.update,
    required this.schedulesModel,
    this.jobModel,
    this.pageType,
    this.workOrderId
  });

  EventFormType? pageType;
  final VoidCallback update; // update method from respective controller to refresh ui from service itself
  final SchedulesModel? schedulesModel; // used to set up form data
  JobModel? jobModel; // used to store selected job data

  // form field controllers
  JPInputBoxController titleController = JPInputBoxController();
  JPInputBoxController tradesController = JPInputBoxController();
  JPInputBoxController companyCrewController = JPInputBoxController();
  JPInputBoxController labourContractorsController = JPInputBoxController();
  JPInputBoxController dateTimeController = JPInputBoxController();
  JPInputBoxController recurringFrequencyController = JPInputBoxController(text: DropdownListConstants.recurringDurationList.first.label);
  JPInputBoxController recurringOccurrencesController = JPInputBoxController(text: "2");

  List<JPMultiSelectModel> crewUsers = []; // used to store users
  List<JPMultiSelectModel> contractorsUsers = []; // used to store users
  List<JPMultiSelectModel> trades = []; // used to store users
  List<JPMultiSelectModel> tagList = [];

  List<ReminderModel> notificationReminders = [];

  // form toggles
  bool isAllDayReminderSelected = false;
  bool isUserNotificationSelected = false;
  bool defaultRecurringSelected = false;
  bool isRecurringSelected = false;
  bool isTitleEditedOnce = false;
  bool isLoading = true;
  bool isOnlyThis = false;

  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user
  List<AttachmentResourceModel> uploadedAttachments = []; // contains attachments coming from server

  String? startDateTime = DateTime.now().toString();
  String? endDateTime = DateTime.now().toString();
  String selectedRecurringType = DropdownListConstants.recurringDurationList.first.id;
  String? errorText;
  String? workOrderId;

  Map<String, dynamic> initialJson = {}; // helps in data changes comparison

  // setFormData(): set-up form data to be pre-filled in form
  void setFormData() {
    if (schedulesModel != null) {
      // setting task details title
      titleController.text = schedulesModel?.title ?? "";
      if(pageType == EventFormType.editScheduleForm) {
        isTitleEditedOnce = true;
      }

      for(int i = 0; i < trades.length; i++) {
        for(int j = 0; j < (schedulesModel?.trades?.length ?? 0); j++) {
          if(trades[i].id == schedulesModel?.trades?[j].id?.toString()) {
            trades[i].isSelect = true;
          }
        }
      }

      FormValueSelectorService.parseMultiSelectData(trades, tradesController);

      isAllDayReminderSelected = schedulesModel?.fullday ?? false;

      // Setting date and time
      startDateTime = DateTime.parse(DateTimeHelper.formatDate(schedulesModel?.startDateTime ?? DateTime.now().toString(), DateFormatConstants.dateTimeServerFormat)).toString();
      endDateTime = DateTime.parse(DateTimeHelper.formatDate(schedulesModel?.endDateTime ?? DateTime.now().add(const Duration(hours: 1)).toString(), DateFormatConstants.dateTimeServerFormat)).toString();

    }

    if(schedulesModel?.repeat != null && schedulesModel?.occurence != null) {
      selectedRecurringType = schedulesModel!.repeat!;
      recurringOccurrencesController.text = schedulesModel!.occurence!.toString();
      recurringFrequencyController.text = SingleSelectHelper.getSelectedSingleSelectValue(DropdownListConstants.recurringDurationList, selectedRecurringType);
      isRecurringSelected = true;
      isOnlyThis = true;
    }

    notificationReminders.addAll(schedulesModel?.remainder ?? []);
    isUserNotificationSelected = notificationReminders.isNotEmpty;

    uploadedAttachments.addAll(schedulesModel?.attachments ?? []);
    attachments.addAll(uploadedAttachments);

    if(jobModel != null)  setScheduleTitle();

    initialJson = eventFormJson();
    update();
  }

  void setScheduleTitle () {
    if(pageType == EventFormType.createScheduleForm && !isTitleEditedOnce) {

      titleController.text = "";

      ///   Sub Contractor
      titleController.text = titleController.text + (contractorsUsers.where((contractor) => contractor.isSelect).map((e) => e.label).join(', '));

      if((contractorsUsers.firstWhereOrNull((element) => element.isSelect) != null)) {
        titleController.text = "${titleController.text} / ";
      }

      ///   Company Crew
      titleController.text = titleController.text + (crewUsers.where((crew) => crew.isSelect).map((e) => e.label).join(', '));

      if((crewUsers.firstWhereOrNull((element) => element.isSelect) != null)) {
        titleController.text = "${titleController.text} / ";
      }

      ///   Customer Name
      titleController.text = titleController.text + (jobModel?.customer?.fullNameMobile ?? "");

      if(titleController.text.isNotEmpty) {
        titleController.text = "${titleController.text} / ";
      }

      ///   Trade
      titleController.text = titleController.text + (trades.where((trade) => trade.isSelect).map((e) => e.label).join(', '));

      if((trades.firstWhereOrNull((element) => element.isSelect) != null)) {
        titleController.text = "${titleController.text} / ";
      }
      ///   job/project #
      if((jobModel?.altId?.isNotEmpty ?? false) && (jobModel?.parentId?.toString().isNotEmpty ?? false)) {
        titleController.text = "${titleController.text}project # " ;
      } else if(jobModel?.altId?.isNotEmpty ?? false) {
        titleController.text = "${titleController.text}job # ";
      }

      String divCode = jobModel?.divisionCode ?? jobModel?.division?.code ?? "";
      titleController.text = titleController.text + (divCode.isNotEmpty ? ("$divCode-${jobModel?.altId ?? ""}") : (jobModel?.altId ?? ""));

      ///   remove last "/" if exist
      String temp = titleController.text.trim();
      if(temp.substring(temp.length - 1) == "/") {
        titleController.text = temp.substring(0, temp.length - 1);
      }
    }
  }


  Map<String, dynamic> eventFormJson() {
    final data = <String, dynamic>{};

    data['id'] = schedulesModel?.id;
    data['title'] = titleController.text;

    var repIds = FormValueParser.multiSelectToSelectedIds(crewUsers);
    data['rep_ids[]'] = repIds?.isEmpty ?? true ? '[]' : repIds;

    var subContractorIds = FormValueParser.multiSelectToSelectedIds(contractorsUsers);
    data['sub_contractor_ids[]'] = subContractorIds?.isEmpty ?? true ? '[]' : subContractorIds;


    data['full_day'] = isAllDayReminderSelected ? 1 : 0;

    if(isAllDayReminderSelected) {
      data['date'] = DateTimeHelper.format(startDateTime.toString(), DateFormatConstants.dateTimeServerFormat);
    } else if((startDateTime?.isNotEmpty ?? false) && (endDateTime?.isNotEmpty ?? false)) {
      data['start_date_time'] = DateTimeHelper.format(startDateTime, DateFormatConstants.dateTimeServerFormat);
      data['end_date_time'] = DateTimeHelper.format(endDateTime, DateFormatConstants.dateTimeServerFormat);
    }

    if(pageType == EventFormType.createForm || pageType == EventFormType.editForm) {
      data['type'] = "event";
      data['subject_edited'] = pageType == EventFormType.editForm ? 0 : 1;
      data["only_this"] = !isOnlyThis ? 1 : 0;
      if(isRecurringSelected) {
        data['repeat'] = selectedRecurringType;
        data['occurence'] = recurringOccurrencesController.text;
      }
    }

    if(pageType == EventFormType.createScheduleForm || pageType == EventFormType.editScheduleForm) {

      data['job_id'] = jobModel?.id;

      // trade section
      var tradeIds = FormValueParser.multiSelectToSelectedIds(trades);
      data['trade_ids[]'] = tradeIds?.isEmpty ?? true ? null : tradeIds;

      // Work Order Notes section
      var workCrewNoteIds = schedulesModel?.workCrewNote?.map((workOrderNote) => workOrderNote.id).toList();
      data['work_crew_note_ids[]'] = workCrewNoteIds?.isEmpty ?? true ? null : workCrewNoteIds;

      // Work order section
      var workOrderIds = schedulesModel?.workOrder?.map((workOrder) => workOrder.id).toList();
      if (workOrderId != null) {
        // Adding work order file id to link schedule with
        workOrderIds ??= [];
        workOrderIds.add(int.parse(workOrderId!));
      }
      data['work_order_ids[]'] = workOrderIds?.isEmpty ?? true ? null : workOrderIds;

      // material section
      var materialListIds = schedulesModel?.materialList?.map((material) => material.id).toList();
      data['material_list_ids[]'] = materialListIds?.isEmpty ?? true ? null : materialListIds;

      if(isUserNotificationSelected) {
        data['reminders'] = notificationReminders.map((reminder) => {
          'type' : reminder.type,
          'minutes' : reminder.minutes
        }).toList();
      }

      if(isRecurringSelected) {
        data['repeat'] = selectedRecurringType;
        data['occurence'] = recurringOccurrencesController.text;
      }

      data["only_this"] = !isOnlyThis ? 1 : 0;

      // Attachments section
      if(attachments.isNotEmpty || uploadedAttachments.isNotEmpty) {

        List<AttachmentResourceModel> attachmentsToUpload = [];
        List<AttachmentResourceModel> attachmentsToDelete = [];

        attachmentsToUpload = attachments.where((attachment) => !uploadedAttachments.contains(attachment)).toList();
        attachmentsToDelete = uploadedAttachments.where((attachment) => attachments.isEmpty || !attachments.contains(attachment)).toList();

        // Map attachments for API payload
        // Using attachment.type with fallback to "resource" for backward compatibility
        // Some attachments may have null type due to legacy data or when created without explicit type
        // The "resource" type is the default expected by the backend API
        data['attachments'] = attachmentsToUpload.map((attachment) => {
          'type': attachment.type ?? "resource",
          'value': attachment.id,
        }).toList();

        for(int i = 0; i < (attachmentsToDelete.length); i++) {
          data['delete_attachments[$i]'] = attachmentsToDelete[i].id.toString();
        }
      }

    }

    return data;
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = eventFormJson();
    return initialJson.toString() != currentJson.toString();
  }

 bool checkIfSpecificFieldChanged() {
  final currentJson = eventFormJson();
  bool hasChanged = false;
  
  hasChanged = [
    'date',
    'sub_contractor_ids[]',
    'rep_ids[]',
    'full_day',
    'start_date_time',
    'end_date_time',
  ].any((field) => initialJson[field].toString() != currentJson[field].toString());
  return hasChanged;
}
}