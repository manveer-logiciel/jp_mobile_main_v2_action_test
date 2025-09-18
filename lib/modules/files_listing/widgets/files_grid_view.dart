import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/gridview/index.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/file_status_icons.dart';
import 'package:jp_mobile_flutter_ui/TextButton/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'files_grid_shimmer.dart';
import 'files_status_tag.dart';
import 'files_type_tag.dart';

class FilesGridView extends StatelessWidget {
  const FilesGridView({super.key, required this.controller});

  final FilesListingController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return const FilesGridShimmer();
    } else if (!controller.isLoading && controller.resourceList.isEmpty) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NoDataFound(
              icon: Icons.folder,
              title: controller.getPlaceHolderText(),
            ),
          ],
        ),
      );
    } else {
      return JPGridView(
        physics: const AlwaysScrollableScrollPhysics(),
        disableOnRefresh: controller.isInSelectionMode,
        onRefresh: controller.onRefresh,
        onLoadMore: controller.canShowLoadMore ? controller.onLoadMore : null,
        isLoading: controller.isLoadMore,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: 0.92,
        ),
        listCount: controller.resourceList.length,
        padding: const EdgeInsets.all(16),
        doAddFloatingButtonMargin: !controller.isNotInDefaultMode(),
        itemBuilder: (_, index) {
          if (index < controller.resourceList.length) {
            final data = controller.resourceList[index];
            return Stack(
              children: [
                Positioned.fill(
                  child: JPThumb(
                    key: ValueKey("${controller.type.toString()}_$index"),
                    onTap: (val) {
                      controller.onTapResource(index);
                    },
                    onLongPress: (
                      controller.resourceList[index].isDir == 1 && 
                      (controller.type == FLModule.dropBoxListing) || 
                      (controller.type == FLModule.templates) ||
                      (controller.type == FLModule.templatesListing) ||
                      (controller.type == FLModule.mergeTemplate) ||
                      (controller.type == FLModule.googleSheetTemplate)
                      ) ? null : () {
                        controller.onLongPressResource(index);
                    },
                    suffixTap: (val) {
                      controller.onTapMore(index);
                    },
                    isDisabled: controller.isFolderDisabled(data),
                    isSelect: data.isSelected ?? false,
                    isQuickActionIconDisabled: !controller.doShowQuickAction(data) 
                    || controller.type == FLModule.dropBoxListing
                        &&  ((data.showThumbImage ?? false) ? JPThumbType.image
                            : data.jpThumbType ?? JPThumbType.icon) == JPThumbType.folder,
                    type: FileListingQuickActionHelpers.isChooseSupplierSettings(data.worksheet)
                        ? JPThumbType.icon
                        : (data.showThumbImage ?? false)
                        ? JPThumbType.image
                        : data.jpThumbType ?? JPThumbType.icon,
                    iconType: FileListingQuickActionHelpers.isChooseSupplierSettings(data.worksheet)
                        ? JPThumbIconType.pdf
                        : data.jpThumbIconType ?? JPThumbIconType.pdf,
                    fileName: controller.type == FLModule.attachmentInvoice ? data.title ?? '' : !Helper.isValueNullOrEmpty(data.groupId) ? data.groupName : data.name ?? "",
                    userName: controller.getUserNameInInstantGalleryFilter(controller.resourceList,index),
                    folderCount: data.noOfChild != null ? data.noOfChild == -1 ? '' : data.noOfChild.toString() : '',
                    thumbImage: getThumbImage(data),
                    statusTag: FileStatusTag.getTag(data, controller.type),
                    thumbIconList: FileStatusIcon.getList(data, controller.type),
                    suffixIcon: getSuffixIcon(data),
                    relativeTime: data.getRelativeTime(),
                  ),
                ),
                Visibility(
                  visible: controller.type != FLModule.materialLists,
                  child: Positioned(
                    top: 45,
                    left: 0,
                    child: FileTypeTag.getTag(data)
                  ),
                ),
                Visibility(
                  visible: controller.isSupplierOrder(data),
                  child: Positioned(
                      bottom: 80,
                      right: 0,
                      child: FileTypeTag.getTag(data)
                  ),
                ),
                Visibility(
                  visible: controller.type == FLModule.materialLists,
                  child: Positioned(
                  bottom: 50,
                  right: 0,
                  child: FileTypeTag.getTag(data, isSecondTag: true)
                ),)
              ],
            );
          } else if (controller.canShowLoadMore) {
            return const FilesGridShimmerTile();
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }

  Widget? getThumbImage(FilesListingModel data) {
    return data.base64Image != null
        ? Center(
            child: Image.memory(
              data.base64Image!,
              fit: BoxFit.cover,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
          )
        : ((data.showThumbImage ?? false)
            ? Center(
                child: JPNetworkImage(
                  src: data.thumbUrl,
                  boxFit: BoxFit.cover,
                ),
              )
            : Center(
                child: JPNetworkImage(
                  src: data.url,
                  boxFit: BoxFit.cover,
                ),
              ));
  }

  // For locked directories, display a tooltip with info icon
  Widget? getSuffixIcon(FilesListingModel data) {
    if (doAddCustomSuffixIcon(data)) {
      return const SizedBox(
        height: 28,
      );
    } else if (controller.isResourceLocked(data)) {
      // Shows a tooltip with the message "This directory can not be modified"
      // when user taps on the more button for locked directories
      return JPToolTip(
        message: 'directory_locked'.tr,
        showOnSingleTap: true,
        icon: Icons.info_outline,
        child: JPTextButton(
          padding: 5,
          iconSize: 22,
          color: JPAppTheme.themeColors.text,
          icon: Icons.more_horiz,
        ),
      );
    } else {
      return null;
    }
  }

  // Determine if a custom suffix icon should be added
  // Previously included locked directories, but that's now handled separately in getSuffixIcon
  bool doAddCustomSuffixIcon(FilesListingModel data) {
    return (controller.mode == FLViewMode.attach || controller.mode == FLViewMode.apply && !data.isSelected!)
        || (controller.type == FLModule.mergeTemplate && !data.isSelected!)
        || controller.type == FLModule.templates
        || controller.type == FLModule.googleSheetTemplate;
  }
}
