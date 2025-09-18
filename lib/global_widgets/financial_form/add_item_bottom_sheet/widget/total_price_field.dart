import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../core/utils/job_financial_helper.dart';
import '../controller.dart';

class AddItemTotalPriceField extends StatelessWidget {
  const AddItemTotalPriceField({
    super.key,
    required this.controller
  });

  final AddItemBottomSheetController controller;

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
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: JPText(
                text: JobFinancialHelper.getCurrencyFormattedValue(
                value: controller.service.itemTotalPrice),
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
