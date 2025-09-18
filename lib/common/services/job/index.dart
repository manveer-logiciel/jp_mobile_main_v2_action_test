import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/Button/type.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_size.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import '../../../core/constants/assets_files.dart';
import '../../../core/utils/single_select_helper.dart';
import '../../enums/cj_list_type.dart';
import '../../enums/quick_action_type.dart';
import '../auth.dart';
import '../permission.dart';

class JobService {
  static List<JPQuickActionModel> getQuickActionList(JobModel job, {String? actionFrom, CJListType? listType, QuickActionType? quickActionType}) {
    num jobPrice = JobFinancialHelper.getTotalPrice(job);
    String formattedJobPrice = jobPrice != 0 ? JobFinancialHelper.getCurrencyFormattedValue(value: jobPrice) : "";

    bool isCustomerJobFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.customerJobFeatures]);
    bool isProductionFeatureAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    bool isPrimeSubUser = AuthService.isPrimeSubUser();

    bool hasManageProgressPermission = PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard]);
    bool hasViewProgressPermission = PermissionService.hasUserPermissions([PermissionConstants.viewProgressBoard]);

    List<JPQuickActionModel> quickActionList = job.listType == CJListType.projectJobs ?
    [
      JPQuickActionModel(id: "edit_project", child: const Icon(Icons.edit_outlined, size: 18), label: 'edit_project'.tr.capitalize!),
      JPQuickActionModel(id: "edit_job", child: const Icon(Icons.edit_outlined, size: 18), label: 'edit_Job'.tr.capitalize!),
      JPQuickActionModel(id: "follow_up_call", child: const JPIcon(Icons.call_outlined, size: 18), label: 'follow_up_call'.tr.capitalize!),
      JPQuickActionModel(id: "create_appointment", child: const JPIcon(Icons.today_outlined, size: 18), label: 'create_appointment'.tr.capitalize!),
      JPQuickActionModel(id: "project_note", child: const JPIcon(Icons.description_outlined, size: 18), label: 'project_notes'.tr.capitalize!),
      if(job.scheduled != null) ...{
       JPQuickActionModel(id: "job_scheduled", child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), label: job.scheduled!),
      } else ...{
        JPQuickActionModel(id: "schedule_project", child: const JPIcon(Icons.calendar_month_outlined, size: 18), label: 'schedule_project'.tr.capitalize!),
      },
      JPQuickActionModel(id: "add_to_progress", child: const JPIcon(Icons.add, size: 18), label: 'add_to_progress_board'.tr.capitalize!),
      JPQuickActionModel(id: "in_progress_boards", child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), label: 'in_progress_boards'.tr.capitalize!),
      JPQuickActionModel(id: "mark_as_awarded", child: const JPIcon(Icons.shield_outlined, size: 18), label: Helper.isTrue(job.isAwarded) ? 'mark_as_awarded'.tr.capitalize! : 'mark_as_not_awarded'.tr.capitalize!),
      JPQuickActionModel(id: "project_price", child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 18), label: "${'project_price'.tr.capitalize!} ${formattedJobPrice.isNotEmpty ? "($formattedJobPrice)" : ""}"),
      JPQuickActionModel(id: "mark_lost_job", child: const JPIcon(Icons.work_off_outlined, size: 18), label: 'mark_lost_project'.tr.capitalize!),
      JPQuickActionModel(id: "reinstate_job", child: const JPIcon(Icons.refresh_outlined, size: 18), label: 'reinstate_project'.tr.capitalize!),
      JPQuickActionModel(id: "delete", child: const JPIcon(Icons.delete_outline, size: 18), label: 'delete'.tr.capitalize!),
    ] :
    [
      JPQuickActionModel(id: "edit_job", child: const Icon(Icons.edit_outlined, size: 18), label: 'edit_Job'.tr.capitalize!),
      JPQuickActionModel(id: "edit_customer", child: const Icon(Icons.edit_outlined, size: 18), label: 'edit_customer'.tr.capitalize!),
      JPQuickActionModel(id: "view", child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), label: 'view'.tr.capitalize!),
      JPQuickActionModel(id: "email", child: const JPIcon(Icons.email_outlined, size: 18), label: 'email'.tr.capitalize!),
      JPQuickActionModel(id: "follow_up_call", child: const JPIcon(Icons.call_outlined, size: 18), label: 'follow_up_call'.tr.capitalize!),
      if(quickActionType != QuickActionType.jobSearch)
       JPQuickActionModel(id: "job_flags", child: const JPIcon(Icons.flag_outlined, size: 18), label: 'Job_flags'.tr.capitalize!),
      if(isCustomerJobFeatureAllowed && !Helper.isValueNullOrEmpty(job.shareUrl))
       JPQuickActionModel(id: "share_web_page", child: const JPIcon(Icons.share_outlined, size: 18), label: 'share_customer_web_page'.tr.capitalize!),
      JPQuickActionModel(id: "add_to_progress", child: const JPIcon(Icons.add, size: 18), label: 'add_to_progress_board'.tr.capitalize!),
      if(job.scheduled != null) ...{
        JPQuickActionModel(id: "job_scheduled",
            child: const JPIcon(Icons.remove_red_eye_outlined, size: 18),
            label: job.scheduled!),
      } else ...{
        if(isProductionFeatureAllowed)
         JPQuickActionModel(id: "schedule_job", child: const JPIcon(Icons.calendar_month_outlined, size: 18), label: 'schedule_job'.tr.capitalize!),
      },
      JPQuickActionModel(id: "in_progress_boards", child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), label: 'in_progress_boards'.tr.capitalize!),
      JPQuickActionModel(id: "job_note", child: const JPIcon(Icons.description_outlined, size: 18), label: 'job_note'.tr.capitalize!),
      JPQuickActionModel(id: "appointment", child: const JPIcon(Icons.today_outlined, size: 18), label: 'appointment'.tr.capitalize!),
      JPQuickActionModel(id: "create_appointment", child: const JPIcon(Icons.today_outlined, size: 18), label: 'create_appointment'.tr.capitalize!),
      JPQuickActionModel(id: "job_price", child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 18), label: "${'job_price'.tr.capitalize!} ${formattedJobPrice.isNotEmpty ? "($formattedJobPrice)" : ""}"),
      JPQuickActionModel(id: "archive", child: const JPIcon(Icons.archive_outlined, size: 18), label: 'archive'.tr.capitalize!),
      JPQuickActionModel(id: "unarchive", child: const JPIcon(Icons.archive_outlined, size: 18), label: 'unarchive'.tr.capitalize!),
      JPQuickActionModel(id: "mark_lost_job", child: const JPIcon(Icons.work_off_outlined, size: 18), label: 'mark_lost_job'.tr.capitalize!),
      JPQuickActionModel(id: "reinstate_job", child: const JPIcon(Icons.refresh_outlined, size: 18), label: 'reinstate_job'.tr.capitalize!),
      JPQuickActionModel(id: "delete", child: const JPIcon(Icons.delete_outline, size: 18), label: 'delete'.tr.capitalize!),
      JPQuickActionModel(id: "quickbooks_error", child: Image.asset(AssetsFiles.qbWarning), label: 'quick_book_sync_error'.tr.capitalize!),
    ];

    if(job.customer?.isBidCustomer ?? false){
      Helper.removeMultipleKeysFromArray(quickActionList, ["edit_customer", "share_web_page"]);
    }


    if ((!QuickBookService.isQuickBookConnected() && !QuickBookService.isQBDConnected()) ||
      job.quickbookSyncStatus != '2'|| job.customer!.isDisableQboSync) {
        Helper.removeMultipleKeysFromArray(quickActionList, ["quickbooks_error"]); // Remove QuickBook Sink Error
    }
    
    if(job.appointmentDate?.isEmpty ?? true) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["appointment"]);
    }

    if(!PermissionService.hasUserPermissions([PermissionConstants.manageShareCustomerWebPage])) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["share_web_page"]);
    }

    if(!PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule])) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["schedule_job", "schedule_project"]);
    }

    if(job.scheduled?.isEmpty ?? false) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["schedule"]);
    }

    if(!Helper.isValueNullOrEmpty(job.jobLostDate) || Helper.isTrue(job.lostJob)) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["mark_lost_job"]);
    }
    if((Helper.isValueNullOrEmpty(job.jobLostDate)) || isPrimeSubUser) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["reinstate_job"]);
    }

    if(!PermissionService.hasUserPermissions([PermissionConstants.manageFinancial, PermissionConstants.updateJobPrice])) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["job_price"]);
    }

    if(!hasManageProgressPermission && !hasViewProgressPermission){
      Helper.removeMultipleKeysFromArray(quickActionList, ["in_progress_boards", "add_to_progress"]);
    }

    if(!hasManageProgressPermission && hasViewProgressPermission){
      if(job.productionBoards?.isEmpty ?? true){
        Helper.removeMultipleKeysFromArray(quickActionList, ["add_to_progress", "in_progress_boards"]);
      } else {
        Helper.removeMultipleKeysFromArray(quickActionList, ["add_to_progress"]);
      }
    }

    if(hasManageProgressPermission && !hasViewProgressPermission){
      if(job.productionBoards?.isEmpty ?? true){
        Helper.removeMultipleKeysFromArray(quickActionList, ["in_progress_boards"]);
      } else {
        Helper.removeMultipleKeysFromArray(quickActionList, ["add_to_progress"]);
      }
    }

    if(hasManageProgressPermission && hasViewProgressPermission){
      if(job.productionBoards?.isEmpty ?? true){
        Helper.removeMultipleKeysFromArray(quickActionList, ["in_progress_boards"]);
      } else {
        Helper.removeMultipleKeysFromArray(quickActionList, ["add_to_progress"]);
      }
    }

    if(!PermissionService.hasUserPermissions([PermissionConstants.deleteJob])) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["delete"]);
    }

    if(job.isMultiJob) {
      Helper.removeMultipleKeysFromArray(quickActionList, ["job_price", "schedule_job", "schedule_project"]);
    }

    if(AuthService.isPrimeSubUser()) {
      List<String> actionsToRemoved = [
        "edit_job",
        "archive",
        "edit_customer",
        "add_to_progress",
        "mark_lost_job",
        "follow_up_call",
        "unarchive",
        "delete"
      ];
      Helper.removeMultipleKeysFromArray(quickActionList, actionsToRemoved);
    }

    if(job.archived != null && job.archived!.isNotEmpty) {
      quickActionList.clear();    ///  clear all & add unarchive
      quickActionList.add(JPQuickActionModel(id: "unarchive", child: const Icon(Icons.archive_outlined, size: 18), label: 'unarchive'.tr.capitalize!));
    } else {
      Helper.removeMultipleKeysFromArray(quickActionList, ["unarchive"]);
    }

    return quickActionList;
  }

  //Setting options and opening quick action bottom sheet
  static openQuickActions({
    required JobModel job,
    required Function(dynamic, String, int) callback,
    required int jobIndex,
    String? actionFrom,
    CJListType? listType,
    QuickActionType? quickActionType
  }) {
    List<JPQuickActionModel> quickActionList = getQuickActionList(job, actionFrom: actionFrom, listType: listType, quickActionType: quickActionType);
    SingleSelectHelper.openQuickAction(
      dataModel: job,
      quickActionList: quickActionList,
      callback: callback,
      currentIndex: jobIndex,
    );
  }

  static Future<void> openDescDialog({JobModel? job, VoidCallback? updateScreen}) async {
    String jobDescription = job?.description ?? '';
    TextEditingController descController = TextEditingController();
    showJPGeneralDialog(
      isDismissible: true,
      child: (JPBottomSheetController controller) {
        return JPQuickEditDialog(
          type: JPQuickEditDialogType.textArea,
          title: (job?.isProject ?? false) ? "project_description".tr.toUpperCase() : "job_description".tr.toUpperCase(),
          errorText: "provide_description".tr,
          controller: descController,
          fillValue: jobDescription,
          prefixTitle: "cancel".tr,
          suffixTitle: "save".tr,
          onPrefixTap: (val) => Get.back(),
          disableButton: controller.isLoading,
          suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
          position: JPQuickEditDialogPosition.center,
          moreHeaderActions: [
            AbsorbPointer(
              absorbing: controller.isLoading,
              child: JPButton(
                text: 'trade_scripts'.tr,
                textSize: JPTextSize.heading5,
                type: JPButtonType.outline,
                size: JPButtonSize.extraSmall,
                onPressed: () => tradeButtonPressed(
                  jobDescription: jobDescription,
                  updateController: (val) => descController.text = val
                ),
              ),
            )
          ],
          onSuffixTap: (val) {
            controller.toggleIsLoading();
            updateJobsDescription(val, job, updateScreen);
          },
        );
      }
    );
  }

  static void tradeButtonPressed({String? value, String? jobDescription, Function(String)? updateController}) async {
    Get.toNamed(Routes.snippetsListing, preventDuplicates: false,
      arguments: {
        NavigationParams.type: STArg.tradeScript,
        NavigationParams.pageType: STArgType.copyDescription}
      )?.then((value) {
      if (value != null && value.toString().isNotEmpty) {
        jobDescription = "${jobDescription ?? ""}${jobDescription?.isNotEmpty ?? false ? "\n" : ""}$value";
        updateController!(jobDescription!);
      }
    });
  }

  static Future<void> updateJobsDescription(String val, JobModel? jobModel, VoidCallback? updateData) async {
    try {
      Map<String, dynamic> queryParams = {
        "id": jobModel?.id ?? -1,
        "description": val
      };
      var response = await JobRepository.updateDescription(queryParams);
      if(response.toString().contains("successfully")) {
        Helper.showToastMessage("description_updated".tr);
        jobModel?.description = val;
      }
    } catch (e) {
      rethrow;
    } finally {
      updateData?.call();
      Get.back();
    }
  }
}