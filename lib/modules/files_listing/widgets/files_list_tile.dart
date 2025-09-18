import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/constants/worksheet.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_thumb.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'file_status_icons.dart';
import 'files_status_tag.dart';
import 'files_type_tag.dart';

class FilesListTile extends StatelessWidget {
  const FilesListTile(
      {super.key,
        required this.data,
        this.onTap,
        required this.type,
        this.onLongPress,
        this.isInMoveFileMode = false,
        this.isInCopyFileMode = false,
        this.onTapMore,
        this.isSearching = false,
        this.hideQuickAction = false,
        this.disableQuickAction = false,
        this.relativeTime,
        this.isSupplierOrder = false,
        this.isChooseSupplierSettings = false
      });

  final FilesListingModel data;

  final VoidCallback? onTap;

  final VoidCallback? onLongPress;

  final bool? isInMoveFileMode;

  final bool? isInCopyFileMode;

  final bool disableQuickAction;

  final VoidCallback? onTapMore;

  final bool? isSearching;

  final FLModule type;

  final bool hideQuickAction;

  final String? relativeTime;

  final bool isSupplierOrder;

  final bool isChooseSupplierSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (data.isSelected ?? false)
            ? JPAppTheme.themeColors.lightBlue
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 12
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      getThumbFromType(),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            JPText(
                              text: data.name ?? "",
                              textSize: JPTextSize.heading4,
                              fontWeight: JPFontWeight.regular,
                              textAlign: TextAlign.start,
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (data.ancestors != null) ...{
                              const SizedBox(
                                height: 4,
                              ),
                              getFilePath(),
                            } else if (data.isDir == 1) ...{
                              const SizedBox(
                                height: 4,
                              ),
                              getSubTitle() ?? const SizedBox.shrink(),
                            },
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [
                                  FileTypeTag.getTag(data, isListView: true, isSecondTag: data.type == WorksheetConstants.materialList),
                                  if(isSupplierOrder)
                                    FileTypeTag.getTag(data, isListView: true),
                                  Flexible(child: FileStatusTag.getTag(data,type)),
                                ],
                              ),
                            ),
                            /// Relative time
                            if (!Helper.isValueNullOrEmpty(relativeTime)) ...{
                              JPText(
                                text: relativeTime!,
                                textSize: JPTextSize.heading6,
                                textColor: JPAppTheme.themeColors.tertiary,
                              ),
                            }
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),

                      if(!(isInMoveFileMode! || isInCopyFileMode!))
                        Row(
                          children: FileStatusIcon.getList(data, type).map((e){
                            return Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: e,
                            );
                          }).toList(),
                        ),
                      if(data.noOfChild != -1)                      
                      getTrailingIcon(),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
            Divider(
              indent: 60,
              height: 1,
              color: JPAppTheme.themeColors.secondaryText,
            ),
          ],
        ),
      ),
    );
  }

  Widget getOption({required IconData icon, VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric( horizontal: 3,),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: JPAppTheme.themeColors.darkGray,
      ),
      padding: const EdgeInsets.all(4),
      child: JPIcon(
        icon,
        color: JPAppTheme.themeColors.base,
        size: 12,
      ),
    ),
  );

  Widget getThumbFromType() {
    if(isChooseSupplierSettings) {
      return getIcon();
    }
    if(data.showThumbImage ?? false){
      return getImage();
    }
    switch (data.jpThumbType) {
      case JPThumbType.folder:
        return getFolder();
      case JPThumbType.image:
        return getImage();
      case JPThumbType.icon:
        return getIcon();
      default:
        return getFolder();
    }
  }

  Widget getFolder() => const JPThumbFolder(
    size: ThumbSize.small,
  );

  Widget getImage() => SizedBox(
    height: 30,
    width: 30,
    child: data.base64Image != null ? Center(
      child: Image.memory(
        data.base64Image!,
        fit: BoxFit.cover,
        height: double.maxFinite,
        width: double.maxFinite)) : ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: JPNetworkImage(
        src: data.thumbUrl ?? '',
        boxFit: BoxFit.cover,
        size: JPAvatarSize.small,
      ),
    ),
  );

  Widget getIcon() {
    return JPThumbIcon(
      isSelect: data.isSelected ?? false,
      iconType: isChooseSupplierSettings
          ? JPThumbIconType.pdf
          : data.jpThumbIconType ?? JPThumbIconType.pdf,
      size: ThumbSize.small,
    );
  }

  Widget? getSubTitle() {
    switch (isInMoveFileMode! || isInCopyFileMode!) {
      case true:
        return JPText(
          text: "${data.noOfChildDir?.toString() ?? "0"} ${(data.noOfChildDir ?? 0) != 1 ? 'folders' : 'folder'}",
          textSize: JPTextSize.heading5,
          textColor: JPAppTheme.themeColors.secondaryText,
        );
      case false:
        return data.noOfChild == -1 ? const SizedBox.shrink():
         JPText(
            text: "${data.noOfChild} ${(data.noOfChild ?? 0) != 1 ? 'files' : 'file'}",
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.secondaryText,
        );
    }
  }

  Widget getFilePath() {
    if (data.ancestors != null &&
        data.ancestors != null ) {
      List<String> path = [];

      for (var element in data.ancestors!) {
        path.add(element.name ?? '');
      }

      return JPText(
        text: path.isNotEmpty ? '${'company_files'.tr} / ${path.join(" / ")} / ${data.name}' : '${'company_files'.tr} / ${data.name}',
        textSize: JPTextSize.heading5,
        maxLine: 1,
        overflow: TextOverflow.ellipsis,
        textColor: JPAppTheme.themeColors.secondaryText,
      );
    } else {
      return JPText(
        text: '${'company_files'.tr} / ${data.name}',
        textSize: JPTextSize.heading5,
        maxLine: 1,
        overflow: TextOverflow.ellipsis,
        textColor: JPAppTheme.themeColors.secondaryText,
      );
    }
  }

  // Get the appropriate trailing icon based on resource state
  // For selected items: show check circle
  // For locked directories: show tooltip with info icon
  // For normal items: show more options button
  Widget getTrailingIcon() {
    if(data.isSelected ?? false){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: JPIcon(
          Icons.check_circle,
          color: JPAppTheme.themeColors.primary,
        ),
      );
    }else if(data.locked == 1 || data.isRestricted){
      // Add tooltip for locked directories in list view
      // Shows a tooltip with the message "This directory can not be modified"
      // when user taps on the more button for locked directories
      // Previously this was just an empty SizedBox
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
    } else if(!(isInMoveFileMode! || isInCopyFileMode! || hideQuickAction || disableQuickAction)){
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: JPTextButton(
          icon: Icons.more_horiz,
          onPressed: onTapMore,
          padding: 4,
          color: JPAppTheme.themeColors.text,
          iconSize: 20,
        ),
      );
    }else{
      return const SizedBox.shrink();
    }

  }

}
