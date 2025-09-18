import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/enums/resource_type.dart';
import '../../../common/models/files_listing/files_listing_model.dart';

class FileStatusTag {

  static EdgeInsets textPadding = const EdgeInsets.symmetric(vertical: 2, horizontal: 5);

  static Widget getTag(FilesListingModel data, FLModule type) {

    if(type == FLModule.financialInvoice) {
      if(data.type != ResourceType.unsavedResource) {
        if(num.parse(data.openBalance!) <= 0.0) {
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.success,
            text: "paid".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        }
      }
      return const SizedBox.shrink();
    } 
      switch(data.status) {
        case "sent":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.warning,
            text: "sent".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "viewed":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.purple,
            text: "viewed".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "accepted":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.success,
            text: "accepted".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "draft":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.draft,
            text: "draft".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "rejected":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.secondary,
            text: "rejected".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "closed":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.success,
            text: "paid".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        case "completed":
          return JPChip(
            backgroundColor: JPAppTheme.themeColors.success,
            text: "completed".tr.capitalize!,
            textColor: JPAppTheme.themeColors.base,
            textPadding: textPadding,
          );
        
        default:
          return const SizedBox.shrink();
      }
  }
}