import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class FileInfo extends StatelessWidget {

  const FileInfo({super.key, required this.data,  this.isInvoice = false});

  final dynamic data;
  final bool isInvoice; 

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: JPColor.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: JPText(
                    text: 'details'.tr,
                    fontFamily: JPFontFamily.montserrat,
                    fontWeight: JPFontWeight.medium,
                    textSize: JPTextSize.heading3,
                    textAlign: TextAlign.start,
                  ),
                ),
                JPTextButton(
                  icon: Icons.close,
                  color: JPAppTheme.themeColors.text,
                  iconSize: 22,
                  padding: 2,
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            titleAndSubtitle(title: 'name'.tr, subTitle: isInvoice ? data.title ?? '' : data.name ?? ''),
            if(data.unitNumber != null)
            titleAndSubtitle(title: '${'unit'.tr.capitalizeFirst!}#', subTitle: data.unitNumber ?? ''),
            if(data.createdAt != null)
            titleAndSubtitle(
                title: 'uploaded_on'.tr,
                subTitle: DateTimeHelper
                    .format(data.createdAt.toString(), DateFormatConstants.dateTimeFormatWithSeconds)
                    .toString()),
            if(data.createdAt != null)
            titleAndSubtitle(
                title: 'last_modified'.tr,
                subTitle: DateTimeHelper
                    .format(data.updatedAt.toString(), DateFormatConstants.dateTimeFormatWithSeconds)
                    .toString()),
            titleAndSubtitle(
                title: 'file_size'.tr,
                subTitle:
                    FileHelper.getFileSizeWithUnit(data.size ?? 0).toString()),
          ],
        ),
      ),
    );
  }

  Widget titleAndSubtitle({String title = '', String subTitle = ''}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            JPText( 
              text: title,
              textSize: JPTextSize.heading4,
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 3,
            ),
            JPText(
              text: subTitle,
              textSize: JPTextSize.heading5,
              textColor: JPAppTheme.themeColors.darkGray,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      );
}