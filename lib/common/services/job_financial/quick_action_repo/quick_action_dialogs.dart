
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_handler.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/delete_dialog/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/files_listing/widgets/apply_credit_bottom_sheet.dart';
import 'package:jobprogress/modules/job_financial/listing/dialog_box/index.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/position.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

// FinancialListQuickActionPopups contains all the popups/bottom sheet/dialogs
// that will be displayed on clicking on quick action
class FinancialListQuickActionPopups{
  // Below comment applies to all functions inside FinancialListQuickActionPopups

  // Parameters : params[required] , action[required if present], arguments[optional if present]
  // 1.) params - it will contain all the data on which quick action is to be performed
  // 2.) action - it is being used here as a differentiator so that same function (e.g. showConfirmationBottomSheet())
  //              sheet can be used for multiple quick actions
  // 3.) arguments - It can be used to pass some additional data

 static void openCancelNotesDialog({
  required JFListingType type, 
  required FinancialListingModel model,
  required int jobId,
  required  Function(FinancialListingModel model,String action)? onActionComplete,
  }) {
    showJPGeneralDialog(
    child: (controller){
      return AbsorbPointer(
        absorbing: controller.isLoading,
        child: JPQuickEditDialog(
          title: 'confirmation'.tr.toUpperCase(),
          label: 'reason'.tr,
          type: JPQuickEditDialogType.textArea,
          isFieldRequired: true,
          maxLength: 500,
          confirmationMessage:getConfirmationmessageforDialogBox(type: type), 
          errorText: 'please_enter_cancellation_reason'.tr,
          suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
          disableButton: controller.isLoading,
          suffixTitle: controller.isLoading ? '' : 'proceed'.tr,
          prefixTitle: 'CANCEL'.tr,
          position: JPQuickEditDialogPosition.center,
          onSuffixTap: (val) async {
            controller.toggleIsLoading();
            model.cancelNote = val;
            await JobFinancialListQuickActionHandlers.cancelWithDialogBox(
              val: val, 
              id: model.id!, 
              jobId: jobId, 
              type: type,
              toggleIsLoading: controller.toggleIsLoading
            ); 
            Get.back();
            onActionComplete!(model, FinancialQuickAction.cancel);     
          },
          onPrefixTap: (value) {
            Get.back();
          },
        ),
      );
    });
  }

