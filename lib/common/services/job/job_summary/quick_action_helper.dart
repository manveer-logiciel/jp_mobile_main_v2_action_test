import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/event_form_type.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/file_upload.dart';
import 'package:jobprogress/common/enums/invoice_form_type.dart';
import 'package:jobprogress/common/enums/task_form_type.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/files_listing/create_file_actions.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/follow_up_note/add_edit_model.dart';
import 'package:jobprogress/common/models/forms/hover_order_form/params.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/repositories/subscriber_details.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/file_picker.dart';
import 'package:jobprogress/common/services/files_listing/add_more_actions/more_actions.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/common/services/note_actions/quick_actions.dart';
import 'package:jobprogress/common/services/progress_board/add_to_progress_board.dart';
import 'package:jobprogress/common/services/upload.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_price_update_helper.dart';
import 'package:jobprogress/core/utils/message_send_helper.dart';
import 'package:jobprogress/core/utils/upgrade_plan_helper.dart';
import 'package:jobprogress/global_widgets/add_edit_work_crew_dialog_box/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/call_dialog/index.dart';
import 'package:jobprogress/global_widgets/send_message/index.dart';
import 'package:jobprogress/modules/follow_ups_notes/listing/widgets/add_edit_followup_note/index.dart';
import 'package:jobprogress/modules/job_note/add_edit_dialog_box/index.dart';
import 'package:jobprogress/modules/job_note/listing/controller.dart';
import 'package:jobprogress/routes/pages.dart';

class JobSummaryQuickActionHelper {

  void handleQuickActions(String id, JobModel jobModel, VoidCallback onActionComplete, {
    Function(FLModule)? onRecentFileUpdated
  }) {
    switch (id) {
      case "JobSummaryActions.call":
        openCustomerCallDialog(jobModel);
        break;
      case "JobSummaryActions.text":
        openCustomerTextDialog(jobModel);
        break;
      case "JobSummaryActions.email":
        goToEmailCompose(jobModel);
        break;
      case "JobSummaryActions.task":
        goToCreateTaskForm(jobModel);
        break;
      case "JobSummaryActions.jobProjectNote":
        openAddJobNoteDialog(jobModel,onActionComplete);
        break;
      case "JobSummaryActions.followUps":
        openAddFollowUpsDialogBox(jobModel, onActionComplete);
        break;
      case "JobSummaryActions.appointment":
        goToCreateAppointmentForm(jobModel);
        break;
      case "JobSummaryActions.message":
        openSendMessageSheet(jobModel);
        break;
      case "JobSummaryActions.photo":
        uploadFile(jobModel: jobModel);
        break;
      case "JobSummaryActions.measurement":
        openAddMoreFileListingQuickAction(jobModel, FLModule.measurements);
        break;
      case "JobSummaryActions.estimating":
        openAddMoreFileListingQuickAction(jobModel, FLModule.estimate, onRecentFileUpdated: onRecentFileUpdated);
        break;
      case "JobSummaryActions.formProposal":
        openAddMoreFileListingQuickAction(jobModel, FLModule.jobProposal, onRecentFileUpdated: onRecentFileUpdated);
        break;
      case "JobSummaryActions.jobProjectPrice":
        openJobProjectPriceDialog(jobModel);
        break;
      case "JobSummaryActions.workCrew":
        openAddWorkCrewDialog(jobModel, onActionComplete);
        break;
      case "JobSummaryActions.scheduleJobProject":
        goToScheduleJobProject(jobModel);
        break;
      case "JobSummaryActions.invoice":
        goToInvoiceOrChangeOrderForm(jobModel, InvoiceFormType.invoiceCreateForm);
        break;
      case "JobSummaryActions.changeOrder":
        goToInvoiceOrChangeOrderForm(jobModel, InvoiceFormType.changeOrderCreateForm);
        break;
      case "JobSummaryActions.bill":
        goToBillForm(jobModel);
        break;
      case "JobSummaryActions.refund":
        goToRefundForm(jobModel);
        break;
      case "JobSummaryActions.clockIn":
        goToClockInOutForm(jobModel, isClockedInButton: true);
        break;
      case "JobSummaryActions.clockOut":
        goToClockInOutForm(jobModel, isClockedInButton: false);
        break;
      case "JobSummaryActions.progressBoard":
        addInProgressBoard(jobModel);
        break;
      case "JobSummaryActions.file":
        uploadDocument(jobModel);
        break;
      case "JobSummaryActions.scan":
        uploadDocument(jobModel, doScan: true);
        break;
    }

  }

