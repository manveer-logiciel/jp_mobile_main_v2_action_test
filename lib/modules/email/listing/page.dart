import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/secondary_drawer/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/email/listing/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/animations/scale_and_rotate.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';

class EmailListingView extends StatelessWidget {
  const EmailListingView({super.key, this.refTag});

  final String? refTag;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EmailListingController(), tag: refTag);

    return GetBuilder<EmailListingController>(
        tag: refTag ?? controller.controllerTag,
        init: controller,
        global: false,
        initState: (_) {
          controller.setUpDrawerKeys();
        },
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: JPScaffold(
                  scaffoldKey: controller.scaffoldKey,
                  backgroundColor: JPScreen.isDesktop ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.inverse,
                  floatingActionButton: Visibility(
                    visible: controller.canShowFloatingActionButton,
                    child: JPButton(
                      size: JPButtonSize.floatingButton,
                      iconWidget: Icon(Icons.add_outlined, color: JPAppTheme.themeColors.base),
                      onPressed: () {
                        Helper.navigateToComposeScreen(
                          arguments: {'jobId' : controller.jobId},
                          onEmailSent: controller.refreshList
                        );
                      },
                    ),
                  ),
                  endDrawer: controller.canDrawerOpen ? JPMainDrawer(
                    selectedRoute: controller.jobId != null ? '' : 'emails',
                    currentJob: controller.job,
                    onRefreshTap: () {
                      controller.refreshList(showLoading: true);
                    },
                  ) : null,
                  drawer: controller.canDrawerOpen && controller.job == null ? JPSecondaryDrawer(
                    title: 'menu'.toUpperCase(),
                    itemList: controller.customLabelList + controller.labelList,
                    selectedItemSlug: controller.selectedLabel?.id.toString() ??'',
                    tag: 'emails',
                    onTapItem: controller.onTapDrawerItem,
                    actionList: controller.actionList,
                    onTapAction: controller.onTapDrawerAction,
                  ) : null,
                  body: EmailsResponsiveView(
                    header: JPHeader(
                      backIcon: backIcon(controller),
                      title: controller.job != null
                          ? controller.job!.customer!.fullName!
                          : controller.isMultiSelectionOn
                          ? '${controller.selectedEmails.length} Selected'
                          : 'emails'.tr,
                      actions: [
                        IconButton(
                            splashRadius: 20,
                            onPressed: () {
                              controller.scaffoldKey.currentState!.openEndDrawer();
                            },
                            icon: JPIcon(
                              Icons.menu,
                              color: JPAppTheme.themeColors.base,
                            )
                        )
                      ],
                    ),
                    controller: controller,
                  ),
              ),
            ),
          );
        });
  }

  Widget backIcon(EmailListingController controller) => JPScaleAndRotateAnim(
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
          onPressed: controller.clearSelectedEmails,
        ),
        forward: !controller.isMultiSelectionOn,
      );
}
