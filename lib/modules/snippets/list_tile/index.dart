import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/snippet_trade_script.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/snippets/list_tile/shimmer.dart';
import 'package:jobprogress/modules/snippets/listing/controller.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'list_tile.dart';

class SnippetTradeList extends StatelessWidget {
  final SnippetsListingController controller;
  const SnippetTradeList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top:16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: JPInputBox(
                  fillColor: JPAppTheme.themeColors.base,
                  type: JPInputBoxType.searchbar,
                  debounceTime: 700,
                  hintText: 'search'.tr,
                  controller: controller.searchController,
                  onChanged: controller.onSearchTextChanged,
                ),
              ),
            ],
          ),
        ),
        controller.isLoading
            ? const SnippetTradeListShimmer()
            : controller.snippetList.isNotEmpty
                ? JPListView(
                    listCount: controller.snippetList.length,
                    padding: const EdgeInsets.only(
                        top: 20),
                    onLoadMore:
                        controller.canShowMore ? controller.loadMore : null,
                    onRefresh: controller.refreshList,
                    itemBuilder: (_, index) {
                      if (index < controller.snippetList.length) {
                        return SnippetTradeListTile(
                          data: controller.snippetList[index],
                          index: index,
                          onTap: () {
                            controller.openDetailsDialog(
                              controller.snippetList[index],
                            );
                          },
                          onCopyPressed: () {
                            controller.copyText(
                                controller.snippetList[index].description ?? ""
                            );
                          },
                        );
                      } else if (controller.canShowMore) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: FadingCircle(
                              size: 25,
                              color: JPAppTheme.themeColors.primary,
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  )
                : Expanded(
                    child: NoDataFound(
                      icon: Icons.task,
                      title: controller.type == STArg.snippet
                          ? 'no_snippet_found'.tr.capitalize
                          : 'no_trade_script_found'.tr.capitalize,
                    ),
                  )
      ],
    );
  }
}
