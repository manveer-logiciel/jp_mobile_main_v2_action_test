import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/enums/payment_form_type.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/common/services/credit/apply_credit_form.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/index.dart';
import 'package:jobprogress/common/services/job_financial/quick_action_repo/invoices_without_thumb_repo.dart';
import 'package:jobprogress/common/services/worksheet/helpers.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

import '../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../enums/beacon_access_denied_type.dart';
import '../../enums/invoice_form_type.dart';
import '../../enums/resource_type.dart';

class JobFinancialListQuickActionHandlers{

  static void view({required JFListingType type , required FinancialListingModel model}){
    JobFinancialListingQuickActionRepo.view(type: type, model: model);
  }

  static void viewHistory({
    required int jobId, 
    required int customerId, 
    required FinancialListingModel model,
    required final Function(FinancialListingModel model, String action) onActionComplete}) async{
        await Get.toNamed(
          Routes.jobfinancialListingModule,
          arguments:{
          'listing': JFListingType.commissionPayment,
          'jobId':jobId,
          'customer_id':customerId,
          'commission_id':model.id,
          'commission_user': model.paidTo!.fullName,
        },
        preventDuplicates: false
      );
      onActionComplete(model,FinancialQuickAction.payCommission);
    }

  
  static void openQuickBookSyncErrorBottom({required JFListingType type , required int modelId}){
    JobFinancialListingQuickActionRepo.openQuickBookSyncErrorBottomSheet(type: type, id: modelId);
  }

  static Future<void> applyCredit({JPBottomSheetController? controller, required FinancialListingModel model, int? jobId, final Function(FinancialListingModel model, String action)? onActionComplete, bool hadUnappliedAmount = false, List<FinancialListingModel>? unAplliedCreditList}) async { 
    if(hadUnappliedAmount){
      try{
        controller?.toggleIsLoading();
        bool success = await JobFinancialRepository.ajdustUnappliedCredit(ApplyCreditFormService.getApplyCreditBottomSheetParams(model, unAplliedCreditList!));
        if(success){
          Helper.showToastMessage('${'credit'.tr.capitalize!} ${'applied'.tr}');
          Get.back();
        }
      } catch(e){
        rethrow;
      } finally {
        controller?.toggleIsLoading();
      }
      
    } else {
      await Get.toNamed(Routes.applyCreditForm, arguments: { NavigationParams.jobId: jobId, NavigationParams.invoiceId: model.id});
    }
    onActionComplete!(model, FinancialQuickAction.applyCredit);
  }

  static Future<dynamic> cancelWithDialogBox({required JFListingType type, 
    required int jobId, 
    required String val,
    required VoidCallback toggleIsLoading, 
    required int id}) async {
    try {
      return await JobFinancialListingQuickActionRepo.cancelWithDialogBox(val: val, jobId: jobId, type: type, id: id);
    } catch(e) {
      rethrow;
    } finally {
      toggleIsLoading();  
    }
  }

