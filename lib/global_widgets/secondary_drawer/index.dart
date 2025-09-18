import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/controller.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/list_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPSecondaryDrawer extends StatelessWidget {

  const JPSecondaryDrawer({
    super.key,
    required this.title,
    this.icon = Icons.close,
    required this.itemList,
    this.actionList,
    this.onTapItem,
    this.onTapAction,
    required this.selectedItemSlug,
    this.job,
    this.tag,
    this.headerActions,
    this.selectedSlugCount,
  });

  /// itemList will contain all the drawer items
  final List<JPSecondaryDrawerItem> itemList;

  /// itemList will contain all the drawer actions and will be displayed at the bottom
  final List<JPSecondaryDrawerItem>? actionList;

  /// title is used to display drawer title
  final String title;

  /// icon is used to display drawer close icon
  final IconData icon;

  /// callback to drawer item tap
  final Function(JPSecondaryDrawerItem slug)? onTapItem;

  /// callback to drawer action tap
  final Function(JPSecondaryDrawerItem slug)? onTapAction;

  /// selectedItemSlug is used to display selected item in drawer
  final String selectedItemSlug;

  /// used to display job counts in drawer
  final JobModel? job;

  /// used to create multiple instances of same controller
  /// in order to load same drawer with new data
  final String? tag;

  /// headerActions are used to display icons/widgets in between drawer title and cancel icon
  final List<Widget>? headerActions;

  /// selectedSlugCount can be used to show total number of items of selected slug
  final int? selectedSlugCount;

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(JPSecondaryDrawerController(job), tag: tag ?? title);

    return GetBuilder<JPSecondaryDrawerController>(
      init: controller,
        tag: tag ?? title,
        builder: (_) {
          return JPSafeArea(
            bottom: false,
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: JPResponsiveDesign.maxSizeMenuWidth
              ),
              child: Drawer(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20)
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 21, right: 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: JPText(
                                  text: title,
                                  fontWeight: JPFontWeight.medium,
                                  textSize: JPTextSize.heading3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: headerActions != null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: headerActions ?? [],
                              ),
                            ),
                            JPTextButton(
                                color: JPAppTheme.themeColors.text,
                                icon: icon,
                                iconSize: 24,
                                onPressed: () {
                                  Get.back();
                                })
                          ],
                        ),
                        Flexible(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18
                            ),
                            itemCount: itemList.length,
                            itemBuilder: (_, index) {

                              final isSelected = selectedItemSlug == itemList[index].slug;
                              final tempCount = controller.getCount(itemList[index].slug, job);
                              final count = isSelected ? selectedSlugCount ?? tempCount : tempCount;

                              return SecondaryDrawerListTile(
                                item: itemList[index],
                                job: job,
                                onTapTile: () {
                                  Get.back();
                                  if(itemList[index].route != null) {
                                    controller.handleRoute(
                                        itemList[index], selectedItemSlug);
                                  } else if(onTapItem != null) {
                                    onTapItem!(itemList[index]);
                                  }
                                },
                                isSelected: isSelected,
                                count: count,
                              );
                            },
                          ),
                        ),
                        if(actionList != null)
                          JPSafeArea(
                            top: false,
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                top: 5,
                                bottom: Helper.shouldApplySafeArea(context) ? 0 : 10
                              ),
                              itemCount: actionList!.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, index) {
                                return SecondaryDrawerListTile(
                                  item: actionList![index],
                                  onTapTile: () async {
                                    Get.back();
                                    if(onTapAction != null) {
                                      await Future<void>.delayed(const Duration(milliseconds: 300));
                                      onTapAction!(actionList![index]);
                                    }
                                  },
                                  isSelected: false,
                                );
                              },
                              separatorBuilder: (_, index) {
                                return const SizedBox(
                                  height: 0,
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  )
              ),
            ),
          );
        },
    );
  }
}