  void openCustomerCallDialog(JobModel jobModel) {
    final List<CustomerInfo> customerInfo = [];
    jobModel.customer?.phones?.forEach((element) {
      customerInfo.add(CustomerInfo(label: element.label.toString().capitalize!, phone: element));
    });
    showJPGeneralDialog(
      isDismissible: false,
      child: (_) {
        return JPCallDialog(
          jobModel: jobModel,
          customerInfo: customerInfo,
        );
      }
    );
  } 

  void uploadFile({required JobModel jobModel}) {
    final params = FileUploaderParams(
      type: FilesListingService.moduleTypeToUploadType(FLModule.jobPhotos),
      job: jobModel,
      parentId: int.tryParse(jobModel.meta?.defaultPhotoDir ?? '-1') ?? -1,
      onlyShowPhotosOption: true
    );

    UploadService.uploadFrom(from: UploadFileFrom.popup, params: params);

  }

  void openCustomerTextDialog(JobModel jobModel) {
    SaveMessageSendHelper().saveMessageLogs(
      jobModel.customer!.phones![0].number!, 
      job: jobModel, 
      customerModel: jobModel.customer,
    );
  }

  Future<void> goToEmailCompose(JobModel jobModel) async {
    await Get.toNamed(Routes.composeEmail, arguments: {
      'action': 'job_detail',
      'jobId': jobModel.id,
    });
  }

  Future<void> goToCreateTaskForm(JobModel jobModel) async {
    await Get.toNamed(Routes.createTaskForm, arguments: {
      NavigationParams.pageType: TaskFormType.createForm,
      NavigationParams.jobModel: jobModel,
    });
  }