  static void getUnappliedCreditBottomSheet({
    required final Function(FinancialListingModel model, String action) onActionComplete,
    required List<FinancialListingModel> unAppliedCreditList,
    required FinancialListingModel model}) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: ApplyCreditBottomSheet(
            title: model.name!,
            disableButtons: controller.isLoading, 
            onTapPrefix: Get.back<void>,
            openBalance:  JobFinancialHelper.getCurrencyFormattedValue(value: model.openBalance!), 
            unappliedCredit: JobFinancialHelper.getTotalUnappliedAmount(unAppliedCreditList),
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading), 
            onTapSuffix: () async {
              await  JobFinancialListQuickActionHandlers.applyCredit(
                controller: controller,
                model: model, 
                hadUnappliedAmount: true, 
                onActionComplete: onActionComplete,
                unAplliedCreditList: unAppliedCreditList
              );
            }, 
          ) 
        );
      })
    );
  }

  static void openCancelNoteConfirmationBottomSheet({
    required JFListingType type, 
    required FinancialListingModel model,
    required  Function(FinancialListingModel modal,String action)? onActionComplete}) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
      return AbsorbPointer(
        absorbing: controller.isLoading,
        child: JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: "confirmation".tr,
          subTitle: getConfirmationmessageforBottomSheet(type: type),
          suffixBtnText: 'yes'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          prefixBtnText: 'no'.tr,
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await  JobFinancialListQuickActionHandlers.cancelWithoutDialogBox(
              id: model.id!, 
              type: type,
              toggleIsLoading: controller.toggleIsLoading
            );
            Get.back();
            onActionComplete!(model,FinancialQuickAction.cancel);
          },
        ),
      );
      })
    );
  }

  static void deleteConfirmationBottomSheet({
    required JFListingType type, 
    required FinancialListingModel model,
    required  Function(FinancialListingModel modal,String action)? onActionComplete,
  }) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: JPConfirmationDialog(
            icon: Icons.warning_amber_outlined,
            title: "confirmation".tr,
            subTitle:getConfirmationmessageforDeleteDialogBox(type),
            suffixBtnText: 'delete'.tr,
            disableButtons: controller.isLoading,
            suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
            prefixBtnText: 'cancel'.tr,
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () async {
              controller.toggleIsLoading();
              await  JobFinancialListQuickActionHandlers.delete(id: model.id!, type:type,toggleIsLoading: controller.toggleIsLoading);
              Get.back();
              onActionComplete!(model, FinancialQuickAction.delete);
            },
          ),
        );
      })
    );
  } 

  static  void linkedProposalDialogBox({
    required JFListingType type, 
    required FinancialListingModel model,
    required int jobId,
    required  Function(FinancialListingModel modal,String action)? onActionComplete}){ 
    return FileAttachService.showAttachDialog( 
      FLModule.jobProposal, 
      jobId: jobId,
      allowMultiple: false,
      onFilesSelected: (files) async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        linkedInvoiceConfirmationBottomSheet(file: files[0], model: model, onActionComplete: onActionComplete);
      }
    );
  }

   static void linkedInvoiceConfirmationBottomSheet({
    required FinancialListingModel model,
    required  Function(FinancialListingModel modal,String action)? onActionComplete,
    required AttachmentResourceModel file}) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: "confirmation".tr,
          subTitle: "you_are_about_to_link_invoice_to_proposal_please_note_that_all_the_other_invoices_for_this_job_would_also_be_linked_with_the_proposal_press_confirm_to_proceed".tr,
          suffixBtnText: 'yes'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          prefixBtnText: 'no'.tr,
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            model.proposalId = file.id;
            model.proposalUrl = file.path;
            await  JobFinancialListQuickActionHandlers.linkedProposal(id: model.id!, proposalId: model.proposalId!);
            onActionComplete!(model, FinancialQuickAction.linkProposal);
            controller.toggleIsLoading();
          },
        );
      })
    );
  } 
  static void unlinkedInvoiceConfirmationBottomSheet({
    required  Function(FinancialListingModel modal,String action)? onActionComplete,
    required FinancialListingModel model}) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: ((controller) {
        return JPConfirmationDialog(
          icon: Icons.warning_amber_outlined,
          title: "confirmation".tr,
          subTitle: 'you_are_about_to_unlink_invoice_from_proposal_please_note_that_all_the_other_invoices_for_this_job_would_also_be_unlinked_from_the_proposal_press_confirm_to_proceed'.tr,
          suffixBtnText: 'yes'.tr,
          disableButtons: controller.isLoading,
          suffixBtnIcon: showJPConfirmationLoader(show: controller.isLoading),
          prefixBtnText: 'no'.tr,
          onTapPrefix: () {
            Get.back();
          },
          onTapSuffix: () async {
            controller.toggleIsLoading();
            await  JobFinancialListQuickActionHandlers.unlinkedProposal(id: model.id!);
            onActionComplete!(model,FinancialQuickAction.unlinkProposal);
            controller.toggleIsLoading();
          },
        );
      })
    );
  } 

  static void showDeleteDialogBox({
    required void  Function(dynamic modal,String action)? onActionComplete,
    required dynamic model}){
    showJPGeneralDialog(
      child:  (controller) {
        return DeleteDialogWithPassword(
          actionFrom: 'job_financial',
          model: model,
          title: 'delete_invoice'.tr.toUpperCase(),
          deleteCallback: onActionComplete!
        );
    });
  }

  static void showpayDialogBox({required FinancialListingModel model, required final Function(FinancialListingModel model, String action) onActionComplete}){
    showJPGeneralDialog(child:(controller){
      return PayCommissionDialog(
        model: model,
        onApply: onActionComplete
      );
    });
  }
  
  static String getConfirmationmessageforBottomSheet({required JFListingType type}){
    switch(type){ 
      case JFListingType.changeOrders:
        return "you_are_about_to_cancel_order.respective_amount_will_be_re_adjuststed".tr;
      case JFListingType.credits:
        return 'you_are_about_to_cancel_credit.respective_amount_will_be_readjusted'.tr;
      case JFListingType.commission:
        return 'you_are_about_to_cancel_commission.respective_amount_will_be_readjusted'.tr;
      case JFListingType.commissionPayment:
        return 'you_are_about_to_cancel_commission.respective_amount_will_be_readjusted'.tr;
      default:
        return "";
    }
  }
  
  static String getConfirmationmessageforDialogBox({required JFListingType type}){
    switch(type){ 
      case JFListingType.paymentsReceived:
        return 'you_are_going_to_cancel_this_payment_and_respective_amount_will_be_re-adjusted_Kindly_add_the_reason_for_cancelling_payment below'.tr;
      case JFListingType.refunds:
        return '';

      default:
        return "";
    }
  }

   static String getConfirmationmessageforDeleteDialogBox(JFListingType type){
    switch(type){ 
      case JFListingType.accountspayable:
        return "you_are_about_to_delete_this_bill".tr;
      
      case JFListingType.commissionPayment:
        return 'you_are_about_to_delete_this_commission_press_confirm_to_proceed'.tr;

      default:
        return "";
    }
  }    
}
