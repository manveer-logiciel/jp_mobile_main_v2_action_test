import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../common/enums/file_listing.dart';
import '../controller.dart';

class CumulativeInvoiceSecondaryHeader extends StatelessWidget {
  const CumulativeInvoiceSecondaryHeader({
    super.key,
    required this.controller,
  });

  final FilesListingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10 ,left: 16, bottom: 5, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: JPText(
              text: "${"job_invoice".tr.toUpperCase()}${controller.resourceList.isNotEmpty 
                ? ' (${controller.resourceList.length})': ''} ",
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
              textAlign: TextAlign.start,
              height: 1,
            ),
          ),
          if(controller.type == FLModule.financialInvoice && controller.resourceList.isNotEmpty)
            Flexible(
              child: Material(
                color: JPAppTheme.themeColors.base,
                child:  JPTextButton(
                  onPressed: () => controller.openCumulativeInvoiceActions(),
                  color: JPAppTheme.themeColors.text,
                  text: 'cumulative_invoice'.tr,
                  textSize: JPTextSize.heading5,
                  icon: Icons.arrow_drop_down,
                ),
              ),
            ),
        ],
      ),
    );
  }
}