  void openAddJobNoteDialog(JobModel jobModel, VoidCallback onActionComplete) {
    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: AddEditJobNoteDialogBox(
            jobModel: jobModel,
            controller: JobNoteListingController(),
            dialogController: dialogController,
            jobId: jobModel.id,
            onApply: onActionComplete
          ),
        );
      }
    );
  }

  void openAddFollowUpsDialogBox(JobModel jobModel, VoidCallback onActionComplete) {
    List<Map<String, dynamic>> data = NoteService.getSuggestionsList(jobModel);

    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: AddEditFollowUpNote(
            onApply: onActionComplete,
            job: jobModel,
            suggestions: data,
            addEditFollowUpModel: AddEditFollowUpModel(
              jobId: jobModel.id,
              stageCode: jobModel.currentStage?.code,
              customerId: jobModel.customerId,
            ),
          ),
        );
      }
    );
  }

  Future<void> goToCreateAppointmentForm(JobModel jobModel) async {
    await Get.toNamed(Routes.createAppointmentForm, arguments: {
      NavigationParams.pageType: AppointmentFormType.createJobAppointmentForm,
      NavigationParams.appointment: AppointmentModel.fromJobModel(jobModel)
    });
  }

  void openSendMessageSheet(JobModel jobModel) {
    showJPBottomSheet(
      isScrollControlled: true,
      enableInsets: true,
      child: (_) {
        return SendMessageForm(
          jobData: jobModel,
          onMessageSent: () {
            Helper.showToastMessage('message_sent'.tr);
          },
        );
      },
    );
  }


  Future<void> openAddMoreFileListingQuickAction(JobModel jobModel, FLModule type, {
    Function(FLModule)? onRecentFileUpdated
  }) async {
    bool showUpgradeDialog = await UpgradePlanHelper.showUpgradePlanOnDocumentLimit(); 
    if(showUpgradeDialog) {
      return;
    }
    SubscriberDetailsModel? subscriberDetails;
    if (type == FLModule.measurements) {
      final response = await SubscriberDetailsRepo.getDetails();
      subscriberDetails = response['details'];
    }
    FilesListingMoreActionsService.openMoreAction(
      CreateFileActions(
        type: type,
        jobModel: jobModel,
        subscriberDetails: subscriberDetails,
        fileList: [],
        onActionComplete: (FilesListingModel model, action) {
          switch (action) {
            case "FLQuickActions.upload":
              final params = FileUploaderParams(
                type: FilesListingService.moduleTypeToUploadType(type),
                job: jobModel,
              );
              UploadService.uploadFrom(from: UploadFileFrom.popup, params: params);
              break;

            case "FLQuickActions.hover":
              navigateToHoverForm(jobModel);
              break;
            default:
              onRecentFileUpdated?.call(type);
              break;
          }
        }
      ),
    );
  }

  Future<void> navigateToHoverForm(JobModel? job) async {
    await Get.toNamed(Routes.hoverOrderForm, arguments: {
      NavigationParams.params : HoverOrderFormParams(
        customer: job?.customer,
        jobId: job?.id,
        hoverUser: job?.hoverJob?.hoverUser
      )
    });
  }

  void openJobProjectPriceDialog(JobModel jobModel) {
    JobPriceUpdateHelper.openJobPriceDialog(
      jobId: jobModel.id,
      onApply: () {
        Helper.showToastMessage("job_price_update_requested".tr);
        Get.back();
      },
    );
  }

  void openAddWorkCrewDialog(JobModel jobModel,VoidCallback onActionComplete) async {
    List<String> crewUsersIds = jobModel.workCrew?.map((user) => user.id.toString()).toList() ?? [];
    List<String> contractorsUsersIds = jobModel.subContractors?.map((user) => user.id.toString()).toList() ?? [];

    // Get the company crew list using the user IDs of the work crew
    final companyCrewList = await FormsDBHelper.getAllUsers(
      crewUsersIds, 
      withSubContractorPrime: false,
      divisionIds: [jobModel.division?.id]);

    // Get the subcontractors users using the user IDs of the subcontractors
    final contractorsUsers = await FormsDBHelper.getAllUsers(
      contractorsUsersIds, 
      onlySub: true,
      useCompanyName: true, 
      isSubTextVisible: false, 
      divisionIds: [jobModel.division?.id]);
      
    final tagList = await FormsDBHelper.getAllTags();

    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: AddEditWorkCrewDialogBox(
            jobModel: jobModel,
            companyCrewList: companyCrewList,
            subcontractorList: contractorsUsers,
            tagList: tagList,
            dialogController: dialogController,
            onFinish: (workCrewRepository) {
              onActionComplete();
            },
          ),
        );
      }
    ); 
  }

  Future<void> goToScheduleJobProject(JobModel jobModel) async {
    await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
      NavigationParams.pageType: EventFormType.createScheduleForm,
      NavigationParams.jobModel: jobModel,
    });
  }

  Future<void> goToInvoiceOrChangeOrderForm(JobModel jobModel, InvoiceFormType formType) async {
    await Get.toNamed(Routes.invoiceForm, arguments: {
      NavigationParams.jobId: jobModel.id,
      NavigationParams.pageType: formType,
    });
  }

  Future<void> goToBillForm(JobModel jobModel) async {
    await Get.toNamed(Routes.billForm, arguments: {
      NavigationParams.jobId: jobModel.id,
      NavigationParams.customerId: jobModel.customerId,
    });
  }

  Future<void> goToRefundForm(JobModel jobModel) async {
    await Get.toNamed(Routes.refundForm, arguments: {
      NavigationParams.jobId: jobModel.id,
      NavigationParams.customerId: jobModel.customerId,
    });
  }

  Future<void> goToClockInOutForm(JobModel jobModel, {required bool isClockedInButton}) async {
    if (ClockInClockOutService.checkInDetails != null && isClockedInButton) {
      ClockInClockOutService.openAutoClockedOutConfirmationDialog(jobModel);
    } else {
      ClockInClockOutService.setJob(jobModel); // set job in clock-in form
      await Get.toNamed(Routes.clockInClockOut, arguments: {
        NavigationParams.jobModel: jobModel,
      });
    }
    if (ClockInClockOutService.checkInDetails == null) {
      ClockInClockOutService.setJob(null); // remove job after back from clock-in form
    }
  }

  Future<void> addInProgressBoard(JobModel jobModel) async {
    AddToProgressBoardHelper.addInProgressBoard(
      jobModel: jobModel,
      index: 0,
      onCallback: ({callbackType, currentIndex, job}) {
        
      },
    );
  }

  Future<void> uploadDocument(JobModel jobModel, {
    bool doScan = false,
  }) async {
    FileUploaderParams params = FileUploaderParams(
        type: FileUploadType.photosAndDocs,
        job: jobModel,
        jobId: jobModel.id,
        parentId: int.parse(jobModel.meta?.defaultPhotoDir ?? '0'));

    if (doScan) {
      // Scanning document
      UploadService.scanDocAndAddToQueue(params);
    } else {
      // getting files/docs from storage
      List<String> docs = await FilePickerService.pickFile();
      // if picked files are not empty add them to upload queue
      if(docs.isNotEmpty) {
        UploadService.parseParamsAndAddToQueue(docs, params);
      }
    }
  }
}