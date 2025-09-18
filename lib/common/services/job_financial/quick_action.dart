import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_handler.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_list.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/quick_action_dialogs.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../files_listing/quick_action_handlers.dart';

class JobFinancialService {
  static Future<void> 
  openQuickActions({
    required int customerId,
    required dynamic model,
    required JFListingType type, 
    required JobModel job,
    required  Function(dynamic modal,String action) onActionComplete}) async {
     List<JPQuickActionModel> actions = JobFinancialListingQuickActionsList.getActions(job: job, model: model, type: type);
      showJPBottomSheet(
      child: (_) => JPQuickAction(
        mainList: actions,
        onItemSelect: (value) {
          Get.back();
          handleQuickAction(model: model, type: type, val: value, job: job, onActionComplete: onActionComplete, customerId: customerId);
        },
      ),
      isScrollControlled: true);
  }

  static Future<void> handleQuickAction({
        int? customerId,
      List<FinancialListingModel>? unAppliedCreditList,
      required String val,
      required FinancialListingModel model,
      required JFListingType type,
      required  void Function(dynamic modal,String action) onActionComplete,
      required JobModel job
      }) async {
    switch(val){
      case FinancialQuickAction.view:
        JobFinancialListQuickActionHandlers.view(model: model, type: type);
        break;
      case FinancialQuickAction.cancelWithReason:
        FinancialListQuickActionPopups.openCancelNotesDialog(jobId: job.id, onActionComplete: onActionComplete, type: type, model: model);
        break;
      case FinancialQuickAction.cancelWithoutReason:
        FinancialListQuickActionPopups.openCancelNoteConfirmationBottomSheet(onActionComplete: onActionComplete, model: model, type: type);
        break;
      case FinancialQuickAction.printDepositReceipt:
        JobFinancialListQuickActionHandlers.print(id: model.id!, type: type);
        break;
      case FinancialQuickAction.printInvoice:
        JobFinancialListQuickActionHandlers.print(invoiceId: model.invoiceId!, type: type);
        break;
      case FinancialQuickAction.viewDepositReceipt:
        JobFinancialListQuickActionHandlers.downloadView(id: model.id!, type: type);
        break;
      case FinancialQuickAction.viewInvoice:
       JobFinancialListQuickActionHandlers.downloadView(invoiceId: model.invoiceId!, type: type);
        break;
      case FinancialQuickAction.print:
        JobFinancialListQuickActionHandlers.print(url: model.url, type: type);
        break;
      case FinancialQuickAction.downloadViewRefund:
        JobFinancialListQuickActionHandlers.downloadView(url: model.url!, type: type);
        break;     
      case FinancialQuickAction.downloadViewInvoice:
        JobFinancialListQuickActionHandlers.downloadView(id: model.id!, url: model.url!, type: type);
        break;
      case FinancialQuickAction.info:
        JobFinancialListQuickActionHandlers.view( model: model, type: type);
        break;
      case FinancialQuickAction.linkProposal:
        FinancialListQuickActionPopups.linkedProposalDialogBox(jobId: job.id, model:model, onActionComplete: onActionComplete, type: type);
        break;
      case FinancialQuickAction.unlinkProposal:
        FinancialListQuickActionPopups.unlinkedInvoiceConfirmationBottomSheet(onActionComplete: onActionComplete, model: model);
        break;
      case FinancialQuickAction.viewLinkedProposal:
        JobFinancialListQuickActionHandlers.downloadViewProposal(proposalUrl: model.proposalUrl!);
        break;
      case FinancialQuickAction.qbPay:
         JobFinancialListQuickActionHandlers.qbPay(shareUrl: job.shareUrl!);
         break;
      case FinancialQuickAction.deleteInvoice:
        FinancialListQuickActionPopups.showDeleteDialogBox(model: model, onActionComplete: onActionComplete);
        break;
      case FinancialQuickAction.downloadView:
        JobFinancialListQuickActionHandlers.downloadView(type: type, url: model.url);
        break;
      case FinancialQuickAction.delete:
        FinancialListQuickActionPopups.deleteConfirmationBottomSheet(model: model, onActionComplete: onActionComplete, type: type);
        break;
      case FinancialQuickAction.payCommission:
         FinancialListQuickActionPopups.showpayDialogBox(onActionComplete: onActionComplete,model: model);
         break;
      case FinancialQuickAction.viewHistory:
        JobFinancialListQuickActionHandlers.viewHistory(customerId: customerId!, jobId: job.id, model: model,onActionComplete: onActionComplete);
        break;
      case FinancialQuickAction.quickBookSyncError:
        JobFinancialListQuickActionHandlers.openQuickBookSyncErrorBottom(modelId: model.id!, type: type);
        break;
      case FinancialQuickAction.email:
        Helper.navigateToComposeScreen(arguments:{'financial_file_id': model.id, 'action': type,'jobId':job.id});
        break;
      case FinancialQuickAction.recordPayment:
        JobFinancialListQuickActionHandlers.receivePayment(model: model, jobId: job.id,onActionComplete: onActionComplete);
       break; 
      case FinancialQuickAction.leapPay:
        JobFinancialListQuickActionHandlers.receivePayment(model: model, jobId: job.id, isRecordPayment: false, onActionComplete: onActionComplete);
       break;
      case FinancialQuickAction.applyCredit:
      if(unAppliedCreditList == null || unAppliedCreditList.isEmpty){
        JobFinancialListQuickActionHandlers.applyCredit(model: model, jobId: job.id, onActionComplete: onActionComplete);        
      } else {
        FinancialListQuickActionPopups.getUnappliedCreditBottomSheet(model: model, unAppliedCreditList: unAppliedCreditList, onActionComplete: onActionComplete);
      }
      break;
      case FinancialQuickAction.edit:
      case FinancialQuickAction.attachments:
        JobFinancialListQuickActionHandlers.onEditPress(model, type, job.id, customerId, onActionComplete);
      break;
      case FinancialQuickAction.unsavedResourceEdit:
        JobFinancialListQuickActionHandlers.navigateToEditUnsavedResource(model, type, job.id, customerId, onActionComplete);
        break;
      case FinancialQuickAction.unsavedResourceDelete:
        JobFinancialListQuickActionHandlers.navigateToDeleteUnsavedResource(model, type, job.id, customerId, onActionComplete);
        break;
      case FinancialQuickAction.sendViaText:
        FilesListingModel? attachment;

        if(!Helper.isValueNullOrEmpty(model.url)) {
          attachment = FilesListingModel.fromFinancialListModel(model);
        }
        FileListQuickActionHandlers.sendViaJobProgress(jobModel: job, model: attachment);
    }
  }
}
