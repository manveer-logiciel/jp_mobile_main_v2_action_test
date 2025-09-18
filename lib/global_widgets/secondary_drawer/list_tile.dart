import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/secondary_drawer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/secondary_drawer_item.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/from_firebase/index.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class SecondaryDrawerListTile extends StatelessWidget {

  const SecondaryDrawerListTile({super.key, required this.item, required this.isSelected, this.onTapTile, this.count, this.job});

  final JPSecondaryDrawerItem item;

  final VoidCallback? onTapTile;

  final bool isSelected;

  final int? count;

  final JobModel? job;

  @override
  Widget build(BuildContext context) {
    return typeToItem() ?? const SizedBox.shrink();
  }

  Widget? typeToItem() {
    switch (item.itemType) {
      case SecondaryDrawerItemType.tile:
        return  item.permissions != null && item.permissions!.isNotEmpty
        ? HasPermission(
          permissions: item.permissions!,
          child: getTile()) 
        : getTile();

      case SecondaryDrawerItemType.label:
        return getLabel();

      case SecondaryDrawerItemType.action:
        return getAction();

      case SecondaryDrawerItemType.button:
        return getButton();
    }
  }

  Widget getTile() {
    if(item.slug == 'follow_up' && AuthService.isPrimeSubUser()) {
      return const SizedBox.shrink();
    }
    if(item.slug == 'job_financial' && AuthService.isPrimeSubUser()) {
      return const SizedBox.shrink();
    }
    if(item.slug == FileUploadType.formProposals && job?.parentId != null){
      return const SizedBox.shrink();
    }
    if(item.slug == FileUploadType.materialList && (job?.isMultiJob ?? false) && !isSelected){
      return const SizedBox.shrink();
    }
    if(item.slug == FileUploadType.workOrder && (job?.isMultiJob ?? false) && !isSelected){
      return const SizedBox.shrink();
    }
    if(item.slug == 'work_crew_notes' && (job?.isMultiJob ?? false)){
      return const SizedBox.shrink();
    }
    // Removing Estimations Folder from drawer if
    // 1. Sales Pro for Estimates is enabled
    // 2. Estimates count is zero (means no estimates created yet)
    if (item.slug == FileUploadType.estimations 
        && LDService.hasFeatureEnabled(LDFlagKeyConstants.salesProForEstimate)
        && (job?.count?.estimates ?? 0) == 0) {
      return const SizedBox.shrink();
    }
    
    if(item.slug == FileUploadType.measurements
        && (job?.isMultiJob ?? false)
        && ((job?.count?.measurements ?? 0) == 0)
        && !ConnectedThirdPartyService.isEagleViewConnected()){
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 5
      ),
      child: SizedBox(
        height: 40,
        child: Material(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
          ),
          color: isSelected ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.5) : null,
          child: InkWell(
            key: ValueKey(item.slug),
            onTap:isSelected ? (){Get.back();} : onTapTile,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16,
              ),
              child: Center(
                child: Row(
                  children: [
                    item.svgAssetsPath != null
                      ? SvgPicture.asset(
                          item.svgAssetsPath!,
                          colorFilter: ColorFilter.mode(JPAppTheme.themeColors.primary, BlendMode.srcIn),
                          height: 18,
                          width: 24,
                        )
                      : JPIcon(
                        item.icon!,
                        color: JPAppTheme.themeColors.primary,
                        size: 24,
                      ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: JPText(
                        text: item.slug == 'job_notes' && job?.parentId != null ? 'project_notes'.tr : item.title,
                        fontWeight: JPFontWeight.medium,
                        textAlign: TextAlign.start,
                        maxLine: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    getCount(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLabel() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 13,
        bottom: 5,
        left: 16,
        right: 16
      ),
      child: JPText(
        text: item.title,
        textAlign: TextAlign.start,
        maxLine: 1,
        textColor: JPAppTheme.themeColors.darkGray,
        fontWeight: JPFontWeight.medium,
      ),
    );
  }

  Widget getCount() {
    if(item.number != null && item.number != 0) {
      return JPText(
        text: item.number.toString(),
        fontWeight: JPFontWeight.medium,
        textColor: JPAppTheme.themeColors.primary,
      );
    } else if(item.realTimeKeys != null) {
      return FromFirebase(
        child: (val) {
          return Visibility(
            visible: val != '0',
            child: JPText(
              text: val.toString(),
              fontWeight: JPFontWeight.medium,
              textColor: JPAppTheme.themeColors.primary,
            ),
          );
        },
        realTimeKeys: item.realTimeKeys!,
      );
    } else if(count != null && count != 0) {
      return JPText(
        text: count.toString(),
        fontWeight: JPFontWeight.medium,
        textColor: JPAppTheme.themeColors.primary,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget getAction() {
    return SizedBox(
      height: 40,
      child: Material(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20)
        ),
        color: isSelected ? JPAppTheme.themeColors.lightBlue : null,
        child: InkWell(
          onTap: onTapTile,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20)
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16
            ),
            child: Center(
              child: Row(
                children: [
                  JPIcon(
                    item.icon!,
                    color: JPAppTheme.themeColors.primary,
                    size: 24,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: JPText(
                      text: item.title,
                      fontWeight: JPFontWeight.medium,
                      textAlign: TextAlign.start,
                      textColor: JPAppTheme.themeColors.primary,
                      maxLine: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getButton() {
    return Row(
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 3,
          child: JPButton(
            size: JPButtonSize.small,
            onPressed: onTapTile,
            text: item.title.toUpperCase(),
            textSize: JPTextSize.heading3,
            iconWidget: JPIcon(
              item.icon!,
              color: JPAppTheme.themeColors.base,
              size: 22,
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

}
