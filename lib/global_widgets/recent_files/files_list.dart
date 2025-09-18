
import 'package:flutter/material.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/modules/files_listing/widgets/file_status_icons.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_status_tag.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_type_tag.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';

class JobOverViewFilesList extends StatelessWidget {
  const JobOverViewFilesList({
    super.key,
    required this.files,
    this.onTapResource,
    required this.type,
    this.onTapSuffix,
    this.onLongPressResource,
    this.onTapViewAll,
  });

  final List<FilesListingModel> files;

  final Function(int index)? onTapResource;

  final Function(int index)? onLongPressResource;

  final Function(int index)? onTapSuffix;

  final VoidCallback? onTapViewAll;

  final FLModule type;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: double.maxFinite,
      child: Column(
        children: [
          JPListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            listCount: files.length - 1,
            scrollDirection: Axis.horizontal,
            shrinkWrap: false,
            itemBuilder: (_, index) {
              final data = files[index];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      JPThumb(
                        onTap: (val) => onTapResource!(index),
                        onLongPress: () => onLongPressResource!(index),
                        suffixTap: (val) => onTapSuffix!(index),
                        isSelect: data.isSelected ?? false,
                        type: data.showThumbImage!
                          ? JPThumbType.image
                          : data.jpThumbType ?? JPThumbType.icon,
                        iconType: data.jpThumbIconType ?? JPThumbIconType.pdf,
                        fileName: data.name ?? "",
                        folderCount: data.noOfChild.toString(),
                        statusTag: FileStatusTag.getTag(data, type),
                        thumbImage: (data.showThumbImage ?? false)
                          ? Center(
                            child: JPNetworkImage(
                              src: data.thumbUrl,
                              boxFit: BoxFit.cover,
                            ),
                          )
                          : null,
                        thumbIconList: FileStatusIcon.getList(data, type),
                        suffixIcon: data.locked == 1 ? const SizedBox(height: 28,) : null,
                        relativeTime: data.getRelativeTime(),
                      ),
                      Positioned(
                        top: 45, left: 0,
                        child: FileTypeTag.getTag(data)),
                      ],
                    ),
                  ),
                );
            },
          ),
        ],
      ),
    );
  }
}


