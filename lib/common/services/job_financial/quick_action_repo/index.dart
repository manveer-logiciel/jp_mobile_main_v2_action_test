import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/files_listing/widgets/file_info.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/commission_payment.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/invoices_without_thumb_repo.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/payment_received_repo.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/accounts_payable.dart';
import 'package:jobprogress/common/services/quick_book.dart';
import 'package:jobprogress/core/constants/quick_book_error.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/refunds_repo.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/change_order_bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/commission-bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/credit_detail_bottom_sheet/index.dart';
import 'package:jobprogress/modules/job_financial/listing/bottom_sheet/payment_detail_bottom_sheet/index.dart';
import 'change_order_repo.dart';
import 'commission.dart';
import 'credits_repo.dart';

class JobFinancialListingQuickActionRepo {
  static void view({required JFListingType type, required FinancialListingModel model}) {
    switch (type) {
      case JFListingType.changeOrders:
        showJPBottomSheet(child: (_) => JobFinancialChangeOrderBottomSheet(changeOrder: model));
        break; 
      case JFListingType.paymentsReceived:
        showJPBottomSheet(child: (_) => JobFinancialPaymentDetailBottomSheet(paymentsReceived: model));
        break; 
      case JFListingType.credits:
        showJPBottomSheet(child: (_) => JobFinancialCreditsDetailBottomSheet(creditsDetail: model));
        break;            
      case JFListingType.refunds:
        break;
      case JFListingType.accountspayable:
        break;
      case JFListingType.jobInvoicesWithoutThumb:
        showJPBottomSheet(child: (_) => FileInfo(data: model, isInvoice: true));
        break;
      case JFListingType.commission:
        showJPBottomSheet(child: (_) => JobFinancialCommisionBottomSheet(commission: model));
        break;
      default:
        return;
    }
  }

  static void openQuickBookSyncErrorBottomSheet({required JFListingType type, required int id}) {
    switch (type) {
      case JFListingType.changeOrders:
        break;
      case JFListingType.paymentsReceived:
        break;
      case JFListingType.credits:
        break;        
      case JFListingType.refunds:
        QuickBookService.openQuickBookErrorBottomSheet(QuickBookSyncErrorConstants.refundEntity, id.toString());
        break;
      case JFListingType.accountspayable:
        QuickBookService.openQuickBookErrorBottomSheet(QuickBookSyncErrorConstants.bill, id.toString());
        break;
      case JFListingType.jobInvoices:
        break;
      default:
        return ;
      
    }
  }

  static Future<dynamic> cancelWithDialogBox({required JFListingType type, required int id, required int jobId, required String val}) async {
    switch (type) {
      case JFListingType.changeOrders:
      case JFListingType.paymentsReceived:
        await JobFinancialPaymentReceivedQuickActionRepo.cancelPaymentReceived(jobId: jobId, val: val, id: id);
        break;
      case JFListingType.credits:
        break;          
      case JFListingType.refunds:
        await JobFinancialRefundsQuickActionRepo.cancelRefund(jobId: jobId, val: val, id: id);
        break;
      case JFListingType.accountspayable:
        break;
      case JFListingType.jobInvoicesWithoutThumb:
        break;
      default:
        return;
    }
  }

  static Future<dynamic> cancelWithoutDialogBox({required JFListingType type, required int id}) async {
    switch (type) {
      case JFListingType.changeOrders:
        await JobFinancalChangeOrderQuickActionRepo.cancelChangeOrder(id: id);
        break;
      case JFListingType.paymentsReceived:
        break;
      case JFListingType.credits:
        await JobFinancalCreditsQuickActionRepo.cancelCredit(id: id);
        break;                
      case JFListingType.refunds:
        break;  
      case JFListingType.accountspayable:
        break;
      case JFListingType.jobInvoicesWithoutThumb:
        break;
      case JFListingType.commission:
        await JobFinancalCommissionQuickActionRepo.cancelCommission(id: id);
        break;
      case JFListingType.commissionPayment:
        await JobFinancalCommissionPaymentQuickActionRepo.cancelCommissionPayment(id: id);
        break;
      default:
        return;
    }
  }

  static Future<dynamic> print({required JFListingType type, int? invoiceId, int? id, String? url}) async {
    switch (type) {
      case JFListingType.changeOrders:
        await JobFinancalChangeOrderQuickActionRepo.printInvoice(invoiceId: invoiceId!);
        break;
      case JFListingType.paymentsReceived:
        await JobFinancialPaymentReceivedQuickActionRepo.printPaymentDepositSlip(modelId: id!);
        break;
      case JFListingType.credits:
        break;          
      case JFListingType.refunds:
        await JobFinancialRefundsQuickActionRepo.printRefund(url: url!);
        break;  
      case JFListingType.accountspayable:
        await JobFinancialAccountsPayableQuickActionRepo.print(url: url);
        break;
      case JFListingType.jobInvoicesWithoutThumb:
        await JobFinancialInvoicesWithoutThumbQuickActionRepo.print(url: url!);
        break;
      default:
        return;
    }
  }

  static Future<dynamic> delete({required JFListingType type, required int id}) async {
    switch (type) {
      case JFListingType.accountspayable:
        await JobFinancialAccountsPayableQuickActionRepo.delete(id: id);
        break;
      case JFListingType.commissionPayment:
        await JobFinancalCommissionPaymentQuickActionRepo.delete(id: id);
        break;
      default:
        return;
    }
  }

  static Future<dynamic> downlodView({required JFListingType type, int? invoiceId, int? id, String? url}) async {
    switch (type) {
      case JFListingType.changeOrders:
        await JobFinancalChangeOrderQuickActionRepo.openInvoice(invoiceId: invoiceId!);
        break;
      case JFListingType.paymentsReceived:
        await JobFinancialPaymentReceivedQuickActionRepo.viewPaymentDepositFileSlip(modalId: id!);
        break;
      case JFListingType.credits:
        break;
      case JFListingType.refunds:
        await JobFinancialRefundsQuickActionRepo.viewRefund(url: url!);
        break;
      case JFListingType.accountspayable:
        await JobFinancialAccountsPayableQuickActionRepo.view(url: url);
        break;
      case JFListingType.jobInvoicesWithoutThumb:
        await JobFinancialInvoicesWithoutThumbQuickActionRepo.downloadView(url: url!);
        break;
      default:
        return;
    }
  }
}