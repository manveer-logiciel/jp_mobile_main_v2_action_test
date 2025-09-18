import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/job_customer_flags.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../detail_screen_body/index.dart';
import '../detail_screen_body/shimmer.dart';
import 'controller.dart';

class CustomerDetailView extends StatelessWidget {
  const CustomerDetailView({super.key,});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerDetailController>(
      init: CustomerDetailController(),
      global: false,
      builder: (controller) {
        return JPWillPopScope(
          onWillPop: controller.onWillPop,
          child: JPScaffold(
            backgroundColor: JPAppTheme.themeColors.inverse,
            appBar: JPHeader(
              backgroundColor: JPAppTheme.themeColors.inverse,
              backIconColor: JPAppTheme.themeColors.text,
              onBackPressed: () {
                Get.back(result: controller.customer);
              },
              actions: [
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Center(
                    child: JPTextButton(
                      color: JPAppTheme.themeColors.text,
                      iconSize: 24,
                      onPressed: () => controller.navigateToCustomerFilesScreen(controller.customer!.id!),
                      icon: Icons.perm_media_outlined
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: Center(
                    child: JPTextButton(
                      color: JPAppTheme.themeColors.text,
                      iconSize: 24,
                      onPressed: () => controller.scaffoldKey.currentState!.openEndDrawer(),
                      icon: Icons.menu
                    ),
                  ),
                ),
              ],
            ),
            scaffoldKey: controller.scaffoldKey,
            endDrawer: JPMainDrawer(
              selectedRoute: 'customer_manager',
              onRefreshTap: controller.refreshPage,
            ),
            body: controller.customer != null
                ? CustomerDetailScreenBody(
              updateScreen: controller.refreshPage,
              customer: controller.customer!,
              addFlagCallback:(() => 
                JobCustomerFlags.showFlagsBottomSheet(
                  customer: controller.customer,
                  updateScreen: controller.update, 
                  id: controller.customer!.id!,
                )
              ),
              launchMapCallback: controller.launchMapCallback,
              navigateToJobListingScreen: controller.navigateToJobListingScreen,
              navigateToAddJobScreen: controller.navigateToAddJobScreen,
            )
                : const CustomerDetailScreenShimmer(),
          ),
        );
      }
    );
  }
}
