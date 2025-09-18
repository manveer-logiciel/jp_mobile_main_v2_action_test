import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/appointment_form_type.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jobprogress/common/enums/job_quick_action_callback_type.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/job/job_follow_up_status.dart';
import 'package:jobprogress/common/services/job_customer_flags.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/feature_flag_constant.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/constants/quick_book_error.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/job_price_update_helper.dart';
import '../../../global_widgets/bottom_sheet/controller.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../global_widgets/delete_dialog/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../../enums/calendars.dart';
import '../../enums/event_form_type.dart';
import '../../enums/job.dart';
import '../../enums/parent_form_type.dart';
import '../../enums/quick_action_type.dart';
import '../../models/job/job.dart';
import '../../repositories/job.dart';
import '../feature_flag.dart';
import '../progress_board/add_to_progress_board.dart';
import '../quick_book.dart';
import 'index.dart';

class JobQuickActionHelper {

  List<JPMultiSelectModel> filterByMultiList = [];
  List<JPMultiSelectModel> progressBoardsList = [];
  late final void Function(dynamic model,dynamic action)? deleteCallback;
  late final void Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? quickActionCallback;

  void openQuickActions({
    JobModel? job,
    int? index,
    Function({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType})? quickActionCallback,
    Function(dynamic model,dynamic action)? deleteCallback, CJListType? listType,
    QuickActionType? quickActionType}) {
    this.deleteCallback = deleteCallback;
    this.quickActionCallback = quickActionCallback;
    JobService.openQuickActions(job: job!..listType = listType, jobIndex: index!, listType: listType, callback: handleQuickActionCallback, quickActionType: quickActionType);
  }

  Future<void> handleQuickActionCallback(dynamic jobModel, String action, int index) async {
    switch (action) {
      case "edit_job":
        navigateToJobScreen(jobModel);
        break;
      case "edit_customer":
        navigateToCustomer(jobModel.customerId);
        break;
      case "view":
        navigateToDetailScreen(jobID: jobModel.id, currentIndex: index);
        break;
      case "email":
        Helper.navigateToComposeScreen(
          arguments: { 
            'jobId': jobModel.id,
            'action': 'job_detail',
          });
        break;
      case "call":
        Helper.launchCall(jobModel?.phoneNumber ?? "");
        break;
      case "job_flags":
        JobCustomerFlags.showFlagsBottomSheet(
          isQuickAction: true,
          flagCallbackForJob: quickActionCallback,
          jobModel: jobModel,
          index: index,
          id: jobModel.id,
        );
        break;
      case "share_web_page":
        shareWebPage(job: jobModel, index: index);
        break;
      case "add_to_progress":
        selectProgressBoards(jobModel, index);
        break;
      case "in_progress_boards":
        selectInProgressBoards(jobModel, index);
        break;
      case "schedule_project":
      case "schedule_job":
        navigateToScheduleJob(jobModel);
        break;
      case "project_note":
      case "job_note":
        Get.toNamed(Routes.jobNoteListing, arguments: {'jobId': jobModel!.id, 'customerId': jobModel.customerId});
        break;
      case "follow_up_call":
        Get.toNamed(Routes.followUpsNoteListing, arguments: {'jobId': jobModel!.id,  'customerId': jobModel!.customerId});
        break;
      case "create_appointment":
       navigateToCreateAppointment(jobModel);
        break;
      case "project_price":
      case "job_price":
        updateTotalJobPrice(jobModel, index);
        break;
      case "archive":
        archiveJob(jobModel, index);
        break;
      case "unarchive":
        unarchiveJob(jobModel, index);
        break;
      case "mark_lost_job":
        markAsLostJob(jobModel, index);
        break;
      case "reinstate_job":
        reinstateJob(jobModel, index);
        break;
      case "delete":
        deleteJob(job: jobModel);
        break;
      case "quickbooks_error":
        QuickBookService.openQuickBookErrorBottomSheet(QuickBookSyncErrorConstants.jobEntity, jobModel!.id.toString());
        break;
      case "edit_project":
        navigateToEditProjectScreen(jobModel);
        break;
      case "appointment":
        quickActionCallback?.call(callbackType: JobQuickActionCallbackType.appointment, job: jobModel);
        break;
      case "job_scheduled":
        navigateToScheduledDetailScreen(jobModel);
        break;
      case "mark_as_awarded":
        quickActionCallback?.call(callbackType: JobQuickActionCallbackType.markAsAwarded, job: jobModel);
        break;
      default:
    }
  }

