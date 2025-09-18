
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_multiselect.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'shimmer.dart';

class JPNetworkMultiSelect extends StatelessWidget {

  const JPNetworkMultiSelect({
    super.key,
    required this.selectedItems,
    required this.onDone,
    required this.type,
    this.inputHintText,
    this.title,
    this.additionalParams
  });

  final List<JPMultiSelectModel> selectedItems;

  final Function(List<JPMultiSelectModel> list) onDone;

  final JPNetworkMultiSelectType type;

  final String? inputHintText;

  final String? title;

  final Map<String, dynamic>? additionalParams;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPLoadMoreMultiSelectController>(
      init: JPLoadMoreMultiSelectController(type, additionalParams),
      builder: (controller) {
        return JPMultiSelect(
          title: title ?? 'select'.tr,
          inputHintText: inputHintText,
          mainList: controller.mainList,
          onLoadMore: controller.canShowLoadMore ? controller.onLoadMore : null,
          isLoadMore: controller.isLoadMore,
          isLoading: controller.isLoading,
          type: JPMultiSelectType.network,
          onSearch: controller.onSearch,
          initialSelectionsForNetworkList: selectedItems,
          totalNetworkListCount: controller.totalCount,
          canShowLoadMore: controller.canShowLoadMore,
          listLoader: const JPLoadMoreMultiSelectShimmer(),
          onDone: (list) {
            Get.back();
            onDone(list);
          },
        );
      }
    );
  }
}
