import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/task/template_listing/controller.dart';
import 'package:jobprogress/modules/task/template_listing/list_tile/shimmer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'list_tile.dart';

class TaskTemplateList extends StatelessWidget {
  final TaskTemplateListingController controller;
  const TaskTemplateList({super.key, required this.controller});

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
        controller.isLoading ? 
          const TaskTemplateListShimmer(): 
          controller.templateList.isNotEmpty
            ? JPListView(
                listCount: controller.templateList.length,
                padding: const EdgeInsets.only(top: 20),
                onLoadMore: controller.canShowMore ? controller.loadMore : null,
                onRefresh: controller.refreshList,
                itemBuilder: (_, index) {
                  if (index < controller.templateList.length) {
                    return TaskTemplateListTile(
                      data: controller.templateList[index],
                      index: index,
                      onTap: () {
                        Get.back(result: controller.templateList[index]);
                      },
                      onViewPressed: () {
                        controller.openTemplateInDialog(controller.templateList[index]);
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
            :  Expanded(
                child: NoDataFound(
                  icon: Icons.task,
                  title: 'no_template_found'.tr.capitalize,
                ),
              )
      ],
    );
  }
}
