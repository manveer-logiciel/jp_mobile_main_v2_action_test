import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/single_field_shimmer/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/models/customer_list/customer_listing_filter.dart';
import '../filter_dialog/index.dart';
import 'controller.dart';

class CustomerListSecondaryHeader extends StatelessWidget {
  CustomerListSecondaryHeader({super.key});

  final customerController = Get.put(CustomerListingController());

  void openCustomFilters() {

    showJPGeneralDialog(
      child:(controller) => CustomerListingDialog(
        selectedFilters: customerController.filterKeys,
        defaultFilterKeys: customerController.defaultFilterKeys,
        onApply: (CustomerListingFilterModel params) {
          customerController.applyFilters(params);
        },
      )
    );
  }

  void openSortBy() {
    customerController.setSortByList();
    SingleSelectHelper.openSingleSelect(
      customerController.sortByList ?? [],
      customerController.filterKeys.selectedItem,
      'sort_by'.tr,
      (value) {
        customerController.applySortFilters(value);
        Get.back();
      } ,
      isFilterSheet: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 11, top: 10, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///   Sort By
          customerController.sortByList?.isEmpty ?? true
            ? const JPSingleFieldShimmer(height: 10, width: 100,)
            : Material(
            key: const ValueKey(WidgetKeys.customerListingSortFilterKey),
            color: JPAppTheme.themeColors.inverse,
            child: JPTextButton(
                color: JPAppTheme.themeColors.tertiary,
                onPressed: () => openSortBy(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading5,
                text: "${"sort_by".tr}: ${customerController.sortByList!.firstWhere(
                        (element) => element.id == customerController.filterKeys.selectedItem).label}",
                icon: Icons.keyboard_arrow_down_outlined
            ),
          ),
          ///   Filters
          JPFilterIcon(
            onTap: () => openCustomFilters(),
          ),
        ],
      ),
    );
  }
}