import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/enums/cj_list_type.dart';
import '../../../common/enums/page_type.dart';
import '../../../core/utils/helpers.dart';
import '../../../global_widgets/details_listing_tile/index.dart';
import '../../../global_widgets/safearea/safearea.dart';
import '../../../global_widgets/scaffold/index.dart';
import 'controller.dart';

class ReorderAbleJobListingView extends StatelessWidget {
  const ReorderAbleJobListingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReorderAbleJobListingController>(
      global: false,
      init: ReorderAbleJobListingController(),
      builder: (controller) {
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: 'back'.tr,
            onBackPressed: () => Get.back(result: controller.jobList),
          ),
          body: JPSafeArea(
            top: false,
            containerDecoration: BoxDecoration(color: JPAppTheme.themeColors.base),
            child: Container(
              color: JPAppTheme.themeColors.inverse,
              padding: const EdgeInsets.only(top: 1),
              child: ReorderableListView.builder(
                onReorder: controller.onListItemReorder,
                scrollController: controller.infiniteScrollController,
                itemCount: controller.jobList?.length ?? 0 + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index < (controller.jobList?.length ?? 0)) {
                    return Column(
                      key: Key('$index'),
                      children: [
                        CustomerJobDetailListingTile(
                          listType: CJListType.job,
                          pageType: PageType.fileListing,
                          customerIndex: index,
                          job: controller.jobList?[index],
                          borderRadius: 0,
                        ),
                        const SizedBox(height: 1,)
                      ],
                    );
                  } else if (Helper.isTrue(controller.canShowLoadMore)) {
                    return Padding(
                      key: Key('$index'),
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: FadingCircle(
                          color: JPAppTheme.themeColors.primary,
                          size: 25)),
                    );
                  } else {
                    return SizedBox.shrink(key: Key('$index'),);
                  }
                }
              ),
            ),
          ));
        });
  }
}