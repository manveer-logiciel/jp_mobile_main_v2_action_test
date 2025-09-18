import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/Icon/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

// FileListingQuickActionOptions contains actions that will be displayed on quick action popup
class JobFinancialListingQuickActionOptions {
  static const double iconSize = 18;

  static JPQuickActionModel view =  JPQuickActionModel(
    id: FinancialQuickAction.view, 
    child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize), 
    label: 'view'.tr.capitalize!
  );
  
  static JPQuickActionModel viewHistory = JPQuickActionModel(
    id: FinancialQuickAction.viewHistory,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize),
    label: '${'view'.tr.capitalize!} ${'history'.tr.capitalize!}', 
  );

  static JPQuickActionModel payCommission = JPQuickActionModel(
    id: FinancialQuickAction.payCommission,
    child: const JPIcon(Icons.add_circle_outline_outlined, size: iconSize),
    label: '${'pay'.tr.capitalize!} ${'commission'.tr.capitalize!}', 
  );

  static JPQuickActionModel attachments = JPQuickActionModel(
    id: FinancialQuickAction.attachments,
    child: const JPIcon(Icons.attachment_outlined, size: iconSize),
    label: 'attachments'.tr.capitalize!, 
  );

  static JPQuickActionModel print =  JPQuickActionModel(
    id: FinancialQuickAction.print, 
    child: const JPIcon(Icons.print_outlined, size: iconSize), 
    label: 'print'.tr.capitalize!
  );
 
  static JPQuickActionModel delete =  JPQuickActionModel(
    id: FinancialQuickAction.delete, 
    child: const JPIcon(Icons.delete_outlined, size: iconSize), 
    label: 'delete'.tr.capitalize!
  );

  static JPQuickActionModel downloadView = JPQuickActionModel(
    id: FinancialQuickAction.downloadView,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize),  
    label: 'view'.tr.capitalize!
  );
  
  static JPQuickActionModel edit = JPQuickActionModel(
    id: FinancialQuickAction.edit, 
    child: const JPIcon(Icons.edit_outlined, size: iconSize), 
    label: 'edit'.tr.capitalize!
  );

  static JPQuickActionModel viewDepositReceipt = JPQuickActionModel(
    id: FinancialQuickAction.viewDepositReceipt,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize), 
    label: '${'view'.tr.capitalize!} ${'deposit'.tr.capitalize!} / ${'receipt'.tr.capitalize!}'
  );

  static JPQuickActionModel emailDepositReceipt = JPQuickActionModel(
    id: FinancialQuickAction.email, 
    child:  const JPIcon(Icons.email_outlined, size: iconSize), 
    label: '${'email'.tr.capitalize!} ${'deposit'.tr.capitalize!} / ${'receipt'.tr.capitalize!}'
  );

  static JPQuickActionModel downloadViewRefund = JPQuickActionModel(
    id: FinancialQuickAction.downloadViewRefund,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize), 
    label: 'view'.tr.capitalize!,
  );

  static JPQuickActionModel printDepositReceipt = JPQuickActionModel(
    id: FinancialQuickAction.printDepositReceipt, 
    child:  const JPIcon(Icons.print_outlined, size: iconSize), 
    label: '${'print'.tr.capitalize!} ${'deposit_receipts'.tr.capitalize!}'
  ); 
  
  static JPQuickActionModel cancelWithReason =  JPQuickActionModel(
    id: FinancialQuickAction.cancelWithReason, 
    child:  const JPIcon(Icons.cancel_outlined, size: iconSize), 
    label: 'cancel'.tr.capitalize!
  ); 

  static JPQuickActionModel cancelWithoutReason =  JPQuickActionModel(
    id: FinancialQuickAction.cancelWithoutReason, 
    child:  const JPIcon(Icons.cancel_outlined, size: iconSize), 
    label: 'cancel'.tr.capitalize!
  ); 

  static JPQuickActionModel email = JPQuickActionModel(
    id: FinancialQuickAction.email, 
    child:  const JPIcon(Icons.email_outlined, size: iconSize), 
    label: 'email'.tr.capitalize!
  );
  static JPQuickActionModel printInvoice = JPQuickActionModel(
    id: FinancialQuickAction.printInvoice, 
    child:  const JPIcon(Icons.print_outlined, size: 18), 
    label: '${'print'.tr.capitalize!} ${'invoice'.tr.capitalize!}'
  );

  static JPQuickActionModel viewInvoice =JPQuickActionModel(
    id: FinancialQuickAction.viewInvoice,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), 
    label: '${'view'.tr.capitalize!} ${'invoice'.tr.capitalize!}' ,
  );

  static JPQuickActionModel downloadViewInvoice =JPQuickActionModel(
    id: FinancialQuickAction.downloadViewInvoice,
    child: const JPIcon(Icons.remove_red_eye_outlined, size: 18), 
    label: 'view'.tr.capitalize! ,
  );

  static JPQuickActionModel recordPayment = JPQuickActionModel(
    id: FinancialQuickAction.recordPayment,
    child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: 18), 
    label: 'record_payment'.tr.capitalize! ,
  );

  static JPQuickActionModel qbPay = JPQuickActionModel(
    id: FinancialQuickAction.qbPay,
    child: Image.asset(AssetsFiles.quickBook), 
    label: 'qb_pay'.tr,
  );

  static JPQuickActionModel leapPay = JPQuickActionModel(
    id: FinancialQuickAction.leapPay,
    child: Image.asset(AssetsFiles.leapPay, height: 18, width: 18),
    label: 'leap_pay'.tr,
  );

  static JPQuickActionModel viewLinkedProposal = JPQuickActionModel(
    id: FinancialQuickAction.viewLinkedProposal,
    child: const JPIcon(Icons.description_outlined, size: 18), 
    label: 'view_linked_proposal'.tr,
  );

  static JPQuickActionModel applyCredit = JPQuickActionModel(
    id: FinancialQuickAction.applyCredit,
    child: const JPIcon(Icons.description_outlined, size: 18), 
    label: 'apply_credit'.tr,
  );

  static JPQuickActionModel linkProposal = JPQuickActionModel(
    id: FinancialQuickAction.linkProposal,
    child: const JPIcon(Icons.link_outlined, size: 18), 
    label: 'link_proposal'.tr,
  );

  static JPQuickActionModel unlinkProposal = JPQuickActionModel(
    id: FinancialQuickAction.unlinkProposal,
    child: const JPIcon(Icons.link_off_outlined, size: 18), 
    label: 'unlink_proposal'.tr,
  );

  static JPQuickActionModel sendViaText = JPQuickActionModel(
    id: FinancialQuickAction.sendViaText,
    child: const JPIcon(Icons.send_to_mobile_outlined, size: 18),
    label: 'send_via_text'.tr,
  );

  static JPQuickActionModel deleteInvoice = JPQuickActionModel(
    id: FinancialQuickAction.deleteInvoice,
    child: const JPIcon(Icons.delete_outlined, size: 18), 
    label: 'delete_invoice'.tr,
  );

  static JPQuickActionModel info = JPQuickActionModel(
    id: FinancialQuickAction.info,
    child: const JPIcon(Icons.info_outlined, size: 18), 
    label: 'info'.tr,
  );

  static JPQuickActionModel quickBookSyncError =  JPQuickActionModel(
    id: FinancialQuickAction.quickBookSyncError, 
    child: Image.asset(AssetsFiles.qbWarning), 
    label: 'quick_book_sync_error'.tr.capitalize!
  );

  static JPQuickActionModel editUnsavedResource = JPQuickActionModel(
      id: FinancialQuickAction.unsavedResourceEdit.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel deleteUnsavedResource = JPQuickActionModel(
      id: FinancialQuickAction.unsavedResourceDelete.toString(),
      label: 'delete'.tr,
      child: const JPIcon(Icons.delete_outlined, size: iconSize));
}
