import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/order_status_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/models/files_listing/files_listing_model.dart';
import '../../../common/services/quick_book.dart';
import '../../../core/constants/assets_files.dart';

class FileTypeTag {

  static Widget getTag(
    FilesListingModel data, {bool isListView = false, bool isSecondTag = false}) {

    String? tagTitle = getTagTitle(data, isSecondTag: isSecondTag);
    Color? tagColor = getTagColor(data, isSecondTag: isSecondTag);

    if(tagTitle != null) {
      if(isListView) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: isIntegrationOrderIcon(tagTitle)
              ? getTagIcon(tagTitle) : JPChip(
              backgroundColor: tagColor ?? JPAppTheme.themeColors.tertiary,
              text: tagTitle,
              textColor: JPAppTheme.themeColors.base,
              textPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          ),
        );
      } else {
        return isIntegrationOrderIcon(tagTitle)
            ? Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: getTagIcon(tagTitle),
        ) : Container(
          decoration: BoxDecoration(
              color: (tagColor ?? JPAppTheme.themeColors.success),
              borderRadius: isIntegrationOrderStatus(data) || isSecondTag ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ) : const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: JPText(
            text: tagTitle.tr,
            textColor: JPAppTheme.themeColors.base,
            textSize: JPTextSize.heading5,
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

 
  static String? getTagTitle(FilesListingModel data ,{bool isSecondTag = false}) {
  
    bool isPdf = data.jpThumbIconType == JPThumbIconType.pdf;

    if(data.insuranceEstimate ?? false) {
      return "merge".tr;
    }
    if(data.type == "clickthru" && data.clickthruId != null) {
      return "clickthru".tr;
    }

    switch(data.type) {
      case "xactimate":
        return "insurance".tr;
    }

    if(isSecondTag && !Helper.isValueNullOrEmpty(data.srsOrderDetail?.orderStatus)) {
      return "srs_order".tr;
    }

    if(isSecondTag && Helper.isTrue(data.isBeaconOrder)) {
      return "beacon_order".tr;
    }

    if(isSecondTag && !Helper.isValueNullOrEmpty(data.abcOrderDetail?.orderStatus)) {
      return "abc_order".tr;
    }

    if((data.worksheet?.suppliers?.isNotEmpty ?? false) && (data.forSupplierId != null)) {
      if(Helper.isSupplierHaveSrsItem(data.worksheet?.suppliers, isSRSV2Only: true)) {
        return data.srsOrderDetail?.orderStatus != null ? data.srsOrderDetail?.orderStatusLabel.toString().capitalize : "srs_order".tr;
      } else if(Helper.isSupplierHaveBeaconItem(data.worksheet?.suppliers)) {
        return data.beaconOrderDetails?.orderStatus != null ? data.beaconOrderDetails?.orderStatusLabel.toString().capitalize : "beacon_order".tr;
      } else if(Helper.isSupplierHaveABCItem(data.worksheet?.suppliers)) {
        return data.abcOrderDetail?.orderStatus != null ? data.abcOrderDetail?.orderStatusLabel.toString().capitalize : "abc_order".tr;
      }
    }

    if((data.hoverJob?.state?.isNotEmpty ?? false) && (isPdf || data.hoverJob?.state != 'complete')) {
      return data.hoverJob?.state.toString().replaceAll("_", " ").capitalize;
    }

    if((data.evOrder?.status?.name?.isNotEmpty ?? false)) {
      return data.evOrder?.status?.name.toString().replaceAll("_", " ").capitalize;
    }

    return QuickBookService.getQDBStatus(data.worksheet);
  }

  static Color? getTagColor(FilesListingModel data ,{bool isSecondTag = false}) {
    bool isSrsOrderPending = data.srsOrderDetail?.orderStatus == OrderStatusConstants.pending;
    bool isBeaconOrderPending = data.beaconOrderDetails?.orderStatus == OrderStatusConstants.pending;
    bool isABCOrderStatusPending = data.abcOrderDetail?.orderStatus == OrderStatusConstants.pending;
    if (data.hoverJob?.state == 'complete') {
      return JPAppTheme.themeColors.success;
    } else if(data.srsOrderDetail != null) {
      return isSrsOrderPending ? JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7) : JPAppTheme.themeColors.success;
    } else if(isSecondTag) {
      return JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7);
    } else if(data.beaconOrderDetails != null) {
      return isBeaconOrderPending ? JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7) : JPAppTheme.themeColors.success;
    } else if(data.abcOrderDetail != null) {
      return isABCOrderStatusPending ? JPAppTheme.themeColors.tertiary.withValues(alpha: 0.7) : JPAppTheme.themeColors.success;
    }
    return null;
  }

  static Widget getTagIcon(String? tagTitle) {
    String? imgAsset;
    if(tagTitle == 'srs_order'.tr) {
      imgAsset = AssetsFiles.srsLogo;
    } else if(tagTitle == 'beacon_order'.tr) {
      imgAsset = AssetsFiles.qxoLogo;
    } else if(tagTitle == 'abc_order'.tr) {
      imgAsset = AssetsFiles.abcLogo;
    }

    if(imgAsset != null) {
      return Image.asset(imgAsset, height: 22);
    } else {
      return const SizedBox.shrink();
    }
  }

  static bool isIntegrationOrderIcon(String tagTitle) => tagTitle == 'srs_order'.tr || tagTitle == 'beacon_order'.tr || tagTitle == 'abc_order'.tr;

  static bool isIntegrationOrderStatus(FilesListingModel data) => data.srsOrderDetail != null || data.beaconOrderDetails != null || data.abcOrderDetail != null;
}