import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/main_drawer_item.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/count.dart';
import 'package:jobprogress/core/constants/connected_third_party_constants.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/global_value_listener/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/tap_handler.dart';
import 'package:jobprogress/modules/uploads/controller.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JPMainDrawerListItem extends StatelessWidget {
  const JPMainDrawerListItem(
      {super.key,
      required this.list,
      this.selectedRoute,
      this.onTap,
      this.onRefreshTap,
      this.currentJob});

  final MainDrawerItem list;
  final String? selectedRoute;
  final VoidCallback? onTap;
  final VoidCallback? onRefreshTap;
  final JobModel? currentJob;

  bool get hideJobOptions => (list.slug == 'add_job'
      || list.slug == 'edit_job'
      || list.slug == 'edit_customer'
      || list.slug == 'edit_project'
      || list.slug == 'add_project'
      )
      && (Get.currentRoute != Routes.jobSummary || AuthService.isPrimeSubUser());

  @override
  Widget build(BuildContext context) {
    Widget getTile() {
      if (list.slug == 'company_files' && AuthService.isPrimeSubUser()) {
        return const SizedBox.shrink();
      }
      if(list.slug == 'company_contacts' && AuthService.isPrimeSubUser()){
        return const SizedBox.shrink();
      }
      if(list.slug == 'companycam' && !(ConnectedThirdPartyService.getConnectedPartyKey(ConnectedThirdPartyConstants.companyCam) ?? false)) {
        return const SizedBox.shrink();
      }
      if(list.slug == 'dropbox' && !(AuthService.userDetails?.isDropBoxConnected ?? false)) {
        return const SizedBox.shrink();
      }
      if (hideJobOptions) {
        return const SizedBox.shrink();
      }
      if(list.slug == 'edit_project' && !(currentJob?.isProject ?? false)) {
        return const SizedBox.shrink();
      }
      if(list.slug == 'add_project' && !(currentJob?.isMultiJob ?? false)) {
        return const SizedBox.shrink();
      }

      return InkWell(
        key: Key(list.slug),
        onTap: () {
          if (list.slug == 'refresh' && onRefreshTap != null) {
            Get.back();
            onRefreshTap!();
            return;
          }
          if (selectedRoute == list.slug) {
            Get.back();
            return;
          }
          JPMainDrawerTapHandler.onItemTap(list.slug, currentJob: currentJob);
        },
        child: Builder(builder: (context) {
          return Container(
            decoration: list.slug == selectedRoute
                ? BoxDecoration(
                    color: JPAppTheme.themeColors.lightBlue,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  )
                : null,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      selectedRoute != list.slug ? list.icon : list.selectedIcon,
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: JPText(
                            text: list.title,
                            fontWeight: JPFontWeight.medium,
                            textColor: selectedRoute == list.slug
                                ? JPAppTheme.themeColors.primary
                                : null,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLine: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                list.trailingWidget ?? count(),
              ],
            ),
          );
        }),
      );
    }

    return list.permissions != null && list.permissions!.isNotEmpty
        ? HasPermission(permissions: list.permissions!, child: getTile())
        : getTile();
  }

  Widget count({int? count}) {
    if (list.sumOfKeys != null) {
      return FromFirebase(
        realTimeKeys: list.realTimeKeys!,
        sumResultKeys: list.sumOfKeys,
        child: (val) => Visibility(
          visible: val != 0,
          child: JPBadge(
            text: val.toString(),
            backgroundColor: JPAppTheme.themeColors.themeBlue,
          ),
        ),
        placeholder: const SizedBox.shrink(),
      );
    }

    if (count != null && count != 0) {
      return JPBadge(
          text: count.toString(),
          backgroundColor: JPAppTheme.themeColors.themeBlue,
        );
    }

    if (list.realTimeKeys != null) {
      return FromFirebase(
        realTimeKeys: list.realTimeKeys!,
        result: RealTimeResult.add,
        child: (val) => Visibility(
          visible: val != '0',
          child: JPBadge(
            text: val.toString(),
            backgroundColor: JPAppTheme.themeColors.themeBlue,
          ),
        ),
        placeholder: const SizedBox.shrink(),
      );
    }

    if (list.slug == 'uploads') {
      return GlobalValueListener<UploadsListingController>(
        child: (controller) {
          return JPBadge(
            text: controller.queue.length.toString(),
            backgroundColor: JPAppTheme.themeColors.themeBlue,
          );
        },
      );
    }
    if(list.slug == 'appointments') {
      return Visibility(
        visible: CountService.appointmentCount != 0,
        child: JPBadge(
          text: CountService.appointmentCount.toString(),
          backgroundColor: JPAppTheme.themeColors.themeBlue,
        ),
      );
    }
    if(list.slug == 'my_daily_plans') {
      return Visibility(
        visible: CountService.myDailyCount != 0,
        child: JPBadge(
          text: CountService.myDailyCount.toString(),
          backgroundColor: JPAppTheme.themeColors.themeBlue,
        ),
      );
    }

    return const SizedBox();
  }
}