  ///////////////////////    NAVIGATE TO DETAIL SCREEN   ///////////////////////

  void navigateToDetailScreen({int? jobID, int? currentIndex}){
    Get.toNamed(Routes.jobDetailing, arguments: {NavigationParams.jobId: jobID,})
        ?.then((jobModel) {
      quickActionCallback!(job: jobModel, currentIndex: currentIndex, callbackType: JobQuickActionCallbackType.navigateToDetailScreenCallback);
    });
  }

  ////////    DELETE CUSTOMER   ///////

  void deleteJob({required JobModel job}) {
    showJPGeneralDialog(
      child:(controller) => DeleteDialogWithPassword(
        actionFrom: 'job',
        model : job,
        title: job.listType == CJListType.projectJobs ? "delete_project".tr.toUpperCase() : "delete_job".tr.toUpperCase(),
        deleteCallback: deleteCallback,
      )
    );
  }
  
  //////////    MARK AS LOST JOB    /////////

  void markAsLostJob(JobModel jobModel, int index) {
    showJPGeneralDialog(
      isDismissible: true,
      child: (JPBottomSheetController controller) {
        return JPQuickEditDialog(
          type: JPQuickEditDialogType.textArea,
          title: "enter_description".tr.toUpperCase(),
          errorText: "provide_description".tr,
          prefixTitle: "cancel".tr,
          suffixTitle: "mark_as_lost".tr,
          onPrefixTap: (val) => Get.back(),
          position: JPQuickEditDialogPosition.center,
          disableButton: controller.isLoading,
          suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
          onSuffixTap: (val) {
            controller.toggleIsLoading();
            updateJobAsLostOnServer(jobModel, val, index);
          },
        );
      });
  }

