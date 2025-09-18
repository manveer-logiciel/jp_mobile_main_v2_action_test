import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../../../common/models/forms/eagleview_order/index.dart';
import '../../../../../../../global_widgets/divider/index.dart';
import '../../../../../../job/job_detail/widgets/detail_tile.dart';
import '../../controller.dart';

class EagleViewOrderDialogueProductSection extends StatelessWidget {
  const EagleViewOrderDialogueProductSection({
    super.key,
    required this.formData,
    required this.controller
  });

  final EagleViewFormData formData;
  final EagleViewOrderVerificationDialogueController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///   product Information
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: JPText(
            text: "product_information".tr.toUpperCase(),
            textAlign: TextAlign.start,
            textSize: JPTextSize.heading5,
            textColor: JPAppTheme.themeColors.darkGray,
            fontWeight: JPFontWeight.medium,
          ),
        ),
        ///   product Name
        JobDetailTile(
          isVisible: formData.selectedProduct?.label.isNotEmpty ?? false,
          label: "products".tr,
          description: formData.selectedProduct?.label ?? "",
        ),
        JPDivider(isVisible: formData.selectedProduct?.label.isNotEmpty ?? false),
        ///   delivery
        JobDetailTile(
          isVisible: formData.selectedDelivery?.label.isNotEmpty ?? false,
          label: "delivery".tr,
          description: formData.selectedDelivery?.label ?? "",
        ),
        JPDivider(isVisible: formData.selectedDelivery?.label.isNotEmpty ?? false),
        ///   other products
        JobDetailTile(
          isVisible: controller.getOtherProducts().isNotEmpty,
          label: "other_products".tr,
          description: controller.getOtherProducts().map((dynamic e) => e.label).join(', '),
        ),
        JPDivider(isVisible: controller.getOtherProducts().isNotEmpty),
        ///   MeasurementInstructionType
        JobDetailTile(
          isVisible: formData.selectedMeasurements?.label.isNotEmpty ?? false,
          label: "measurement_instructions".tr,
          description: formData.selectedMeasurements?.label ?? "",
        ),
        JPDivider(isVisible: formData.selectedMeasurements?.label.isNotEmpty ?? false),
        ///   PromoCode
        JobDetailTile(
          isVisible: formData.promoCodeController.text.isNotEmpty,
          label: "promo_code".tr,
          description: formData.promoCodeController.text,
        ),
        JPDivider(isVisible: formData.promoCodeController.text.isNotEmpty),
      ],
    );
  }
}