  static Future<void> receivePayment({
    required FinancialListingModel model,
    int? jobId,
    bool isRecordPayment = true,
    final Function(FinancialListingModel model, String action)? onActionComplete,
  }) async {
    await Get.toNamed(Routes.receivePaymentForm, arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.invoiceId: model.id,
      NavigationParams.receivePaymentFormType: isRecordPayment
          ? ReceivePaymentFormType.recordPayment
          : ReceivePaymentFormType.processPayment,
      if (!isRecordPayment) ...{
        NavigationParams.receivePaymentActionFrom: 'quick_action',
        NavigationParams.financialDetails: model
      },
    });
    onActionComplete!(model, FinancialQuickAction.recordPayment);
  }

   static Future<dynamic> delete({required int id , required JFListingType type,required VoidCallback  toggleIsLoading}) async {
    try {
      return await JobFinancialListingQuickActionRepo.delete(type: type, id: id);
    } catch(e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }

  static Future<dynamic> cancelWithoutDialogBox({required JFListingType type, required int id, required VoidCallback toggleIsLoading}) async {
    try {
      return await JobFinancialListingQuickActionRepo.cancelWithoutDialogBox( type: type, id: id);
    } catch(e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }
   
  static Future<dynamic> print({int? id, int? invoiceId, required JFListingType type, String? url}) async {
    try {
      showJPLoader(msg: 'downloading'.tr);
      return await JobFinancialListingQuickActionRepo.print(type: type, id: id, invoiceId: invoiceId , url: url);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  static Future<dynamic> downloadView({int? invoiceId, required JFListingType type, int? id , String? url}) async {
    try {
      showJPLoader(
        msg: 'downloading'.tr
      );
      return await JobFinancialListingQuickActionRepo.downlodView( type: type, id: id, invoiceId: invoiceId, url: url);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  
  static Future<dynamic> downloadViewProposal({required String proposalUrl}) async{
    try {
      showJPLoader(
        msg: 'downloading'.tr
      );
      return await JobFinancialInvoicesWithoutThumbQuickActionRepo.downloadViewProposal(proposalUrl: proposalUrl);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> linkedProposal({required int id, required int proposalId}) async {
     try {
      return await JobFinancialInvoicesWithoutThumbQuickActionRepo.linkProposal(id: id, proposalId: proposalId);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  static Future<dynamic> unlinkedProposal({required int id}) async {
     try {
      return await JobFinancialInvoicesWithoutThumbQuickActionRepo.unlinkProposal(id: id);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  static Future<dynamic> qbPay({required String shareUrl}) async{
    try {
      return await JobFinancialInvoicesWithoutThumbQuickActionRepo.qbPay(shareUrl: shareUrl);
    } catch(e) {
      rethrow;
    } 
  }

  static Future<dynamic> deleteInvoice({required String note, required String password, required int id})async{
    try {
      return await JobFinancialInvoicesWithoutThumbQuickActionRepo.deleteInvoice(note: note, password: password, id: id);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }   
  }

  static Future<void> onEditPress(FinancialListingModel model, JFListingType type, int? jobId, int? customerId, void Function(dynamic modal, String action) onActionComplete) async {
    switch(type) {
      case JFListingType.accountspayable:
        navigateToBillForm(model, jobId, customerId, onActionComplete);
        break;
      case JFListingType.changeOrders:
      case JFListingType.jobInvoicesWithoutThumb:
        navigateToEditUnsavedResource(model, type, jobId!, customerId, onActionComplete);
        break;
      default:
        break;
    }
  }

  static Future<void> navigateToBillForm(FinancialListingModel model, int? jobId,
      int? customerId, Function(FinancialListingModel model, String action) onActionComplete) async {
    final result = await Get.toNamed(Routes.billForm, arguments: {
      NavigationParams.jobId: jobId,
      NavigationParams.customerId: customerId,
      NavigationParams.bill: model
    });
    if(result != null && result) {
      onActionComplete(model, FinancialQuickAction.accountPayable);
    }
  }

  static void navigateToEditUnsavedResource(FinancialListingModel model, JFListingType type, int jobId, int? customerId, void Function(dynamic modal, String action) onActionComplete) {
    BeaconAccessDeniedType beaconAccessDeniedType;
    if(model.type != null) {
      beaconAccessDeniedType = model.type == 'change_order' ?
      BeaconAccessDeniedType.changeOrder : BeaconAccessDeniedType.invoice;
    } else {
      beaconAccessDeniedType = type == JFListingType.changeOrders ?
      BeaconAccessDeniedType.changeOrder : BeaconAccessDeniedType.invoice;
    }
    WorksheetHelpers.checkIsNotBeaconOrBeaconAccountExist(model.beaconAccountId, (isNotBeaconOrBeaconAccountExist) async {
      if(isNotBeaconOrBeaconAccountExist) {
        dynamic result;
        switch (type) {
          case JFListingType.jobInvoicesWithoutThumb:
            if(model.type == ResourceType.changeOrder) {
              result = await navigateToInvoiceForm(jobId: jobId, invoiceId: model.id,
                  pageType: InvoiceFormType.changeOrderFromInvoiceForm);
            } else if(model.type == ResourceType.unsavedResource) {
              result = await navigateToInvoiceForm(jobId: jobId, id: model.id,
                  unsavedResourceId: model.unsavedResourceId,
                  pageType: model.id == null ?  InvoiceFormType.invoiceCreateForm :  InvoiceFormType.invoiceEditForm);
            } else {
              result = await navigateToInvoiceForm(jobId: jobId, id: model.id,
                  pageType: InvoiceFormType.invoiceEditForm);
            }
            break;
          case JFListingType.changeOrders:
            result = await navigateToInvoiceForm(jobId: jobId, id: model.id,
                unsavedResourceId: model.unsavedResourceId,
                pageType: model.id == null ? InvoiceFormType.changeOrderCreateForm : InvoiceFormType.changeOrderEditForm);
            break;
          default:
            break;
        }
        if(result != null) {
          onActionComplete(model, FinancialQuickAction.unsavedResourceEdit);
        }
      }
    }, type: beaconAccessDeniedType);
  }

  static Future<dynamic> navigateToInvoiceForm({int? jobId, int? id,int? invoiceId, int? unsavedResourceId, InvoiceFormType? pageType}) async =>
      await Get.toNamed(Routes.invoiceForm, arguments: {
        NavigationParams.jobId : jobId,
        NavigationParams.id : id,
        NavigationParams.invoiceId : invoiceId,
        NavigationParams.dbUnsavedResourceId : unsavedResourceId,
        NavigationParams.pageType : pageType});

  static Future<void> navigateToDeleteUnsavedResource(FinancialListingModel model, JFListingType type, int jobId, int? customerId, void Function(dynamic modal, String action) onActionComplete) async {
    showJPLoader(msg: "deleting_auto_saved_resource");
    dynamic result;
    result = await UnsavedResourcesHelper.deleteUnsavedResource(id: model.unsavedResourceId ?? 0);
    Get.back();
    if(result != null) {
      onActionComplete(model, FinancialQuickAction.unsavedResourceDelete);
    }
  }
} 
