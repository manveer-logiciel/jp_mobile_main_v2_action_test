
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/services/files_listing/forms/hover_order_form/index.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/animations/scale_in_out.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/assets_files.dart';

class FilesListingHeaderActions extends StatelessWidget {
  const FilesListingHeaderActions({
    super.key,
    required this.controller,
  });

  final FilesListingController controller;

  bool get canShowViewToggle => controller.type != FLModule.companyCamProjects
      && controller.type != FLModule.instantPhotoGallery;

  bool get canShowHover => controller.type == FLModule.measurements
      && HoverOrderFormService.canSyncHover(controller.jobModel, controller.subscriberDetails);

  bool get canShowHoverSynced => controller.type == FLModule.measurements
      && controller.jobModel?.hoverJob?.id != null && PermissionService.hasUserPermissions([PermissionConstants.manageHover]);
  
  bool get showCreateFolder => !(controller.type == FLModule.jobPhotos && !PermissionService.hasUserPermissions([PermissionConstants.manageJobDirectory]));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if(canShowHoverSynced)  hoverSynced(),
        if(canShowHover)  hover(),
        if (controller.doShowCreateFolder())  createFolder(),
        if(controller.type == FLModule.templates || controller.type == FLModule.templatesListing || controller.type == FLModule.googleSheetTemplate) showTradeFilter(),
        if(canShowViewToggle) viewToggle(),
        if(controller.doShowDrawer) drawerMenu()
      ],
    );
  }
  Widget showTradeFilter() {
    return JPFilterIcon(
            type: JPFilterIconType.headerAction,
            isFilterActive: controller.selectedFilterByOptions?.isNotEmpty ?? false,
            onTap: controller.type == FLModule.templates || controller.type == FLModule.templatesListing || controller.type == FLModule.googleSheetTemplate
                ? controller.openFilters
                : null,
        );
  }

  Widget createFolder() {
    return HasPermission(
      permissions: const [PermissionConstants.manageJobDirectory],
      orOtherCondition: controller.type != FLModule.jobPhotos,
      child: JPScaleInOutAnim(
        firstChildKey: 'createFolder',
        firstChild: JPTextButton(
          key: const ValueKey('od1'),
          icon: Icons.create_new_folder_outlined,
          onPressed: () {
            controller.showCreateFolderDialog();
          },
          color: JPAppTheme.themeColors.base,
          iconSize: 25,
        ),
        forward: !controller.isInSelectionMode,
      ),
    );
  }

  Widget viewToggle() {
    return Visibility(
      visible: !controller.isGoalSelected,
      child: Opacity(
        opacity: controller.resourceList.isEmpty ? 0.5 : 1,
        child: JPScaleInOutAnim(
          firstChildKey: 'viewType',
          firstChild: JPTextButton(
            icon: controller.showListView
                ? Icons.grid_view
                : Icons.view_list_outlined,
            onPressed: controller.resourceList.isEmpty
                ? null
                : () {
              controller.toggleView();
            },
            color: JPAppTheme.themeColors.base,
            iconSize: 25,
          ),
          forward: !controller.isInSelectionMode,
        ),
      ),
    );
  }

  Widget drawerMenu() {
    return JPScaleInOutAnim(
      firstChildKey: 'drawer',
      secondChildKey: 'quickAction',
      firstChild: JPTextButton(
        icon: Icons.menu,
        onPressed: () {
          controller.scaffoldKey.currentState!.openEndDrawer();
          Helper.hideKeyboard();
        },
        color: JPAppTheme.themeColors.base,
        iconSize: 25,
      ),
      secondChild: controller.type == FLModule.mergeTemplate
          ? JPButton(
        text: controller.proposalPageType != null ? 'add_pages'.tr : 'create'.tr.toUpperCase(),
        colorType: JPButtonColorType.base,
        type: JPButtonType.outline,
        size: JPButtonSize.extraSmall,
        onPressed: controller.onTapCreateMergeTemplate,
      )
          : JPTextButton(
        icon: Icons.more_vert,
        onPressed: () {
          controller.showQuickAction();
        },
        color: JPAppTheme.themeColors.base,
        iconSize: 25,
      ),
      forward: !controller.isInSelectionMode,
    );
  }

  Widget hover() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5
      ),
      child: JPButton(
        text: 'hover'.tr.capitalizeFirst,
        type: JPButtonType.outline,
        disabled: controller.isLoading,
        fontWeight: JPFontWeight.bold,
        size: JPButtonSize.extraSmall,
        colorType: JPButtonColorType.base,
        onPressed: controller.navigateToHoverForm,
      ),
    );
  }

  Widget hoverSynced() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Image.asset(
          AssetsFiles.hoverLogo,
          width: 18,
          height: 18,
          color: JPAppTheme.themeColors.base,
        ),
      ),
    );
  }

}
