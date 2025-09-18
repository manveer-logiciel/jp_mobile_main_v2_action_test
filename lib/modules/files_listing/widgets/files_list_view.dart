import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_helpers.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/modules/files_listing/widgets/company_cam_listing_tile.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/company_cam_shimmer.dart';
import 'package:jp_mobile_flutter_ui/AnimatedSpinKit/fading_circle.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'files_list_tile.dart';
import 'files_list_shimmer.dart';
import 'multi_page_tile.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({super.key, required this.controller});

  final FilesListingController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoading) {
      return (controller.type == FLModule.companyCamProjects)
          ? const CompanyCamListingListShimmer()
          : const CompanyFilesListingListShimmer();
    } else if (!controller.isLoading && controller.resourceList.isEmpty) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NoDataFound(
              icon: Icons.folder,
              title: controller.getPlaceHolderText().capitalize,
            ),
          ],
        ),
      );
    } else {
      return JPListView(
        disableOnRefresh: controller.isInSelectionMode,
        onRefresh: controller.onRefresh,
        physics: const AlwaysScrollableScrollPhysics(),
        doAddFloatingButtonMargin: !controller.isNotInDefaultMode(),
        onLoadMore: controller.canShowLoadMore ? controller.onLoadMore : null,
        listCount: controller.resourceList.length,
        itemBuilder: (_, index) {
          if (index < controller.resourceList.length) {
            final data = controller.resourceList[index];
            return Opacity(
              opacity: controller.isInSelectionMode && data.isDir == 1 && controller.type != FLModule.companyCamProjects ? 0.6 : 1,
              child: getTile(data, index),
            );
          } else if (controller.canShowLoadMore) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: FadingCircle(
                  color: JPAppTheme.themeColors.primary,
                  size: 25,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    }
  }

  Widget getTile(FilesListingModel data, int index) {
    switch (controller.type) {
      case FLModule.companyCamProjects:
        return CompanyCamListingTile(
          data: data,
          onTap: () { controller.onTapResource(index);},
        );

      default:
        if (data.isGroup ?? false) {
          return FilesMultiPageTile(
            data: data,
            onTap: () => controller.onTapResource(index),
            onTapExpand: () => controller.onTapTemplateGroup(index),
            onTapTemplate: (templateIndex) => controller.onTapTemplate(index, templateIndex),
          );
        }

        return FilesListTile(
          type: controller.type,
          data: data,
          onTap: () {
            controller.onTapResource(index);
          },
          onLongPress: (controller.resourceList[index].isDir == 1 && (controller.type == FLModule.dropBoxListing)) || controller.type == FLModule.templatesListing
              ? null
              : () {
            controller.onLongPressResource(index);
            },
          onTapMore: () {
            controller.onTapMore(index);
          },
          isInMoveFileMode: controller.isInMoveFileMode,
          isInCopyFileMode: controller.isInCopyFileMode,
          hideQuickAction: hideQuickAction(),
          relativeTime: data.getRelativeTime(),
          isSupplierOrder: controller.isSupplierOrder(data),
          isChooseSupplierSettings: FileListingQuickActionHelpers.isChooseSupplierSettings(data.worksheet)
        );
    }
  }

  bool hideQuickAction() {
    switch (controller.type) {
      case FLModule.templates:
      case FLModule.templatesListing:
      case FLModule.mergeTemplate:
      case FLModule.companyCamImagesFromJob:
        return true;
      default:
        return false;
    }
  }
}
