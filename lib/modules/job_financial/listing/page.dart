import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/job_financial_listing.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/global_widgets/secondary_header/index.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jobprogress/modules/job_financial/listing/listing_total_tile/invoices.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/job_overview_placeholders/header_placeholder.dart';
import 'controller.dart';

class JobFinancialListingView extends StatelessWidget{
  const JobFinancialListingView ({super.key,});
  @override
  Widget build(BuildContext context) { 
    return GetBuilder< JobFinancialListingModuleController>(
      init:  JobFinancialListingModuleController(),
      global: false,
      builder: (controller) => JPScaffold(
        scaffoldKey: controller.scaffoldKey,
        backgroundColor: JPAppTheme.themeColors.base,
        appBar: JPHeader(
          title: controller.listingType != JFListingType.commissionPayment ? 
            controller.job != null ? controller.job!.customer!.fullName! : '' : 
            controller.commissionUser!,
           titleWidget: controller.job == null && controller.isLoading ? const JobOverViewHeaderPlaceHolder() : null,
          onBackPressed: () {
            Get.back();
          },
          actions: [
            Visibility(
              visible: controller.showApplyPaymentButton && 
                PhasesVisibility.canShowSecondPhase && 
                PermissionService.hasUserPermissions([PermissionConstants.manageFinancial]),
              child: Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: JPButton(
                  text: 'apply_payment'.tr.toUpperCase(),
                  onPressed: controller.navigateToApplyForm,
                  type: JPButtonType.outline,
                  size: JPButtonSize.extraSmall,
                  colorType: JPButtonColorType.base,
                ),
              ),
            ),
             Visibility(
              visible: controller.canManagePriceHistory,
              child: Container(
                padding: const EdgeInsets.all(6),
                alignment: Alignment.center,
                child: JPIconButton(
                  backgroundColor: JPAppTheme.themeColors.secondary,
                  onTap: () => controller.onTapTotalJobPrice(),
                  icon: Icons.edit_outlined,
                  iconColor: JPAppTheme.themeColors.base,
                  iconSize: 20,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              child: JPIconButton(
                backgroundColor: JPAppTheme.themeColors.secondary,
                onTap: () => controller.scaffoldKey.currentState!.openEndDrawer(),
                icon: Icons.menu,
                iconColor: JPAppTheme.themeColors.base,
                iconSize: 24,
              ),
            ),
          ],
        ),   
        endDrawer: JPMainDrawer(
          selectedRoute: '',
          onRefreshTap: controller.refreshList  
        ),
        drawer: Helper.isValueNullOrEmpty(controller.job) ? null : JPSecondaryDrawer(
          title: 'job_menu'.tr.toUpperCase(),
          itemList: JobDrawerItemLists().jobSummaryItemList,
          selectedItemSlug: 'job_financial',
          job: controller.job,
          tag: controller.jobId.toString(),
        ),
        floatingActionButton: controller.showFloatingActionButton() ?
        JPButton(
            size: JPButtonSize.floatingButton,
            iconWidget: JPIcon(
              Icons.add,
              color: JPAppTheme.themeColors.base,
            ),
            onPressed: controller.handleFloatingActionButtonClick
          ) : null,
        body: JPSafeArea(
          child: Column(
            children: [
              if(controller.listingType != JFListingType.commissionPayment && !Helper.isValueNullOrEmpty(controller.job))
              JPSecondaryHeader(
                customerId: controller.customerId!,
                currentJob : controller.job,
                onJobPressed: controller.handleChangeJob,
                onTap: (){ 
                    controller.scaffoldKey.currentState!.openDrawer();
                }
              ),
              controller.isLoading ? controller.getShimmer() :
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: !Helper.isValueNullOrEmpty(controller.financialList),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          runSpacing: 5,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: double.infinity),
                            JPText(
                              text: controller.getTitle().toUpperCase(),
                              fontWeight: JPFontWeight.medium,
                              textAlign: TextAlign.left,
                              
                            ),
                            const SizedBox(width: 5),
                            Wrap(
                              children: [
                                JPText(
                                  text: controller.listingType != JFListingType.jobPriceHistory &&
                                  controller.listingType != JFListingType.jobInvoicesWithoutThumb? 
                                  '${'total'.tr}: ' : '',
                                  fontWeight: JPFontWeight.medium,
                                  textAlign: TextAlign.left,
                                ),
                                JPText(
                                  fontWeight: JPFontWeight.medium,
                                  text: controller.listingType != JFListingType.jobPriceHistory &&
                                  controller.listingType != JFListingType.jobInvoicesWithoutThumb? 
                                  JobFinancialHelper.getCurrencyFormattedValue(value:controller.totalAmount) : '',
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                    ),
                    getList(controller),
                  ],
                )
              ),          
            ],
          ),
        )
       )
    );
  }
}

Widget getList(JobFinancialListingModuleController controller) {
  return
    Helper.isValueNullOrEmpty(controller.financialList) ?
    Expanded(
      child: NoDataFound(
        icon: Icons.description_outlined,
        title:  '${'no'.tr} ${controller.getNoDataMessage()}',
      ),
    ) :
    Expanded(
      child: Column(
        children: [
          JPListView(
            padding: controller.listingType == JFListingType.jobInvoicesWithoutThumb  ?
            EdgeInsets.zero :
            controller.showFloatingActionButton() ?
            const EdgeInsets.only(bottom: 75): EdgeInsets.zero,
            onRefresh: controller.refreshList,
            listCount: controller.financialList.length-1, itemBuilder: (_, index)
            {
              return controller.getListTile(controller: controller, index: index);
            }
          ),
          if(controller.listingType == JFListingType.jobInvoicesWithoutThumb) ...{
            InvoiceTotalTile(controller: controller),
          }
        ],
      ),
    );
}
