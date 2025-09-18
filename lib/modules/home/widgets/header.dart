import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class HomePageHeader extends StatelessWidget {
  const HomePageHeader({
    super.key,
    required this.controller
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ///   Filters
          JPFilterIcon(
            type: JPFilterIconType.headerAction,
            onTap: () => controller.openFilterDialog()
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: JPColor.transparent,
                child: JPTextButton(
                  key: const Key(WidgetKeys.homeSearchIcon),
                  padding: 6,
                  iconSize: 24,
                  color: JPAppTheme.themeColors.base,
                  icon: Icons.search,
                  onPressed: () {
                    controller.navigateToCustomerNdJobSearch();
                  },
                ),
              ),
              if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.automation]))
              FromLaunchDarkly(
                flagKey: LDFlagKeyConstants.workflowAutomationLogs,
                child: (_) =>Stack(
                  children: [
                    Material(
                      color: JPColor.transparent,
                      child: JPTextButton(
                        key: const Key(WidgetKeys.automationButton),
                        padding: 10,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.base,
                        iconWidget: SvgPicture.asset(
                          AssetsFiles.automation,
                          colorFilter: ColorFilter.mode(
                            JPAppTheme.themeColors.base,
                            BlendMode.srcIn)
                        ),
                        onPressed: () {
                          controller.showAutomationView();
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: FromFirebase(
                            child: (val) {
                              if(CountService.automationCount > 0) {
                                return Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: JPAppTheme.themeColors.themeBlue,
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                            realTimeKeys: const [RealTimeKeyType.automationFeedUpdated], 
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ), 
              Center(
                child: Stack(
                  children: [
                    Material(
                      color: JPColor.transparent,
                      child: JPTextButton(
                        padding: 6,
                        iconSize: 24,
                        color: JPAppTheme.themeColors.base,
                        icon: Icons.notifications_outlined,
                        onPressed: () {
                          controller.showNotificationView();
                        },
                      ),
                    ),
                    Positioned.fill(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: FromFirebase(
                                  child: (val) {
                                    if(int.parse(val) > 0) {
                                      return Container(
                                        height: 10,
                                        width: 10,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: JPAppTheme.themeColors.themeBlue,
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  },
                                  realTimeKeys: const [RealTimeKeyType.notificationUnread],
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              Material(
                color: JPColor.transparent,
                child: JPTextButton(
                  key: const Key(WidgetKeys.mainDrawerMenuKey),
                  padding: 6,
                  iconSize: 24,
                  color: JPAppTheme.themeColors.base,
                  onPressed: () {
                    controller.scaffoldKey.currentState!.openEndDrawer();
                  },
                  icon: Icons.menu
                ),
              ),
            ],
          ),
        ],
      ),
    ); 
  }
}