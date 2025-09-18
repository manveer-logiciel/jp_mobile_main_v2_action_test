import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/services/company_contact_listing/actions.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/global_widgets/single_child_scroll_view.dart/index.dart';
import 'package:jobprogress/modules/company_contacts/list_tile/index.dart';
import 'package:jobprogress/modules/company_contacts/list_tile/shimmer.dart';
import 'package:jobprogress/modules/company_contacts/listing/selected_contact_list_item.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/animations/scale_and_rotate.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class CompanyContactListingView extends StatelessWidget {
  const CompanyContactListingView({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getContactList(CompanyContactListingController controller) {
      return controller.isLoading
          ? const Expanded(child: CompanyContactShimmer())
          : controller.companyContactsGroup.isNotEmpty
              ? JPSingleChildScrollView(
                  onLoadMore:
                      controller.canShowLoadMore ? controller.loadMore : null,
                  onRefresh: controller.refreshList,
                  isLoading: controller.isLoadMore,
                  item: Column(
                    children: [
                      for (var index = 0;
                          index < controller.companyContactsGroup.length;
                          index++)
                        if (index < controller.companyContactsGroup.length)
                          Container(
                              margin: EdgeInsets.only(
                                  top: index == 0 ? 0 : 20,
                                  bottom: (index ==
                                          controller
                                                  .companyContactsGroup.length -
                                              1)
                                      ? 16
                                      : 0),
                              child: CompanyContactsTileList(
                                  controller.companyContactsGroup[index],
                                  controller.isMultiSelectionOn,
                                  ((selectedContactIndex) {
                                controller.onContactChecked(
                                    index, selectedContactIndex);
                              }), controller)),
                      if (controller.isLoadMore)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Center(
                              child: FadingCircle(
                                  color: JPAppTheme.themeColors.primary,
                                  size: 25)),
                        ),
                      if (!controller.isLoadMore)
                        const SizedBox(
                            height: JPResponsiveDesign.floatingButtonSize),
                    ],
                  ))
              : controller.textController.text.isEmpty
                  ? Expanded(
                      child: NoDataFound(
                        icon: Icons.contact_page,
                        title: 'no_contact_found'.tr.capitalize,
                        descriptions:
                            'there_are_no_contact_found'.tr.capitalizeFirst,
                      ),
                    )
                  : Expanded(
                      child: NoDataFound(
                        icon: Icons.search,
                        title: 'no_search_result'.tr.capitalize,
                        descriptions: 'try_changing_your_search_parameter'
                            .tr
                            .capitalizeFirst,
                      ),
                    );
    }

    Widget getSecondaryHeader(CompanyContactListingController controller) {
      return Padding(
        padding: const EdgeInsets.only(right: 16, left: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: JPTextButton(
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openDrawer();
                  },
                  color: JPAppTheme.themeColors.tertiary,
                  icon: Icons.menu,
                  iconSize: 24,
                ),
              ),
              Expanded(
                child: JPInputBox(
                    type: JPInputBoxType.searchbar,
                    debounceTime: 700,
                    controller: controller.textController,
                    onChanged: controller.onSearchTextChanged,
                    hintText: 'search_contacts'.tr),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, right: 11),
            child: JPText(
              text: controller.textController.text.isNotEmpty &&
                      !controller.isLoading
                  ? (controller.totalContactLength < 2)
                      ? '${controller.totalContactLength} ${'result'.tr}'
                      : '${controller.totalContactLength} ${'results'.tr}'
                  : '',
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
            ),
          )
        ]),
      );
    }

    double getMaxHeight(CompanyContactListingController controller) {
      if (controller.isSelectedListHasElement) {
        return 100;
      }
      return 0;
    }

    return GetBuilder<CompanyContactListingController>(
        init: CompanyContactListingController(),
        global: false,
        builder: (controller) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: JPScaffold(
              scaffoldKey: controller.scaffoldKey,
              appBar: JPHeader(
                backIcon: controller.isMultiSelectionOn
                    ? IconButton(
                        splashRadius: 20,
                        onPressed: () async {
                          bool res = await controller.clearSelectedContact();
                          if (!res) Get.back();
                        },
                        icon: const JPIcon(Icons.close))
                    : null,
                onBackPressed: () async {
                  bool res = await controller.clearSelectedContact();
                  if (!res) Get.back();
                },
                title: "company_contacts".tr,
                actions: [
                  !controller.isMultiSelectionOn && controller.activeTag == null
                      ? !controller.isForJobContactFormSelection
                          ? IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                controller.scaffoldKey.currentState!
                                    .openEndDrawer();
                              },
                              icon: JPIcon(
                                Icons.menu,
                                color: JPAppTheme.themeColors.base,
                              )
                            )
                          : const SizedBox.shrink()
                      : JPPopUpMenuButton(
                          popUpMenuButtonChild: const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: JPIcon(Icons.more_vert),
                          ),
                          childPadding: const EdgeInsets.only(
                              left: 16, right: 16, top: 12, bottom: 12),
                          itemList: CompanyContactListingActions.getActions(
                              controller.isMultiSelectionOn,
                              controller.activeTag),
                          onTap: (PopoverActionModel selected) {
                            controller.handleHeaderActions(selected.value);
                          },
                          popUpMenuChild: (PopoverActionModel val) {
                            return JPText(text: val.label);
                          },
                        ),
                ],
              ),
              endDrawer: !controller.isForJobContactFormSelection
                  ? JPMainDrawer(
                      selectedRoute: 'company_contacts',
                      onRefreshTap: () {
                        controller.refreshList(showLoading: true);
                      })
                  : null,
              drawer: JPSecondaryDrawer(
                title: 'company_contacts'.tr.toUpperCase(),
                itemList: controller.drawerItems,
                onTapItem: controller.onTapDrawerItem,
                selectedItemSlug:
                    controller.activeTag?.id.toString() ?? 'all_contacts',
                tag: 'company_contacts',
                actionList: controller.drawerActions,
                onTapAction: controller.onTapDrawerAction,
              ),
              body: JPSafeArea(
                top: false,
                containerDecoration:
                    BoxDecoration(color: JPAppTheme.themeColors.inverse),
                child: Container(
                  color: JPAppTheme.themeColors.inverse,
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getSecondaryHeader(controller),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 15, left: 16),
                                child: JPText(
                                  textAlign: TextAlign.left,
                                  text: controller.getTitleText(),
                                  fontWeight: JPFontWeight.medium,
                                )),
                            AnimatedContainer(
                                constraints:
                                    BoxConstraints(maxHeight: getMaxHeight(controller)),
                                duration: const Duration(milliseconds: 100),
                                child: AnimatedList(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    controller: controller.scrollController,
                                    key: controller.animatedScrollKey,
                                    initialItemCount:
                                        controller.selectedContacts.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index, animation) {
                                      return CompanyContactSelectedContactItem(
                                        controller: controller,
                                          item: controller
                                              .selectedContacts[index],
                                          animation: animation);
                                    })),
                            getContactList(controller)
                          ]))
                    ],
                  ),
                ),
              ),
              floatingActionButton: (controller.isForJobContactFormSelection || controller.isMultiSelectionOn)
              ? null
              : JPButton(
                  key: const Key(WidgetKeys.addCompanyContactKey),
                  size: JPButtonSize.floatingButton,
                  iconWidget: JPIcon(
                    Icons.add,
                    color: JPAppTheme.themeColors.base,
                  ),
                  onPressed: controller.navigateToCreateCompanyContact,
                ),
        ),
      );
    });
  }

  Widget backIcon(CompanyContactListingController controller) =>
      JPScaleAndRotateAnim(
        firstChildKey: 'icon1',
        secondChildKey: 'icon2',
        firstChild: IconButton(
          icon: const JPIcon(Icons.arrow_back),
          iconSize: 22,
          splashRadius: 20,
          color: JPAppTheme.themeColors.base,
          onPressed: () {
            Get.back();
          },
        ),
        secondChild: IconButton(
          icon: const JPIcon(Icons.close),
          iconSize: 22,
          splashRadius: 20,
          color: JPAppTheme.themeColors.base,
          onPressed: controller.clearSelectedContact,
        ),
        forward: !controller.isMultiSelectionOn,
      );
}
