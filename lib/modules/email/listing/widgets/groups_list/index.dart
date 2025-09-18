import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';
import 'package:jobprogress/modules/email/listing/shimmer.dart';
import 'package:jobprogress/modules/email/listing/widgets/groups_list/emails_list.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:sticky_headers/sticky_headers.dart';

class EmailsGroupList extends StatelessWidget {
  const EmailsGroupList({
    super.key,
    required this.controller,
  });

  final EmailListingController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const Expanded(
        child: EmailShimmer(),
      );
    } else if (!controller.isLoading && controller.emailGroup.isEmpty) {
      return controller.textController.text.isEmpty
          ? Expanded(
              child: NoDataFound(
                  icon: JPScreen.isDesktop ? null : Icons.email,
                  title: 'no_email_found'.tr.capitalize,
                  descriptions: 'try_changing_email_filter'.tr.capitalizeFirst,
              ),
        )
          : Expanded(
              child: NoDataFound(
                icon: JPScreen.isDesktop ? null : Icons.search,
                title: 'no_search_result'.tr.capitalize,
                descriptions: 'try_changing_your_search_parameter'.tr.capitalizeFirst,
              ),
            );
    } else {
      return JPListView(
        doAddFloatingButtonMargin: true,
        onLoadMore: controller.canShowLoadMore ? controller.loadMore : null,
        onRefresh: controller.refreshList,
        listCount: controller.emailGroup.length,
        itemBuilder: (_, index) {
          if (index < controller.emailGroup.length) {
            return Container(
              margin: EdgeInsets.only(
                  top: index == 0 ? 0 : 20,
                  bottom: (index == controller.emailGroup.length - 1) ? 16 : 0),
              child: StickyHeader(
                header: Container(
                  width: double.infinity,
                  color: JPScreen.isDesktop ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.inverse,
                  padding: const EdgeInsets.only(
                    bottom: 10,
                    left: 16,
                  ),
                  transform: Matrix4.translationValues(0.0, -1, 0.0),
                  child: JPText(
                      textColor: JPAppTheme.themeColors.tertiary,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.left,
                      text: controller.emailGroup[index].groupName),
                ),
                content: Material(
                  color: JPAppTheme.themeColors.base,
                  borderRadius: BorderRadius.circular(18),
                  child: EmailsList(
                    emails: controller.emailGroup[index],
                    showFirstLetterOfEmail: controller.showFirstLetterOfEmail,
                    showEmailListWithThreeDots: controller.showEmailListWithThreeDots,
                    onTap: (i) => controller.onTapEmail(index, i),
                    onLongPress: (int i) {
                      if(controller.jobId == null) {
                        controller.onEmailChecked(index, i);
                      }
                    },
                    selectedId: controller.selectedEmailId,
                  ),
                ),
              ),
            );
          } else if (controller.canShowLoadMore) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: FadingCircle(
                  color: JPAppTheme.themeColors.primary,
                  size: 25,
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      );
    }
  }
}
