import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/core/constants/subscriber_plan_code.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/company_switch_dialog_box/controller.dart';
import 'package:jobprogress/global_widgets/main_drawer/header.dart';
import 'package:jobprogress/global_widgets/main_drawer/item_lists.dart';
import 'package:jobprogress/global_widgets/main_drawer/controller.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/global_widgets/day_count_down/day_count.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'category_title.dart';
import 'footer.dart';
import 'list_item.dart';

class JPMainDrawer extends StatelessWidget {
  final String? selectedRoute;
  final VoidCallback? onRefreshTap;
  final JobModel? currentJob;

  JPMainDrawer({super.key, this.selectedRoute = '', this.currentJob, this.onRefreshTap});

  final JPMainDrawerItemLists itemLists = JPMainDrawerItemLists();

  @override
  Widget build(BuildContext context) {
    final MainDrawerController controller = Get.put(MainDrawerController());
    final CompanySwitchController companySwitchController =
        Get.put(CompanySwitchController());

    return Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8
        ),
        child: Drawer(
          width: JPResponsiveDesign.maxSizeMenuWidth,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
            ),
            child: GetBuilder<MainDrawerController>(builder: (_) {
              return controller.loggedInUser != null
                  ? Column(children: [
                      JPMainDrawerHeader(
                        loggedInUser: controller.loggedInUser!,
                      ),
                      JPDayCountDown(
                        horizontalPadding: 20,
                        topPadding: 15,
                        bottomPadding: 5,
                        remainingDays: controller.subscriberDetails?.subscription?.remainingDays,
                        visibility:  controller.subscriberDetails?.subscription?.plan?.code == SubscriberPlanCode.essentialFree30Days,
                        color: JPAppTheme.themeColors.text,  
                        showupgradeButton: true,
                        textSize: JPTextSize.heading4,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 17,
                              ),
                              for (int i = 0;
                                  i < itemLists.mainItemList.length;
                                  i++)
                                JPMainDrawerListItem(
                                    list: itemLists.mainItemList[i],
                                    selectedRoute: selectedRoute,
                                    onRefreshTap: onRefreshTap,
                                    currentJob: currentJob,
                                ),
                              JPMainDrawerCategoryTitle(title: 'media'.tr),
                              for (int i = 0;
                                  i < itemLists.mediaItemList.length;
                                  i++)
                                JPMainDrawerListItem(
                                  list: itemLists.mediaItemList[i],
                                  selectedRoute: selectedRoute,
                                  onRefreshTap: onRefreshTap,
                                  currentJob: currentJob,
                                ),
                              JPMainDrawerCategoryTitle(title: 'others'.tr.toUpperCase()),
                              for (int i = 0;
                                  i < itemLists.otherItemList.length;
                                  i++)
                                JPMainDrawerListItem(
                                  list: itemLists.otherItemList[i],
                                  selectedRoute: selectedRoute,
                                  onRefreshTap: onRefreshTap,
                                  currentJob: currentJob,
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 24),
                                    child: JPTextButton(
                                      text: 'privacy_policy'.tr,
                                      padding: 5,
                                      textSize: JPTextSize.heading4,
                                      color: JPAppTheme.themeColors.darkGray,
                                      textDecoration: TextDecoration.underline,
                                      onPressed: () {
                                        Helper.launchUrl(Urls.termAndConditionUrl);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 24),
                                    child: JPTextButton(
                                      text: 'terms_of_use'.tr,
                                      padding: 5,
                                      textSize: JPTextSize.heading4,
                                      color: JPAppTheme.themeColors.darkGray,
                                      textDecoration: TextDecoration.underline,
                                      onPressed: () {
                                        Helper.launchUrl(Urls.termsOfUseUrl);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
                      JPMainDrawerFooter(
                          loggedInUser: controller.loggedInUser!,
                          onTap: () {
                            companySwitchController.openCompanySwitchBox(false);
                          }),
                    ])
                  : const SizedBox.shrink();
            }),
        ),
    );
  }
}
