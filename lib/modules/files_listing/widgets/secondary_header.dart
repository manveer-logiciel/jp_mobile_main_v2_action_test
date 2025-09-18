import 'package:flutter/material.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';


class InstantPhotoGallerySecondaryHeader extends StatelessWidget {
   const InstantPhotoGallerySecondaryHeader({required this.controller, super.key,
  });

  final FilesListingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 11, top: 10, bottom: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: JPAppTheme.themeColors.base,
            child: JPTextButton(
                color: JPAppTheme.themeColors.tertiary,
                onPressed: () {
                 controller.openInstantPhotoGalleryFilterBy();
                },
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading5,
                text: 'Sort By: ${SingleSelectHelper.getSelectedSingleSelectValue(controller.instantPhotoGallerySortByList, controller.instantPhotoGallerySelectedFilterByOptions)}',
                icon: Icons.keyboard_arrow_down_outlined),
          ),
          if(!AuthService.isPrimeSubUser() && FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.userManagement])) 
          JPFilterIcon(onTap: () => controller.filterInstantPhotoGalleryByUser(), isFilterActive: controller.selectedUsers.isNotEmpty),
        ],
      ),
    );
  }
}
