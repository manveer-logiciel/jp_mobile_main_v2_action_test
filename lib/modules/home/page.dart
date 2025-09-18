import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/subscriber_plan_code.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/global_widgets/day_count_down/day_count.dart';
import 'package:jobprogress/modules/home/widgets/footer/footer.dart';
import 'package:jobprogress/modules/home/widgets/header.dart';
import 'package:jobprogress/modules/home/widgets/navigation_buttons.dart';
import 'package:jobprogress/modules/home/widgets/stages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return JPScaffold(
      scaffoldKey: controller.scaffoldKey,
      resizeToAvoidBottomInset: false,
      endDrawer: JPMainDrawer(
        selectedRoute: 'home',
        onRefreshTap: controller.refreshPage,
      ),
      body: GetBuilder<HomeController>(
        builder: (_) {
          return Container(
            decoration: BoxDecoration(
              color: JPAppTheme.themeColors.text,
              image: const DecorationImage(
                image: AssetImage('assets/images/home-background.jpg'),
                alignment: Alignment.centerRight,
                opacity: 0.4,
                fit: BoxFit.cover
              ),
            ),
            child: JPSafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomePageHeader(controller: controller),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20
                                  ),
                                  child: JPNetworkImage(
                                    src: controller.subscriberDetails?.largeIcon ?? '',
                                    height: 85,
                                    width: JPScreen.width * 0.75,
                                    placeHolder: Image.asset('assets/images/home-logo.png',
                                      height: 85,
                                      width: double.infinity
                                    )
                                  ),
                                ),
                                if(controller.isStageListLoading || controller.stages.isNotEmpty)
                                Column(
                                  children: [
                                    SizedBox(height: Get.height * 0.05),
                                    HomePageStages(controller: controller)
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.05),
                                HomePageNavigationButtons(controller: controller),
                                JPDayCountDown(
                                  remainingDays: controller.subscriberDetails?.subscription?.remainingDays,
                                  visibility: controller.subscriberDetails?.subscription?.plan?.code == SubscriberPlanCode.essentialFree30Days,
                                  topPadding: 30,
                                  color: JPAppTheme.themeColors.base,
                                  alignment: MainAxisAlignment.center,
                                  textSize: JPTextSize.heading3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HomePageFooter(controller: controller),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}