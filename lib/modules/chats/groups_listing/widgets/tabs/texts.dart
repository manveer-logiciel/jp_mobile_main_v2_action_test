

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/chats.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/controller.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/messages/index.dart';
import 'package:jobprogress/modules/chats/groups_listing/widgets/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TextsTab extends StatelessWidget {
  const TextsTab({
    super.key,
    required this.controller,
  });

  final GroupsListingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SMS Type Filter Header - Show for admin users or when coming from job summary
        // Wrapped with LaunchDarkly feature flag
        FromLaunchDarkly(
          flagKey: LDFlagKeyConstants.textNotificationsAutomation,
          child: (flagDetails) {
            if (AuthService.isOwner() || AuthService.isSystemUser() || controller.jobId != null) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: JPText(
                        text: 'text_type'.tr,
                        textSize: JPTextSize.heading5,
                        fontWeight: JPFontWeight.medium,
                        textColor: JPAppTheme.themeColors.text,
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(8),
                      color: JPAppTheme.themeColors.inverse,
                      child: InkWell(
                        onTap: () {
                          controller.showSmsTypeFilter();
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                JPText(
                                  text: SingleSelectHelper.getSelectedSingleSelectValue(controller.smsTypeOptions, controller.selectedSmsType),
                                  textSize: JPTextSize.heading5,
                                  fontWeight: JPFontWeight.medium,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                ),
                                const SizedBox(width: 4),
                                JPIcon(
                                  Icons.arrow_drop_down,
                                  size: 22,
                                  color: JPAppTheme.themeColors.tertiary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
        Expanded(
          child: Column(
            children: [
              if (controller.isLoadingTexts && controller.texts.isEmpty) ...{
                const GroupListingShimmer(),
              }
              else if (controller.texts.isEmpty)...{
                /// placeholder
                Expanded(
                  child: Center(
                    child: NoDataFound(
                      title: 'no_text_found'.tr.capitalize,
                      icon: JPScreen.isDesktop ? null : Icons.sms,
                      descriptions: 'you_currently_havent_got_any_text'.tr,
                    ),
                  ),
                )
              }
              else...{
                  GroupsThreadList(
                    onLongPressGroup: controller.onLongPressGroup,
                    onTapGroup: controller.onTapGroup,
                    onLoadMore: controller.loadMoreTexts,
                    canShowLoadMore: controller.canShowTextsLoadMore,
                    groups: controller.texts,
                    controller: controller,
                    selectedGroupId: controller.groupsService.selectedGroupData?.groupId,
                    showAutomatedPill: controller.selectedSmsType == ChatsConstants.smsTypeAll,
                  )
                }
            ],
          ),
        ),
      ],
    );
  }
}
