
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jobprogress/modules/job_financial/shimmer/index.dart';
import 'package:jobprogress/modules/job_financial/widgets/apporve_reject_tile.dart';
import 'package:jobprogress/modules/job_financial/widgets/circle_progress_bar_tile.dart';
import 'package:jobprogress/modules/job_financial/widgets/comman_tile.dart';
import 'package:jobprogress/modules/job_financial/widgets/main_tile.dart';
import 'package:jobprogress/modules/job_financial/widgets/note_tile.dart';
import 'package:jobprogress/modules/job_financial/widgets/total_job_price_tile.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/has_permission/index.dart';
import '../../core/constants/phases_visibility.dart';
import 'controller.dart';

class JobFinancialView extends StatelessWidget{
  const JobFinancialView ({super.key});

  @override
  Widget build(BuildContext context) { 
    return GetBuilder<JobFinancialController>(
      init:  JobFinancialController(),
      global: false,
      builder: (controller) => JPScaffold(
        scaffoldKey: controller.scaffoldKey,
        backgroundColor: JPAppTheme.themeColors.base,
        appBar: JPHeader(
          title: controller.job != null && controller.job!.customer != null ? controller.job!.customer!.fullName! : '',
           titleWidget: controller.job == null && controller.isLoading ? const JobOverViewHeaderPlaceHolder() : null,
          onBackPressed: () {
            Get.back();
          },
          actions: [
            IconButton(
              splashRadius: 20,
              onPressed: () {
                controller.scaffoldKey.currentState!.openEndDrawer();
              },
              icon: JPIcon(
                Icons.menu,
                color: JPAppTheme.themeColors.base,
              ),
            )
          ],
        ),
        endDrawer: JPMainDrawer(
          onRefreshTap: controller.refreshScreen,
          selectedRoute: '',
        ),
        drawer: Helper.isValueNullOrEmpty(controller.job) ? null : JPSecondaryDrawer(
          title: 'job_menu'.tr.toUpperCase(),
          itemList: JobDrawerItemLists().jobSummaryItemList,
          selectedItemSlug: 'job_financial',
          job: controller.job,
          tag: controller.jobId.toString(),
        ),
        floatingActionButton: HasPermission(
          permissions: const [PermissionConstants.manageFinancial],
          child: Visibility(
            visible: !controller.disableFinancial,
            child: JPButton(
                key: const ValueKey(WidgetKeys.addButtonKey),
                size: JPButtonSize.floatingButton,
                disabled: controller.isLoading,
                iconWidget: JPIcon(
                  Icons.add,
                  color: JPAppTheme.themeColors.base,
                ),
                onPressed: controller.navigateToCreateAppointment,
              ),
          ),
        ),
        body: JPSafeArea(
          child: Container(
            color: JPAppTheme.themeColors.inverse,
            child: Column(
              children: [
                if(!Helper.isValueNullOrEmpty(controller.job))
                JPSecondaryHeader(
                  customerId: controller.customerId,
                  currentJob : controller.job,
                  onJobPressed: controller.handleChangeJob,
                  onTap: (){
                    controller.scaffoldKey.currentState!.openDrawer();
                  }
                ),
                controller.isLoading ?
                  const JobFinancialShimmer() :
                  Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: 
                    Stack(
                      children: [
                        Container(
                          height: 167,
                          color: JPAppTheme.themeColors.secondary,                   
                        ),
                        Column(
                          children:[
                            JobFinanacialTotalJobPriceTile(
                              controller: controller,
                              canBlockFinancials: controller.disableFinancial,
                              value: JobFinancialHelper.getCurrencyFormattedValue(
                              value: controller.financialDataModel.totalPrice),
                              showDoneIcon: controller.job?.jobAmountApprovedBy ?? false
                            ),
                            JobFinancialMainTile( 
                               job: controller.job,
                               jobPrice:JobFinancialHelper.getCurrencyFormattedValue(value: controller.financialDataModel.jobPrice),
                               invoiceAmount:JobFinancialHelper.getCurrencyFormattedValue(value:controller.job?.financialDetails?.jobInvoiceAmount),
                               estimatedTax: JobFinancialHelper.getCurrencyFormattedValue(value: controller.financialDataModel.estimateTax.toString()),
                               invoicedTax: JobFinancialHelper.getCurrencyFormattedValue(value:controller.job?.financialDetails?.jobInvoiceTaxAmount),
                             ),
                            if(controller.jobPriceRequestedUpdate != null && controller.isJobPriceRequestSubmitFeatureEnabled)
                              ApporveRejectJobRequestTile(controller: controller),
                            JobFinancialTile(
                              onTap: () async {
                                await  Get.toNamed(
                                  Routes.jobfinancialListingModule,
                                  arguments: {
                                    'listing': JFListingType.changeOrders, 
                                    'jobId':controller.jobId,
                                    'job':controller.job,
                                    'customer_id':controller.customerId
                                  }
                                );
                                controller.refreshScreen();
                              },
                              circleAvtarBackgroundColor: JPAppTheme.themeColors.lightRed, 
                              circleAvtarIcon: Icons.currency_exchange_outlined, 
                              circleAvtarIconColor: controller.disableFinancial ? 
                                JPAppTheme.themeColors.darkRed.withValues(alpha: 0.5) :
                                JPAppTheme.themeColors.darkRed, 
                              title: '${'change_orders'.tr} / ${'other_charges'.tr}', 
                              amount:JobFinancialHelper.getCurrencyFormattedValue(value: controller.job?.financialDetails?.totalChangeOrderAmount),
                              canBlockFinancials: controller.disableFinancial,
                            ),
                            JobFinancialCircularProgresBarTile(
                              onTap: () async {
                                await  Get.toNamed(
                                  Routes.jobfinancialListingModule, 
                                  arguments: {
                                    'listing': JFListingType.paymentsReceived, 
                                    'jobId':controller.jobId, 
                                    'customer_id':controller.customerId
                                  }
                                );
                                controller.refreshScreen();
                              },
                              title: 'payments'.tr,
                              unappliedAmount: controller.job?.financialDetails?.unappliedPayment, 
                              amount: controller.financialDataModel.paymentReceivedAmount,
                              appliedAmount: controller.job?.financialDetails?.appliedPayment,
                              canBlockFinancial: controller.disableFinancial, 
                              controller: controller, 
                              progressBarValue: controller.financialDataModel.paymentReceivedProgressbarValue,
                            ),
                            JobFinancialCircularProgresBarTile(
                              onTap: () async {
                                await Get.toNamed(
                                  Routes.jobfinancialListingModule,
                                  arguments: {
                                    'listing': JFListingType.credits, 
                                    'jobId':controller.jobId, 
                                    'customer_id':controller.customerId
                                  }
                                );
                                controller.refreshScreen();
                              },
                              title: 'credits'.tr,
                              amount: controller.job?.financialDetails?.totalCredits ?? 0, 
                              appliedAmount: controller.job?.financialDetails?.appliedCredits ,
                              unappliedAmount: controller.job?.financialDetails?.unappliedCredits, 
                              canBlockFinancial: controller.disableFinancial,
                              showInfoButton: true, 
                              controller: controller,
                              progressBarValue: controller.financialDataModel.creditProgressbarValue,
                            ),
                            JobFinancialTile(
                            showInfoButton: true,
                              circleAvtarBackgroundColor: JPAppTheme.themeColors.lemon, 
                              circleAvtarIcon: JobFinancialHelper.getCurrencyIcon(),
                              circleAvtarIconColor: controller.disableFinancial ?
                                JPAppTheme.themeColors.darkYellow.withValues(alpha: 0.5) : JPAppTheme.themeColors.darkYellow,
                              title: 'amount_owed'.tr, 
                              refundAdjustedAmount: controller.getRefundAdjustedAmount,
                              amount: JobFinancialHelper.getCurrencyFormattedValue(value:controller.job?.financialDetails?.pendingPayment),
                              amountColor: controller.disableFinancial ?
                                JPAppTheme.themeColors.warning.withValues(alpha: 0.5) :
                                JPAppTheme.themeColors.warning,
                              canBlockFinancials: controller.disableFinancial,
                            ),        
                            JobFinancialTile(
                              onTap: () async {
                                await Get.toNamed(
                                  Routes.jobfinancialListingModule,
                                  arguments: {
                                    'listing': JFListingType.refunds, 
                                    'jobId':controller.jobId, 
                                    'customer_id':controller.customerId
                                  }
                                );
                                controller.refreshScreen();
                              }, 
                              circleAvtarBackgroundColor: JPAppTheme.themeColors.mintGreen, 
                              circleAvtarIcon: Icons.account_balance_wallet_outlined, 
                              circleAvtarIconColor: controller.disableFinancial ?
                              JPAppTheme.themeColors.oliveGreen.withValues(alpha: 0.5) : JPAppTheme.themeColors.oliveGreen,
                              title: 'refunds'.tr,
                              canBlockFinancials: controller.disableFinancial,
                              amount: JobFinancialHelper.getCurrencyFormattedValue(value: controller.job?.financialDetails?.totalRefunds),
                            ),
                            JobFinancialTile(
                              onTap: () async {
                                await Get.toNamed(
                                  Routes.jobfinancialListingModule,
                                  arguments: {
                                    'listing': JFListingType.commission,
                                    'jobId':controller.jobId,
                                    'customer_id': controller.customerId
                                  }
                                );
                                controller.refreshScreen();
                              },
                              circleAvtarBackgroundColor: JPAppTheme.themeColors.lightPurple, 
                              circleAvtarIcon: Icons.payments_outlined, 
                              circleAvtarIconColor: controller.disableFinancial ? 
                                JPAppTheme.themeColors.darkPurple.withValues(alpha: 0.5) :
                                JPAppTheme.themeColors.darkPurple, 
                              canBlockFinancials: controller.disableFinancial,
                              title: 'commissions'.tr,
                              amount:JobFinancialHelper.getCurrencyFormattedValue(value: controller.job?.financialDetails?.totalCommission),
                            ),
                            JobFinancialTile(
                              onTap: () async {
                                await Get.toNamed(
                                  Routes.jobfinancialListingModule,
                                  arguments: {
                                    'listing': JFListingType.accountspayable, 
                                    'jobId':controller.jobId, 
                                    'customer_id':controller.customerId
                                  },
                                );
                                controller.refreshScreen();
                              },
                              canBlockFinancials: Helper.isValueNullOrEmpty(controller.job?.financialDetails),
                              circleAvtarBackgroundColor: JPAppTheme.themeColors.uranianBlue, 
                              circleAvtarIcon: Icons.request_quote_outlined, 
                              circleAvtarIconColor:JPAppTheme.themeColors.cornFlowerBlue, 
                              title: 'accounts_payable'.tr,
                              amount: JobFinancialHelper.getCurrencyFormattedValue(value: controller.job?.financialDetails?.totalAccountPayableAmount),
                            ),
                            if(!Helper.isValueNullOrEmpty(controller.job?.financialDetails))
                            Visibility(
                              visible: PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]) || controller.note.isNotEmpty,
                              child: JobFinancialNoteTile(controller: controller)),   
                              SizedBox(
                                height: (PhasesVisibility.canShowSecondPhase
                                  ? JPResponsiveDesign.floatingButtonSize : 0) + 20,
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
       )
    );
  }
}

