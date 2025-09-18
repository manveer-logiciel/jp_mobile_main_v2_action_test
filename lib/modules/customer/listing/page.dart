import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/cj_list_type.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/details_listing_tile/index.dart';
import '../../../global_widgets/listview/index.dart';
import '../../../global_widgets/no_data_found/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import '../list_tile/shimmer.dart';
import 'controller.dart';
import 'secondary_header.dart';

class CustomerListingView extends GetView<CustomerListingController> {
  const CustomerListingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget getCustomerList() {
      return controller.isLoading
        ?  const Expanded(child: CustomerListTileShimmer())
        : controller.customerList.isNotEmpty
          ? JPListView(
        listCount: controller.customerList.length,
        onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
        onRefresh: controller.refreshList,
        itemBuilder: (context, index) {
          if (index < controller.customerList.length) {
            return Column(
              children: [
                CustomerJobDetailListingTile(
                  key: ValueKey('${WidgetKeys.customerListingKey}[$index]'),
                  listType: CJListType.customer,
                  customerIndex: index,
                  customer: controller.customerList[index],
                  navigateToCustomerDetailScreen: controller.navigateToDetailScreen,
                  openCustomerQuickActions: controller.openQuickActions,
                  isLoadingMetaData: controller.isMetaDataLoading(index),
                  pageType: PageType.customerListing,
                  updateScreen:(){
                    controller.updateConsentStatus(index);
                  },
                  onTapEmailAction:() => controller.onTapEmailAction(
                      customerId: controller.customerList[index].id,
                    ),
                  onTapAppointmentChip: () => controller.openAppointment(index),
                ),
                const SizedBox(height: 10,)
              ],
            );
          } else if (controller.canShowLoadMore) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                  child: FadingCircle(
                      color: JPAppTheme.themeColors.primary,
                      size: 25)),
            );
          } else {
            return const SizedBox(height: JPResponsiveDesign.floatingButtonSize);
          }
        },
      )
          : Expanded(
        child: NoDataFound(
          icon: Icons.person_outline,
          title: 'no_customer_found'.tr.capitalize,
          descriptions: 'try_changing_filter'.tr.capitalizeFirst,
        ),
      );
    }

    return GetBuilder<CustomerListingController>(builder: (_) {
      return JPScaffold(
        appBar: JPHeader(
          title: 'customer_manager'.tr,
          onBackPressed: () => Get.back(),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              onPressed: () =>
                  controller.scaffoldKey.currentState!.openEndDrawer(),
              icon:  JPIcon(
                Icons.menu,
                color: JPAppTheme.themeColors.base,
              )
            ),
          ],
        ),
        scaffoldKey: controller.scaffoldKey,
        endDrawer: JPMainDrawer(
            selectedRoute: 'customer_manager',
            onRefreshTap: () {
              controller.refreshList(showShimmer: true);
            }),

        floatingActionButton: !AuthService.isPrimeSubUser() ? JPButton(
          size: JPButtonSize.floatingButton,
          iconWidget: JPIcon(
            Icons.add,
            color: JPAppTheme.themeColors.base,
          ),
          onPressed: controller.navigateToAddScreen,
        ) : const SizedBox.shrink(),
        body: JPSafeArea(
          top: false,
          containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
          child: Container(
            color: JPAppTheme.themeColors.inverse,
            child: Column(
              children: [
                CustomerListSecondaryHeader(),
                getCustomerList(),
                ],
              ),
            ),
          ),
        );
      });
  }
}
