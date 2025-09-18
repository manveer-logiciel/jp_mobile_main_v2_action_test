
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_summary_action.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/job/job_summary/quick_action_helper.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/plus_button_sheet/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobSummaryService {

  static List<JPQuickActionModel> quickActions(JobModel? jobModel) {
    bool isParentJob = jobModel?.parentId != null;
    bool isMultiJob = jobModel?.isMultiJob ?? false;
    bool isSubUser = AuthService.isSubUser();
    bool isPrimeSubUser = AuthService.isPrimeSubUser();
    bool canBlockFinancial = jobModel?.financialDetails?.canBlockFinancial ?? false;
    final List<JPQuickActionModel> quickActionList = [
      JPQuickActionModel(id: JobSummaryActions.call.toString(), label: 'call'.tr, child: const JPIcon(Icons.call_outlined)),
      JPQuickActionModel(id: JobSummaryActions.text.toString(), label: 'text'.tr, child: const JPIcon(Icons.textsms_outlined)),
      JPQuickActionModel(id: JobSummaryActions.email.toString(), label: 'email'.tr, child: const JPIcon(Icons.email_outlined)),
      JPQuickActionModel(id: JobSummaryActions.task.toString(), label: 'task'.tr, child: const JPIcon(Icons.task_alt_sharp)),
      JPQuickActionModel(
        id: JobSummaryActions.jobProjectNote.toString(), 
        label: isParentJob ? 'project_notes'.tr.capitalize! : 'job_notes'.tr.capitalize!, 
        child: const JPIcon(Icons.edit_note_outlined),
      ),
      if(!AuthService.isPrimeSubUser())
        JPQuickActionModel(id: JobSummaryActions.followUps.toString(), label: 'follow_up'.tr, child: const JPIcon(Icons.contact_phone_outlined)),
      JPQuickActionModel(id: JobSummaryActions.scan.toString(), label: 'scan'.tr, child: const JPIcon(Icons.document_scanner_outlined)),
      JPQuickActionModel(id: JobSummaryActions.file.toString(), label: 'file'.tr, child: const JPIcon(Icons.picture_as_pdf)),
      JPQuickActionModel(id: JobSummaryActions.photo.toString(), label: 'photo'.tr, child: const JPIcon(Icons.photo_camera_outlined)),
      JPQuickActionModel(id: JobSummaryActions.appointment.toString(), label: 'appointment'.tr, child: const JPIcon(Icons.today_outlined)),
      if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))
        JPQuickActionModel(id: JobSummaryActions.message.toString(), label: 'message'.tr, child: const JPIcon(Icons.messenger_outline)),
      JPQuickActionModel(id: JobSummaryActions.measurement.toString(), label: 'measurement'.tr, child: SvgPicture.asset(AssetsFiles.measurement)),
      JPQuickActionModel(id: JobSummaryActions.estimating.toString(), label: 'estimate'.tr, child: const JPIcon(Icons.description_outlined)),
      JPQuickActionModel(id: JobSummaryActions.formProposal.toString(), label: 'form_proposals'.tr, child: const JPIcon(Icons.description_outlined)),
      JPQuickActionModel(
        id: JobSummaryActions.jobProjectPrice.toString(),
        label: isParentJob ? 'project_price'.tr : 'job_price'.tr,
        child: const JPIcon(Icons.price_change_outlined),
      ),
      if(!AuthService.isPrimeSubUser())
        JPQuickActionModel(id: JobSummaryActions.workCrew.toString(), label: 'work_crew'.tr, child: const JPIcon(Icons.person_3_outlined)),
      JPQuickActionModel(
        id: JobSummaryActions.scheduleJobProject.toString(),
        label: isParentJob ? 'schedule_project'.tr : 'schedule_job'.tr,
        child: const JPIcon(Icons.calendar_month_outlined),
      ),
      JPQuickActionModel(id: JobSummaryActions.invoice.toString(), label: 'invoice'.tr, child: SvgPicture.asset(AssetsFiles.jobInvoices)),
      JPQuickActionModel(id: JobSummaryActions.changeOrder.toString(), label: 'change_order'.tr, child: SvgPicture.asset(AssetsFiles.changeOrders)),
      JPQuickActionModel(id: JobSummaryActions.bill.toString(), label: 'bill'.tr, child: SvgPicture.asset(AssetsFiles.bill)),
      JPQuickActionModel(id: JobSummaryActions.refund.toString(), label: 'refund'.tr, child: SvgPicture.asset(AssetsFiles.refund)),
      JPQuickActionModel(id: JobSummaryActions.clockIn.toString(), label: 'clock_in'.tr, child: const JPIcon(Icons.timer_outlined)),
      JPQuickActionModel(id: JobSummaryActions.clockOut.toString(), label: 'clock_out'.tr, child: const JPIcon(Icons.timer_off_outlined)),
      JPQuickActionModel(id: JobSummaryActions.progressBoard.toString(), label: 'progress_board'.tr, child: const JPIcon(Icons.paste_outlined)),
    ];

    bool manageFinancialPermission = PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]);
    bool manageProgressBoardPermission = PermissionService.hasUserPermissions([PermissionConstants.manageProgressBoard]);
    bool hasCustomerPhonePermission = !(isPrimeSubUser && AuthService.userDetails!.dataMasking);
    bool hasManageEstimatesPermission = PermissionService.hasUserPermissions([PermissionConstants.manageEstimates]);
    bool hasManageProposalsPermission = PermissionService.hasUserPermissions([PermissionConstants.manageProposals]) && !isParentJob;

    bool hasJobProjectPricePermission = !isMultiJob && !isSubUser &&
          (manageFinancialPermission || PermissionService.hasUserPermissions([PermissionConstants.viewFinancial, PermissionConstants.updateJobPrice]));
  
    bool showWorkCrew = !isSubUser && !isMultiJob;
    bool hasJobProjectSchedulePermission = PermissionService.hasUserPermissions([PermissionConstants.manageJobSchedule]) && !isMultiJob;

    bool hasInvoicePermission = manageFinancialPermission && (jobModel?.jobInvoices?.isEmpty ?? true) && !canBlockFinancial;
    bool hasChangeOrderPermission = manageFinancialPermission && (jobModel?.jobInvoices?.isNotEmpty ?? false) && !isMultiJob && !isParentJob && !canBlockFinancial;
    bool hasBillPermission = manageFinancialPermission && !isMultiJob;
    bool hasRefundPermission = manageFinancialPermission && !isMultiJob && !canBlockFinancial;

    bool showClockIn = ClockInClockOutService.checkInDetails?.jobModel?.id != jobModel?.id;
    bool showProgressBoard = !isSubUser && (jobModel?.productionBoards?.isEmpty ?? false) && manageProgressBoardPermission;

    bool isProductionFeatureEnabled = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    bool isFinanceFeatureEnabled = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
    bool isUserManagementFeatureEnabled = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);

    // [isSalesProForEstimate] - To check if user is sales pro for estimate flag is enabled
    bool isSalesProForEstimate = LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate);
    
    if (!hasCustomerPhonePermission) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.call.toString(), JobSummaryActions.text.toString()]);
    }
    if (isParentJob) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.appointment.toString()]);
    }
    if (!hasManageEstimatesPermission) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.estimating.toString()]);
    }
    if (!hasManageProposalsPermission) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.formProposal.toString()]);
    }
    if (!hasJobProjectPricePermission) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.jobProjectPrice.toString()]);
    }
    if (!showWorkCrew || !isProductionFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.workCrew.toString()]);
    }
    if (!hasJobProjectSchedulePermission || !isProductionFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.scheduleJobProject.toString()]);
    }
    if (!hasInvoicePermission || !isFinanceFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.invoice.toString()]);
    }
    if (!hasChangeOrderPermission || !isFinanceFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.changeOrder.toString()]);
    }
    if (!hasBillPermission || !isFinanceFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.bill.toString()]);
    }
    if (!hasRefundPermission || !isFinanceFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.refund.toString()]);
    }
    if (!showClockIn || !isUserManagementFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.clockIn.toString()]);
    } 
    if(showClockIn || !isUserManagementFeatureEnabled) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.clockOut.toString()]);
    }
    if (!showProgressBoard) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.progressBoard.toString()]);
    }
    // removing estimate action if sales pro for estimate flag is enabled
    if (isSalesProForEstimate) {
      Helper.removeMultipleKeysFromArray(quickActionList, [JobSummaryActions.estimating.toString()]);
    }

    return quickActionList;
  }

  static void openQuickActions(JobModel? jobModel, Function(String) onActionComplete, {
    Function(FLModule)? onRecentFileUpdated
  }) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: (_) => JPPlusButtonSheet(
        job: jobModel,
        options: quickActions(jobModel),
        hasFourColumnInTablet: true,
        onTapOption: (id) {
          Get.back();
          JobSummaryQuickActionHelper().handleQuickActions(id, jobModel!, () => onActionComplete.call(id),
              onRecentFileUpdated: onRecentFileUpdated,
          );
        },
        onActionComplete: (String action) {},
      ),
    );
  }

}