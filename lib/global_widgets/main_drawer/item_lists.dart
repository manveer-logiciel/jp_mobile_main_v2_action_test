import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/main_drawer_item.dart';
import 'package:jobprogress/common/services/user_preferences.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/phases_visibility.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/global_widgets/global_value_listener/index.dart';
import 'package:jobprogress/modules/uploads/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/services/auth.dart';
import '../../common/services/permission.dart';

class JPMainDrawerItemLists {

  List<MainDrawerItem> mainItemList = [
    MainDrawerItem(
      icon: JPIcon(Icons.home_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
      selectedIcon: JPIcon(Icons.home_outlined, color: JPAppTheme.themeColors.primary,),
      title: "home".tr,
      slug: 'home',
    ),
    if(PhasesVisibility.canShowSecondPhase && !AuthService.isPrimeSubUser()) ...{
      MainDrawerItem(
        icon: JPIcon(Icons.person_add_alt_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.person_add_alt_outlined, color: JPAppTheme.themeColors.primary),
        title: "add_lead_prospect_customer".tr,
        slug: WidgetKeys.addLeadProspectCustomer,
      ),
      MainDrawerItem(
        icon: JPIcon(Icons.post_add_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.post_add_outlined, color: JPAppTheme.themeColors.primary),
        title: "add_job".tr,
        slug: 'add_job',
      ),
      MainDrawerItem(
        icon: JPIcon(Icons.post_add_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.post_add_outlined, color: JPAppTheme.themeColors.primary),
        title: "add_project".tr,
        slug: 'add_project',
      ),
      MainDrawerItem(
        icon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.primary),
        title: "edit_job".tr,
        slug: 'edit_job',
      ),
      MainDrawerItem(
        icon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.primary),
        title: "edit_project".tr,
        slug: 'edit_project',
      ),
      MainDrawerItem(
        icon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.edit_outlined, color: JPAppTheme.themeColors.primary),
        title: "edit_customer".tr.capitalize!,
        slug: 'edit_customer',
      ),
    },
    MainDrawerItem(
      icon: JPIcon(Icons.event_note_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
      selectedIcon: JPIcon(Icons.event_note_outlined, color: JPAppTheme.themeColors.primary),
      title: 'add_appointment'.tr,
      slug: 'add_appointment'),
    MainDrawerItem(
        icon: JPIcon(Icons.history_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.history_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'recent_jobs'.tr,
        slug: WidgetKeys.recentJobsItemKey),
    if(UserPreferences.hasNearByAccess ?? false)
      MainDrawerItem(
          icon: JPIcon(Icons.place_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
          selectedIcon: JPIcon(Icons.place_outlined, color: JPAppTheme.themeColors.primary),
          title: 'nearby'.tr,
          slug: WidgetKeys.nearByJobsKey),
    MainDrawerItem(
      icon: SvgPicture.asset(
        'assets/svg/daily_plan_Icon.svg',
        colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn),
      ),
      selectedIcon: SvgPicture.asset('assets/svg/daily_plan_Icon.svg',
          colorFilter: ColorFilter.mode(JPAppTheme.themeColors.primary, BlendMode.srcIn)
      ),
      title: 'my_daily_plans'.tr,
      slug: 'my_daily_plans',
    ),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))
      if(ClockInClockOutService.checkInDetails != null)...{
        MainDrawerItem(
          icon: JPIcon(Icons.timer_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
          selectedIcon: JPIcon(Icons.timer_outlined, color: JPAppTheme.themeColors.primary,),
          title: 'clock_out'.tr,
          slug: 'clock_out',
        ),
      } else...{
        MainDrawerItem(
          icon: JPIcon(Icons.timer_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
          selectedIcon: JPIcon(Icons.timer_outlined, color: JPAppTheme.themeColors.primary,),
          title: 'clock_in'.tr,
          slug: WidgetKeys.clockIn,
        ),
      },
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))
      MainDrawerItem(
        icon: JPIcon(Icons.article_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.article_outlined, color: JPAppTheme.themeColors.primary),
        title: 'clock_summary'.tr,
        slug: 'clock_summary'),
    MainDrawerItem(
        icon: JPIcon(Icons.date_range_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.date_range_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'staff_calendar'.tr,
        slug: 'staff_calender'),
    if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]))
      MainDrawerItem(
        icon: JPIcon(Icons.date_range_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.date_range_outlined, color: JPAppTheme.themeColors.primary),
        title: 'production_calendar'.tr,
        slug: 'production_calender'),
    if(PermissionService.hasUserPermissions([PermissionConstants.viewProgressBoard]) && !AuthService.isPrimeSubUser())
      MainDrawerItem(
        icon: JPIcon(Icons.assignment_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.assignment_outlined, color: JPAppTheme.themeColors.primary),
        title: 'progress_board'.tr,
        slug: 'progress_board',
        permissions: [
          PermissionConstants.manageProgressBoard,
          PermissionConstants.viewProgressBoard
        ]
      ),
    if(!AuthService.isPrimeSubUser())
      MainDrawerItem(
        icon: JPIcon(Icons.perm_contact_calendar_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.perm_contact_calendar_outlined, color: JPAppTheme.themeColors.primary),
        title: 'company_contacts'.tr,
        slug: WidgetKeys.companyContactsItemKey),
    MainDrawerItem(
      icon: JPIcon(Icons.cached_outlined, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
      selectedIcon: JPIcon(Icons.cached_outlined, color: JPAppTheme.themeColors.primary),
      title: 'refresh'.tr,
      slug: WidgetKeys.refreshKey),
  ];

  List<MainDrawerItem> mediaItemList = [
    MainDrawerItem(
        icon: JPIcon(Icons.local_see_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.local_see_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'take_instant_photo'.tr,
        slug: 'take_instant_photo'),
    MainDrawerItem(
        icon: JPIcon(Icons.collections_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.collections_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'instant_photo_gallery'.tr,
        slug: 'instant_photo_gallery'),
    if(!AuthService.isPrimeSubUser() && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.thirdPartyIntegrations]))
      MainDrawerItem(
          icon: SvgPicture.asset('assets/svg/company_cam_icon.svg',
              colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn)),
          selectedIcon: SvgPicture.asset('assets/svg/company_cam_icon.svg',
            colorFilter: ColorFilter.mode(JPAppTheme.themeColors.primary, BlendMode.srcIn)
          ),
          title: 'companycam'.tr,
          slug: 'companycam'),
    MainDrawerItem(
        icon: JPIcon(Icons.perm_media_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.perm_media_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'company_files'.tr,
        slug: 'company_files',
        permissions: [
          PermissionConstants.manageCompanyFiles,
          PermissionConstants.viewCompanyFiles
        ]),
    MainDrawerItem(
      icon: SvgPicture.asset("assets/svg/drop_box_icon.svg",
          colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn)),
      selectedIcon: SvgPicture.asset("assets/svg/drop_box_icon.svg",
       colorFilter: ColorFilter.mode(JPAppTheme.themeColors.primary, BlendMode.srcIn)
      ),
      title: 'dropbox'.tr,
      slug: 'dropbox',
    ),
    MainDrawerItem(
        icon: JPIcon(Icons.file_upload_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.file_upload_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'uploads'.tr,
        slug: 'uploads',
        trailingWidget: GlobalValueListener<UploadsListingController>(
          child: (controller) {

            final progressCount = controller.getProgressCount();
            if(progressCount.isEmpty) {
              return const SizedBox();
            } else {
              return JPBadge(
                text: progressCount,
                backgroundColor: JPAppTheme.themeColors.secondary,
              );
            }
          },
        )
    ),
  ];

  List<MainDrawerItem> otherItemList = [
    MainDrawerItem(
      icon: JPIcon(Icons.event_note_outlined,
          color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
      selectedIcon: JPIcon(Icons.event_note_outlined,
          color: JPAppTheme.themeColors.primary),
      title: 'appointments'.tr,
      slug: 'appointments',
    ),
    MainDrawerItem(
        icon: JPIcon(Icons.task_alt_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.task_alt_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'tasks'.tr,
        slug: 'tasks',
        realTimeKeys: [RealTimeKeyType.taskPending]),
    MainDrawerItem(
        icon: JPIcon(Icons.textsms_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon:
        JPIcon(Icons.textsms_outlined, color: JPAppTheme.themeColors.primary),
        title: FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]) ? 'messages_texts'.tr : 'texts'.tr.capitalizeFirst!,
        slug: 'messages_text',
        realTimeKeys: [RealTimeKeyType.textMessageUnread],
        sumOfKeys: [
          if(FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement]))...{
            if(FirestoreHelpers.instance.isMessagingEnabled)...{
              FireStoreKeyType.unreadMessageCount,
            } else ...{
              RealTimeKeyType.messageUnread,
            },
          }, 
          RealTimeKeyType.textMessageUnread
        ]
    ),
    MainDrawerItem(
        icon: JPIcon(Icons.email_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon:
        JPIcon(Icons.email_outlined, color: JPAppTheme.themeColors.primary),
        title: 'emails'.tr,
        slug: 'emails',
        realTimeKeys: [RealTimeKeyType.emailUnread]),
    MainDrawerItem(
        icon: JPIcon(Icons.notifications_none_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.notifications_none_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'notifications'.tr,
        slug: 'notifications',
        realTimeKeys: [RealTimeKeyType.notificationUnread]),
    if(!AuthService.isPrimeSubUser())
      MainDrawerItem(
        icon: JPIcon(Icons.description_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.description_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'templates'.tr,
        slug: 'templates',
        permissions: [
          PermissionConstants.manageEstimates,
          PermissionConstants.manageProposals
        ]),
    MainDrawerItem(
        icon: JPIcon(Icons.text_snippet_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.text_snippet_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'snippets'.tr,
        slug: 'snippets'),
    MainDrawerItem(
        icon: JPIcon(Icons.auto_graph_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.auto_graph_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'workflow'.tr,
        slug: 'workflow'),
    // Could be use in future but not now
    // MainDrawerItem(
    //     icon: JPIcon(Icons.help_outline_outlined,
    //         color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
    //     selectedIcon: JPIcon(Icons.help_outline_outlined,
    //         color: JPAppTheme.themeColors.primary),
    //     title: 'support'.tr,
    //     slug: 'support'),
    MainDrawerItem(
        icon: JPIcon(Icons.assignment_ind_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon: JPIcon(Icons.assignment_ind_outlined,
            color: JPAppTheme.themeColors.primary),
        title: 'my_profile'.tr,
        slug: WidgetKeys.myProfile),
    MainDrawerItem(
        icon: JPIcon(Icons.tune_outlined,
            color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
        selectedIcon:
        JPIcon(Icons.tune_outlined, color: JPAppTheme.themeColors.primary),
        title: 'settings'.tr,
        slug: 'settings'),
    MainDrawerItem(
      icon: JPIcon(Icons.logout_outlined,
          color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
      selectedIcon:
      JPIcon(Icons.logout_outlined, color: JPAppTheme.themeColors.primary),
      title: 'logout'.tr,
      slug: 'logout',
    ),
    // MainDrawerItem(
    //   slug: 'demo',
    //   icon: JPIcon(Icons.dashboard_customize_rounded, color: JPAppTheme.themeColors.text.withValues(alpha: 0.8)),
    //   selectedIcon: JPIcon(Icons.dashboard_customize_rounded, color: JPAppTheme.themeColors.primary),
    //   title: 'Demo'),
    // MainDrawerItem(
    //   slug: 'sql',
    //   icon: const JPIcon(Icons.dashboard_customize_rounded),
    //   selectedIcon: JPIcon(Icons.logout_outlined, color: JPAppTheme.themeColors.primary),
    //   title: 'Local DB'),
  ];
}