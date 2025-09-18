import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_options.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../../enums/resource_type.dart';


// JobFinancialListingQuickActionsList contains all the quick actions module wise
class JobFinancialListingQuickActionsList {

  static bool get hasEditPermission => PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]); 
  // getActions()
  // This function differentiate quick actions as per the
  // type of Financial being displayed
  static  List<JPQuickActionModel> getActions({
    FinancialListingModel? model, 
    required JFListingType type, 
    JobModel? job}) {
    switch (type) {
      case JFListingType.paymentsReceived:
        return getPaymentReceivedActionList(model!);
      case JFListingType.changeOrders:
        return getChangeorderActionList(model: model!);
      case JFListingType.jobInvoicesWithoutThumb:
        return getJobInvoicesActionList(modal: model, job: job, );
      case JFListingType.accountspayable:
        return getAccountPayableQuickActionList(job: job!, model: model!);
      case JFListingType.credits:
        return getCreditActionList();
      case JFListingType.refunds:
        return getRefundsList(job: job!, model: model!);     
      case JFListingType.commission:
        return getCommmisionActionList(model: model!);  
      case JFListingType.commissionPayment:
        return getCommmisionPaymentActionList();
          
      default:
        return [];
    }
  }


  static List<JPQuickActionModel> getPaymentReceivedActionList(FinancialListingModel model) {
    bool showCancelAction = hasEditPermission && (!(model.isLeapPayPayment ?? false));
    List<JPQuickActionModel> quickActionList = [
      JobFinancialListingQuickActionOptions.view,
      JobFinancialListingQuickActionOptions.viewDepositReceipt,
      JobFinancialListingQuickActionOptions.emailDepositReceipt,
      JobFinancialListingQuickActionOptions.printDepositReceipt,
      if (showCancelAction) JobFinancialListingQuickActionOptions.cancelWithReason
    ];
    return quickActionList;
  }
  
  static List<JPQuickActionModel> getChangeorderActionList({FinancialListingModel? model}) {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.view,
      if(hasEditPermission) JobFinancialListingQuickActionOptions.edit,
      if(model!.invoiceId !=null)JobFinancialListingQuickActionOptions.viewInvoice,
      if(model.invoiceId !=null)JobFinancialListingQuickActionOptions.printInvoice,   
      if(hasEditPermission)JobFinancialListingQuickActionOptions.cancelWithoutReason
    ];

    if(model.unsavedResourceId != null) {
      quickActionList = [
        JobFinancialListingQuickActionOptions.editUnsavedResource,
        JobFinancialListingQuickActionOptions.deleteUnsavedResource,
      ];
    }
    return quickActionList;
  }

  static List<JPQuickActionModel> getJobInvoicesActionList({FinancialListingModel? modal, JobModel? job, FLModule? type}) {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.email,
      JobFinancialListingQuickActionOptions.edit,
      JobFinancialListingQuickActionOptions.downloadViewInvoice,      
      JobFinancialListingQuickActionOptions.recordPayment,
      JobFinancialListingQuickActionOptions.leapPay,
      if(type == FLModule.financialInvoice)JobFinancialListingQuickActionOptions.applyCredit,
      JobFinancialListingQuickActionOptions.qbPay,
      JobFinancialListingQuickActionOptions.viewLinkedProposal,
      JobFinancialListingQuickActionOptions.linkProposal,
      JobFinancialListingQuickActionOptions.unlinkProposal,
      JobFinancialListingQuickActionOptions.print,
      JobFinancialListingQuickActionOptions.sendViaText,
      JobFinancialListingQuickActionOptions.deleteInvoice,
      JobFinancialListingQuickActionOptions.info,
    ];

    if (ConnectedThirdPartyService.isLeapPayEnabled()) {
      Helper.removeMultipleKeysFromArray(quickActionList, [FinancialQuickAction.qbPay.toString()]);
    }

    if(!QuickBookService.isQuickBookConnected() && modal!.qbInvoiceId == null){
      Helper.removeMultipleKeysFromArray(quickActionList, [FinancialQuickAction.qbPay.toString()]);
    }

    if((double.tryParse((modal?.openBalance).toString()) ?? 0) <= 0.00){
      Helper.removeMultipleKeysFromArray(quickActionList, [
         FinancialQuickAction.recordPayment,
         FinancialQuickAction.leapPay,
         FinancialQuickAction.applyCredit,
      ]);
    }
    
    if(!hasEditPermission){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.edit,
          FinancialQuickAction.deleteInvoice,
          FinancialQuickAction.recordPayment,
          FinancialQuickAction.leapPay,
          FinancialQuickAction.qbPay,
          FinancialQuickAction.applyCredit,
        ]
      );
    }
    if(!PhasesVisibility.canShowSecondPhase){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.applyCredit,
          FinancialQuickAction.recordPayment,
          FinancialQuickAction.leapPay,
        ]
      ); 
    }

    if(!PermissionService.hasUserPermissions([PermissionConstants.manageProposals]) || modal?.type != 'job'){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.linkProposal,
          FinancialQuickAction.unlinkProposal,
          FinancialQuickAction.viewLinkedProposal,
        ]
      );
    }
    
    if(job?.isMultiJob ?? false){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.edit,
          FinancialQuickAction.recordPayment,
          FinancialQuickAction.leapPay,
          FinancialQuickAction.applyCredit,
        ] 
      );
    }
    
    if(job?.parent != null){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.viewLinkedProposal,
          FinancialQuickAction.linkProposal,
          FinancialQuickAction.unlinkProposal
        ] 
      );
    }
    
    if(modal?.proposalId == null){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.viewLinkedProposal,
          FinancialQuickAction.unlinkProposal
        ] 
      );
    }

    if(modal?.proposalId != null){
      Helper.removeMultipleKeysFromArray(quickActionList, [FinancialQuickAction.linkProposal]);
    }

    if(double.parse((modal?.openBalance) ?? "0") <= 0){
      Helper.removeMultipleKeysFromArray(
        quickActionList, [
          FinancialQuickAction.recordPayment,
          FinancialQuickAction.leapPay,
          FinancialQuickAction.applyCredit,
          FinancialQuickAction.qbPay,
        ] 
      );
    }

    if(modal?.type != 'job'){
      Helper.removeMultipleKeysFromArray(quickActionList, [FinancialQuickAction.deleteInvoice.toString()]);
    }

    if(modal?.type == ResourceType.unsavedResource) {
      quickActionList = [
        JobFinancialListingQuickActionOptions.editUnsavedResource,
        JobFinancialListingQuickActionOptions.deleteUnsavedResource,
      ];
    }

     return quickActionList;
  }
   

  static List<JPQuickActionModel> getAccountPayableQuickActionList({required FinancialListingModel model , required JobModel job}) {
    List<JPQuickActionModel> quickActionList = [
      if(hasEditPermission)JobFinancialListingQuickActionOptions.edit,
      if(model.attachments!.isNotEmpty && hasEditPermission) JobFinancialListingQuickActionOptions.attachments,
      JobFinancialListingQuickActionOptions.downloadView,
      JobFinancialListingQuickActionOptions.print,
      JobFinancialListingQuickActionOptions.sendViaText,
      if(hasEditPermission)JobFinancialListingQuickActionOptions.delete,
      JobFinancialListingQuickActionOptions.quickBookSyncError
    ];
    if (!QuickBookService.isQuickBookConnected() && 
        !QuickBookService.isQBDConnected() || 
        model.quickBookSyncStatus != 2 || 
        job.customer!.disableQboFinancialSyncing) 
      {
        quickActionList.removeAt(quickActionList.length - 1);
      }
    return quickActionList;
  } 

  static List<JPQuickActionModel> getCreditActionList() {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.view,
      if(hasEditPermission)JobFinancialListingQuickActionOptions.cancelWithoutReason
    ];
    return quickActionList;
  }

  static List<JPQuickActionModel> getRefundsList({required FinancialListingModel model , required JobModel job}) {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.downloadViewRefund,
      JobFinancialListingQuickActionOptions.print,
      JobFinancialListingQuickActionOptions.sendViaText,
      if(hasEditPermission)JobFinancialListingQuickActionOptions.cancelWithReason,
      JobFinancialListingQuickActionOptions.quickBookSyncError
    ];
    if ((!QuickBookService.isQuickBookConnected() && !QuickBookService.isQBDConnected())
      || model.quickBookSyncStatus != 2
      || job.customer!.isDisableQboSync) {
        quickActionList.removeAt(quickActionList.length - 1);
      }
    return quickActionList;
  }

  static List<JPQuickActionModel> getCommmisionActionList({required FinancialListingModel model}) {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.view,
      JobFinancialListingQuickActionOptions.viewHistory,
      if(hasEditPermission)JobFinancialListingQuickActionOptions.payCommission,
      if(hasEditPermission)JobFinancialListingQuickActionOptions.cancelWithoutReason,
    ];
    if(double.parse(model.dueAmount!) == 0.0){
      Helper.removeMultipleKeysFromArray(quickActionList, [FinancialQuickAction.payCommission]);
    }
    return quickActionList;
  }

  static List<JPQuickActionModel> getCommmisionPaymentActionList() {
    List<JPQuickActionModel> quickActionList = [   
      JobFinancialListingQuickActionOptions.delete,
      JobFinancialListingQuickActionOptions.cancelWithoutReason
    ];
    return quickActionList;
  }
}