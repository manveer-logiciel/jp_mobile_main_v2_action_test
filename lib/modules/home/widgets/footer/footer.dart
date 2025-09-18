import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/common/services/home/quick_actions.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/global_widgets/button_sheet/index.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'footer_bg_painter.dart';

class HomePageFooter extends StatelessWidget {
  const HomePageFooter({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: bottomBarWidth,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CustomPaint(
                size: Size(bottomBarWidth, bottomBarHeight),
                painter: HomePageFooterPainter(hasResponsiveConstraints),
              ),      
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: getIconWithBadge(
                            icon: Icons.event_note_outlined,
                            count: CountService.appointmentCount,
                            onTap: () {
                              Get.toNamed(Routes.appointmentListing);
                            }
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: getIconWithBadge(
                          icon: Icons.sms_outlined,
                          fireStoreKeyType: FirestoreHelpers.instance.isMessagingEnabled && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement])
                              ? FireStoreKeyType.unreadMessageCount : null,
                          realTimeKeyType: !FirestoreHelpers.instance.isMessagingEnabled && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement])
                            ? [RealTimeKeyType.messageUnread, RealTimeKeyType.textMessageUnread]
                            : [RealTimeKeyType.textMessageUnread],
                          onTap: () => Get.toNamed(Routes.chatsListing),
                        ),
                      ),
                      Expanded(
                      flex: 3,
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(hasResponsiveConstraints ? -1 : 0, hasResponsiveConstraints ? -8 : -12),
                          child: 
                          JPButtonSheetMenuButton(
                            onTapOption: HomeQuickActionsService.handleQuickActions,
                            child: Material(
                              color: JPAppTheme.themeColors.themeBlue,
                              shape: const CircleBorder(),
                              child: SizedBox(
                                width: bottomBarWidth * 0.15,
                                height: bottomBarWidth * 0.15,
                                child: JPIcon(
                                  Icons.add,
                                  size: JPScreen.isMobile ? 26 : 35,
                                  color: JPAppTheme.themeColors.base,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                      Expanded(
                        flex: 2,
                        child: getIconWithBadge(
                          icon: Icons.mail_outline,
                          realTimeKeyType: [RealTimeKeyType.emailUnread],
                          onTap: () {
                            Get.toNamed(Routes.email, preventDuplicates: false);
                          }
                        ),
                      ),
                      Expanded(
                        key: const Key(WidgetKeys.taskButtonHomePage),
                        flex: 2,
                        child: getIconWithBadge(
                            icon: Icons.task_alt,
                            realTimeKeyType: [RealTimeKeyType.taskPending],
                            onTap: () {
                              Get.toNamed(Routes.taskListing, preventDuplicates: false);
                            }
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: Get.mediaQuery.padding.bottom / 2,
            width: double.maxFinite,
            color: JPAppTheme.themeColors.base.withValues(alpha: 0.2),
          )
        ],
      ),
    );
  }

  bool get hasResponsiveConstraints => JPScreen.width < JPResponsiveDesign.maxButtonWidth;

  double get bottomBarWidth => hasResponsiveConstraints
      ? JPScreen.width
      : JPResponsiveDesign.maxButtonWidth;

  double get bottomBarHeight => hasResponsiveConstraints
      ? JPScreen.width * 0.18
      : 85;

}

Widget getIconWithBadge({IconData? icon, List<RealTimeKeyType>? realTimeKeyType, FireStoreKeyType? fireStoreKeyType, VoidCallback? onTap, int? count}) {

  final button = JPTextButton(
    padding: 12,
    iconSize: 24,
    color: JPAppTheme.themeColors.base,
    icon: icon,
    isExpanded: false,
  );

  final placeHolder = tapHandler(
      children: [
        button,
        if(count != null && count != 0)
          getBadge(int.parse(count.toString()) >= 100 ? '99+' : count.toString()),
      ],
      onTap: onTap
  );

  if(realTimeKeyType != null || fireStoreKeyType != null) {
    return FromFirebase(
      child: (val) {
        return tapHandler(
            children: [
              button,
              if(val != null && val != 0)
                getBadge(int.parse(val.toString()) >= 100 ? '99+' : val.toString()),
            ],
            onTap: onTap
        );
      },
      placeholder: placeHolder,
      realTimeKeys: realTimeKeyType,
      fireStoreKeyType: fireStoreKeyType,
      sumResultKeys: [
        ...realTimeKeyType ?? [],
        fireStoreKeyType
      ],
    );
  } else {
    return placeHolder;
  }
}


Widget tapHandler({VoidCallback? onTap, required List<Widget> children}) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 8
    ),
    child: Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        splashColor: JPAppTheme.themeColors.base.withValues(alpha: 0.2),
        child: Stack(
          children: children,
        ),
      ),
    ),
  );
}

Widget getBadge(String count) {
  return Positioned.fill(
    child: Align(
      alignment: Alignment.topRight,
      child: Container(
        constraints: const BoxConstraints(
            minWidth: 18,
            maxHeight: 40
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 2
        ),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: JPAppTheme.themeColors.themeBlue
        ),
        child: JPText(
          text: count.toString(),
          textColor: JPAppTheme.themeColors.base,
          textSize: JPTextSize.heading5,
        ),
      ),
    ),
  );
}
