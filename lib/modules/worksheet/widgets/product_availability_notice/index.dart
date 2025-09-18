import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/worksheet/widgets/product_availability_notice/widgets/product_points_tile.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ProductAvailabilityNotice extends StatelessWidget {

  const ProductAvailabilityNotice({
    super.key,
    required this.controller,
    required this.isDoNotAskAgainVisible,
    required this.isSRSEnable,
    required this.isBeaconEnable,
    required this.isAbcEnable,
    required this.onTapOk
  });

  final JPBottomSheetController controller;

  final bool isDoNotAskAgainVisible;
  final bool isSRSEnable;
  final bool isBeaconEnable;
  final bool isAbcEnable;

  final VoidCallback onTapOk;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JPBottomSheetController>(
      init: controller,
        builder: (_) => Padding(
          padding: const EdgeInsets.symmetric(
          horizontal: 10
          ),
          child: Material(
            color: JPAppTheme.themeColors.base,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  JPText(text: 'product_availability_notice'.tr.capitalize!,
                    textSize: JPTextSize.heading3,
                    fontWeight: JPFontWeight.medium,
                  ),
                  const SizedBox(height: 10,),
                  JPText(text: _getDescription(),
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    height: 1.3,
                  ),
                  const SizedBox(height: 10,),
                  ProductPointsTile(index: 1, description: 'product_availability_notice_point1'.tr),
                  const SizedBox(height: 8,),
                  ProductPointsTile(index: 2, description: _getPoint2Description()),
                  const SizedBox(height: 10,),
                  JPText(text: 'product_availability_notice_note'.trParams({
                    'type': _getSupplierType()
                  }),
                    textSize: JPTextSize.heading5,
                    textAlign: TextAlign.start,
                    height: 1.3,
                  ),
                  const SizedBox(height: 10,),
                  // TODO: Below code displays a check-box for do not display availability notice again after adding new item
                  // if(isDoNotAskAgainVisible) ...{
                  //   JPText(text: 'product_availability_notice_message'.tr,
                  //     textSize: JPTextSize.heading5,
                  //     textAlign: TextAlign.start,
                  //   ),
                  //   const SizedBox(height: 10,),
                  //   Transform.translate(offset: const Offset(-7, 0),
                  //   child: JPCheckbox(
                  //     disabled: controller.isLoading,
                  //     text: 'do_not_show_this_message_again'.tr,
                  //     selected: controller.switchValue,
                  //     onTap: (value) => controller.toggleSwitchValue(!value),
                  //     padding: EdgeInsets.zero,
                  //     separatorWidth: 0,
                  //   ),
                  //   )
                  // },
                  const SizedBox(height: 10,),
                  Align(
                    alignment: Alignment.center,
                    child: JPButton(
                      disabled: controller.isLoading,
                      text: controller.isLoading ? '' : 'ok'.tr,
                      suffixIconWidget: showJPConfirmationLoader(show: controller.isLoading),
                      size: JPButtonSize.small,
                      onPressed: onTapOk,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }

  String _getDescription() {
    if(isSRSEnable) {
      return 'srs_product_availability_notice_description'.tr;
    } else if(isBeaconEnable) {
      return 'beacon_product_availability_notice_description'.tr;
    } else if(isAbcEnable) {
      return 'abc_product_availability_notice_description'.tr;
    } else {
      return '';
    }
  }

  String _getPoint2Description() {
    if(isSRSEnable) {
      return 'srs_product_availability_notice_point2'.tr;
    } else if(isBeaconEnable) {
      return 'beacon_product_availability_notice_point2'.tr;
    } else if(isAbcEnable) {
      return 'abc_product_availability_notice_point2'.tr;
    } else {
      return '';
    }
  }

  String _getSupplierType() {
    if(isSRSEnable) {
      return 'SRS';
    } else if(isBeaconEnable) {
      return 'Beacon';
    } else if(isAbcEnable) {
      return 'ABC';
    } else {
      return '';
    }
  }
}
