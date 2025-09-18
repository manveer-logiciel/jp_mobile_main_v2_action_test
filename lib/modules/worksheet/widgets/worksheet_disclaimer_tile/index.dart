import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../controller.dart';

class WorksheetDisclaimerTile extends StatelessWidget {
  final WorksheetFormController controller;
  const WorksheetDisclaimerTile({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.lightGrassGreen,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: JPRichText(
              text: JPTextSpan.getSpan(
                  '${'disclaimer'.tr.capitalize}: ',
                  textSize: JPTextSize.heading5,
                fontWeight: JPFontWeight.medium,
                children: [
                  JPTextSpan.getSpan('pricing_is_subject_to_change_even_after_placing_an_order'.tr,
                    textSize: JPTextSize.heading5
                  ),
                ]
              ),
            ),
          ),
          const SizedBox(width: 5,),
          JPButton(
            text: controller.service.isColorAdded ? '${'save'.tr} & ${'place_order'.tr}' : 'place_order'.tr,
            size: JPButtonSize.extraSmall,
            onPressed: controller.service.saveAndNavigateToPlaceOrderForm,
          )
        ],
      ),
    );
  }
}
