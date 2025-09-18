import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/models/network_singleselect/params.dart';
import 'package:jobprogress/global_widgets/network_singleselect/controller.dart';
import 'package:jobprogress/global_widgets/network_singleselect/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPNetworkSingleSelect extends StatelessWidget {

  const JPNetworkSingleSelect({
    super.key,
    this.selectedItemId,
    required this.onDone,
    required this.type,
    this.inputHintText,
    this.title,
    this.requestParams,
    this.optionsList = const [],
  });

  /// [selectedItemId] is id of selected item, [null] indicates no items selected
  final String? selectedItemId;

  /// [onDone] returns selected instance of single select to extract useful data from
  final Function(JPSingleSelectModel) onDone;

  /// [type] can be used to separate network lists
  final JPNetworkSingleSelectType type;

  /// [inputHintText] used to proved input hint to search field
  final String? inputHintText;

  /// [title] used to give title to selector dialog
  final String? title;

  /// [requestParams] used to pass additional params to api
  final JPSingleSelectParams? requestParams;

  /// [optionsList] used to hold options to select from
  final List<JPSingleSelectModel> optionsList;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPNetworkSingleSelectController>(
        init: JPNetworkSingleSelectController(
          type: type,
          requestParams: requestParams,
          mainList: optionsList
        ),
        builder: (controller) {
          return JPSingleSelect(
            title: title ?? 'select'.tr,
            inputHintText: inputHintText,
            mainList: controller.mainList,
            onLoadMore: controller.canShowLoadMore ? controller.onLoadMore : null,
            isLoadMore: controller.isLoadMore,
            isLoading: controller.isLoading,
            type: JPSingleSelectType.network,
            canShowLoadMore: controller.canShowLoadMore,
            selectedItemId: selectedItemId,
            canShowSearchBar: controller.canSearch,
            onSearch: controller.onSearch,
            listLoader: const JPNetworkSingleSelectShimmer(),
            onItemSelect: (selectedItemId) {
              final selectedItem = controller.getSelectedItem(selectedItemId);
              if(selectedItem != null) onDone(selectedItem);
            },
          );
        }
    );
  }
}
