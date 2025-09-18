import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/files_listing/forms/worksheet_form/add_item.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import '../../controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class WorksheetAddItemTotalPrice extends StatelessWidget {
  const WorksheetAddItemTotalPrice({
    super.key,
    required this.controller
  });

  final WorksheetAddItemController controller;

  WorksheetAddItemService get service => controller.service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: controller.formUiHelper.inputVerticalSeparator),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          JPText(text: 'total_price'.tr,
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading3
          ),
          /// total price
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: JPText(
                text: JobFinancialHelper.getCurrencyFormattedValue(value: service.totalPrice),
                textColor: JPAppTheme.themeColors.primary,
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading3,
                textAlign: TextAlign.start,
              ),
            ),
          )
        ],),
    );
  }
}
