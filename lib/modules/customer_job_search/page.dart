import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../global_widgets/listview/index.dart';
import '../../../global_widgets/no_data_found/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import '../../common/enums/cj_list_type.dart';
import '../../common/models/popover_action.dart';
import '../../common/services/customer_job_search/actions.dart';
import '../../core/utils/helpers.dart';
import '../../global_widgets/details_listing_tile/index.dart';
import 'controller.dart';
import 'widgets/list_tile/shimmer.dart';

class CustomerJobSearchView extends StatelessWidget {
  const CustomerJobSearchView({super.key});

  @override
  Widget build(BuildContext context) {

    Widget getList(CustomerJobSearchController controller) {
      if(controller.isLoading) {
        return const Expanded(child: JobListTileShimmer());
      } else if(!(controller.jobList.isEmpty ^ controller.customerList.isEmpty)) {
        if((controller.jobList.isEmpty ^ controller.customerList.isEmpty) || controller.searchTextController.text.length >= 2) {
          return Expanded(
            child: NoDataFound(
              icon: controller.filterKeys.isWithJob ? Icons.work_outline :  Icons.person_outline,
              title: controller.filterKeys.isWithJob ? 'no_job_found'.tr.capitalize : 'no_customer_found'.tr.capitalize,
            ),
          );
        } else {
          return controller.pageType == PageType.fileListing
              ? Expanded(
            child: NoDataFound(
              icon: Icons.search,
              title:  'search_to_select_job'.tr.capitalize,
            ))
              : Expanded(
            child: Container(
              color: JPAppTheme.themeColors.base,
            ),
          );
        }
      } else {
        return JPListView(
          onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
          onRefresh: controller.refreshList,
          listCount: controller.filterKeys.isWithJob ?  controller.jobList.length : controller.customerList.length,
          itemBuilder: (context, index) {
            if (index < (controller.filterKeys.isWithJob ? controller.jobList.length : controller.customerList.length)) {
              return Column(
                children: [
                  CustomerJobDetailListingTile(
                    listType: controller.filterKeys.isWithJob ? CJListType.job : CJListType.customer,
                    pageType: controller.pageType,
                    customerIndex: index,
                    job: controller.filterKeys.isWithJob ? controller.jobList[index] : null,
                    customer: controller.filterKeys.isWithJob ? null : controller.customerList[index],
                    borderRadius: 0,
                    navigateToJobDetailScreen: controller.navigateToJobDetailScreen,
                    openJobQuickActions: controller.openJobQuickActions,
                    navigateToCustomerDetailScreen: controller.navigateToCustomerDetailScreen,
                    openCustomerQuickActions: controller.openCustomerQuickActions,
                    openDescDialog: controller.openDescDialog,
                    onTapProgressBoard: () => controller.openProgressBoard(index),
                    onTapJobSchedule: () => controller.openJobSchedule(index),
                    onTapAppointmentChip: () => controller.openAppointment(index),
                  ),
                  const SizedBox(height: 1,)
                ],
              );
            } else if (controller.canShowLoadMore) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16,),
                child: Center(
                    child: FadingCircle(
                        color: JPAppTheme.themeColors.primary,
                        size: 25)),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      }
    }

    return GetBuilder<CustomerJobSearchController>(
      global: false,
      init: CustomerJobSearchController(),
      builder: (controller) {
      return JPWillPopScope(
        onWillPop: controller.willPopScope,
        child: GestureDetector(
          onTap: () => Helper.hideKeyboard(),
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.base,
            appBar: JPHeader(
              onBackPressed: () => controller.willPopScope(),
              titleWidget: JPInputBox(
                  key: const Key(WidgetKeys.jobSearchInput),
                  controller: controller.searchTextController,
                  type: JPInputBoxType.searchbarWithoutBorder,
                  hintText: controller.filterKeys.isWithJob ? "job_search_hint".tr : "customer_search_hint".tr,
                  onChanged: controller.search,
                  textSize: JPTextSize.heading4,
                  scrollPadding: EdgeInsets.zero,
                  fillColor: JPAppTheme.themeColors.base,
                  cancelButtonSize: 24,
                  cancelButtonColor: JPAppTheme.themeColors.secondaryText.withValues(alpha: 0.6),
                  onTapSuffix: () => controller.clearSearch(clearText: true),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 10
                  ),
                  debounceTime: 300,
              ),
              backIconColor: JPAppTheme.themeColors.text,
              backgroundColor: JPAppTheme.themeColors.base,
              actions: [
                if(controller.searchTextController.text.isNotEmpty)
                  const SizedBox(
                    width: 5,
                  ),

                controller.getMoreIconButtons(),


                if(controller.pageType != PageType.selectJob && controller.pageType != PageType.selectCustomer)
                  Center(
                    child: JPPopUpMenuButton(
                      offset: const Offset(-5, 43),
                      popUpMenuButtonChild: Padding(
                        padding: const EdgeInsets.all(6),
                        child: JPIcon(Icons.tune, color: JPAppTheme.themeColors.text, size: 24,),
                      ),
                      itemList: CustomerJobSearchActions.getActions(controller.filterKeys.isWithJob),
                      popUpMenuChild: (PopoverActionModel val) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              JPText(text: val.label, textColor: val.isSelected ? JPAppTheme.themeColors.primary : null,),
                              const SizedBox(width: 24,),
                              val.isSelected
                                  ? JPIcon(Icons.check, color: JPAppTheme.themeColors.primary, size: 24,)
                                  : const SizedBox(width: 1,),
                            ],
                          ),
                        );
                      },
                      onTap: (PopoverActionModel selected) {
                        controller.updateListType();
                      },
                    ),
                  ),

                const SizedBox(
                  width: 12,
                )
              ],
            ),
            scaffoldKey: controller.scaffoldKey,
            body: JPSafeArea(
              top: false,
              containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
              child: Container(
                color: JPAppTheme.themeColors.inverse,
                padding: const EdgeInsets.only(top: 1),
                child: Column(
                  children: [
                    getList(controller),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