  Future<void> updateJobAsLostOnServer (JobModel jobModel, String val, int index) async {
    try {
      Map<String, dynamic> queryParams = {
        "follow_up": [{
          "customer_id": jobModel.customerId,
          "job_id": jobModel.id,
          "mark": "lost_job",
          "note": val,
          "stage_code": jobModel.currentStage?.code ?? ""
        }]
      };

      var response = await JobRepository.markAsLostJob(queryParams);
      if (response['status'] == 200) {
        Helper.showToastMessage(jobModel.listType == CJListType.projectJobs ? "project_marked_as_lost".tr : "job_marked_as_lost".tr);
        jobModel.followUpStatus = JobFollowUpStatus.fromJson(response['follow_ups'][0]);
        quickActionCallback!(callbackType: JobQuickActionCallbackType.markAsLostJobCallback, job: jobModel, currentIndex: index);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  //////////    REINSTATE JOB    /////////

  void reinstateJob(JobModel jobModel, int index) {
    showJPBottomSheet(
      isDismissible: false,
      child: (JPBottomSheetController controller) {
        return JPConfirmationDialog(
          icon: Icons.info_outline,
          title: jobModel.listType == CJListType.projectJobs ? "reinstate_project".tr.toUpperCase() : "reinstate_job".tr.toUpperCase(),
          subTitle: jobModel.listType == CJListType.projectJobs ? "reinstate_project_conformation_message".tr : "reinstate_job_conformation_message".tr,
          type: JPConfirmationDialogType.message,
          prefixBtnText: "cancel".tr,
          suffixBtnText: "reinstate_now".tr,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButtons: controller.isLoading,
          onTapSuffix: () {
            controller.toggleIsLoading();
            reinstateJobOnServer(jobModel, index);
          },
        );
      });
  }

  Future<void> reinstateJobOnServer (JobModel jobModel, int index) async {
    try {
      Map<String, dynamic> queryParams = {
        "id": jobModel.followUpStatus!.id
      };
      var response = await JobRepository.reinstateJob(queryParams);
      if (response == 200) {
        Helper.showToastMessage(jobModel.listType == CJListType.projectJobs ? "project_reinstated".tr : "job_reinstated".tr);
        quickActionCallback!(callbackType: JobQuickActionCallbackType.reinstateJob, job: jobModel, currentIndex: index);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  //////////    ARCHIVE JOB    /////////

  void archiveJob(JobModel jobModel, int index,) {
    showJPBottomSheet(
      isDismissible: false,
      child: (JPBottomSheetController controller) {
        if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures])) {
          return JPConfirmationDialogWithSwitch(
            title: jobModel.listType == CJListType.projectJobs ? "archive_project".tr.toUpperCase():  "archive_job".tr.toUpperCase(),
            subTitle: jobModel.listType == CJListType.projectJobs ? "project_archive_conformation".tr : "job_archive_conformation".tr,
            toggleTitle: FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]) ? "show_on_customer_web_page".tr : "",
            suffixBtnText: 'archive'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onPrefixTap: (val) => Get.back(),
            onSuffixTap: (val) {
              controller.toggleIsLoading();
              archiveJobOnServer(jobModel, index, true, val: val).trackArchiveEvent(MixPanelEventTitle.jobArchive);
            },
          );
        } else {
          return JPConfirmationDialog(
            title: "confirmation".tr,
            icon: Icons.archive_outlined,
            subTitle: jobModel.listType == CJListType.projectJobs ? "project_archive_conformation".tr : "job_archive_conformation".tr,
            suffixBtnText: 'archive'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            onTapPrefix: () => Get.back(),
            onTapSuffix: () {
              controller.toggleIsLoading();
              archiveJobOnServer(jobModel, index, true).trackArchiveEvent(MixPanelEventTitle.jobArchive);
            },
          );
        }

      });
  }

  Future<void> archiveJobOnServer (JobModel jobModel, int index, bool isArchive, {bool? val}) async {
    try {
      Map<String, dynamic> queryParams = {
        "archive": isArchive ? 1: 0,
        "archive_cwp": val ?? false ? 1 : 0
      };
      if(!isArchive) {
        queryParams.removeWhere((key, value) => key == "archive_cwp");
      }
      var response = await JobRepository.archiveJob(jobModel.id.toString(), queryParams);
      if (response == 200) {
        Helper.showToastMessage(jobModel.listType == CJListType.projectJobs
            ? isArchive ? "project_archived".tr : "project_unarchived".tr
            : isArchive ? "job_archived".tr : "job_unarchived".tr);
        quickActionCallback!(callbackType: isArchive ? JobQuickActionCallbackType.archive : JobQuickActionCallbackType.unarchive, job: jobModel, currentIndex: index,);
      }
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  //////////    UNARCHIVE JOB    /////////

  void unarchiveJob(JobModel jobModel, int index) {
    showJPBottomSheet(
        isDismissible: false,
      child: (JPBottomSheetController controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: "confirmation".tr,
          subTitle: jobModel.listType == CJListType.projectJobs ? "project_unarchive_conformation".tr : "job_unarchive_conformation".tr,
          prefixBtnText: "no".tr,
          suffixBtnText: "yes".tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          onTapPrefix: () => Get.back(),
          onTapSuffix: () {
            controller.toggleIsLoading();
            archiveJobOnServer(jobModel, index, false);
          },
        );
      });
  }

  //////////    ADD TO PROGRESS BOARD JOB    /////////

  Future<void> selectProgressBoards(JobModel jobModel, int index) async {
    AddToProgressBoardHelper.addInProgressBoard(
      jobModel: jobModel,
      index: index,
      onCallback: quickActionCallback,
    );
  }

  //////////    IN-PROGRESS BOARD    /////////

  Future<void> selectInProgressBoards(JobModel jobModel, int index) async {
    AddToProgressBoardHelper.inProgressBoard(
      jobModel: jobModel,
      index: index,
      onCallback: quickActionCallback,
    );
  }

  //////////    SHARE WEB PAGE    /////////

  void shareWebPage({JobModel? job, int? index}) {
    showJPBottomSheet(
      isDismissible: false,
        child: (JPBottomSheetController controller) {
          return JPConfirmationDialogWithSwitch(
            title: "confirmation".tr,
            subTitle: "share_web_page_conformation".tr,
            prefixBtnText: "cancel".tr,
            suffixBtnText: "share".tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            isToggleVisible : false,
            actionIcons: [
               JPIconButton(
                backgroundColor: JPAppTheme.themeColors.base,
                icon: Icons.remove_red_eye_outlined,
                iconColor: JPAppTheme.themeColors.text,
                highlightColor: JPAppTheme.themeColors.lightBlue,
                iconSize: 24,
                onTap: () => Helper.launchUrl(job!.shareUrl!),
               ),
              JPIconButton(
                backgroundColor: JPAppTheme.themeColors.base,
                icon: Icons.copy_all_outlined,
                iconColor: JPAppTheme.themeColors.text,
                highlightColor: JPAppTheme.themeColors.lightBlue,
                iconSize: 24,
                onTap: () => Helper.copyToClipBoard(job?.shareUrl ?? "")
                    .whenComplete(() => Helper.showToastMessage("url_copied".tr)),
              ),
            ],
            onPrefixTap: (val) => Get.back(),
            onSuffixTap: (val) {
              controller.toggleIsLoading();
              shareJobToCustomerWebPage(job: job!);
            },
          );
        });
  }

  Future<void> shareJobToCustomerWebPage ({JobModel? job,}) async {
    await JobRepository.shareJobToCustomerWebPage(job!.id).then((response) {
      if(response == 200) {
        Helper.showToastMessage("email_sent".tr);
        Get.back();
      }
    }).catchError((onError) {Get.back();});
  }

  ///////////////////////    UPDATE JOB PRICE   ///////////////////////////

  void updateTotalJobPrice(JobModel jobModel, int index) => JobPriceUpdateHelper.openJobPriceDialog(
    jobId: jobModel.id,
    onApply: () {
      Helper.showToastMessage(jobModel.listType == CJListType.projectJobs ?
      "project_price_update_requested".tr : "job_price_update_requested".tr);
      Get.back();
    },
  );

  void navigateToJobScreen(JobModel jobModel) {
    Get.toNamed(Routes.jobForm, arguments: {
      NavigationParams.jobModel: jobModel,
      NavigationParams.type: JobFormType.edit,
    });
  }

  void navigateToCustomer(int customerId) {
    Get.toNamed(Routes.customerForm, arguments: {
      NavigationParams.customerId: customerId,
    })?.then((result) {
      if(result != null) {
        quickActionCallback?.call(callbackType: JobQuickActionCallbackType.customer);
      }
    });
  }

  Future<void> navigateToCreateAppointment(JobModel jobModel) async {
    final result = await Get.toNamed(Routes.createAppointmentForm, arguments: {
      NavigationParams.pageType: AppointmentFormType.createJobAppointmentForm,
      NavigationParams.appointment: AppointmentModel.fromJobModel(jobModel)
    });
    if(result != null) {
      quickActionCallback?.call(callbackType: JobQuickActionCallbackType.createAnAppointment);
    }
  }

  Future<void> navigateToScheduleJob(JobModel jobModel) async {
    final result = await Get.toNamed(Routes.createEventForm, preventDuplicates: false, arguments: {
      NavigationParams.pageType: EventFormType.createScheduleForm,
      NavigationParams.jobModel: jobModel,
    });
    if(result != null) {
      quickActionCallback?.call(callbackType: JobQuickActionCallbackType.scheduleJob);
    }
  }

  void navigateToEditProjectScreen(JobModel jobModel) {
    Get.toNamed(Routes.projectForm, arguments: {
      NavigationParams.jobModel: jobModel,
      NavigationParams.type: JobFormType.edit,
      NavigationParams.parentFormType: ParentFormType.individual
    });
  }

  void navigateToScheduledDetailScreen(JobModel jobModel) {
    if((jobModel.scheduleCount ?? 0) > 1){
      Get.toNamed(Routes.calendar, arguments: {
        NavigationParams.type : CalendarType.production,
        NavigationParams.jobId: jobModel.id},
        preventDuplicates: false
      );
    } else {
      Get.toNamed(Routes.scheduleDetail, arguments: {
        NavigationParams.jobId: jobModel.id
      });
    }
  }
}