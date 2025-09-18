import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../../../core/constants/assets_files.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../global_widgets/bottom_sheet/index.dart';
import '../../../global_widgets/plus_button_sheet/widgets/index.dart';
import '../../../routes/pages.dart';
import '../../enums/invoice_form_type.dart';
import '../../enums/job_financial_listing.dart';
import '../../models/job_financial/plus_button_actions.dart';

class JobFinancialPlusButtonService {
  static List<JPQuickActionModel> getQuickActionList() {
    List<JPQuickActionModel> quickActionList = [
    JPQuickActionModel(
      label: 'invoice'.tr,
      id: JFListingType.jobInvoices.toString(),
      child: SvgPicture.asset(AssetsFiles.jobInvoices),
    ),
    JPQuickActionModel(
      label: 'change_order'.tr,
      id: JFListingType.changeOrders.toString(),
      child: SvgPicture.asset(AssetsFiles.changeOrders),
    ),
    JPQuickActionModel(
      label: 'payment'.tr,
      id: JFListingType.paymentsReceived.toString(),
      child: SvgPicture.asset(AssetsFiles.paymentsReceived),
    ),
    JPQuickActionModel(
      label: 'credit'.tr,
      id: JFListingType.credits.toString(),
      child: SvgPicture.asset(AssetsFiles.credits,
      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
    ),
    JPQuickActionModel(
      label: 'refund'.tr,
      id: JFListingType.refunds.toString(),
      child: SvgPicture.asset(AssetsFiles.refund),
    ),
     JPQuickActionModel(
      label: 'bill'.tr,
      id: JFListingType.bill.toString(),
      child: SvgPicture.asset(AssetsFiles.bill),
    ),
    ];
    return quickActionList;
  }

  static Future<void> openQuickActions(PlusButtonActions params) async {
    List<JPQuickActionModel> quickActionList = getQuickActionList();
    if (params.job!.isMultiJob) {
      quickActionList = [quickActionList[0]];
    }
    showJPBottomSheet(
      child: (_) => JPPlusButtonSheet(
        job: params.job,
        onTapOption: (id) {
          Get.back();
          handleQuickActions(id,params);
        },
        options: quickActionList,
        onActionComplete: (String action) { 
          params.onActionComplete(action);
        },
      ),
    );
  }

  static void handleQuickActions(String action,PlusButtonActions params) {
    switch (action) {
      case "JFListingType.jobInvoices":
        navigateToJobInvoicesScreen(params);
        break;  
      case "JFListingType.changeOrders":
        navigateToChangeOrderFormScreen(params);
        break;
      case "JFListingType.paymentsReceived":
        navigateToPaymentReceiveScreen(params);
        break;
      case "JFListingType.credits":
        navigateToCreditsScreen(params);
        break;
      case "JFListingType.refunds":
        navigateToRefundsScreen(params);
        break;
      case "JFListingType.bill":
        navigateToBillScreen(params);
        break;
      default:
        break;
    }
  }

  static Future<void> navigateToJobInvoicesScreen(PlusButtonActions params) async {
    dynamic success = await Get.toNamed(Routes.invoiceForm, arguments: {
    NavigationParams.jobId : params.jobId,
    NavigationParams.pageType : InvoiceFormType.invoiceCreateForm});
    
    if(success != null) {
      params.onActionComplete();
    }
  }
  
  static Future<void> navigateToChangeOrderFormScreen(PlusButtonActions params) async{
    dynamic success = await Get.toNamed(Routes.invoiceForm, arguments: {
      NavigationParams.jobId : params.jobId,
      NavigationParams.pageType : InvoiceFormType.changeOrderCreateForm});
    
    if(success != null) {
      params.onActionComplete();
    }
  }
  
  static Future<void> navigateToPaymentReceiveScreen(PlusButtonActions params) async{
    dynamic success = await Get.toNamed(Routes.receivePaymentForm, arguments: {
      NavigationParams.jobId : params.jobId,});

    if(success != null) {
      params.onActionComplete();
    }
  }
  
  static Future<void> navigateToCreditsScreen(PlusButtonActions params) async{
    dynamic success = await Get.toNamed(Routes.applyCreditForm, arguments: {
      NavigationParams.jobId : params.jobId,});

    if(success != null) {
      params.onActionComplete();
    }
  }

  static Future<void> navigateToRefundsScreen(PlusButtonActions params) async{
    dynamic success = await Get.toNamed(Routes.refundForm, arguments: {
      NavigationParams.jobId: params.jobId,
      NavigationParams.customerId: params.customerId});

    if(success != null) {
      params.onActionComplete();
    }
  }
  
  static Future<void> navigateToBillScreen(PlusButtonActions params) async{
     dynamic success = await Get.toNamed(Routes.billForm, arguments: {
      NavigationParams.jobId: params.jobId,
      NavigationParams.customerId: params.customerId});

    if(success != null) {
      params.onActionComplete();
    }
  }
  
}